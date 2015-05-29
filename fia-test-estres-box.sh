#!/usr/bin/env python
#-*- coding: UTF-8 -*-

# autor: Carlos Rueda
# fecha: 2013-11-29
# mail: carlos.rueda@deimos-space.com

import os
import sys
import math
import haversine
import csv
import threading
import time
import datetime
import socket
import logging
from dateutil.relativedelta import *


print ('Empezamos !')

#HOST = "192.168.24.4"
#PORT = 5001
HOST = "127.0.0.1"
PORT = 5001

numtramas = 0

if len(sys.argv) == 1:
    print "--------------------------------------------------------"
    print "Este programa necesita parametros:"
    print " --> fichero.csv"
    print "Ejemplo: fia-test-estres.sh ruta1.csv"
    exit()

if len(sys.argv) < 2:
    print "ERROR: Numero de parámetros incorrecto"
    exit()

file_ruta = sys.argv[1]

# connect to server
print ('Conectando al KCS')
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, int(PORT)))

fichero = csv.reader(open(file_ruta, 'rb'))

for index,row in enumerate(fichero):
    lon = float(row [0])
    lat = float(row [1]) 
    speed = 0
    try:
        speed = row[2]
    except:
        speed = 0

    lon_deg = int(lon)
    lon_min = (abs(lon) - abs(int(lon)))*60
    str_lon_deg = str (lon_deg)
    str_lon_min = str (lon_min)
    str_lon_min = str_lon_min[0:7]

    lat_deg = int(lat)
    lat_min = (abs(lat) - abs(int(lat)))*60
    str_lat_deg = str (lat_deg)
    str_lat_min = str (lat_min)
    str_lat_min = str_lat_min[0:7]
                   
    #hora_actual = time.strftime("%H%M%S", time.localtime())
    utc_datetime = datetime.datetime.utcnow()
    hora_actual = utc_datetime.strftime("%H%M%S")
                    
    for box in range(1, 11): 

        str_prave = "$PRAVE,0"+str(box)+",0300,"+str_lat_deg+str_lat_min+","+str_lon_deg+str_lon_min+","+str(hora_actual)+",2,9,719,36,12.4,0,-71,"+str(speed)+",0,,*7D"+'\r\n'
        print "Trama " + str(numtramas) + " -> " + str_prave 
        s.sendall(str_prave)

        numtramas += 1

        time.sleep(0.1)

