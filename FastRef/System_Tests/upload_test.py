import requests

r = requests.post('http://1-dot-fast-ref.appspot.com/upload.jsp', files={'test.txt': open('test.txt', 'rb')})
