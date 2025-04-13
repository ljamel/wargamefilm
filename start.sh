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

    espeak-ng -v fr -s 120 "$response" --stdout | paplay &

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

morpion() {
  read -p "Nombre de joueurs (0, 1 ou 2) ? " n
  b=(1 2 3 4 5 6 7 8 9)

  aff() {
    echo " ${b[0]} | ${b[1]} | ${b[2]}"
    echo "---+---+---"
    echo " ${b[3]} | ${b[4]} | ${b[5]}"
    echo "---+---+---"
    echo " ${b[6]} | ${b[7]} | ${b[8]}"
  }

  gagnant=""
  win() {
    for i in 0 3 6; do [[ ${b[i]} == ${b[i+1]} && ${b[i]} == ${b[i+2]} ]] && gagnant=${b[i]} && return 0; done
    for i in 0 1 2; do [[ ${b[i]} == ${b[i+3]} && ${b[i]} == ${b[i+6]} ]] && gagnant=${b[i]} && return 0; done
    [[ ${b[0]} == ${b[4]} && ${b[0]} == ${b[8]} ]] && gagnant=${b[0]} && return 0
    [[ ${b[2]} == ${b[4]} && ${b[2]} == ${b[6]} ]] && gagnant=${b[2]} && return 0
    return 1
  }

  if [[ $n == 0 ]]; then
    echo "Simulation autonome..."
    sleep 1
    end=$((SECONDS+30))
    while (( SECONDS < end )); do
      b=(1 2 3 4 5 6 7 8 9)
      for ((t=0;t<9;t++)); do
        clear
        aff
        sleep 0.2
        while :; do
          r=$((RANDOM % 9))
          [[ ${b[r]} != X && ${b[r]} != O ]] && b[r]=$([[ $t%2 == 0 ]] && echo X || echo O); break
        done
        win && break
      done
    done
    echo
    echo "Match nul... Drôle de jeu : pour gagner, il ne faut pas jouer."
    return
  fi

  player1="X"
  player2=$([[ $n -eq 1 ]] && echo "O" || echo "O")
  for ((t=0; t<9; t++)); do
    clear
    aff
    current=$([[ $((t % 2)) -eq 0 ]] && echo "$player1" || echo "$player2")

    if [[ $current == "X" && $n -ge 1 ]]; then
      while :; do
        r=$((RANDOM % 9))
        [[ ${b[r]} != X && ${b[r]} != O ]] && b[r]="X"; echo "Ordi (X) joue case $((r+1))"; break
      done
    elif [[ $current == "O" && $n -eq 1 ]]; then
      read -p "À toi (O), choisis une case : " c
      ((c--))
      [[ ${b[c]} != X && ${b[c]} != O ]] && b[c]="O" || { echo "Invalide"; read; ((t--)); continue; }
    else
      read -p "Joueur $current, choisis une case : " c
      ((c--))
      [[ ${b[c]} != X && ${b[c]} != O ]] && b[c]=$current || { echo "Invalide"; read; ((t--)); continue; }
    fi

    win && { clear; aff; echo "Le joueur $gagnant a gagné !"; return; }
  done

  clear
  aff
  echo "Match nul !"
}

while :
do

  [[ "$user_input" == "exit" ]] && break
  [[ "$user_input" == "morpion" ]] && morpion

  read -p "A quoi voulez-vous jouer : " user_input

  context+="$user_input"

  response=$(ollama run gemma3:1b "$preprompt $response")

  afficher_lentement "Joshua : $response"

done
