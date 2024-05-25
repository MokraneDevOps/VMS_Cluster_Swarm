#!/bin/bash

# Installer Java 17
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk openjdk-17-jre

# Ajouter le dépôt et la clé Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Mettre à jour et installer Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Vérifier si Jenkins est installé avec succès
if systemctl is-active --quiet jenkins; then
    echo "Jenkins a été installé avec succès."
else
    echo "Erreur : Jenkins n'a pas pu être installé."
    exit 1
fi

# Démarrer et activer Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Pull de l'image SonarQube et lancement du conteneur
sudo docker pull sonarqube:lts-community
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community

# Vérifier si SonarQube est lancé
if sudo docker ps | grep -q sonarqube; then
    echo "Le conteneur SonarQube a été lancé avec succès."
else
    echo "Erreur : Le conteneur SonarQube n'a pas pu être lancé."
    exit 1
fi

# Affichage de l'état des services Jenkins et Docker
echo "État du service Jenkins :"
sudo systemctl status jenkins

echo "État du conteneur SonarQube :"
sudo docker ps | grep sonarqube

echo "Installation terminée. Jenkins est disponible sur http://<votre-ip>:8080 et SonarQube sur http://<votre-ip>:9000"
