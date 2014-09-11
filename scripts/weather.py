#!/usr/bin/python

import sys
import urllib
from string import maketrans
from xml.sax import handler, parseString

class ElementProcesser(handler.ContentHandler):
  def startElement(self, name, attrs):
    if name == "city":
      print attrs["data"]
    elif name == "current_conditions":
      print "    Current conditions"
    elif name == "condition":
      print "        " + attrs["data"]
    elif name == "humidity":
      print "        " + attrs["data"]
    elif name == "wind_condition":
      print "        " + attrs["data"]
    elif name == "day_of_week":
      print "    " + self.getDayOfWeek(attrs["data"])
    elif name == "temp_f":
      print "        Temperature " + attrs["data"] + " F"
    elif name == "low":
      print "        Low " + attrs["data"] + " F"
    elif name == "high":
      print "        Hi  " + attrs["data"] + " F"
    
  def getDayOfWeek(self,day):
    if day == "Mon":
      return "Monday"
    elif day == "Tue":
      return "Tuesday"
    elif day == "Wed":
      return "Wednesday"
    elif day == "Thu":
      return "Thursday"
    elif day == "Sat":
      return "Saturday"
    elif day == "Fri":
      return "Friday"
    elif day == "Sun":
      return "Sunday"
    else:
      return day

f = urllib.urlopen("http://www.google.com/ig/api?weather=BOSTON")
xml = f.read()
f.close()

trans=maketrans("\xe1\xe9\xed\xf3\xfa","aeiou")
xml = xml.translate(trans)

parseString(xml,ElementProcesser())
