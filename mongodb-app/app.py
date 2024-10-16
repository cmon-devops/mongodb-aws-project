from pymongo import MongoClient

# Use the EC2 public DNS in the connection string
client = MongoClient("mongodb://<ec2-public-dns>:27017/")

# Create or switch to a database
db = client["mydatabase"]

# Create or switch to a collection
collection = db["mycollection"]

# Insert a document
data = {"name": "AWS MongoDB", "description": "Connected to MongoDB from EC2"}
collection.insert_one(data)

# Fetch the document
document = collection.find_one({"name": "AWS MongoDB"})
print("Document:", document)
