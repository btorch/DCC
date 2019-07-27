import falcon
import json
import mysql.connector as mariadb


dbconfig_dict = {
    'user': 'web01',
    'password': 'dicocel2019',
    'host': '10.1.1.149',
    'database': 'fornecedor_in',
    'charset':  'utf8mb4',
    'collation':'utf8mb4_unicode_ci'
}

class Resource(object):

    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                cursor.execute("SELECT * FROM transitando_nfe")
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


