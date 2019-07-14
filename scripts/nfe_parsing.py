#!/usr/bin/env python2.7
# coding=utf-8

import xmltodict
import locale
import sys
import os
from optparse import OptionParser
from prettytable import PrettyTable


'''
Setting up some environmental variables
'''
os.environ['LC_ALL'] = 'C'
os.environ['LANG'] = 'en_US.UTF-8'
locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')


def display (nfefile):

    '''
    Function will open the XML File and 
    transform it into a dict object
    '''
    try: 
        with open(nfefile) as fd:
            doc = xmltodict.parse(fd.read())
    except IOError as e:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
    except:
        print "Unexpected error:", sys.exc_info()[0]
    else:
        fd.close()

    '''
    Dados Gerais da NFe
    '''
    nfe_numero = int(doc['nfeProc']['NFe']['infNFe']['ide']['nNF'])
    data_saida = str(doc['nfeProc']['NFe']['infNFe']['ide']['dhSaiEnt'])
    '''
    Dados do Fornecedor
    '''
    emissor_cnpj = str(doc['nfeProc']['NFe']['infNFe']['emit']['CNPJ'])
    emissor_nome = str(doc['nfeProc']['NFe']['infNFe']['emit']['xNome'])

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
    prod_vol = str(doc['nfeProc']['NFe']['infNFe']['transp']['vol']['qVol'])
    prod_embalagem = str(doc['nfeProc']['NFe']['infNFe']['transp']['vol']['esp'])


    print("\n")
    print ("Numero NFe: {0}").format(nfe_numero)
    print ("Fornecedor Nome: {0} (CNPJ: {1})".format(emissor_nome,emissor_cnpj))
    '''print ("Fornecedor CNPJ: {0}".format(emissor_cnpj))'''
    print ("Valor Bruto: {0} \t Valor Nota: {1}".format(locale.currency(valor_bruto,grouping=True),
                                                        locale.currency(valor_nota,grouping=True)))
    print ("Quantidade Volumes: {0} {1}".format(prod_vol,prod_embalagem))


    '''
    Visualizar produtos
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
    (options, args) = parser.parse_args()
    display (options.nfefile)

    return 0


if __name__ == '__main__':
    status = main()
    sys.exit(status)




