from mail import SessionGoogle

user = 'fastreftest@gmail.com'
pwd = 'fastref123'
url_login = "https://accounts.google.com/AccountChooser?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&hl=en&service=ah"

url_auth = "https://accounts.google.com/ServiceLogin?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&service=ah&sacu=1&rip=1#password"
session = SessionGoogle(url_login, url_auth, user, pwd)
payload = {
		'restriction': 'public',
		'document': open('publicuploadtest.pdf')
	}
files = {
			'document': open('publicuploadtest.pdf')
		}
url = 'http://1-dot-fast-ref.appspot.com/upload.jsp'
r = session.post(url, data=payload, files=files)
import pdb
pdb.set_trace()
print r.status_code
