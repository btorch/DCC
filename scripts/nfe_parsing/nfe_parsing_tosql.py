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
        raise Exception("Arquivo de config vazio (Code: 204)")
        sys.exit(1)
    else:
        """ Get Defaults """
        conf = dict(c.defaults())
        results['xml_directory'] = conf.get('xml_directory', './XML')
        results['xml_transito'] = conf.get('xml_transito','TRANSITO')
        results['mes'] = conf.get('mes', '')

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



def get_xml_files(xml_directory,month,transito=''):
    """
    Gets the listing of XML files found on the location provided
    If transito value has been provided then get the listing of the
    files found on the transito folder

    param xml_directory: Folder where the XML files exist
    param month: month provided in the configuration file
    param transito: name of folder where files in transit are located

    returns: a list of all XML files found with absolute path
    """
    month_locdict={1:'01 JANEIRO', 2:'02 FEVEREIRO', 3:'03 MARÇO', 4:'04 ABRIL',
                5:'05 MAIO', 6:'06 JUNHO', 7:'07 JULHO', 8:'08 AGOSTO', 9:'09 SETEMBRO',
                10:'10 OUTUBRO', 11:'11 NOVEMBRO', 12:'12 DEZEMBRO'}

    if month:
        if transito:
            full_dir = xml_directory + '/' + month_locdict[int(month)] + '/' + transito
        else:
            full_dir = xml_directory + '/' + month_locdict[int(month)]
    else:
        month_location = time.strftime("%m %B")
        if transito:
            full_dir = xml_directory + '/' + month_location + '/' + transito
        else:
            full_dir = xml_directory + '/' + month_location
    
    # Criar lista dos aquivos
    abs_files = []
    if os.path.isdir(full_dir):
        if not len(os.listdir(full_dir)) == 0:
            for file in os.listdir(full_dir):
                if file.endswith(".xml"):
                    if os.path.isfile(os.path.join(full_dir, file)):
                        abs_files.append(full_dir + '/' + file)
        else:
            print ("The directory is empty: {0}".format(full_dir))
    else:
        print ("The directory doesn't exist: {0}".format(full_dir))

    return abs_files



def open_db_conn(**db_config_dict):
    """
    Creates a DB connection and cursor

    param db_config_dict: contains DB login/param needed

    returns: the db connection and db cursor handler 
    """
    try: 
        mdb_conn = mariadb.connect(**db_config_dict)
        if mdb_conn.is_connected():
            db_info = mdb_conn.get_server_info()
            print("Conectado ao servidor Maria DB.\nMaria DB {0}".format(db_info))
            db_cursor = mdb_conn.cursor()
    except mariadb.Error as error:
        print("Error: {}".format(error))
        sys.exit(1)

    return (mdb_conn,db_cursor)




