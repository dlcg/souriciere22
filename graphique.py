#!/usr/bin/python
#-*- coding: utf-8 -*-

import matplotlib.pyplot as plt
import itertools
from datetime import date

today = date.today()
todays_date = today.strftime("%y%m%d")

def File(FileName, Title, Xlabel, Ylabel,graph):
    """Extract data from file in order to produce chart"""
    with open(FileName, mode='r', encoding='utf-8') as f:
        lines = f.readlines()
        x = [line.split()[0] for line in lines]
        y = [line.split()[1] for line in lines]
        #Il faut convertir la liste y de 'chaîne de caractères' vers des entiers.
        y = [int(i) for i in y]

        fig, ax = plt.subplots()
        ax.bar(x,y)
        ax.set_title(Title)
        ax.set_ylabel(Ylabel)
        ax.set_xlabel(Xlabel)
        for tick in ax.get_xticklabels():
            tick.set_rotation(30)
        plt.savefig(graph)

def main():
    """Prendre les 3 fichiers dont j'ai besoin en paramètre
    afin de produire les 3 graphiques"""
    FileName = ["util_fin_tri." + todays_date, "mdp_fin_tri." + todays_date, "ip_fin_tri." + todays_date]
    Title   = ['Users_tested', 'Passwords_tested', 'Locations']
    Y_label = ['Nb_of_users',  'Nb_of_passwords', 'Nb_of_try'] 
    X_label = ['Users', 'Passwords', 'Localtion']
    graph   = ['users.png','passwords.png', 'locations.png']

    for (v,w,x,y,z) in zip(FileName, Title, X_label, Y_label, graph):
        File(v,w,x,y,z)

if __name__ == "__main__":
    main()
