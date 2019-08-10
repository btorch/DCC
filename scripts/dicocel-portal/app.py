import falcon
from .transitando import EmTransito,ItemsNfe,ProdRecb

api = application = falcon.API()

emtransito = EmTransito()
recebido = ProdRecb()
items_nfe = ItemsNfe()

api.add_route('/produtos/transitando', emtransito)
api.add_route('/produtos/recebidos', recebido)
api.add_route('/produtos/items/{nfe}', items_nfe)

