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
    'host': '127.0.0.1',
    'database': 'fornecedor_in',
    'charset':  'utf8mb4',
    'collation':'utf8mb4_unicode_ci'
}

dbconfig2_dict = {
    'user': 'web02',
    'password': 'dicocel2019',
    'host': '127.0.0.1',
    'database': 'sistema_in',
    'charset':  'utf8mb4',
    'collation':'utf8mb4_unicode_ci'
}


class EmTransito(object):
    """
    Retrieves the data related to NFe's that are in transit
    """
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        h_fornecedor = req.get_header('x-meu-fornecedor')
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                sqlstm = """SELECT nfe_numero,mes_analisado,DATE(nfe_data) AS nfe_data,
                            SUBSTRING(emissor_nome,1,14) AS emissor_nome,
                            FORMAT(valor_bruto,2,'de_DE') AS valor_bruto,
                            FORMAT(valor_nota,2,'de_DE') AS valor_nota,
                            prod_volumes FROM transitando_nfe
                            WHERE prod_recebido = False
                            AND emissor_nome Like %s """
                sqlstm_tuple = ("%" + h_fornecedor + "%",)
                cursor.execute(sqlstm,sqlstm_tuple)
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
        h_fornecedor = req.get_header('x-meu-fornecedor')
        try:
            conn = mariadb.connect(**dbconfig_dict)
            if conn.is_connected():
                cursor = conn.cursor(dictionary=True)
                sqlstm = """SELECT nfe_numero,mes_analisado,DATE(nfe_data) AS nfe_data,
                            SUBSTRING(emissor_nome,1,14) AS emissor_nome,
                            FORMAT(valor_bruto,2,'de_DE') AS valor_bruto,
                            FORMAT(valor_nota,2,'de_DE') AS valor_nota,                            
                            prod_volumes FROM transitando_nfe
                            WHERE prod_recebido = True
                            AND emissor_nome Like %s """
                sqlstm_tuple = ("%" + h_fornecedor + "%",)
                cursor.execute(sqlstm,sqlstm_tuple)
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


class Vendas(object):
    """
    Retreives information related to sale numbers
    """
    def on_get(self, req, resp, tipo):

        if tipo == "dia":
            sqlstm = """SELECT p.Seq AS Pedido, p.Status, p.Data, p.NtFiscal, p.Codcli AS ClienteNum,
                        (SELECT c.nomecli FROM CADCLI c WHERE c.codcli = p.Codcli ) AS Cliente,
                        p.CodVen AS VendedorNum,
                        (SELECT v.Descricao FROM Cadven v WHERE v.Codigo = p.CodVen ) AS Vendedor,
                        FORMAT(p.TotPedido,2,'de_DE') AS TotalPedido, p.Qtd_Parc AS Parcelas FROM PEDIDOS p 
                        WHERE p.Data = (CURDATE() - INTERVAL 100 DAY) and
                        p.Codcli != '04773' ORDER BY p.CodVen """

        elif tipo == "semana":
            sqlstm = """SELECT p.Seq AS Pedido, p.Status, p.Data, p.NtFiscal, p.Codcli AS ClienteNum,
                        (SELECT c.nomecli FROM CADCLI c WHERE c.codcli = p.Codcli ) AS Cliente,
                        p.CodVen AS VendedorNum,
                        (SELECT v.Descricao FROM Cadven v WHERE v.Codigo = p.CodVen ) AS Vendedor,
                        FORMAT(p.TotPedido,2,'de_DE') AS TotalPedido, p.Qtd_Parc AS Parcelas FROM PEDIDOS p 
                        WHERE WEEK(p.Data) = WEEK(DATE(CONVERT_TZ((CURDATE() - INTERVAL 100 DAY),'+00:00','-03:00')))
                        and p.Codcli != '04773' ORDER BY p.CodVen """


        resp.status = falcon.HTTP_200
        try:
            conn = mariadb.connect(**dbconfig2_dict)
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
