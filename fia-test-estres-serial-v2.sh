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
import serial
from dateutil.relativedelta import *

print ('Empezamos !')

numtramas = 0

ser = None


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

# connect to serial
print ('Conectando al puerto serie')
# connect to serial port
ser = serial.Serial()
ser.port     = "/dev/ttyS0"
ser.baudrate = 115200
ser.parity   = 'N'
ser.rtscts   = False
ser.xonxoff  = False
ser.timeout  = 1     # required so that the reader thread can exit

try:
    ser.open()
except serial.SerialException, e:
    sys.stderr.write("Could not open serial port %s: %s\n" % (ser.port, e))


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
        ser.write(str_prave)

        numtramas += 1

        time.sleep(0.1)