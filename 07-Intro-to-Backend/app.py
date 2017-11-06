import json
from flask import Flask
import pdb

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World'


@app.route('/person')
def person_route():
    pdb.set_trace()

    person = {'name': 'Bob', 'age': '109'}
    json_person = json.dumps(person)

    return json_person, 200, None


if __name__ == "__main__":
    app.run()
