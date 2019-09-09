import os
import sys
from logging.handlers import SysLogHandler, RotatingFileHandler
import logging

# Logging Levels
# https://docs.python.org/3/library/logging.html#logging-levels
# CRITICAL  50
# ERROR 40
# WARNING   30
# INFO  20
# DEBUG 10
# NOTSET    0

loggers = {}

def set_up_logging(name):
    global loggers

    if loggers.get(name):
        return loggers.get(name)
    else:
        if not 'logs' in os.getcwd():
            log_path = os.getcwd() + '/logs/falcon_pedidos.log'
        else:
            log_path = os.getcwd() + '/falcon_pedidos.log'

        with open(log_path, 'a+'):
            pass

        logger = logging.getLogger(name)
        logger.setLevel(logging.INFO)
        handler = RotatingFileHandler(log_path,maxBytes=5242880,backupCount=5)
        #handler = logging.StreamHandler()
        handler.setLevel(logging.INFO)
        formatter = logging.Formatter('[%(asctime)s] [%(name)s] [%(process)d]:[%(thread)d] [%(levelname)s]: %(message)s]')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        loggers[name] = logger

        return logger