# -*- coding: utf-8 -*-
from django.shortcuts import render
from django.shortcuts import redirect
from django.shortcuts import render_to_response
from django import forms
from django.template import Context, Template
from models import *
from django.utils import timezone
from django.http import HttpResponse
import zipfile
import StringIO
from django.forms import widgets
import shutil
import urllib2
import urllib
import json
from django.template.loader import render_to_string
import sys
import cgi
import traceback
import re
from django.views.decorators.csrf import csrf_exempt
import base64
# import lxml.html as LH
import xml.etree.ElementTree as ET
import string
import datetime

def main(request):

    return render(request, 'noctalk.html', {})