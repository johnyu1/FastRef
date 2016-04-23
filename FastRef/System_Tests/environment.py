from mail import SessionGoogle

def before_all(context):
	user = 'fastreftest@gmail.com'
	pwd = 'fastref123'
	url_login = "https://accounts.google.com/AccountChooser?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&hl=en&service=ah"
	url_auth = "https://accounts.google.com/ServiceLogin?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&service=ah&sacu=1&rip=1#password"
	context.session = SessionGoogle(url_login, url_auth, user, pwd)
	context.url = 'http://1-dot-fast-ref.appspot.com/'
	context.login = ''
	# these are for upload tests
	context.fname = ''
	context.publicfname = 'publictest.pdf'
	context.privatefname = 'privatetest.pdf'
	context.payld = {
		'restriction':''
		'document':''
	}
	# these are for access tests
	context.privid = 'AMIfv94Jb3FctN-hIIGrbt29S80U9Cdt2KxysQnMUkTs9jCX4S39azxqibn_10glMcfPSCTzTyIf2uvFyTBChDDIt6cly10t3H0t85KbCPI85XeHTX17uYkRFzTaIj7ZqUGW8CD_G3fIIihm4uyqwcmkgo_FJGi4tQ'
	context.publid = 'AMIfv94AglBCY6EMzH1R4zXIiRDwmcu3GhpXzDOCHI2yxZ0S_f5zJZuN3R-WoboANQDQEMFwG1-5CmpZCg0thZqftdT0QQBL94Xr9j3-xQvUjV3RXOioZbgK4bW8YTifvVWjsl7n9L1BZ60Us-oBUiUL44z8F7LqZw'
	