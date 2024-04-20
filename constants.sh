#!/bin/bash

porownajPliki="Porównaj pliki"
porownajKatalogi="Porównaj katalogi"

stworzBackup="Stworz kopie zapasowa katalogu"
zmianyWPlikach="Sprawdz zmiany na plikach"
przywrocPliki="Przywroc stan plikow z kopii zapasowej"

backupFolder="backup"

komendaWTerminalu="Komenda w terminalu"
wyjscie="Wyjście"

universalInfoWidth=320

TRUE=0
FALSE=1

#we are using this while making back up for files, we cant have / in file name so replace it with this sequence 
slashToCodeConverter="#$%"