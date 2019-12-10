import locale
import sys
import os
import pyodbc
import logging
from optparse import OptionParser
from logging.handlers import SysLogHandler, RotatingFileHandler
from pathlib import Path, PureWindowsPath


# locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')

def set_up_logging():
    """
    Setting up Logging
    return: logger object
    """
    filename = Path("pysisif.log")

    # Create a custom logger
    logger = logging.getLogger('pysisif-processor')
    logger.setLevel(logging.INFO)

    # Create handlers
    f_handler = RotatingFileHandler(filename,maxBytes=5242880,backupCount=5)
    f_handler.setLevel(logging.INFO)
    
    # Create formatters and add it to handlers
    f_format = logging.Formatter('[%(asctime)s] [%(name)s] [%(process)d]:[%(thread)d] [%(levelname)s]: %(message)s')
    f_handler.setFormatter(f_format)

    # Add handlers to the logger
    logger.addHandler(f_handler)

    return logger



def automa_db(nota):

    # Using a DSN, but providing a password as well
    con = pyodbc.connect('DSN=pyautoma', autocommit=True)
    #con.setdecoding(pyodbc.SQL_WCHAR, encoding='utf-8')
    con.setencoding(encoding='utf-8')
    cur = con.cursor()

    sql_query = "SELECT cfo, tpo, codfor, nome FROM ENTRADAS WHERE Nota = ?"
    sql_tuple = (nota,)
    res = cur.execute(sql_query,sql_tuple)
    head_row = cur.fetchall()

    #automa_dict = {}
    #automa_dict["cfop"] = row[0]
    #automa_dict["tpo"] = row[1]

    sql2_query = '''SELECT pr.Seqo, pr.Cdpro, p.descricao, pr.Qtd, p.unidade, pr.Total, pr."Desc", p.SitA, p.SitB 
                    from prdent pr INNER JOIN produto p on (pr.cdpro = p.codigo) where pr.nota = ?
                 '''
    #sql2_query = "SELECT Seqo,Cdpro,Qtd,Total,Desc FROM prdent WHERE Nota = ?"
    sql2_tuple = (nota,)
    res2 = cur.execute(sql2_query,sql2_tuple)
    item_rows = cur.fetchall()

    cur.close()
    con.close()

    return head_row,item_rows




'''
sisif

select seqn from entradas where nron1 = '222172'
insert into PrdEntradas Values(...)
'''
def sisif_db(nota, atm_nfhead, atm_nfitems):

    # Using a DSN, but providing a password as well
    con2 = pyodbc.connect('DSN=pysisif', autocommit=True)
    #con.setdecoding(pyodbc.SQL_WCHAR, encoding='utf-8')
    con2.setencoding(encoding='utf-8')
    cur2 = con2.cursor()

    sql_query = "SELECT seqn FROM entradas WHERE nron1 = ?"
    sql_tuple = (nota,)
    res = cur2.execute(sql_query,sql_tuple)
    seqn_item = cur2.fetchone()
    seqn = seqn_item[0]
    cur2.close()


    ran = 1000
    for item in atm_nfitems:
        print (f'{ran}, {seqn}, {item[0]}, {item[1]}, {item[2]}, {item[3]}, {item[4]}, {item[5]:.2f}, {item[6]}, {item[7]}, {item[8]}, {atm_nfhead[0][0]}, 0, 0, 0 ')
        ran += 1


    print ("Inserting data indo Sisif")
    incount = 0
    for item in atm_nfitems:

        #if incount >= 2:
        #    break

        sql_insert = '''INSERT INTO prdentradas ("SeqN","SeqO","Codpro","Descpro","Qtd","Unid",
                        "Vl_item","Vl_desc","SitA","SitB","Cfop","Vl_bc_icms","Aliq_icms","Vl_icms") 
                        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
                     '''
        sql_intuple = (seqn, item[0], item[1], item[2], item[3], item[4], item[5], item[6], item[7], item[8], atm_nfhead[0][0], 0, 0, 0)
        cur3 = con2.cursor()
        inres =  cur3.execute(sql_insert,sql_intuple)
        cur3.close()
        incount += 1

    con2.close()


def main():

    parser = OptionParser(usage="usage: %prog [options]",
                          version="%prog 1.0")
    parser.add_option("-n", "--nota",
        action="store", type="string",
        default="",
        dest="nota",
        help='Numero da Nota [default: %default]'
    )
    (options, args) = parser.parse_args()

    '''
    Setting up the Logger
    '''
    # logger = set_up_logging(conf)
    nfhead, nfitems = automa_db(options.nota)
    sisif_db(options.nota, nfhead, nfitems)


    return 0


if __name__ == '__main__':
    status = main()
    sys.exit(status)