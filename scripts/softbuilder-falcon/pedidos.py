import falcon
import json
import datetime
import mysql.connector as mariadb
import configparser
import io
import os
import uuid
import mimetypes
from .logger import set_up_logging
logger = set_up_logging()


#locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')


class AuthMiddleware(object):

    def process_request(self, req, resp):
        auth_key = req.get_header('x-auth-key')
        transid = str(uuid.uuid4())
        req.context.transid = transid

        if auth_key is None:
            msg = 'Favor mandar X-Auth-Key header no pedido do API'
            raise falcon.HTTPUnauthorized('Auth token required',msg)

        if not self._token_is_valid(auth_key):
            msg = 'A token mandada nao foi validada'
            raise falcon.HTTPUnauthorized('Authentication required',msg)

    def _token_is_valid(self, auth_key):

        try:
            config = configparser.ConfigParser()
            config.read('config.ini')
            config_token = config['auth']['key']

            if auth_key != config_token:
                return False
        except:
            msg = 'Erro abrindo configuracao'
            raise falcon.HTTPFailedDependency('Openging config issue',msg)

        return True



class RequireJSON(object):

    def process_request(self, req, resp):
        if not req.client_accepts_json:
            msg = 'Somente respondemos pedidos de API em JSON'
            raise falcon.HTTPNotAcceptable(msg,ref='https://json.org')
                
        if req.method in ('POST', 'PUT'):
            if 'application/json' not in req.content_type:
                msg = 'Somente pedidos de API em JSON aceito'
                raise falcon.HTTPUnsupportedMediaType(msg,href='https://json.org')




class PostPedidoHeader(object):

    def on_post(self, req, resp):
        #resp.status = falcon.HTTP_201
        auth_key = req.get_header('x-auth-key')
        #transid = req.context.transid
        transid = str(uuid.uuid4())
        
        """
        Set Mariadb conn from config
        https://gist.github.com/btorch/7c4ab5c000a75e087983852ff67548a4
        """
        try:
            config = configparser.ConfigParser()
            config.read('config.ini')

            dbconfig = {
                'user': config['mariadb']['user'],
                'password': config['mariadb']['password'],
                'host': config['mariadb']['host'],
                'database': config['mariadb']['database'],
                'charset':  config['mariadb']['charset'],
                'collation':config['mariadb']['collation']
            }
        except:
            msg = "Erro abrindo configuracao para Banco de Dados"
            raise falcon.HTTPFailedDependency("DBConfig Error",msg)


        try:
            pedido_header = req.media.get('header')
            pedido_id = pedido_header['id']
            pedido_data = pedido_header['data']
            pedido_codcli = pedido_header['codcli']
            pedido_codven = pedido_header['codven']
            pedido_condpgto = pedido_header['condpgto']
            pedido_formpgto = pedido_header['formpgto']
            pedido_totped = pedido_header['totped']
            pedido_status = pedido_header['status']
            pedido_obs = pedido_header['obs']

            logger.info("Media OK: {0}".format(pedido_header))
        except:
            logger.info("media: {0}".format(pedido_header))
            msg = "Error getting json from media"
            raise falcon.HTTPInternalServerError("JSON Media Error",msg)


        try:
            conn = mariadb.connect(**dbconfig)
            if conn.is_connected():
                cursor = conn.cursor()

                sqlstm = """INSERT INTO pedido (id, dta_lanc, data, codcli,
                            codven, condpgto, formpgto, totped, status, obs)
                            VALUES (%s, NOW(), %s, %s, %s, %s, %s, %s, %s, %s)
                         """    

                sqlstm_tuple = (pedido_id, pedido_data, pedido_codcli, 
                                pedido_codven, pedido_condpgto, pedido_formpgto,
                                pedido_totped, pedido_status, pedido_obs)

                #cursor.execute(sqlstm,sqlstm_tuple)
                cursor.close()
                conn.close()

            resp.status = falcon.HTTP_201
            resp.append_header('X-Transid',transid)
            resp.body = json.dumps({'status': 1, 'message': 'success'})

        except mariadb.Error as e:
            resp.status = falcon.HTTP_500
            resp.append_header('X-Transid',transid)
            resp.body =json.dumps({'status': 0, 'message': 'DB Issue'})







