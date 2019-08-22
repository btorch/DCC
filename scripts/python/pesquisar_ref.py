#! python

import sys
import mysql.connector


def main():

    mydb = mysql.connector.connect(host='192.168.1.200',user='dicocel',passwd='1234',database='base_dados')
    mycursor = mydb.cursor()
    
    loc = str(sys.argv[1])
    ref = str(sys.argv[2])
    sql = "SELECT id, nomepro, Gramatura, Codref FROM produto WHERE Codref = \"%s\" " % ref

    mycursor.execute(sql)
    myresult = mycursor.fetchall()
    for x in myresult:
      print ("\n")
      print(x[1])
      print("LOC: %s -- %s" % (loc,str(x[2])))
      print("COD: %s -- REF: %s" % (x[0],x[3]))
      print ("\n")

      # Write to a csv file
      #f = open("produtos_loc.csv", "a")
      #f.write("%s, %s, %s, %s \n" % (x[0], x[3], loc, x[1]))
      #f.close()

    #print "SQL : %s \n" % sql
    #print "REF : %s \n" % ref
    mycursor.close()
    mydb.close()

    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)

