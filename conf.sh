#!/bin/bash
#Fichier de configuration de la souriciere
#Honeypot configuration file 


LOG="/var/log"
DATE_DU_JOUR=$(date +"%y%m%d")
declare -A CountryArray
CountryArray[United_States]=USA
CountryArray[United_Kingdom]=UK
CountryArray[Russian_Federation]=Russia
CountryArray[Lao_People\'s_Democratic_Republic]=Laos
CountryArray[Korea,_Republic_of]=South_Korea

#declare -A CountryArray=( [United_States]=USA [United_Kingdom]=UK              [Russian_Federation]=Russia [Lao_People\'s_Democratic_Republic]=Laos [Korea,    _Republic_of]=South_Korea )
