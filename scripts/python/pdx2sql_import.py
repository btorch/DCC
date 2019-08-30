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



'''
Setting up some environmental variables
'''
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
    
    """ Get Defaults """
    """    
    else:
        conf = dict(c.defaults())
        results['mes'] = conf.get('mes', '')
    """

    if c.has_section('mysql'):
        conf = dict(c.items('mysql'))
        results['host'] = conf.get('host', '127.0.0.1')
        results['user'] = conf.get('user', 'web01')
        results['pass'] = conf.get('pass','')
        results['db'] = conf.get('db','sistema_in')
        results['table'] = conf.get('table','')
        results['sqlfile'] = conf.get('sqlfile','')
    else:
        raise Exception("Dados de Mysql nao encontrado")
        sys.exit(1)

    return results



def run_import(sqlfile, conn, table):
    '''
    refs:
        checking on encoding
        import chardet 
        chardet.detect(open(file,'rb').read())['encoding']
        https://stackoverflow.com/questions/19699367/unicodedecodeerror-utf-8-codec-cant-decode-byte
    '''
    start = time.time()
    try: 
        with open(sqlfile,"r",encoding="ISO-8859-1") as fd:
            print("Opening {0}".format(sqlfile))
            lines = fd.readlines()
    except IOError as e:
        print ("I/O Error ({0}): {1}".format(e.errno, e.strerror))
        sys.exit(1)
    except:
        #print ("I/O Erro Inesperado: {0}".format(sys.exc_info()[2]))
        raise
        sys.exit(1)
    else:
        fd.close()

    end = time.time()
    elapsed = (end - start)
    print ("Read {0} lines into memory".format(len(lines)))
    print ("Time elapsed to read SQL file: {:.4f} s".format(elapsed))



    start = time.time()
    sql_delete = "DELETE FROM {0}".format(table)
    try:
        cur = conn.cursor()
        cur.execute(sql_delete)
    except mariadb.Error as error:
        conn.rollback()
        print("Error executando DELETE query: {0}".format(error))
        print("Query {0}".format(sql_delete))
        sys.exit(1)

    end = time.time()
    elapsed = (end - start)
    print ("Time elapsed to delete all records: {:.4f} s".format(elapsed))


    start = time.time()
    for line in lines:
        line = line.rstrip()

        try:
            cur.execute(line)
        except mariadb.Error as error:
            conn.rollback()
            print("Error executando INSERT query: {0}".format(error))
            print("Query : {0}".format(line))
            sys.exit(1)

    end = time.time()
    elapsed = (end - start)
    print ("Time elapsed to insert all records: {:.4f} s".format(elapsed))


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
    parser.add_option("-f", "--sqlfile",
        action="store", type="string",
        default="paradox.sql",
        dest="sqlfile",
        help='Arquivo SQL para ser importado [default: %default]'
    )    
                
    (options, args) = parser.parse_args()
    conf = parse_config([options.config, ])

    dbconfig_dict = {
        'user': conf['user'],
        'password': conf['pass'],
        'host': conf['host'],
        'database': conf['db'],
        'charset':  'utf8mb4',
        'collation':'utf8mb4_unicode_ci'
    }

    sqlfile = options.sqlfile
    if not os.path.isfile(sqlfile):
        print ("ERROR: File {0} has not been found".format(sqlfile))
        sys.exit(1)

    table = conf['table']
    if not table:
        print ("ERROR: Table name is empty on {0} file".format(options.config))
        sys.exit(1)

    try:
        conn = mariadb.connect(**dbconfig_dict)
        if conn.is_connected(): 
            run_import(sqlfile,conn,table)
            print("SQL Import has been finished")

    except mariadb.Error as e:
        conn.close()
        print ("ERROR: {}".format(e))
        sys.exit(1)


    if conn.is_connected():
        conn.close()
        print("DB conn fechada")
   
    return 0


if __name__ == '__main__':
    status = main()
    sys.exit(status)


