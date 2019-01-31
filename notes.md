Création du personnage :
Plusieurs scénarios au hasard.
  - le joueur est en prison pour un quelconque crime, il discute avec un prisonnier / un garde l’interpelle. À partir de là, il choisi sa classe, ses attributs, ses talents, son histoire… Une émeute a lieu dans la prison, le joueur en profite pour s'échapper : premiers combats, autres prisonniers, gardes, suivant la direction choisie (égouts avec créatures...)

  - le joueur a été vendu comme esclave pour une quelconque raison. Il voyage en bateau et raconte son histoire à quelqu’un. Le bateau fait naufrage. Le joueur profite de la pagaille ambiante pour s'enfuir : premiers combats, autres esclaves, gardes, marins, créatures sur le bateau...

  - le joueur s'exile. il rencontre quelqu'un et lui raconte son histoire. Puis mauvaise rencontre, bandits, créatures...

Le profil du joueur est sauvegardé dans un fichier à chaque modification (profil et inventaire)


À chaque changement de "tableau", un ou des événements aléatoires se produisent : créatures, pièges, trésors, rien.


Ces éléments sont à une distance aléatoire dans une "pièce" aléatoire.

Chaque tour est déterminé par une action, et donc dépend de la longueur de la salle, la distance à parcourir entre le joueur et la prochaine "porte".
On peut donc utiliser un talent à chaque tour (détection pour les pièges, avancer vers l'objectif, attaquer, talent...)


La difficulté des salles est dépendante du niveau du joueur (ennemi, nombre d'ennemi, pièges et nombre, ouverture coffres...)


Lorsqu'un ennemi est rencontré dans une salle, une nouvelle instance est créée à partir de la base de donnée. Chaque types d'ennemis possèdent différents traits leur donnant accès à différents types d'armes. L'arme ou les armes portées sont choisies aléatoirement parmis les préférences. Lors de la mort de l'ennemi, le loot dépend de l'équipement porté : arme + d'autres éléments (armure, potions, arme supplémentaire(non équipable pour l'ennemi ou moins efficace) (+ argent ?))


loot & xp tables :
http://www.d20pfsrd.com/gamemastering#Table-Character-Wealth-by-Level
http://www.d20srd.org/srd/treasure.htm


https://simplednd.wordpress.com/



Règles très simplifiées :
3 classes de départ

skills :
-listen
-silent move (against listen)
-spot
-hide (against spot)
-lockpick (chests - doors)
-traps (set - disarm)
-tumble
-taunt
-parry
-heal
-bluff
-examine
-concentration


hash (weapon)
  id
  name
  type
  weight
  size
  (material)
  ranged (true or false)
  (damage type)
  damage
  critical range
  critical multiplier
  feats required

hash (creature)


D&D 3.5 or D&D 5.0 ?


ANSI colors

black =
red = fails ennemi / desavantage
green = réussite ennemi / avantage
yellow =
blue = rare items
magenta = very rare items
cyan =
white = log / common uncommon items

black light = précisions règles
red light = fails héro
green light = réussite héro
yellow light = legendary items
blue light =
magenta light =
cyan light =
white light =

background black =
background red = dommages sur ennemi
background green =
background yellow = statut
background blue =
background magenta =
background cyan =
background white =

background black light =
background red light = dommages sur héro
background green light = dommages du héro sur ennemi
background yellow light =
background blue light =
background magenta light =
background cyan light =
background white light =
