#!/usr/bin/env python3
# coding=utf-8

import xmltodict
import locale
import time
import sys
import os
from optparse import OptionParser
from configparser import ConfigParser
from prettytable import PrettyTable
import dateutil.parser
import mysql.connector as mariadb
from decimal import Decimal


'''
Setting up some environmental variables
'''
os.environ['LC_ALL'] = 'C'
#os.environ['LANG'] = 'en_US.UTF-8'
locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')



def parse_config(configfile):
    '''
    Takes care of parsing the configuration file
    '''
    results = {}
    c = ConfigParser()
    if not c.read(configfile):
        raise Exception("Arquivo de config vazio (Code: 204)")
        sys.exit(1)
    else:
        """ Get Defaults """
        conf = dict(c.defaults())
        results['xml_directory'] = conf.get('xml_directory', './XML')

    if c.has_section('mysql'):
        conf = dict(c.items('mysql'))
        results['host'] = conf.get('host', '127.0.0.1')
        results['user'] = conf.get('user', 'web01')
        results['pass'] = conf.get('pass','')
        results['db'] = conf.get('db','fornecedor_in')
    else:
        raise Exception("Dados de Mysql nao encontrado (Code: 404)")
        sys.exit(1)

    return results


def get_xml_files(xml_directory):

    month_location = time.strftime("%m %B")
    full_dir = xml_directory + '/' + month_location 
    
    abs_path_files = []
    for file in os.listdir(full_dir):
        abs_path_files.append(full_dir + '/' + file)

    return abs_path_files


def open_db_conn(**db_config_dict):

    try: 
        mdb_conn = mariadb.connect(**db_config_dict)
        if mdb_conn.is_connected():
            db_info = mdb_conn.get_server_info()
            print("Conectado ao servidor Maria DB.\nMaria DB {0}".format(db_info))
            db_cursor = mdb_conn.cursor(prepared=True)
    except mariadb.Error as error:
        print("Error: {}".format(error))
        sys.exit(1)

    return (mdb_conn,db_cursor)


