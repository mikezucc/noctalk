from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', 'app1.views.main'),
    url(r'^reg', 'app1.views.reg'),
    url(r'^casa', 'app1.views.casa'),
)
