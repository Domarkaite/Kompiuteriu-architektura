#!/usr/bin/env python3
import random

simboliai = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
ln = len(simboliai) - 1

def lVardas():
   s = ''
   for i in range(10):
      s = s + simboliai[random.randint(0,ln)]
   return s
   
def pavadinimai():
   s = ''
   for i in range(5):
      s = s + lVardas() + ';'
   s = s + lVardas()
   return s

def lTekstinis(tarpuSvoris=20):
   ilgis = random.randint(1,20)
   s = ''
   for i in range(ilgis):
      if random.randint(1,100) < tarpuSvoris:
         s = s + ' '
      else:
         s = s + simboliai[random.randint(0,ln)]
   return s

def lSkaitinis3_5():
   return random.randint(-100,100)


def lSkaitinis6():
   return random.randint(-999,999)/100


def eilute(tarpuSvoris=20):
   s = lTekstinis(tarpuSvoris) + ';' + lTekstinis(tarpuSvoris) + ';'
   for i in range(3):
      s = s + str(lSkaitinis3_5()) + ';'  
   s = s +  str(lSkaitinis6())
   return s


kiek = int(input('Kiek eilučių '))
failas = open('input.dat','w')

failas.write(pavadinimai()+'\n')
for r in range(kiek):
   failas.write(eilute()+'\n')
failas.close()


          
   


