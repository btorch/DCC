import falcon
import json
import datetime
import mysql.connector as mariadb


"""
Dict for DB connection
Todo: Need to remove and place it into
      some safe place  
"""

dbconfig2_dict = {
    'user': 'web02',
    'password': 'dicocel2019',
    'host': '127.0.0.1',
    'database': 'sistema_in',
    'charset':  'utf8mb4',
    'collation':'utf8mb4_unicode_ci'
}


class Fornecedor(object):
    """
    Retreives information related to sale numbers
    Testing: (NOW() - INTERVAL 60 DAY)
    00053 = VENDAS INTERNA
    00015 = VENDAS DIRETAS
    04773 = DICOCEL
    """
    def on_get(self, req, resp, codigo, tipo):
        '''
        | 00002  | BELOCAP PRODUTOS CAPILARES LTDA.         |
        | 00653  | SALVATORI INDUSTRIA E COM DE COSMETICOS  |
        | 00208  | BELOCAP - REDKEN                         |
        | 00679  | DELLY DISTRIBUIDORA DE COSMETICOS E PRES |
        | 00008  | CASA ADELINO PRODUTOS ANACONDA LTDA.     |
        | 00179  | VICTORIA AUGUSTA COSMETICOS LTDA - EPP   |
        | 00004  | LABORATORIO SKLEAN DO BRASIL LTDA        |
        | 00156  | ATALANTA LABORATORIO E COSMETICOS LTDA   |
        '''


        if tipo == "dia":
            sqlstm = """SELECT COUNT(i.Cdpro) AS dia_itens FROM PrdPed i
                        JOIN produto c ON i.Cdpro = c.Codigo
                        WHERE i.Data = DATE(CONVERT_TZ(NOW(),'+00:00','-03:00'))
                        AND c.CodFor = %s"""

        elif tipo == "semana":
            sqlstm = """SELECT COUNT(i.Cdpro) AS semana_itens FROM PrdPed i
                        JOIN produto c ON i.Cdpro = c.Codigo
                        WHERE WEEK(i.Data) = WEEK(DATE(CONVERT_TZ(NOW(),'+00:00','-03:00')))
                        AND c.CodFor = %s"""

        elif tipo == "mes":
            sqlstm = """SELECT COUNT(i.Cdpro) AS mes_itens FROM PrdPed i
                        JOIN produto c ON i.Cdpro = c.Codigo
                        WHERE MONTH(i.Data) = MONTH(DATE(CONVERT_TZ(NOW(),'+00:00','-03:00')))
                        AND c.CodFor = %s"""

        elif tipo == "vdia":
            sqlstm = """SELECT FORMAT(SUM(i.Total),2,'de_DE') AS dia_valor FROM PrdPed i 
                        JOIN produto c ON i.Cdpro = c.Codigo 
                        WHERE i.Data = DATE(CONVERT_TZ(NOW(),'+00:00','-03:00')) 
                        AND c.CodFor = %s"""

        elif tipo == "vsemana":
            sqlstm = """SELECT FORMAT(SUM(i.Total),2,'de_DE') AS semana_valor FROM PrdPed i 
                        JOIN produto c ON i.Cdpro = c.Codigo 
                        WHERE WEEK(i.Data) = WEEK(DATE(CONVERT_TZ(NOW(),'+00:00','-03:00'))) 
                        AND c.CodFor = %s"""

        elif tipo == "vmes":
            sqlstm = """SELECT FORMAT(SUM(i.Total),2,'de_DE') AS mes_valor FROM PrdPed i 
                        JOIN produto c ON i.Cdpro = c.Codigo 
                        WHERE MONTH(i.Data) = MONTH(DATE(CONVERT_TZ(NOW(),'+00:00','-03:00'))) 
                        AND c.CodFor = %s"""
        

        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig2_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                cursor.execute(sqlstm,(codigo,))
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

