#! /usr/bin/env python3

import time
import locale
import sys
import os
import json
import shutil
import dateutil.parser
from optparse import OptionParser
from configparser import ConfigParser
from logging.handlers import SysLogHandler, RotatingFileHandler
import logging
import urllib3
import requests
from requests.exceptions import HTTPError
import slack




"""
Info:
    - Install Location: /opt/{app_name}/{bin,log,data,...}

Todo: 
    - Add Slack 
    https://api.slack.com/apps/AQWD3JVFG/general?
    https://slack.dev/python-slackclient/basic_usage.html#sending-a-message
"""


"""
Setting up environmental variables
"""
#os.environ['LC_ALL'] = 'C'
#os.environ['LANG'] = 'en_US.UTF-8'
locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')


"""
Disable InsecureRequestWarning for requests
"""
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)



def set_up_logging(conf):
    """
    Setting up Logging

    param conf: Dict of parsed configuration params
    return: logger object
    """

    # Create a custom logger
    logger = logging.getLogger('softbuilder-processor')
    logger.setLevel(logging.INFO)

    # Create handlers
    f_handler = RotatingFileHandler(conf['logfile'],maxBytes=5242880,backupCount=5)
    f_handler.setLevel(logging.INFO)
    
    # Create formatters and add it to handlers
    f_format = logging.Formatter('[%(asctime)s] [%(name)s] [%(process)d]:[%(thread)d] [%(levelname)s]: %(message)s')
    f_handler.setFormatter(f_format)

    # Add handlers to the logger
    logger.addHandler(f_handler)

    return logger



def enviar_mensagem_slack(logger, slack_token, channel, message):

    client = slack.WebClient(token=slack_token)
    try:
        response = client.chat_postMessage(channel=channel, text=message)
    except:
        logger.exception(f"Slack Inesperado -  {sys.exc_info()[0]} : {sys.exc_info()[1]}")


    # Check to see if the message sent successfully.
    # If the message succeeded, `response["ok"]`` will be `True`
    if response["ok"]:
        #logger.info(f"Slack mensagem enviada com sucesso para {response["channel"]}/{response["message"]["ts"]}")
        logger.info(f"Slack mensagem enviada com sucesso para {channel}")
    # If the message failed, check for rate limit headers in the response
    # and try to send it a second time only
    elif response["ok"] is False and response["headers"]["Retry-After"]:
        delay = int(response["headers"]["Retry-After"])
        logger.info("Slack Rate limited - Retransmitindo em " + str(delay) + " seconds")
        time.sleep(delay)
        retry = client.chat_postMessage(channel=channel, text=message)
        if retry["ok"]:
            logger.info(f"Slack mensagem enviada com sucesso para  {channel} (retry:2)")
        else:
            logger.info(f"Slack mensagem nao enviada devido problemas (retry:2)")



def parse_config(configfile):
    """
    Takes care of parsing the configuration file

    param configfile: Full path of config file 
    returns: Dict containing the data found on the config file
    """
    results = {}
    c = ConfigParser()
    if not c.read(configfile):
        raise Exception("Arquivo de config vazio")
        sys.exit(1)
    else:
        if c.has_section('pedidos'):
            conf = dict(c.items('pedidos'))
            results['json_incoming'] = conf.get('json_incoming', '/opt/softbuilder-processor/pedidos')
            results['json_outgoing'] = conf.get('json_outgoing', '/opt/softbuilder-processor/processados')
            results['json_errors'] = conf.get('json_errors', '/opt/softbuilder-processor/errors')
        else:
            raise Exception("Secao para pedidos nao encontrado")
            sys.exit(1)

        if c.has_section('logger'):
            conf = dict(c.items('logger'))
            results['logfile'] = conf.get('log', '/opt/softbuilder-processor/log/processor.log')
        else:
            raise Exception("Secao para logging nao encontrado")
            sys.exit(1)

        if c.has_section('restapi'):
            conf = dict(c.items('restapi'))
            results['protocol'] = conf.get('protocol', 'http')
            results['addr'] = conf.get('addr', '127.0.0.1')
            results['port'] = conf.get('port', '8080')
            results['path'] = conf.get('path', '/pedido')
            results['key'] = conf.get('key', 'xxxx')
        else:
            raise Exception("Secao para Rest API nao encontrados")
            sys.exit(1)

        if c.has_section('slack'):
            conf = dict(c.items('slack'))
            results['slack_token'] = conf.get('slack_token', 'XXXXX')
            results['slack_channel'] = conf.get('slack_channel', 'sbvendas-pedidos')
        else:
            raise Exception("Secao para slack nao encontrada")
            sys.exit(1)


    return results



