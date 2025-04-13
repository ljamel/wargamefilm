# WARGAMES - Simulation Joshua (en Bash)

Une simulation en ligne de commande inspirée du film culte _Wargames_ (1983)
Incarnez le **Professeur Falken** et discutez avec **Joshua**, le superordinateur intelligent, à travers une interface terminal rétro et une voix synthétique.

Objectif
Ce script Bash simule une interaction avec Joshua, l’IA du film **Wargames**, en français 🇫🇷.  
Joshua affiche ses réponses lentement, avec un ton mystérieux et stratégique, et les lit à voix haute grâce à `espeak-ng`.

Prérequis
Avant de lancer la simulation, assure-toi d’avoir les outils suivants installés :

- Avoir 6 Gos d'espace disque libre
- Un terminal Linux/macOS avec Bash

Installation & Lancement

1. Clone ce dépôt et démmarrer le projet:

```bash
git clone https://github.com/ljamel/wargamefilm.git
cd wargamefilm
bash start.sh
```

2. dépannage (Optionnel)
```bash
# if apt broken try
sudo rm -rf /var/lib/apt/lists/*
sudo apt update

