#!/usr/bin/python

from flask import Flask, url_for
import json
app = Flask(__name__)

@app.route('/')
def api_root():
  return 'Welcome'

@app.route('/testme', methods = ["GET"])
def api_testme():
  resp = {
          "response" : "my_json_payload"
         }
  return json.dumps(resp)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int('5555'), debug=False)
