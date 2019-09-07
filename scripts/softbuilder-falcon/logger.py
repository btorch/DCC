import os
import sys
from logging.handlers import RotatingFileHandle,StreamHandler
import logging

# Logging Levels
# https://docs.python.org/3/library/logging.html#logging-levels
# CRITICAL  50
# ERROR 40
# WARNING   30
# INFO  20
# DEBUG 10
# NOTSET    0


def set_up_logging():
    log_path = '/tmp/falcon_pedidos.log'
    with open(log_path, 'a+'):
        pass

    logger = logging.getLogger('falcon_pedidos')
    logger.setLevel(logging.DEBUG)
    #handler = RotatingFileHandler(log_path,maxBytes=5242880,backupCount=5)
    handler = StreamHandler(sys.stdout)
    #handler.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s: %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    return logger