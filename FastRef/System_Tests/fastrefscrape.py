import sys
import requests
import numpy
from bs4 import BeautifulSoup

visited = []
urls = []
status = []
error_urls = []
error_status = []
error_html = []
def get_links(suffix, s=None):
	url = 'http://1-dot-fast-ref.appspot.com/' + suffix
	urls.append(suffix)
	#print 'URL: ' + url
	if url not in visited:
		visited.append(url)
		response = requests.get(url)
		status.append(response.status_code)
		if response.status_code is not 200:
			error_urls.append(suffix)
			error_status.append(response.status_code)
			if s:
				error_html.append(s)
		#print 'Status Code: ' + str(response.status_code)
		html = response.content
		soup = BeautifulSoup(html, 'html.parser')
		curr_links = soup.find_all('a')
		for link in curr_links:
			#print(link.get('href'))
			get_links(link.get('href'), soup)
	else:
		curr_links = []
	return curr_links

links = get_links('')
print error_urls[1]
print error_status[1]
#print error_html[0].prettify()

	