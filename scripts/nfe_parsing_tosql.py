#!/usr/bin/env python3
# coding=utf-8

import xmltodict
import locale
import sys
import os
from optparse import OptionParser
from prettytable import PrettyTable
import dateutil.parser
import mysql.connector as mariadb


'''
Setting up some environmental variables
'''
os.environ['LC_ALL'] = 'C'
os.environ['LANG'] = 'en_US.UTF-8'
locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')


def insert_data(nfefile,**db_config_dict):

    '''
    Function will open the XML File and 
    transform it into a dict object
    '''
    try: 
        with open(nfefile) as fd:
            doc = xmltodict.parse(fd.read())
    except IOError as e:
        print ("I/O error({0}): {1}").format(e.errno, e.strerror)
    except:
        print ("Unexpected error: {0}").format(sys.exc_info()[0])
    else:
        fd.close()

    '''
    Dados Gerais da NFe
    '''
    nfe_numero = int(doc['nfeProc']['NFe']['infNFe']['ide']['nNF'])
    data = dateutil.parser.parse(doc['nfeProc']['NFe']['infNFe']['ide']['dhSaiEnt'])
    nfe_data = data.strftime('%Y-%m-%d %H:%M:%S')
    '''
    Dados do Fornecedor
    '''
    emissor_nome = str(doc['nfeProc']['NFe']['infNFe']['emit']['xNome'])
    emissor_cnpj = str(doc['nfeProc']['NFe']['infNFe']['emit']['CNPJ'])

    '''
    Dados do Destinatario
    '''
    dest_cnpj = str(doc['nfeProc']['NFe']['infNFe']['dest']['CNPJ'])
    dest_nome = str(doc['nfeProc']['NFe']['infNFe']['dest']['xNome'])

    '''
    Dados de Valor Total
    '''
    valor_bruto = float(doc['nfeProc']['NFe']['infNFe']['total']['ICMSTot']['vBC'])
    valor_nota = float(doc['nfeProc']['NFe']['infNFe']['total']['ICMSTot']['vNF'])
    prod_volumes = int(doc['nfeProc']['NFe']['infNFe']['transp']['vol']['qVol'])
    prod_embalagem = str(doc['nfeProc']['NFe']['infNFe']['transp']['vol']['esp']).capitalize()


    try: 
        mdb_conn = mariadb.connect(**db_config_dict)
        if mdb_conn.is_connected():
            db_info = mdb_conn.get_server_info()
            print("Conectado ao servidor Maria DB.\nMaria DB {0}".format(db_info))
            db_cursor = mdb_conn.cursor(prepared=True)
    except mariadb.Error as error:
        print("Error: {}".format(error))
 

    transitando_nfe_insert = """INSERT INTO transitando_nfe (nfe_numero,nfe_data,emissor_nome,
                                emissor_cnpj,valor_bruto,valor_nota,prod_volumes,prod_embalagem) 
                                VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"""
    transitando_nfe_tuple = (nfe_numero,nfe_data,emissor_nome,emissor_cnpj,
                             valor_bruto,valor_nota,prod_volumes,prod_embalagem)

    try:
        sql_result = db_cursor.execute(transitando_nfe_insert,transitando_nfe_tuple)
        mdb_conn.commit()
        print("Valores inseridos na tabela transitando_nfe")
    except mariadb.Error as error:
        mdb_conn.rollback()
        print("Erro inserindo valores na tabela transitando_nfe: {0}".format(error))
    finally:
        if mdb_conn.is_connected():
            db_cursor.close()
            mdb_conn.close()
            print("DB connecao fechada")




    '''
    table = PrettyTable()
    table.field_names =  ["Item","Codigo","Descricao","Quantidade"]

    num_itens = len(doc['nfeProc']['NFe']['infNFe']['det'])

    start_i = 0
    while start_i < num_itens:

        prod_codigo = str(doc['nfeProc']['NFe']['infNFe']['det'][start_i]['prod']['cProd'])
        prod_descri = doc['nfeProc']['NFe']['infNFe']['det'][start_i]['prod']['xProd']
        prod_quant  = float(doc['nfeProc']['NFe']['infNFe']['det'][start_i]['prod']['qCom'])
        start_i += 1
        table.add_row([start_i,prod_codigo,prod_descri,prod_quant])

    print (table)
    '''

def main():
    '''
    Main function
    '''         
    parser = OptionParser(usage="usage: %prog [options]",
                          version="%prog 1.0")
    parser.add_option("-f", "--file-in",
        action="store", type="string",
        default="",
        dest="nfefile",
        help='Local do aquivo XML da NFE [default: %default]'
    )
    parser.add_option("-s", "--db-ip",
        action="store", type="string",
        default="127.0.0.1",
        dest="dbhost",
        help='IP para connectar ao MariaDB [default: %default]'
    )
    parser.add_option("-u", "--db-user",
        action="store", type="string",
        default="web01",
        dest="dbuser",
        help='User para connectar ao MariaDB [default: %default]'
    )
    parser.add_option("-p", "--db-pass",
        action="store", type="string",
        default="null",
        dest="dbpass",
        help='Password para connectar ao MariaDB [default: %default]'
    )
    parser.add_option("-d", "--db-name",
        action="store", type="string",
        default="mysql",
        dest="dbname",
        help='DB para connectar ao MariaDB [default: %default]'
    )
                
    (options, args) = parser.parse_args()

    mariaconn_config_dict = {
        'user': options.dbuser,
        'password': options.dbpass,
        'host': options.dbhost,
        'database': options.dbname,
        'charset':  'utf8'
    }

    insert_data(options.nfefile,**mariaconn_config_dict)

    return 0


if __name__ == '__main__':
    status = main()
    sys.exit(status)




