import requests
from bs4 import BeautifulSoup
class SessionGoogle:
    def __init__(self, url_login, url_auth, login, pwd):
        self.ses = requests.session()
        login_html = self.ses.get(url_login)
        soup_login = BeautifulSoup(login_html.content).find('form').find_all('input')
        info = {}
        for u in soup_login:
            if u.has_attr('value'):
                info[u['name']] = u['value']
        # override the inputs with out login and pwd:
        info['Email'] = login
        info['Passwd'] = pwd
        self.ses.post(url_auth, data=info)
    def get(self, URL):
        return self.ses.get(URL).text

    def post(self, URL, data=None):
    	return self.ses.post(URL, data).text

