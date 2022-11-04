import subprocess

from flask import Flask, request

app = Flask(__name__)

@app.route("/validate", methods=["POST"])
def hello_world():
    rpc_url = request.json.get('rpc_url')
    contract_address = request.json.get('contract_address')
    token_id = request.json.get('token_id')

    result = subprocess.run(["./validate.sh", rpc_url, contract_address, token_id], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8')