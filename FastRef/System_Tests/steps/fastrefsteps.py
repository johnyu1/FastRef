import requests
from mail import SessionGoogle
@given('User not logged in')
def step_impl(context):
	context.session = requests.session()
@given('User logged in')
def step_impl(context):
	user = 'fastreftest@gmail.com'
	pwd = 'fastref123'
	url_login = "https://accounts.google.com/AccountChooser?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&hl=en&service=ah"

	url_auth = "https://accounts.google.com/ServiceLogin?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&service=ah&sacu=1&rip=1#password"
	context.session = SessionGoogle(url_login, url_auth, user, pwd)
@given('File is public')
def step_impl(context):
	context.public = True
@given('File is private')
def step_impl(context):
	context.public = False
@when('User accesses file')
def step_impl(context):
	url = context.url + 'serve?blob-key='
	if context.public:
		url += context.publid
	else:
		url += context.privid
	context.response = context.session.get(url)
@when('User uploads file')
def step_impl(context):
	restriction = 'private'
	files = {
		'document': open('privateuploadtest.pdf')
	}
	if context.public:
		restriction = 'public'
		files = {
			'document': open('publicuploadtest.pdf')
		}
	payload = {
		'restriction': restriction,
	}
	url = context.url + 'upload.jsp'
	context.response = context.session.post(url, data=payload, files=files)

@when('User deletes file')
def step_impl(context):
	url = context.url + 'listfiles.jsp'
	key = context.privid
	if context.public:
		key = context.publid
	body = {
		'blob-key': key
	}
	context.response = context.session.get(url, data=body)
@when('User adds tags')
def step_impl(context):
	pass

@then('status code is {sc}')
def step_impl(context, sc):
	s = context.response.status_code
	print('SSSStatus code is ' + str(s))
	assert int(context.response.status_code) is int(sc)
