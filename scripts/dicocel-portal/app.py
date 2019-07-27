import falcon
from .transitando import Resource,ItemsNfe

api = application = falcon.API()

emtransito = Resource()
items_nfe = ItemsNfe()

api.add_route('/produtos/transitando', emtransito)
api.add_route('/produtos/transitando/items/{nfe}', items_nfe)

