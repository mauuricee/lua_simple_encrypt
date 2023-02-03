require("fonctions") -- Charge le fichier fonctions.lua
require("menus") -- Charge le fichier menus.lua
key = nil -- Réinitialise la clé secrète à chaque démarrage

print("===========================================") -- Message affiché lors du démarrage
print("Système de chiffrement de phrases")           -- de base du script
print("Permet de générer / importer une clé")
print("Permet de chiffrer / déchiffrer une phrase")
print("===========================================")
MainMenu() -- Affiche le menu principal