def parse_and_insert_data(nfefile,month,mdb_conn,db_cursor,recebido=False):
    """
    - Opens XML file and transforms it into a dict object
    - Collects the data needed to be used by SQL
    - Inserts the collected data into DB Table
    - Updates status of prod_recebido

    param nfefile: NFe XML file to be parsed aand inserted into db
    param month: Month for which data is being analized
    param mdb_conn: db connection handler
    param db_cursor: db cursor handler
    param recebido: tells whether xml has been received

    returns: doesn't return anything only inserts data into database
    """
    try: 
        with open(nfefile) as fd:
            print("Opening {0}".format(nfefile))
            doc = xmltodict.parse(fd.read())
    except IOError as e:
        print ("I/O Error ({0}): {1}".format(e.errno, e.strerror))
    except:
        print ("I/O Erro Inesperado: {0}".format(sys.exc_info()[0]))
    else:
        fd.close()


    '''
    Data do mes do ano (YYYY-MM-DD) no qual o arquivo XML
    se encontrava na pasta do diretorio
    '''
    if month:
        mes_analisado = time.strftime("%Y-{:02d}-01".format(int(month)))
    else:
        mes_analisado = time.strftime("%Y-%m-01")

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
        print ("XML Erro Analizando: Key not found {0}".format(e))
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
        print ("XML Erro Analizando: Key not found {0}".format(e))
        raise
    except AttributeError as e:
        print ("Attribute Error: {0}".format(e))
        raise 



    '''
    Check if NFe already exits in the database
    If transito is False then update prod_recebido to True
    '''
    sql_nfe_check = "SELECT nfe_numero FROM transitando_nfe WHERE nfe_numero = %s"
    sql_nfe_status = "SELECT prod_recebido FROM transitando_nfe WHERE nfe_numero = %s"
    sql_nfe_update = "UPDATE transitando_nfe SET prod_recebido = True WHERE nfe_numero = %s"
    sql_nfe_tuple = (nfe_numero,)

    insert_ok = False
    try:
        db_cursor.execute(sql_nfe_check,sql_nfe_tuple)
        records = db_cursor.fetchall()
        if (nfe_numero,) not in records:
            insert_ok = True
        else:
            if recebido:
                try:
                    db_cursor.execute(sql_nfe_status,sql_nfe_tuple)
                    status_recebido = db_cursor.fetchone()
                    if False in status_recebido:
                        db_cursor.execute(sql_nfe_update,sql_nfe_tuple)
                        mdb_conn.commit()
                        print("NFE: {0} status de recebido atualizado".format(nfe_numero))
                except mariadb.Error as error:
                    print("Error executando query: {0}".format(error))

            print("Nota ja existente no banco de dados... Pulando")
    except mariadb.Error as error:
        print("Error executando SELECT: {0}".format(error))


    '''
    Inserindo os dados Gerais da NFe na tabela transitando_nfe
    '''
    transitando_nfe_insert = """INSERT INTO transitando_nfe (nfe_numero,mes_analisado,
                                nfe_data,emissor_nome,emissor_cnpj,valor_bruto,valor_nota,
                                prod_volumes,prod_embalagem,prod_recebido) 
                                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
    transitando_nfe_tuple = (nfe_numero,mes_analisado,nfe_data,emissor_nome,emissor_cnpj,
                             valor_bruto,valor_nota,prod_volumes,prod_embalagem,recebido)
    if insert_ok:
        try:
            sql_result = db_cursor.execute(transitando_nfe_insert,transitando_nfe_tuple)
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
        'charset':  'utf8mb4',
        'collation':'utf8mb4_unicode_ci'
    }
    
    '''
    Open DB Connection and return cursor
    '''
    #start_time = time.time()
    (mdb_conn,db_cursor) = open_db_conn(**mariaconn_config_dict)
    #print("--- %s seconds ---" % (time.time() - start_time))


    # Coletar lista de XML em transito
    xml_files_transito = get_xml_files(conf['xml_directory'],conf['mes'],conf['xml_transito'])
    if xml_files_transito:
        for nfe_xml in xml_files_transito:
            try:
                if os.path.isfile(nfe_xml):
                    parse_and_insert_data(nfe_xml,conf['mes'],mdb_conn,db_cursor,False)
                else:
                    raise Exception("Erro: Arquivo Nao Encontrado {0}".format(nfe_xml))
            except AssertionError as error:
                print ("DB Erro Inesperado: {0}".format(error))
                sys.exit(1)


    # start_time = time.time()
    # Coletar lista de XML recebidas
    xml_files_recb = get_xml_files(conf['xml_directory'],conf['mes'])
    if xml_files_recb:
        for nfe_xml in xml_files_recb:
            try:
                if os.path.isfile(nfe_xml):             
                    parse_and_insert_data(nfe_xml,conf['mes'],mdb_conn,db_cursor,True)
                else:
                    raise Exception("Erro: Arquivo Nao Encontrado {0}".format(nfe_xml))
            except AssertionError as error:
                print ("DB Erro Inesperado: {0}".format(error))
                sys.exit(1)

    #print("--- %s seconds ---" % (time.time() - start_time))


    if mdb_conn.is_connected():
        db_cursor.close()
        mdb_conn.close()
        print("DB connecao fechada")

    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)




