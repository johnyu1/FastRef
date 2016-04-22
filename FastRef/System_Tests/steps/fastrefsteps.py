@given('User not logged in')
def step_impl(context):

@given('User logged in')
def step_impl(context):

@given('File is public')
def step_impl(context):

@given('File is private')
def step_impl(context):

@when('User accesses file')
def step_impl(context):

@when('User uploads file')
def step_impl(context):

@when('User deletes file')
def step_impl(context):

@when('User adds tags')
def step_impl(context):

@then('status code is {sc}')
def step_impl(context, sc):
	