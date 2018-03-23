'''
 bad and ugly script transmit every videos on a mastodon instance until mastodon fixes the @peertube@instance issue
 
 this script will make username@mastodon follow every new user on peertube
 
 enable rt = True to automatically retoot videos on this account
 unrt = True to retoot and unretoot immediately so has videos will be references in every accounts following your mastodon account


 be aware to run this script from a folder where you have write access
 you should run it in a cron job, for example every 10 minutes
 
 before using it
 sudo apt install pip
 pip install Mastodon.py
'''

host="exode.me"
api_url="https://"+host+"/api/v1"
app_name="exode_to_masto"
mastodon_url="https://mamot.fr"
mastodon_mail="mail"
mastodon_password="password"
rt=True
unrt=True

from mastodon import Mastodon
import time
import urllib2



import json
from pprint import pprint


# Register app - only once!

Mastodon.create_app(
     app_name,
     api_base_url = mastodon_url,
     to_file = 'pytooter_ptomasto_clientcred.secret'
)


# Log in - either every time, or use persisted

mastodon = Mastodon(
    client_id = 'pytooter_ptomasto_clientcred.secret',
    api_base_url = mastodon_url
)
mastodon.log_in(
    mastodon_mail,
    mastodon_password,
    to_file = 'pytooter_ptomasto_usercred.secret'
)



result = {}
result['followed']={}
result['retoot']=[]

import os.path
if(os.path.isfile("peertube_to_masto.json")):
	file = open("peertube_to_masto.json","r") 
	result = json.loads(file.read())
	file.close()
	
	
	
	
cont=True
index=0

# Follow PeerTube user

while(cont):
	response = urllib2.urlopen(api_url+'/accounts?start='+str(index))
	html = response.read()
	data = json.loads(html)
	index+=15
	if(len(data['data'])<15):
		cont=False;
		
	for account in data['data']:
		if(account['host']==host):
			if account['name'] not in result['followed']:
				dicti = mastodon.follows(account['name']+"@"+host)
				result['followed'][account['name']]=dicti.id
				
				
				
# Retoot
if(rt):	
	for account in result['followed']:
		#print(result['followed'][account])	
		for status in reversed(mastodon.account_statuses(result['followed'][account])):
			if("comment" not in status.uri and status.id not in result['retoot']):
				print "rebloging "+status.content
				rb = mastodon.status_reblog(status.id)
				result['retoot'].append(status.id)
				if(unrt):
					mastodon.status_unreblog(rb.reblog.id)


file = open("peertube_to_masto.json","w") 
file.write(json.dumps(result)) 
file.close() 
pprint(result)

