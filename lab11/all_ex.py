from pymongo import MongoClient
import datetime


client = MongoClient("mongodb://localhost:27017")
db = client["test"]

# ex 1
# cursor11 = db.test.find({"cuisine": "Indian" })
# cursor12 = db.test.find({"cuisine": {"$in": ["Indian", "Thai"]} })
# cursor13 = db.test.find({"address.building" : "1115", "address.street" : "Rogers Avenue", "address.zipcode" : "11226"})


# ex2
# cursor2 = db.test.insert_one({"address.building" : "1480", "address.street" : "2 Avenue", 
# 			"address.zipcode" : "10075", "address.coord" : [-73.9557413, 40.7720266], "borough": "Manhattan", 
# 			"cuisine" : "Italian", "name" : "Vella", "id" : "41704620", "grades.grade":'A', "grades.score": 11, "grades.date": datetime.datetime(2014, 10, 1, 0, 0)})

#ex3 
# cursor31 = db.test.delete_one({"borough" : "Manhattan"})
# cursor32 = db.test.delete_many({"cuisine":"Thai"})

#ex4 
cursor4 = db.test.find({"address.street" : "Rogers Avenue"})
for i in cursor4:
	cnt = 0
	for grade in i["grades"]:
		if grade["grade"] == 'C':
			cnt += 1
	db.test.delete_one(i)
	if cnt < 2 :
		i["grades"].append({"date" : datetime.datetime(2014, 7, 10, 0, 0), 'grade':'C', 'score': 30})	
		db.test.insert_one(i)