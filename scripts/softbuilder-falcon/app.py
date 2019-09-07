import falcon
from falcon_cors import CORS
from .pedidos import PostPedidoHeader, AuthMiddleware, RequireJSON
from .logger import set_up_logging
logger = set_up_logging()

#locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')


cors = CORS(allow_all_origins=True,allow_all_headers=True,
            expose_headers_list=['x-auth-key','x-transid'],allow_all_methods=True)


#api = application = falcon.API(middleware=[cors.middleware,AuthMiddleware(),RequireJSON()])
api = application = falcon.API(middleware=[cors.middleware])

pedido_header = PostPedidoHeader()
#peido_item = PostPedidoItem()

api.add_route('/pedido/header', pedido_header)
#api.add_route('/pepido/item', pedido_item)

