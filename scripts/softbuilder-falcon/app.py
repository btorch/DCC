import falcon
from falcon_cors import CORS
from .pedidos import Pedido, AuthMiddleware, RequireJSON


#locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')
'''
Required Pip Modules
mysql-connector falcon falcon-cors gunicorn

'''

cors = CORS(allow_all_origins=True,allow_all_headers=True,
            expose_headers_list=['x-auth-key','x-transid'],allow_all_methods=True)


#api = application = falcon.API(middleware=[cors.middleware,AuthMiddleware(),RequireJSON()])
api = application = falcon.API(middleware=[cors.middleware,AuthMiddleware(),RequireJSON()])

'''
PedidoHeader, PedidoItem, 
pedido_header = PedidoHeader()
pedido_item = PedidoItem()

api.add_route('/pedido/header', pedido_header)
api.add_route('/pedido/item', pedido_item)
'''
pedido = Pedido()
api.add_route('/pedido', pedido)

