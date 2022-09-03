from deemix import __main__
import click


import requests
import json
import sys
import time
import shlex
from funkwhale_cli import api
from funkwhale_cli import cli
from click.testing import CliRunner
from requests_toolbelt.multipart.encoder import MultipartEncoder
import curlify
import os
import subprocess

AUTH_SERVER=""
CLIENT_ID=""
CLIENT_SECRET=""
CLIENT_TOKEN=""
@click.command()
@click.option('-b', '--bitrate', default=None, help='Overwrites the default bitrate selected')
@click.option('-p', '--path', type=str, help='Downloads in the given folder', required=False)
@click.argument('url', nargs=-1, required=True)
@click.option('--fkplaylist', required=True, help='ID of the funkwhale playlist to import to')
def startimport(url, bitrate, path, fkplaylist):
	with open("configfordeemix.json") as f:
		configDeemix = json.load(f)

	print ("Downloading into: "+configDeemix['downloadLocation'])
	sys.argv = ['',  '--portable', '.', url[0]]
	#__main__.download()
	import_success=[]
	if os.path.isfile("import_success.json"):
		with open("import_success.json") as f:
			import_success = json.load(f)
	lst = os.listdir(configDeemix['downloadLocation'])
	lst.sort()
	for filename in lst:
		f = os.path.join(configDeemix['downloadLocation'], filename)
		if f in import_success:
			continue
		
		if f.endswith(".mp3"):
			print ("sending "+f)
			process = subprocess.Popen(['beet', 'import', "--nocopy", "-a",  "-q", "-s", f],
                     stdout=subprocess.PIPE, 
                     stderr=subprocess.PIPE)
			stdout, stderr = process.communicate()
			
			sendResult = sendFile(f)
			parsedSend=json.loads(sendResult)
			print("/api/v1/uploads/"+parsedSend["uuid"]+"/")
			print("waiting for import")
			#check if import finished
			
			status="pending"
			i = 0
			while status == "pending" and i <5:
				importResult=doAuthRequest("get","/api/v1/uploads/")
				parsedImport=json.loads(importResult)
				for track in parsedImport['results']:
					if track['uuid'] == parsedSend["uuid"]:
						status = track['import_status']
						if track['import_status'] == "pending":
							break
						if track['import_status'] == "errored":
							break
						print(track['import_status'])
						print("adding track id: " + str(track['track']['id']))
						doAuthRequest("post","/api/v1/favorites/tracks/", json={"track":track['track']['id']})
						import_success.append(f)
						f = open("import_success.json", "w")
						f.write(json.dumps(import_success))
						f.close()
						break
				i = i+1
				time.sleep(2)

def doAuthRequest(method, endpoint, data=None, files=None, json=None, newHeaders = {}):
	headers={"User-Agent": "sf", "Authorization":"Bearer "+CLIENT_TOKEN}
	headers.update(newHeaders)
	if method == "get":
		response = requests.get(
		AUTH_SERVER+"/"+endpoint,
		headers=headers,
		)
	elif method=="post":
		response = requests.post(
		AUTH_SERVER+"/"+endpoint,
		headers=headers, data = data, json=json
		)
		
	return response.text
	#print(curlify.to_curl(response.request))
def sendFile(path):
	mp_encoder = MultipartEncoder(
    fields={
       "source": "upload://{}".format("file.mp3"), 
       "library": "04ca8108-863e-4db3-ae6e-9b3274f6ff3f",
       "audio_file": ('file.mp3', open(path, 'rb'))      
    }
)
	return doAuthRequest("post","api/v1/uploads", data=mp_encoder, newHeaders={'Content-Type': mp_encoder.content_type})
if __name__ == '__main__':
    startimport()

