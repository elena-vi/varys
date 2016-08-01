from urlparse import urljoin, urlsplit

class Parser:
  
  def __init__(self, url):
    self.url = urlsplit(url)

  def removeQuery(self):
    u = self.url
    return u.scheme + '://' + u.netloc + u.path

  def joinDomain(self, dom):
    u = self.url    
    return urlsplit(dom).scheme + '://' + urlsplit(dom).netloc + u.path + u.query + u.fragment