def insert_data(nfefile,mdb_conn,db_cursor):

    '''
    Function will open the XML File and 
    transform it into a dict object
    '''
    try: 
        with open(nfefile) as fd:
            print("Opening {0}".format(nfefile))
            doc = xmltodict.parse(fd.read())
    except IOError as e:
        print ("I/O error({0}): {1}".format(e.errno, e.strerror))
    except:
        print ("I/O Unexpected error: {0}".format(sys.exc_info()[0]))
    else:
        fd.close()


    try:
        '''
        Dados Gerais da NFe
        '''
        ide = doc['nfeProc']['NFe']['infNFe']['ide']
        nfe_numero = int(ide.get('nNF','00000000'))
        data = dateutil.parser.parse(ide.get('dhSaiEnt','2019-01-01T00:00:00-00:00'))
        nfe_data = data.strftime('%Y-%m-%d %H:%M:%S')  
        '''
        Dados do Fornecedor
        '''
        emissor = doc['nfeProc']['NFe']['infNFe']['emit']
        emissor_nome = str(emissor.get('xNome','Nada'))
        emissor_cnpj = str(emissor.get('CNPJ','XXX'))
        '''
        Dados do Destinatario
        '''
        dest = doc['nfeProc']['NFe']['infNFe']['dest']
        dest_nome = str(dest.get('xNome','XXX'))
        dest_cnpj = str(dest.get('CNPJ','XXX'))
        '''
        Dados de Valor Total
        '''
        valor = doc['nfeProc']['NFe']['infNFe']['total']['ICMSTot']
        valor_bruto = Decimal(valor.get('vBC','0'))
        valor_nota = Decimal(valor.get('vNF','0'))

    except KeyError as e:
        print ("XML Parsing Error: Key not found {0}".format(e))
        raise
    except AttributeError as e:
        print ("Attribute Error: {0}".format(e))
        raise

    try:
        transp = doc['nfeProc']['NFe']['infNFe']['transp']
        if not transp.get('vol'):
            prod_volumes = 0
            prod_embalagem = "Nada"
        else:
            vols = doc['nfeProc']['NFe']['infNFe']['transp']['vol']
            prod_volumes = int(vols.get('qVol','0'))
            prod_embalagem = str(vols.get('esp','Nenhuma').capitalize())
    except KeyError as e:
        print ("XML Parsing Error: Key not found {0}".format(e))
        raise
    except AttributeError as e:
        print ("Attribute Error: {0}".format(e))
        raise



    '''
    Check if NFe already exits in the database
    '''
    sql_select = "SELECT nfe_numero FROM transitando_nfe WHERE nfe_numero = %s"
    sql_select_tuple = (nfe_numero,)
    insert_ok = False
    try:
        db_cursor.execute(sql_select,sql_select_tuple)
        records = db_cursor.fetchall()
        if (nfe_numero,) not in records:
            insert_ok = True
        else:
            print("Skipping Insert")
    except mariadb.Error as error:
        print("Error executando SELECT: {0}".format(error))


    '''
    Inserindo os dados Gerais da NFe na tabela transitando_nfe
    '''
    transitando_nfe_insert = """INSERT INTO transitando_nfe (nfe_numero,nfe_data,emissor_nome,
                                emissor_cnpj,valor_bruto,valor_nota,prod_volumes,prod_embalagem) 
                                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"""
    transitando_nfe_tuple = (nfe_numero,nfe_data,emissor_nome,emissor_cnpj,
                             valor_bruto,valor_nota,prod_volumes,prod_embalagem)
    if insert_ok:
        try:
            sql_result = db_cursor.execute(transitando_nfe_insert,transitando_nfe_tuple)
            '''mdb_conn.commit()'''
            print("NFe {0} valores inseridos na tabela transitando_nfe".format(nfe_numero))
        except mariadb.Error as error:
            mdb_conn.rollback()
            print("NFe {0} Erro inserindo valores na tabela transitando_nfe: {1}".format(nfe_numero,error))
            sys.exit(1)
        

    '''
    Inserindo os Items da NFe na tabela transitando_nfe_items
    '''

    transitando_nfe_items_insert  = """INSERT INTO transitando_nfe_items (nfe_numero,
                                       nfe_data,prod_codigo,prod_descri,prod_quant) 
                                       VALUES (%s,%s,%s,%s,%s)"""

    if insert_ok:
        if not isinstance(doc['nfeProc']['NFe']['infNFe']['det'],list):
            prod_codigo = str(doc['nfeProc']['NFe']['infNFe']['det']['prod']['cProd'])
            prod_descri = doc['nfeProc']['NFe']['infNFe']['det']['prod']['xProd']
            prod_quant  = float(doc['nfeProc']['NFe']['infNFe']['det']['prod']['qCom'])

            transitando_nfe_items_tuple = (nfe_numero,nfe_data,prod_codigo,prod_descri,prod_quant)
            sql_result = db_cursor.execute(transitando_nfe_items_insert,transitando_nfe_items_tuple)

        else:
            infNFe = doc['nfeProc']['NFe']['infNFe']
            num_itens = len(infNFe.get('det',''))

            try:
                start_i = 0
                while start_i < num_itens:

                    prod_codigo = str(doc['nfeProc']['NFe']['infNFe']['det'][start_i]['prod']['cProd'])
                    prod_descri = doc['nfeProc']['NFe']['infNFe']['det'][start_i]['prod']['xProd']
                    prod_quant  = float(doc['nfeProc']['NFe']['infNFe']['det'][start_i]['prod']['qCom'])

                    transitando_nfe_items_tuple = (nfe_numero,nfe_data,prod_codigo,prod_descri,prod_quant)
                    sql_result = db_cursor.execute(transitando_nfe_items_insert,transitando_nfe_items_tuple)
                    start_i += 1
                
                mdb_conn.commit()
                print("NFe {0} valores inseridos na tabela transitando_nfe_items".format(nfe_numero))
            except mariadb.Error as error:
                mdb_conn.rollback()
                print("NFe {0} Erro inserindo valores na tabela transitando_nfe: {1}".format(nfe_numero,error))
                sys.exit(1)



def main():
    '''
    Main function
    '''         
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

    mariaconn_config_dict = {
        'user': conf['user'],
        'password': conf['pass'],
        'host': conf['host'],
        'database': conf['db'],
        'charset':  'utf8'
    }
    
    '''
    Open DB Connection and return cursor
    '''
    start_time = time.time()
    (mdb_conn,db_cursor) = open_db_conn(**mariaconn_config_dict)
    print("--- %s seconds ---" % (time.time() - start_time))


    start_time = time.time()
    for nfe_xml in get_xml_files(conf['xml_directory']):
        try:
            if os.path.isfile(nfe_xml):             
                insert_data(nfe_xml,mdb_conn,db_cursor)
            else:
                raise Exception("Error: File Not Found {0}".format(nfe_xml))
        except AssertionError as error:
            print ("DB Unexpected error: {0}".format(error))
            sys.exit(1)

    print("--- %s seconds ---" % (time.time() - start_time))

    if mdb_conn.is_connected():
        db_cursor.close()
        mdb_conn.close()
        print("DB connecao fechada")

    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)




