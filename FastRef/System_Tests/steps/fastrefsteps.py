import requests
@given('User not logged in')
def step_impl(context):
	context.session = requests.session()
@given('User logged in')
def step_impl(context):
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


@when('User deletes file')
def step_impl(context):

@when('User adds tags')
def step_impl(context):

@then('status code is {sc}')
def step_impl(context, sc):
	assertEqual(context.response.status_code, sc)