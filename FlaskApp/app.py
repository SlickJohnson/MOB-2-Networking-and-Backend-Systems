import json
from flask import Flask, request
import pdb

from pymongo import MongoClient
from encoder import JSONEncoder
from bson import Binary, Code
from bson.json_util import dumps

mongo = MongoClient('localhost', 27017)

app = Flask(__name__)

app.db = mongo.test


@app.route('/')
def index():
    return 'Hello World'


@app.route('/users')
def users():
    name = request.args.get('name')

    users_collection = app.db.users

    result = users_collection.find_one(
        {'name': name}
    )

    json_result = dumps(result)


    return(json_result, 200, None)


@app.route('/courses', methods=['GET', 'POST'])
def courses():
    courses_collection = app.db.courses

    if request.method == 'POST':
        course = request.json

        result = courses_collection.insert_one(course)

        return (JSONEncoder().encode(result), 201, None)

    name = request.args.get('name')

    result = courses_collection.find_one(
        {'name': name}
    )

    return (JSONEncoder().encode(result), 200, None)


@app.route('/person')
def person_route():
    pdb.set_trace()

    person = {'name': 'Bob', 'age': '109'}
    json_person = json.dumps(person)

    return json_person, 200, None


@app.route('/my_page')
def my_page_route():
    return "Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text "


@app.route('/pets')
def pets_route():
    pets = [{'name': 'Rex', 'color': 'Brown'}, {'name': 'Rex', 'color': 'Brown'}, {'name': 'Rex', 'color': 'Brown'},
            {'name': 'Rex', 'color': 'Brown'}, {'name': 'Rex', 'color': 'Brown'}, {'name': 'Rex', 'color': 'Brown'}]
    json_pets = json.dumps(pets)

    return json_pets, 200, None


if __name__ == "__main__":
    app.run(debug=True)
