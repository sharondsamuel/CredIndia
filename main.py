from flask import *

from api import api


app=Flask(__name__)

app.secret_key="diet"


app.register_blueprint(api,url_prefix='/api')

app.run(debug=True,port=5022,host="0.0.0.0")
