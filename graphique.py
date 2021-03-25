#!/usr/bin/python
#-*- coding: utf-8 -*-

import matplotlib.pyplot as plt
from datetime import date

today = date.today()
todays_date = today.strftime("%y%m%d")
filename = 'util_fin_tri' + '.' + todays_date

def File(fichier):
    """Extract data from file in order to produce chart"""
    with open(fichier, mode='r', encoding='utf-8') as f:
        lines = f.readlines()
        x = [line.split()[0] for line in lines]
        y = [line.split()[1] for line in lines]
        #Il faut convertir la liste y de 'chaîne de caractères' vers des entiers.
        y = [int(i) for i in y]

        fig, ax = plt.subplots()
        ax.bar(x,y)
        ax.set_title('users tested')
        ax.set_ylabel('count users')
        ax.set_title('Top 10 users tested')
        for tick in ax.get_xticklabels():
            tick.set_rotation(35)
        plt.show()

def main():
    """Prendre les 3 fichiers dont j'ai besoin en paramètre
    afin de produire les 3 graphiques"""
    #file = File()
    test = ["util_fin_tri.210325","mdp_fin_tri.210325"]
    for x in test:
        File(x)

if __name__ == "__main__":
    main()