def get_ped_jsons(logger, pedidos_in):
    """
    Gets a listing of JSON files found on the location provided

    param pedidos_in: Folder where the JSON files exist
    returns: a list of all JSON files found with absolute path
    """
    
    abs_files = []
    if os.path.isdir(pedidos_in):
        if not len(os.listdir(pedidos_in)) == 0:
            for file in os.listdir(pedidos_in):
                if file.endswith((".json",".JSON")):
                    if os.path.isfile(os.path.join(pedidos_in, file)):
                        abs_files.append(os.path.join(pedidos_in, file))
        else:
            logger.info(f"Diretorio esta vazio: {pedidos_in}")
    else:
        logger.error(f"Diretorio nao existe: {pedidos_in}")
        sys.exit(1)

    return abs_files



def process_pedido(conf, logger, json_file):
    """
    Opens and reads all query lines of the SQL
    file that has been created on Windows Server
    from a Paradox to MySQL export logic

    param conf: Dict containing configuration file params
    param logger: Object for logger
    param json_file: Single json file for a pedido

    return status
    
    refs:
        curl -ki -XPUT 
        -H 'content-type: application/json' 
        -H 'X-Auth-Key: xxx' -d @data6.json
        https://10.1.1.22:10000/pedido
    """

    """
    Setup Rest API URL
    """
    proto = conf['protocol']
    ip = conf['addr']
    port = conf['port']
    uri = conf['path']
    key = conf['key']
    api_url = f"{proto}://{ip}:{port}{uri}"
    myheaders = {'X-Auth-Key': key, 'content-type':'application/json'}

    """
    SLACK
    """
    channel = conf['slack_channel']
    token = conf['slack_token']


    """
    Open JSON file for pedido
    """
    json_loading = 0
    json_processed = 0
    json_fname = os.path.basename(json_file)

    # Slack Notificacoes
    slack_msg_move_err = "Slack - Erro tentando "

    try:
        with open(json_file) as fd:
            try:
                json_data = json.load(fd)
                if ( len(json_data['items']) or len(json_data['header']) ) == 0 :
                    logger.info(f"Pedido nao parece conter nada: {json_file}")
                    json_loading = 2
                else:
                    logger.info(f"Iniciando carregamento do pedido: {json_file}")
                    json_loading = 1
            except json.JSONDecodeError as je:
                logger.exception(f"Erro decodificando JSON - {je}")
                fd.close()
            except ValueError as e:
                logger.exception(f"Erro JSON ({e.errno}): {e.strerror}")
                fd.close()
    except IOError as e:
        logger.exception(f"I/O Erro ({e.errno}): {e.strerror}")
        return 1
    except FileNotFoundError as fnf_error:
        logger.exception(f"Arquivo Json nao encontrado: {fnf_error}")
        return 1
    except:
        logger.exception(f"I/O Erro Inesperado -  {sys.exc_info()[0]} : {sys.exc_info()[1]}")
        return 1
    else:
        logger.info(f"Fechando aquivo do pedido: {json_file}")
        fd.close()


    # Se tudo deu certo loading o arquivo json
    # enviar arquivo para Rest API
    if json_loading == 1:
        try:
            response = requests.put(api_url, json=json_data, headers=myheaders, verify=False)
            transId = response.headers.get('X-Trans-Id','N/A')
            # If the response was successful, no Exception will be raised
            response.raise_for_status()
        except HTTPError as http_err:
            logger.error(f"HTTP erro ocorreu: {http_err}")
            logger.error(f"Arquivo {json_file} nao pode ser submitido")
            return 1
        except Exception as err:
            logger.error(f"Non-HTTP erro ocorreu: {err}")
            logger.error(f"Arquivo {json_file} nao pode ser submitido")
            return 1
        else:
            logger.info(f"Pedido submitido com sucesso (Status: {response.status_code}, Trans-Id: {transId})")

        """
        Caso pedido tenha sido processado com sucesso
        """
        if 200 <= response.status_code <= 299:
            json_processed = 1
            try:
                shutil.move(json_file, conf['json_outgoing'])
                logger.info(f"Movendo arquivo Json de pedido ja processado (Trans-Id: {transId})")

            except shutil.Error as se:
                logger.exception(f"Shutil erro movendo arquivo: {se} (Trans-Id: {transId})")
                slack_msg_move_err = f"Slack - Shutil erro movendo arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
                slack_msg_move_err += f"\nSlack - Shutil Error: {se} (Trans-Id: {transId})"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
            except IOError as e:
                logger.exception(f"I/O Erro movendo arquivo - ({e.filename},{e.errno}): {e.strerror} (Trans-Id: {transId})")
                slack_msg_move_err = f"Slack - I/O Erro movendo arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
                slack_msg_move_err += f"\nSlack - I/O Error: ({e.filename},{e.errno}), {e.strerror}  (Trans-Id: {transId})"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
            except OSError as e:
                logger.exception(f"OS Erro movendo arquivo - ({e.filename},{e.errno}): {e.strerror} (Trans-Id: {transId})")
                slack_msg_move_err = f"Slack - OS Erro movendo arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
                slack_msg_move_err += f"\nSlack - OS Error: ({e.filename},{e.errno}), {e.strerror}  (Trans-Id: {transId})"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
        else:
            try:
                shutil.move(json_file, conf['json_errors'])
                logger.error(f"Movendo arquivo Json de pedido nao processado para diretorio errors (Trans-Id: {transId})")
                return 1
            except shutil.Error as se:
                logger.exception(f"Shutil erro movendo arquivo: {se} (Trans-Id: {transId})")
                slack_msg_move_err = f"Slack - Shutil erro movendo arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
                slack_msg_move_err += f"\nSlack - Shutil Error: {se} (Trans-Id: {transId})"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
                return 1
            except IOError as e:
                logger.exception(f"I/O Erro movendo arquivo - ({e.filename},{e.errno}): {e.strerror} (Trans-Id: {transId})")
                slack_msg_move_err = f"Slack - Erro tentando mover arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
                slack_msg_move_err += f"\nSlack - I/O Error: ({e.filename},{e.errno}), {e.strerror}  (Trans-Id: {transId})"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
                return 1
            except OSError as e:
                logger.exception(f"OS Erro movendo arquivo - ({e.filename},{e.errno}): {e.strerror} (Trans-Id: {transId})")
                slack_msg_move_err = f"Slack - OS Erro movendo arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
                slack_msg_move_err += f"\nSlack - OS Error: ({e.filename},{e.errno}), {e.strerror}  (Trans-Id: {transId})"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
                return 1

    elif json_loading == 2:
            try:
                shutil.move(json_file, conf['json_errors'])
                logger.error(f"Arquivo {json_fname} nao contem nenhum item")
                logger.error(f"Movendo arquivo de pedido vazio")
                return 1
            except (shutil.Error, IOError, OSError) as e:
                logger.error(f"Erro movendo arquivo de pedido vazio: {e}")
                slack_msg_move_err = f"Slack - Erro movendo arquivo de pedido vazio {json_fname}"
                slack_msg_move_err += f"\nSlack - {e}"
                slack_msg_move_err += f"\nSlack - Nada sendo processado"
                enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
                return 1
    else:
        try:
            shutil.move(json_file, conf['json_errors'])
            logger.error(f"Error JSON Syntax com arquivo {json_fname}, movendo para diretorio errors (Trans-Id: {transId})")
            return 1
        except shutil.Error as se:
            logger.exception(f"Shutil erro movendo arquivo: {se} (Trans-Id: {transId})")
            slack_msg_move_err = f"Slack - Shutil erro movendo arquivo json {json_fname} para diretorio errors (Trans-Id: {transId})"
            slack_msg_move_err += f"\nSlack - Shutil Error: {se} (Trans-Id: {transId})"
            enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
            return 1
        except IOError as e:
            logger.exception(f"I/O Erro movendo arquivo - ({e.filename},{e.errno}): {e.strerror} (Trans-Id: {transId})")
            slack_msg_move_err = f"Slack - JSON Syntax Erro: tentando mover arquivo {json_fname} para diretorio errors (Trans-Id: {transId})"
            slack_msg_move_err += f"\nSlack - I/O Error: ({e.filename},{e.errno}), {e.strerror}  (Trans-Id: {transId})"
            enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
            return 1
        except OSError as e:
            logger.exception(f"OS Erro movendo arquivo - ({e.filename},{e.errno}): {e.strerror} (Trans-Id: {transId})")
            slack_msg_move_err = f"Slack - JSON Syntax Erro: tentando mover arquivo {json_fname} para diretorio errors (Trans-Id: {transId})"
            slack_msg_move_err += f"\nSlack - OS Error: ({e.filename},{e.errno}), {e.strerror}  (Trans-Id: {transId})"
            enviar_mensagem_slack(logger, token, channel, slack_msg_move_err)
            return 1

    return 0



def main():

    parser = OptionParser(usage="usage: %prog [options]",
                          version="%prog 1.0")
    parser.add_option("-c", "--conf",
        action="store", type="string",
        default="./config.cfg",
        dest="config",
        help='Local do arquivo com configuracoes [default: %default]'
    )
    (options, args) = parser.parse_args()
    conf = parse_config([options.config, ])

    '''
    Setting up the Logger
    '''
    logger = set_up_logging(conf)

    '''
    Get all JSON pedidos files
    '''
    lista_pedidos = get_ped_jsons(logger,conf['json_incoming'])

    if lista_pedidos:
        for pedido in lista_pedidos:
            result = process_pedido(conf, logger, pedido)
            pedido_base = os.path.basename(pedido)
            if not result:
                logger.info(f"Pedido {pedido} processado")
            else:
                logger.info(f"Pulando pedido {pedido_base}")
    else:
        logger.info("Nenhum pedido para ser processado ... finalizando")
        sys.exit(0)

    return 0


if __name__ == '__main__':
    status = main()
    sys.exit(status)


