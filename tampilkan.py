# -*- coding: utf-8 -*-
"""
Created on Mon Sep 18 10:26:27 2017

@author: jng2
"""

from selenium import webdriver
from selenium.webdriver.support.ui import Select
import time
from time import sleep 
import os

browser = webdriver.Firefox(executable_path='/usr/local/bin/geckodriver') 
url = "http://dct.kpu.go.id/index.php?go=dct-dpr&partai=01"
browser.get(url) #navigate to the page

element = browser.find_element_by_xpath("//select[@name='kdprop']")
all_options = element.find_elements_by_tag_name("option")
for option in all_options:
    val = option.get_attribute("value")
    #print("First value is: %s" % val) #can comment this out
    option.click()
    time.sleep(4)
    element2 = browser.find_element_by_css_selector("div#areadapil")
    all_options2 = element2.find_elements_by_tag_name("option")
    for option2 in all_options2:
        val2 = option2.get_attribute("value")
        #print("Second value is: %s" % val2) #can comment this out
        option2.click()
        loadpage = browser.find_element_by_id("tampilkan")
        loadpage.click()
        time.sleep(4)
        if val2: 
            innerHTML = browser.execute_script("return document.body.innerHTML")
            #print(innerHTML)
            os.chdir("/Users/jng2/Dropbox/Work/python_stuff/indpages") #set working folder where files will be saved
            file = open("dct-dpr_" + str(val) + "_" + str(val2) + ".html", 'w')
            file.write(innerHTML)
            file.close()
