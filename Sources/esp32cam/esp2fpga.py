################################################
# esp2fpga.py
# Andrew Woska
# agwoska@bu.edu
################################################
# additional coding needed to run on FPGA
################################################

import sys
import os
import time
from serial import Serial
from PIL import Image

################################################
# constants
################################################

uri = 'http://1.0.0.1'  # edit this to be the IP address of the server
com = 'COM3'            # edit this to be the COM port of the FPGA
baudrate = 115200

################################################
# serial communication
################################################

def open_serial():
    return Serial(com, baudrate)
# end open_serial

def send_data(ser, data):
    ser.write(data)
    ser.flush()
# end send_data

def send_bmp_file(ser, filename):
    f = open(filename, 'rb')
    data = f.read()
    send_data(ser, data)
    f.close()
# end send_file

def receive_data(ser, size):
    return ser.read(size)
# end receive_data

def receive_byte(ser):
    return ser.read()
# end receive_byte

################################################
# server communication
################################################

def request_img():
    os.system('wget ' + uri + '/capture')
# end request_img

def get_img():
    # get image from server at uri/saved-photo
    os.system('wget ' + uri + '/saved-photo -O img.jpg')
# end get_img

# convert jpg to bmp (RGB888)
def convert_img(filename):
    im = Image.open(filename)
    im.save(filename[:-4] + '.bmp')
# end convert_img

################################################
# main runner
################################################

def main():
    # open serial connection
    # ser = open_serial()
    # get image from server
    request_img()
    # wait 5 seconds for image to be taken
    time.sleep(5)
    get_img()
    # # convert image to bmp
    convert_img('img.jpg')
    # # send image to FPGA
    # send_file(ser, 'img.bmp')
# end main

if __name__ == '__main__':
    main()
