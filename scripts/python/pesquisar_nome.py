#!/usr/local/bin/python

import sys
import mysql.connector


def main():

    mydb = mysql.connector.connect(host='192.168.1.200',user='dicocel',passwd='1234',database='base_dados')
    mycursor = mydb.cursor()
    
    nome = str(sys.argv[1])
    sql_select = "SELECT * FROM produto WHERE nomepro LIKE \"%{0}%\"".format(nome)

    mycursor.execute(sql_select)
    myresult = mycursor.fetchall()

    for i in mycursor.description:
        print ("{0}\t".format(str(i[0])) ),

    print ("\n")
    for x in myresult:
        for y in x:
          # Python 3
          # print(str(y), end =" ") 
          # Python 2
          print("{0}\t".format(str(y)))

        #print "\n"

    print ("\n")
    mycursor.close()
    mydb.close()

    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)

