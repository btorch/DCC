import falcon
import json
import mysql.connector as mariadb



"""
Dict for DB connection
Todo: Need to remove and place it into
      some safe place  
"""
dbconfig_dict = {
    'user': 'web01',
    'password': 'dicocel2019',
    'host': '10.1.1.149',
    'database': 'fornecedor_in',
    'charset':  'utf8mb4',
    'collation':'utf8mb4_unicode_ci'
}



class EmTransito(object):
    """
    Retrieves the data related to NFe's that are in transit
    """
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                cursor.execute("SELECT * FROM transitando_nfe WHERE prod_recebido = False")
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



class ProdRecb(object):
    """
    Retrieves the data related to NFe's that have already been recieved
    """
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                cursor.execute("SELECT * FROM transitando_nfe WHERE prod_recebido = True")
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



class ItemsNfe(object):
    """
    Retreives the items related to an NFe number
    """
    def on_get(self, req, resp, nfe):
        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                cursor.execute("SELECT * FROM transitando_nfe_items where nfe_numero = {}".format(nfe))
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


