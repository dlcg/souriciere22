#!/bin/bash -vx

#Extrait les identifiants des IBN récoltés par la souricière.
#Attention les bonnes pratiques en développement sont de ne jamais travailler directement sur le file system (fichier à plat dans notre exemple). Passez par une base de données.

#You will need to install GeoIP package 
#Yum install GeoIP 

DATE_DU_JOUR=$(date +"%y%m%d")

#declare -A CountryArray=( [United_States]=USA [United_Kingdom]=UK [Russian_Federation]=Russia [Lao_People\'s_Democratic_Republic]=Laos [Korea,_Republic_of]=South_Korea )

declare -A CountryArray
CountryArray[United_States]=USA 
CountryArray[United_Kingdom]=UK 
CountryArray[Russian_Federation]=Russia
CountryArray[Lao_People\'s_Democratic_Republic]=Laos 
CountryArray[Korea,_Republic_of]=South_Korea

premiere_extraction() {
cp /var/log/passwords /var/log/souriciere/passwords.${DATE_DU_JOUR}
if [ $? -ne 0 ]; then
	printf "Error with passwords file"
else
#Retire les caractères de contrôle.
awk '/^host/ {sub("[[:cntrl:]]","");print $11}' /var/log/souriciere/passwords.${DATE_DU_JOUR} | sed '/^$/d' > mdp.${DATE_DU_JOUR}
awk '/^host/ {sub("[[:cntrl:]]","");print $7}'  /var/log/souriciere/passwords.${DATE_DU_JOUR}  > util.${DATE_DU_JOUR}
awk '/^host/ {sub("[[:cntrl:]]","");print $3}'  /var/log/souriciere/passwords.${DATE_DU_JOUR}  > ip.${DATE_DU_JOUR}
fi
}


utilisateur() {
#crée un fichier avec grep -Fxc -- et un sans. puis faire un diff pour voir s'il y a des différences.
sort -u util.${DATE_DU_JOUR} > util_uniq.${DATE_DU_JOUR}
while read ligne_util; do
	printf "%s %s\n" "${ligne_util}" $(grep -Fxc -- "${ligne_util}" util.${DATE_DU_JOUR}) >> util_fin.${DATE_DU_JOUR} 
done < util_uniq.${DATE_DU_JOUR}


sort -nk2 util_fin.${DATE_DU_JOUR} | tail -10 > util_fin_tri.${DATE_DU_JOUR}
}


mot_de_passe() {
set -x
sort -u mdp.${DATE_DU_JOUR} > mdp_uniq.${DATE_DU_JOUR}
while read ligne; do
	printf "%s %s\n" "${ligne}" $(grep -Fxc -- "${ligne}" mdp.${DATE_DU_JOUR}) >> mdp_fin.${DATE_DU_JOUR}
done < mdp_uniq.${DATE_DU_JOUR}


sort -nk2 mdp_fin.${DATE_DU_JOUR} | tail -10 > mdp_fin_tri.${DATE_DU_JOUR}
}


ip_localisation() {
#Mettre la variable LOCALISATION entre guillemet sinon les lieux composé sont découpés sur plusieurs lignes
#Un problème avec la république de Corée.
while read ligne; do
	IP_LOCALISATION=ip_localisation.${DATE_DU_JOUR}
	LOCALISATION=$(geoiplookup "${ligne}" |cut -d',' -f2-| sed 's/^.//; s/\s/_/g')
	printf "%s:%s\n" "${ligne}" "${LOCALISATION}" >> ${IP_LOCALISATION}
done < ip.${DATE_DU_JOUR}

cut -d':'  -f2 ip_localisation.${DATE_DU_JOUR} | sort -u >> ip_localisation_uniq.${DATE_DU_JOUR}

#A faire: regarder en fonction de l'adresse IP,si c'est un FAI, un hébergeur, un VPN/NAT etc...
while read ligne; do
	printf "%s %s\n" "${ligne}" $(grep -Fc -- "${ligne}" ip_localisation.${DATE_DU_JOUR}) >> ip_fin.${DATE_DU_JOUR}
done < ip_localisation_uniq.${DATE_DU_JOUR}


sort -nk2 ip_fin.${DATE_DU_JOUR} | tail -10 > ip_fin_tri.${DATE_DU_JOUR}
}


replace() {
while read line; do 
	for i in "${!CountryArray[@]}"; do 
		line="${line//"$i"/${CountryArray["$i"]}}" 
	done
	echo ${line} >> localisation_fin_tri.${DATE_DU_JOUR}
done < ip_fin_tri.${DATE_DU_JOUR}
}


if [ $# -eq 0 ]; then
	premiere_extraction

	utilisateur

	mot_de_passe

	ip_localisation
	
	replace
else
	printf "Ne prend pas d'argument"
	exit 1
fi
