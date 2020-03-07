import falcon
from falcon_cors import CORS
from .transitando import EmTransito,ItemsNfe,ProdRecb,Vendas,chartVendas
from .fornecedores import Fornecedor
from .vendedores import Acumulado

cors = CORS(allow_all_origins=True,allow_all_headers=True,
            expose_headers_list=['x-meu-fornecedor'],allow_all_methods=True)

api = application = falcon.API(middleware=[cors.middleware])

emtransito = EmTransito()
recebido = ProdRecb()
items_nfe = ItemsNfe()
vendas = Vendas()
vchart = chartVendas()
fornecedor = Fornecedor()
vendedores = Acumulado()

api.add_route('/produtos/transitando', emtransito)
api.add_route('/produtos/recebidos', recebido)
api.add_route('/produtos/items/{nfe}', items_nfe)
api.add_route('/vendas/{tipo}', vendas)
api.add_route('/chart/vendas', vchart)
api.add_route('/fornecedor/{codigo}/{tipo}', fornecedor)
api.add_route('/vendedores/acumulado/{tipo}', vendedores)
