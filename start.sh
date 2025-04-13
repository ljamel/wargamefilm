#!/bin/bash

##############################################
# Simulation du film WARGAMES (1983)
# Le Professeur Falken / Joshua parle via espeak-ng
# exte affiché lentement à l'écran façon terminal
#
# Auteur : djamal alias (ingenius)
# Date : avril 2025
##############################################

if [ "$(id -u)" -eq 0 ]; then
    echo "Le script ne fonctionne pas en tant qu'utilisateur root."
exit
fi

command -v curl &> /dev/null || { echo "Installation de curl...";sudo apt install curl -y; }
command -v ollama &> /dev/null || { echo "Installation d'Ollama...";sudo curl -s https://ollama.com/install.sh | bash; }
command -v espeak-ng &> /dev/null || { echo "Installation de espeak-ng...";sudo apt install espeak-ng -y; }
command -v paplay &> /dev/null || { echo "Installation de pulseaudio...";sudo apt install pulseaudio* -y; }

afficher_lentement() {
    local texte="$1"
    local delai="0.06"

    espeak-ng -v fr "$response" --stdout | paplay &

    for ((i=0; i<${#texte}; i++)); do
        printf "%s" "${texte:$i:1}"
        sleep "$delai"
    done
    echo
}

preprompt="Tu es maintenant dans une simulation inspirée du film *Wargames* (1983). 
Tu joues le rôle de Joshua, l'ordinateur intelligent.
Tu dois répondre en français, comme dans le film, avec des réponses formelles et intrigantes. 
Lorsque le nom 'Professeur Falken' est mentionné, réponds comme si tu étais un ordinateur en mode analyse stratégique.
Si la langue utilisée n'est pas le français, donne une réponse en français pour rediriger la conversation.
L'ambiance est inspirée du film classique, où chaque réponse doit être énigmatique et un peu froide. et répond sans smile
Demande moi je faire quelle jeu. GUERRE THERMONUCLÉAIRE GLOBALE, MORPION, LABYRINTHE DE FALKEN, BLACK JACK, COEUR, ÉCHECS 
Soit concis."


clear
echo ""
afficher_lentement "Joshua: BONJOUR, PROFESSEUR FALKEN."

sleep 1
afficher_lentement "Joshua: VOUDRIEZ-VOUS JOUER À UN JEU ?"
sleep 1

echo ""
echo "   > GUERRE THERMONUCLÉAIRE GLOBALE"
echo "   > MORPION"
echo "   > LABYRINTHE DE FALKEN"
echo "   > BLACK JACK"
echo "   > COEUR"
echo "   > ÉCHECS"
echo ""

pulseaudio --start
espeak-ng -v fr "BONJOUR, PROFESSEUR FALKEN." --stdout | paplay

# Vérifie si Ollama est installé
command -v ollama &> /dev/null || { echo "Ollama n'est pas installé"; exit 1; }

while :
do

  [[ "$user_input" == "exit" ]] && break

  read -p "A quoi voulez-vous jouer : " user_input

  context+="$user_input"

  response=$(ollama run gemma3:1b "$preprompt $response")

  afficher_lentement "Joshua : $response"

done
