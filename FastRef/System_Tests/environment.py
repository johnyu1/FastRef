from mail import SessionGoogle

def before_all(context):
	user = 'fastreftest@gmail.com'
	pwd = 'fastref123'
	url_login = "https://accounts.google.com/AccountChooser?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&hl=en&service=ah"
	url_auth = "https://accounts.google.com/ServiceLogin?continue=https%3A%2F%2Fappengine.google.com%2F_ah%2Fconflogin%3Fcontinue%3Dhttp%3A%2F%2F1-dot-fast-ref.appspot.com%2Fupload.jsp&service=ah&sacu=1&rip=1#password"
	context.session = SessionGoogle(url_login, url_auth, user, pwd)
	context.url = 'http://1-dot-fast-ref.appspot.com/'
	context.login = False
	# these are for upload tests
	context.public = False
	context.publicfname = 'publictest.pdf'
	context.privatefname = 'privatetest.pdf'
	context.payld = {
		'restriction':'',
		'document':''
	}
	# these are for access tests
	context.privid = 'AMIfv97A96HdF0f1ETd8pcKSKBy9Rz_r0xN3YNFBz-8G26Qs166K2-dzVj_OakyPmmwsQYZ4WPdXGKJUZX2Au5cD9nIAbmuJbjFDQcCi1XTfBm24i7QKJLKGlSUkYmwmEAroI5HBSyJmcQR6NPjkQvoNX5ZBGBfMZg'
	context.publid = 'AMIfv97fkfb5g-1_Cp9Dm3DLPV46Ftma9n6ucTyylGnt2gOsbDKIr9Oy3dWwjxY1hGjTZJM5awCTZOxWvnHYwqalhIUPTRASLi51dQfweJgymeQQjhKJsihBaozjzcfGg0fg9F_HWcqXBlDdtwsFIpgCDnANlwvu4A'
