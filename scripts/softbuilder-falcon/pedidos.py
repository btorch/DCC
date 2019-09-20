import falcon
import json
import datetime
import mysql.connector as mariadb
import configparser
import io
import os
import sys
import uuid
import mimetypes
from .logger import set_up_logging
logger = set_up_logging('Softbuilder')


#locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')


class AuthMiddleware(object):

    def process_request(self, req, resp):
        auth_key = req.get_header('x-auth-key')
        transid = str(uuid.uuid4())
        req.context.transid = transid
        xheader = {"X-Trans-Id":"{}".format(transid)}

        '''
        if 'healthcheck' in req.relative_uri:
            logger.info('"Healthcheck Only" (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))
            return True
        '''

        if auth_key is None:
            msg = 'Favor mandar X-Auth-Key header no pedido do API'
            logger.error('Auth key esta vazia (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))
            raise falcon.HTTPUnauthorized('Auth key obrigatorio', msg, xheader)

        if not self._token_is_valid(auth_key, transid, req.relative_uri):
            msg = 'A auth key enviada nao foi validada'
            logger.error('Auth key invalida (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))
            raise falcon.HTTPUnauthorized('Auth key invalida', msg, xheader)

    def _token_is_valid(self, auth_key, transid, uri):
        xheader = {"X-Trans-Id":"{}".format(transid)}
        try:
            if not 'softbuilder-falcon' in os.getcwd():
                config_path = os.getcwd() + '/softbuilder-falcon/dbconfig.ini'
            else:
                config_path = os.getcwd() + '/dbconfig.ini'

            config = configparser.ConfigParser()
            config.read(config_path)
            config_token = config['auth']['key']

            if auth_key != config_token:
                return False
            else:
                logger.info('Auth key validado (uri: {1}) (transid:{0})'.format(transid, uri))

        except IOError as e:
            logger.error('I/O Error: {}'.format(e))
            msg = 'Erro abrindo arquivo de configuracao'
            raise falcon.HTTPInternalServerError('I/O Error', msg, xheader)
        except:
            msg = 'Erro abrindo configuracao'
            raise falcon.HTTPInternalServerError('Openging config issue', msg, xheader)


        return True



class RequireJSON(object):

    def process_request(self, req, resp):
        transid = req.context.transid
        xheader = {"X-Trans-Id":"{}".format(transid)}

        if not req.client_accepts_json:
            msg = 'Somente respondemos pedidos de API em JSON'
            logger.error('Cliente nao aceita JSON (uri: {0}) (transid:{1})'.format(req.relative_uri, transid))
            raise falcon.HTTPNotAcceptable(msg, xheader, ref='https://json.org')
                
        if req.method in ('POST', 'PUT'):
            if 'application/json' not in req.content_type:
                msg = 'Somente pedidos de API em JSON aceito'
                logger.error('JSON media type obrigatorio (uri: {0}) (transid:{1})'.format(req.relative_uri, transid))
                raise falcon.HTTPUnsupportedMediaType(msg, xheader, href='https://json.org')




class PedidoHeader(object):

    def on_post(self, req, resp):
        #resp.status = falcon.HTTP_201
        auth_key = req.get_header('x-auth-key')
        transid = req.context.transid

        """
        Set Mariadb conn from config
        https://gist.github.com/btorch/7c4ab5c000a75e087983852ff67548a4
        """
        try:
            if not 'softbuilder-falcon' in os.getcwd():
                config_path = os.getcwd() + '/softbuilder-falcon/dbconfig.ini'
            else:
                config_path = os.getcwd() + '/dbconfig.ini'

            config = configparser.ConfigParser()
            config.read(config_path)

            dbconfig = {
                'user': config['mariadb']['user'],
                'password': config['mariadb']['password'],
                'host': config['mariadb']['host'],
                'database': config['mariadb']['database'],
                'charset':  config['mariadb']['charset'],
                'collation': config['mariadb']['collation']
            }

        except IOError as e:
            logger.error('I/O Error: {}'.format(e))
            msg = 'Erro abrindo configuracao para Banco de Dados'
            raise falcon.HTTPFailedDependency('DBConfig File Error',msg)


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

            #logger.info("JSON syntax ok: {0} (transid:{1})".format(pedido_header,transid))
            logger.info('JSON syntax ok (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))
        except falcon.errors.HTTPBadRequest as e:
            #msg = "Error getting json from media"
            #raise falcon.HTTPInternalServerError("JSON Media Error",msg)
            logger.error('{0} {1} (uri: {2}) (transid:{3})'.format(e.title,e.description,req.relative_uri,transid))
            raise falcon.HTTPBadRequest(e.title,e.description,href='https://jsonlint.com')
        except:
            msg = 'Please check your JSON object syntax'
            logger.error('JSON Media Error: {0} (uri: {1}) (transid:{2})'.format(msg,req.relative_uri,transid))
            raise falcon.HTTPBadRequest("JSON Media Error",msg,href='https://jsonlint.com')


        try:
            conn = mariadb.connect(**dbconfig)
            if conn.is_connected():
                logger.info('Database connection established (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))
                cursor = conn.cursor()

                sqlstm = """INSERT INTO pedido (id, dta_lanc, data, codcli,
                            codven, condpgto, formpgto, totped, status, obs)
                            VALUES (%s, NOW(), %s, %s, %s, %s, %s, %s, %s, %s)
                         """    

                sqlstm_tuple = (pedido_id, pedido_data, pedido_codcli, 
                                pedido_codven, pedido_condpgto, pedido_formpgto,
                                pedido_totped, pedido_status, pedido_obs)

                cursor.execute(sqlstm,sqlstm_tuple)
                conn.commit()
                rcount = cursor.rowcount
                logger.info('Insert query committed (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))

            resp.status = falcon.HTTP_201
            resp.append_header('X-Trans-Id',transid)
            resp.body = json.dumps({'status': 1, 'message': 'success','rowcount': rcount})

        except mariadb.Error as e:
            logger.error('Database Error {0} (transid:{1})'.format(e,transid))
            resp.status = falcon.HTTP_500
            resp.append_header('X-Trans-Id',transid)
            resp.body =json.dumps({'status': 0, 'message': 'DB Error {}'.format(e)})

        finally:
            if conn.is_connected():
                cursor.close()
                conn.close()
                logger.info('DB connection closed (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))




class PedidoItem(object):

    def on_post(self, req, resp):
        #resp.status = falcon.HTTP_201
        auth_key = req.get_header('x-auth-key')
        transid = req.context.transid

        """
        Set Mariadb conn from config
        https://gist.github.com/btorch/7c4ab5c000a75e087983852ff67548a4
        """
        try:
            if not 'softbuilder-falcon' in os.getcwd():
                config_path = os.getcwd() + '/softbuilder-falcon/dbconfig.ini'
            else:
                config_path = os.getcwd() + '/dbconfig.ini'

            config = configparser.ConfigParser()
            config.read(config_path)

            dbconfig = {
                'user': config['mariadb']['user'],
                'password': config['mariadb']['password'],
                'host': config['mariadb']['host'],
                'database': config['mariadb']['database'],
                'charset':  config['mariadb']['charset'],
                'collation': config['mariadb']['collation']
            }

        except IOError as e:
            logger.error('I/O Error: {}'.format(e))
            msg = 'Erro abrindo configuracao para Banco de Dados'
            raise falcon.HTTPFailedDependency('DBConfig File Error',msg)


        try:
            pedido_item = req.media.get('item')
            pedido_id = pedido_item['id']
            pedido_data = pedido_item['data']
            pedido_codcli = pedido_item['codcli']
            pedido_codven = pedido_item['codven']
            pedido_cdpro = pedido_item['cdpro']
            pedido_qtd = pedido_item['qtd']
            pedido_prunit = pedido_item['prunit']
            pedido_desconto = pedido_item['desconto']
            pedido_total = pedido_item['total']

            logger.info('JSON syntax ok (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))

        except falcon.errors.HTTPBadRequest as e:
            logger.error('{0} {1} (uri: {2}) (transid:{3})'.format(e.title,e.description,req.relative_uri,transid))
            raise falcon.HTTPBadRequest(e.title,e.description,href='https://jsonlint.com')

        except:
            msg = 'Please check your JSON object syntax'
            logger.error('JSON Media Error: {0} (uri: {1}) (transid:{2})'.format(msg,req.relative_uri,transid))
            raise falcon.HTTPBadRequest("JSON Media Error",msg,href='https://jsonlint.com')


        try:
            conn = mariadb.connect(**dbconfig)
            if conn.is_connected():
                logger.info('Database connection established (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))
                cursor = conn.cursor()

                sqlstm = """INSERT INTO prdped (id, data, codcli, codven,
                            cdpro, qtd, prunit, desconto, total)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                         """

                sqlstm_tuple = (pedido_id, pedido_data, pedido_codcli,
                                pedido_codven, pedido_cdpro, pedido_qtd,
                                pedido_prunit, pedido_desconto, pedido_total)

                cursor.execute(sqlstm,sqlstm_tuple)
                conn.commit()
                rcount = cursor.rowcount
                logger.info('Insert query committed (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))

            resp.status = falcon.HTTP_201
            resp.append_header('X-Trans-Id',transid)
            resp.body = json.dumps({'status': 1, 'message': 'success', 'rowcount': rcount})

        except mariadb.Error as e:
            logger.error('Database Error {0} (transid:{1})'.format(e,transid))
            resp.status = falcon.HTTP_500
            resp.append_header('X-Trans-Id',transid)
            resp.body =json.dumps({'status': 0, 'message': 'DB Error {}'.format(e)})

        finally:
            if conn.is_connected():
                cursor.close()
                conn.close()
                logger.info('DB connection closed (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))




class Pedido(object):

    def on_put(self, req, resp):
        #resp.status = falcon.HTTP_201
        auth_key = req.get_header('x-auth-key')
        transid = req.context.transid
        xheader = {"X-Trans-Id":"{}".format(transid)}

        """
        Set Mariadb conn from config
        https://gist.github.com/btorch/7c4ab5c000a75e087983852ff67548a4
        """
        try:
            if not 'softbuilder-falcon' in os.getcwd():
                config_path = os.getcwd() + '/softbuilder-falcon/dbconfig.ini'
            else:
                config_path = os.getcwd() + '/dbconfig.ini'

            config = configparser.ConfigParser()
            config.read(config_path)

            dbconfig = {
                'user': config['mariadb']['user'],
                'password': config['mariadb']['password'],
                'host': config['mariadb']['host'],
                'database': config['mariadb']['database'],
                'charset':  config['mariadb']['charset'],
                'collation': config['mariadb']['collation']
            }

        except IOError as e:
            logger.error('I/O Erro: {}'.format(e))
            msg = 'Erro abrindo arquivo de configuracao'
            raise falcon.HTTPFailedDependency('Erro lendo configuracao (1)', msg, xheader)

        except KeyError as e:
            logger.error('KeyError Erro: {}'.format(e))
            msg = 'Problema com Keys do DB Config {}'.format(e)
            raise falcon.HTTPFailedDependency('DB Config KeyError (2)', msg, xheader)


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
            ''' Items do Pedido '''
            pedido_items = req.media.get('items')

            if len(pedido_items) == 0:
                msg = 'Pedido Sem Nenhum item'
                logger.error('JSON Media Error: {0} (uri: {1}) (transid:{2})'.format(msg, req.relative_uri, transid))
                raise falcon.HTTPBadRequest("JSON faltando dados (3)", msg, xheader)

            logger.info('JSON syntax ok (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))

        except falcon.errors.HTTPBadRequest as e:
            logger.error('{0} {1} (uri: {2}) (transid:{3})'.format(e.title, e.description, req.relative_uri, transid))
            raise falcon.HTTPBadRequest(e.title, e.description, xheader)

        except KeyError as e:
            logger.error('JSON Pedido KeyError : {}'.format(e))
            msg = 'Problema com Keys do JSON Pedido {}'.format(e)
            raise falcon.HTTPFailedDependency('JSON Pedido KeyError (4)', msg, xheader)

        except:
            msg = 'Syntax do Objeto JSON nao aceito'
            logger.error('JSON Syntax Erro: {0} (uri: {1}) (transid:{2})'.format(msg, req.relative_uri, transid))
            raise falcon.HTTPBadRequest("JSON Syntax Erro (5)", msg, xheader)


        try:
            conn = mariadb.connect(**dbconfig)
            if conn.is_connected():
                logger.info('Database connection established (uri: {1}) (transid:{0})'.format(transid, req.relative_uri))
                cursor = conn.cursor()

                '''Cabecario do Pedido'''
                header_sqlstm = """INSERT INTO pedido (id, dta_lanc, data, codcli,
                                   codven, condpgto, formpgto, totped, status, obs)
                                   VALUES (%s, NOW(), %s, %s, %s, %s, %s, %s, %s, %s)
                                """    

                header_tuple = (pedido_id, pedido_data, pedido_codcli, 
                                pedido_codven, pedido_condpgto, pedido_formpgto,
                                pedido_totped, pedido_status, pedido_obs)

                try:
                    cursor.execute(header_sqlstm, header_tuple)
                    hrcount = cursor.rowcount
                    logger.info('Header [{0}] inserted into pedido table (uri: {1}) (transid:{2})'.format(hrcount, req.relative_uri, transid))

                except mariadb.Error as e:
                    logger.error('Database Erro: Pedido ID Existente {0} (transid:{1})'.format(e, transid))
                    conn.rollback()
                    title = "Database Pedido ID Existente (6)"
                    description = "ID Duplicado - {0}".format(e)
                    raise falcon.HTTPConflict(title, description, xheader)


                '''Items do Pedido'''
                item_sqlstm = """INSERT INTO prdped (id, data, codcli, codven,
                                 cdpro, qtd, prunit, desconto, total)
                                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                              """
            
                try:
                    for item in pedido_items:
                        item_tuple = (pedido_id, pedido_data, pedido_codcli,
                                      pedido_codven, item['cdpro'], item['qtd'],
                                      item['prunit'], item['desconto'], item['total'])

                        try:
                            cursor.execute(item_sqlstm, item_tuple)
                            logger.info('Item [{0}] inserted into prdped table (uri: {1}) (transid:{2})'.format(item['cdpro'], req.relative_uri, transid))

                        except mariadb.Error as e:
                            logger.error('Database Item Error {0} (transid:{1})'.format(e, transid))
                            conn.rollback()
                            title = "Database Item Error (7)"
                            description = "{0}".format(e)
                            raise falcon.HTTPConflict(title, description, xheader)


                except KeyError as e:
                    conn.rollback()
                    logger.error('JSON Item KeyError : {}'.format(e))
                    msg = 'Problema com Keys do JSON Item {}'.format(e)
                    raise falcon.HTTPBadRequest('JSON Item KeyError (8)', msg, xheader)

                except falcon.errors.HTTPBadRequest as e:
                    conn.rollback()
                    logger.error('{0} {1} (uri: {2}) (transid:{3})'.format(e.title, e.description, req.relative_uri, transid))
                    raise falcon.HTTPBadRequest(e.title, e.description, xheader)

                except:
                    conn.rollback()
                    msg = 'Syntax do Objeto JSON nao aceito {}'.format(sys.exc_info()[0])
                    logger.error('JSON Syntax Erro: {0} (uri: {1}) (transid:{2})'.format(msg, req.relative_uri, transid))
                    raise falcon.HTTPBadRequest("JSON Syntax Erro (9)", msg, xheader)

                conn.commit()
                logger.info('Insert query committed (uri: {1}) (transid:{0})'.format(transid,req.relative_uri))


            resp.status = falcon.HTTP_201
            resp.append_header('X-Trans-Id',transid)
            resp.body = json.dumps({'status': 1, 'message': 'success'})

        except mariadb.Error as e:
            logger.error('Database Connection Error {0} (transid:{1})'.format(e, transid))
            title = "Database Connection Error (10)"
            description = "{0}".format(e)
            raise falcon.HTTPInternalServerError(title, description, xheader)

        finally:
            if conn.is_connected():
               cursor.close()
               conn.close()
               logger.info('DB connection closed (uri: {0}) (transid:{1})'.format(req.relative_uri, transid))





