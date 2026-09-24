import  urllib.request 
import json
import math
import hashlib
url = "https://api.biorxiv.org/covid19"
response = urllib.request.urlopen(url+"/0")
data_json = json.loads(response.read().decode('utf-8'))
total_pages = math.ceil(data_json["messages"][0]["total"] / data_json["messages"][0]["count"])
for x in range(total_pages):
  print(url+"/"+str(x*30))
  response = urllib.request.urlopen(url+"/"+str(x*30))
  data_json = json.loads(response.read().decode('utf-8'))
  file_name = "./data/"+str(x*30)+".json"
  with open(file_name, "w") as file:
    file.write(json.dumps(data_json))
  print(file_name)
print(total_pages)