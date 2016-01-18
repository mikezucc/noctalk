from django.db import models
from djangotoolbox.fields import ListField
from djangotoolbox.fields import DictField
from djangotoolbox.fields import EmbeddedModelField

#,related_name='entitymanager_content_type'

# class Article(models.Model):
#     articleid = models.IntegerField()
#     articleimage = models.TextField()
#     articleurl = models.TextField()
#     date = models.CharField(max_length=30)
#     date_time = models.DateTimeField(auto_now_add=False, blank=True)
#     title = models.CharField(max_length=200)
#     text = models.TextField()
#     enc_html = models.TextField()
#     domain = models.CharField(max_length=200)
#     share_link = models.CharField(max_length=200)
#     keyterms = ListField(EmbeddedModelField('KeyTerm'))
#     entities = ListField(EmbeddedModelField('Entity'))
#     concepts = ListField(EmbeddedModelField('Concept'))
#     taxonomy = ListField(EmbeddedModelField('Taxonomy'))

class Noc(models.Model):
    nochandle = models.CharField(max_length=30)
    areacode = models.CharField(max_length=3)
    tidbit = models.CharField(max_length=140)
    gender = models.CharField(max_length=5)
    age = models.IntegerField(default=18)
    prezi = models.CharField(max_length=20)
    twitterh = models.CharField(max_length=30)
    fbh = models.CharField(max_length=200)
    instagh = models.CharField(max_length=30)
    snapch = models.CharField(max_length=30)
    ip_addr = models.CharField(max_length=30)

class Event(models.Model):
    name = models.CharField(max_length=30)
    nochandle = models.CharField(max_length=30)
    ip_addr = models.CharField(max_length=30)
    noc_id = models.ForeignKey('Noc',blank=True, null=True)


    # <input type="text" class="button" id="email" name="nochandle" placeholder="meme_lorde">
    #     <input type="text" class="button" id="email" name="areacode" placeholder="408">
    #     <p>Wave 2: Doctor's Details</p>
    #     <input type="text" class="button" id="email" name="tidbit" placeholder="I like to think in my room alone while listening to alternative rock because my stupid parents.">
    #     <input type="text" class="button" id="email" name="gender" placeholder="Male">
    #     <input type="text" class="button" id="email" name="age" placeholder="21">
    #     <p>Wave 3: Random trivia</p>
    #     <input type="text" class="button" id="email" name="prezi" placeholder="Trump">
    #     <P>Final Wave: Social handles</p>
    #     <input type="text" class="button" id="email" name="twitter" placeholder="@mikezuccarino">
    #     <input type="text" class="button" id="email" name="fb" placeholder="https://www.facebook.com/zuccarino">
    #     <input type="text" class="button" id="email" name="instag" placeholder="@hempaw2">
    #     <input type="text" class="button" id="email" name="snapc" placeholder="bootysnatcher22">