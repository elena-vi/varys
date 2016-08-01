from urlparse import urljoin, urlsplit

class Parser:
  
  def __init__(self, url):
    self.url = urlsplit(url)

  def withoutQuery(self):
    u = self.url
    return u.scheme + '://' + u.netloc + u.path

  def joinDomain(self, dom):
    u = self.url    
    self.__init__(urlsplit(dom).scheme + '://' + urlsplit(dom).netloc + u.path + u.query + u.fragment)
    return self

  def approved(self):
    return True

  def fullUrl(self):
    u = self.url
    return u.scheme + '://' + u.netloc + u.path + u.query + u.fragment
