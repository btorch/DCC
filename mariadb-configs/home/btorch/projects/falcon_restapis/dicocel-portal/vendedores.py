import falcon
import json
import datetime
import mysql.connector as mariadb


"""
Dict for DB connection
Todo: Need to remove and place it into
      some safe place  
"""
dbconfig_dict = {
    'user': 'web02',
    'password': 'dicocel2019',
    'host': '127.0.0.1',
    'database': 'sistema_in',
    'charset':  'utf8mb4',
    'collation':'utf8mb4_unicode_ci'
}


class Acumulado(object):
    """
    Retrieves the data related to NFe's that are in transit
    """
    def on_get(self, req, resp, tipo):

        if tipo == "dia":
            sqlstm = """SELECT p.CodVen AS Codigo,v.Descricao AS Vendedor, SUM(p.TotPedido) AS Total
                        FROM PEDIDOS p JOIN Cadven v ON p.CodVen = v.Codigo 
                        WHERE p.Data = DATE(CONVERT_TZ(NOW(),'+00:00','-03:00'))
                        AND p.Codcli != '04773' AND p.NtFiscal != '' 
                        AND p.CodVen NOT IN ('00015','00053')
                        GROUP BY p.CodVen ORDER BY p.CodVen"""

        elif tipo == "semana":
           sqlstm = """SELECT p.CodVen AS Codigo,v.Descricao AS Vendedor, SUM(p.TotPedido) AS Total
                        FROM PEDIDOS p JOIN Cadven v ON p.CodVen = v.Codigo 
                        WHERE WEEK(p.Data) = WEEK(DATE(CONVERT_TZ(NOW(),'+00:00','-03:00')))
                        AND p.Codcli != '04773' AND p.NtFiscal != ''
                        AND p.CodVen NOT IN ('00015','00053')                        
                        GROUP BY p.CodVen ORDER BY p.CodVen"""

        elif tipo == "mes":
           sqlstm = """SELECT p.CodVen AS Codigo,v.Descricao AS Vendedor, SUM(p.TotPedido) AS Total
                        FROM PEDIDOS p JOIN Cadven v ON p.CodVen = v.Codigo 
                        WHERE MONTH(p.Data) = MONTH(DATE(CONVERT_TZ(NOW(),'+00:00','-03:00')))
                        AND p.Codcli != '04773' AND p.NtFiscal != ''
                        AND p.CodVen NOT IN ('00015','00053')   
                        GROUP BY p.CodVen ORDER BY p.CodVen"""

        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                cursor.execute(sqlstm)
                result = cursor.fetchall()
                cols = [x[0] for x in cursor.description]
                cursor.close()
                conn.close()
                json_data = []
                for x in [[str(row[key]) for key in row] for row in result]:
                    json_data.append( dict(zip(cols,x)) )
            resp.body = json.dumps(json_data, ensure_ascii=False)
        except mariadb.Error as e:
            resp.status = '400 Bad Request'
            resp.body = "ERROR: {}".format(e)






