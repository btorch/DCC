#! /usr/bin/env python3

import time
import locale
import sys
import os
import dateutil.parser
import mysql.connector as mariadb
from optparse import OptionParser
from configparser import ConfigParser
from decimal import Decimal
from logging.handlers import SysLogHandler, RotatingFileHandler
import logging


"""
Info:
    - Install script into /opt/pdx2sql/bin
    - Install configs into /opt/pdx2sql/etc
    - Logging location /opt/pdx2sql/logs
    - Sync/Copy SQL files to be processed into /opt/pdx2sql/imports
    - Create cronjobs pointing to each config
"""

"""
Setting up environmental variables
"""
#os.environ['LC_ALL'] = 'C'
#os.environ['LANG'] = 'en_US.UTF-8'
locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')



def parse_config(configfile):
    """
    Takes care of parsing the configuration file

    param configfile: Dict containing configuration details
    returns: Dict containing the data found on the config file
    """
    results = {}
    c = ConfigParser()
    if not c.read(configfile):
        raise Exception("Arquivo de config vazio")
        sys.exit(1)
    else:
        """ Get Defaults """
        conf = dict(c.defaults())
        results['logfile'] = conf.get('logfile', '/opt/pdx2sql/logs/pdx2sql_import.log')
        

    # Go over MySQL section
    if c.has_section('mysql'):
        conf = dict(c.items('mysql'))
        results['host'] = conf.get('host', '127.0.0.1')
        results['user'] = conf.get('user', 'web02')
        results['pass'] = conf.get('pass','')
        results['db'] = conf.get('db','sistema_in_test')
        results['table'] = conf.get('table','')
        results['sqlfile'] = conf.get('sqlfile','')
    else:
        raise Exception("Dados de Mysql nao encontrado")
        sys.exit(1)

    return results



def run_import(sqlfile,conn,table,logger):
    """
    Opens and reads all query lines of the SQL
    file that has been created on Windows Server
    from a Paradox to MySQL export logic

    With a transaction it will delete all existing
    rows from the table in question and then
    it goes over each line and executes
    the SQL insert statements into the table

    param sqlfile: The sql file location
    param conn: The MySQL connection object
    param table: The name of the MySQL Table
    param logger: The logging object 

    refs:
        Windows file needed ISO-8859-1 for Latin
        import chardet; chardet.detect(open(file,'rb').read())['encoding']
        https://stackoverflow.com/questions/19699367/unicodedecodeerror-utf-8-codec-cant-decode-byte
    """


    # Reading SQL file into memory
    start = time.time()
    try: 
        with open(sqlfile,"r",encoding="ISO-8859-1") as fd:
            logger.info("Opening {0}".format(sqlfile))
            lines = fd.readlines()
    except IOError as e:
        logger.error("I/O Error ({0}): {1}".format(e.errno, e.strerror))
        sys.exit(1)
    except:
        logger.error("I/O Erro Inesperado: {0} : {1}".format(sys.exc_info()[0],sys.exc_info()[1]))
        logger.exception('Oh noes!')
        raise
        sys.exit(1)
    else:
        fd.close()

    end = time.time()
    elapsed = (end - start)
    logger.info("Read {0} lines into memory".format(len(lines)))
    logger.info("Time elapsed to read SQL file: {:.4f} s".format(elapsed))


    # Deleting all existing data from table
    start = time.time()
    sql_delete = "DELETE FROM {0}".format(table)
    try:
        cur = conn.cursor()
        cur.execute(sql_delete)
    except mariadb.Error as error:
        conn.rollback()
        logger.error("Error executando DELETE query: {0}".format(error))
        logger.error("Query {0}".format(sql_delete))
        sys.exit(1)

    end = time.time()
    elapsed = (end - start)
    logger.info("Time elapsed to delete all records: {:.4f} s".format(elapsed))


    # Inserting the data into the table
    start = time.time()
    for line in lines:
        line = line.rstrip()

        try:
            cur.execute(line)
        except mariadb.Error as error:
            conn.rollback()
            logger.error("Error executando INSERT query: {0}".format(error))
            logger.error("Query : {0}".format(line))
            sys.exit(1)

    end = time.time()
    elapsed = (end - start)
    logger.info("Time elapsed to insert all records: {:.4f} s".format(elapsed))
    conn.commit() 



def main():

    parser = OptionParser(usage="usage: %prog [options]",
                          version="%prog 1.0")
    parser.add_option("-c", "--conf",
        action="store", type="string",
        default="./config.cfg",
        dest="config",
        help='Local do arquivo com configuracoes [default: %default]'
    )
    (options, args) = parser.parse_args()
    conf = parse_config([options.config, ])


    # Create Logger
    log_path = conf['logfile']
    logger = logging.getLogger('pdx2sql_importer')
    logger.setLevel(logging.DEBUG)
    # Create Rotating Handler
    handler = RotatingFileHandler(log_path,maxBytes=5242880,backupCount=5)
    handler.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s: %(message)s')
    handler.setFormatter(formatter)
    # Set handler to logger
    logger.addHandler(handler)



    dbconfig_dict = {
        'user': conf['user'],
        'password': conf['pass'],
        'host': conf['host'],
        'database': conf['db'],
        'charset':  'utf8mb4',
        'collation':'utf8mb4_unicode_ci'
    }

    sqlfile = conf['sqlfile']
    if not os.path.isfile(sqlfile):
        logger.error("File {0} has not been found".format(sqlfile))
        sys.exit(1)

    table = conf['table']
    if not table:
        logger.error("Table name is empty on {0} file".format(options.config))
        sys.exit(1)

    try:
        conn = mariadb.connect(**dbconfig_dict)
        if conn.is_connected(): 
            run_import(sqlfile,conn,table,logger)
            logger.info("SQL Import has been finished")

    except mariadb.Error as e:
        conn.close()
        logger.error("{}".format(e))
        sys.exit(1)


    if conn.is_connected():
        conn.close()
        logger.info("DB conn fechada")
   
    return 0


if __name__ == '__main__':
    status = main()
    sys.exit(status)


