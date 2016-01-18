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
from ipware.ip import get_ip

def main(request):

    exists = 'no'
    nochandle = ''
    if 'nochandle' in request.session:
        if Noc.objects.filter(nochandle=str(request.session['nochandle'])).exists():
            exists = 'yes'
            noc = Noc.objects.filter(nochandle=str(request.session['nochandle']))[0]
            nochandle = noc.nochandle
            return redirect('/casa/')

    return render(request, 'noctalk.html', {'exists':exists,'nochandle':nochandle})

def reg(request):

    try:
        # nochandle = models.CharField(max_length=30)
        # areacode = models.CharField(max_length=3)
        # tidbit = nochandle = models.CharField(max_length=140)
        # gender = models.CharField(max_length=5)
        # age = models.IntegerField(default=18)
        # prezi = models.CharField(max_length=20)
        # twitterh = models.CharField(max_length=30)
        # fbh = models.CharField(max_length=200)
        # instagh = models.Charfield(max_length=30)
        # snapch = models.Charfield(max_length=30)

        nochandle = request.POST['nochandle']

        if Noc.objects.filter(nochandle=str(nochandle)).exists():
            return HttpResponse(json.dumps("nochandle exists"), content_type="application/json")

        areacode = request.POST['areacode']
        tidbit = request.POST['tidbit']
        gender = request.POST['gender']
        age = request.POST['age']
        prezi = request.POST['prezi']
        twitterh = request.POST['twitterh']
        fbh = request.POST['fbh']
        instagh = request.POST['instagh']
        snapch = request.POST['snapch']

        ip_addr = get_ip(request)
        if ip_addr is None:
            ip_addr = "0.0.0.0"

        new_noc = Noc.objects.create(nochandle=nochandle, areacode=areacode, tidbit=tidbit, gender=gender, age=age, prezi=prezi, twitterh=twitterh, fbh=fbh, instagh=instagh, snapch=snapch, ip_addr=ip_addr)
        new_noc.save()

        # name = models.CharField(max_length=30)
        # nochandle = models.CharField(max_length=30)
        # ip_addr = models.CharField(max_length=30)
        # noc_id = models.ForeignKey('Noc',blank=True, null=True)

        noc_event = Event.objects.create(name="create",nochandle="nochandle", ip_addr=ip_addr, noc_id=new_noc)
        noc_event.save()

        request.session['nochandle'] = nochandle

        return HttpResponse(json.dumps("success"), content_type="application/json")
    except:
        return HttpResponse(json.dumps(traceback.format_exc()), content_type="application/json")

def casa(request):

    try:
        if 'nochandle' not in request.session:
            return redirect('/')

        return render(request, 'talk.html', {'nochandle':request.session['nochandle']})

    except:
        return HttpResponse(json.dumps(traceback.format_exc()), content_type="application/json")

def user(request):
    try:
        if 'nochandle' not in request.session:
            return redirect('/')

        noch = request.POST['noc']
        noc = Noc.objects.filter(nochandle=str(noch))[0]

        nocj = {"nochandle":noc.nochandle, "areacode":noc.areacode, "tidbit":noc.tidbit, "gender":noc.gender, "age":noc.age, "prezi":noc.prezi, "twitterh":noc.twitterh, "fbh":noc.fbh, "instagh":noc.instagh, "snapch":noc.snapch}

        return HttpResponse(json.dumps(nocj), content_type="application/json")

    except:
        return HttpResponse(json.dumps(traceback.format_exc()), content_type="application/json")




