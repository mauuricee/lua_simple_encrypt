function FailMessage() -- Message affiché lorsqu'un choix erroné est fait
  print("Vous devez renseigner 1, 2, ou 3. Retour au menu principal")
  MainMenu() -- Redirection vers le menu principal
end

function CleanMenu() -- Permet de ne pas laisser affichées des informations sensibles
  for i = 1,50 do
    print("\n\n")
  end
end

function MainMenu() -- Menu principal
  print("\n===========================================")
  print("MENU PRINCIPAL")
  print("===========================================")
  print("Que souhaitez-vous faire ?")
  print("1 - Générer / Importer une clé")
  print("2 - Chiffrer une phrase")
  print("3 - Déchiffrer une phrase")
  print("Saisissez un chiffre puis faites Entrée pour valider votre choix")
  local opt = tonumber(io.read()) -- Lit l'option choisie
  if opt == 1 then -- Lance le menu selon le choix fait
    KeyMenu()
  elseif opt == 2 then
    EncryptMenu()
  elseif opt == 3 then
    DecryptMenu()
  else
    FailMessage() -- Si aucun choix identifié alors message d'erreur
  end
end

function EncryptMenu() -- Menu d'encryption
  print("===========================================")
  print("MENU DE CHIFFREMENT")
  print("===========================================")
  if not key then -- Vérifie si aucune clé n'est chargée
    print("Aucune clé secrète n'est chargée, retour au menu principal")
    MainMenu()
    return false -- Si elle est absente retour au menu principal
  end
  print("Nous vous invitons à écrire ou coller votre phrase.")
  print("Elle vous sera affichée après chiffrement et vous retournerez")
  print("au menu principal")
  local phrase = tostring(io.read()) -- Conversion forcée en string pour éviter une injection
  CleanMenu() -- Permet de ne pas laisser affichée la phrase non chiffrée
  local crypted = Encrypt(phrase,key) -- Execute la fonction de chiffrement
  if not crypted then
    CleanMenu()
    print("Une erreur est survenue. Les crochets")
    print("de type [] et autres symboles alphanumériques")
    print("sont pris en charge. Veuillez donc éviter les")
    print("symboles spéciaux.")
    MainMenu()
    return
  end
  print("\n")
  print(crypted) -- Affiche la phrase chiffrée
  print("\n")
  MainMenu() -- Retourne au menu principal
end

function DecryptMenu() -- Menu de décryptage
  print("===========================================")
  print("MENU DE DÉCHIFFREMENT")
  print("===========================================")
  if not key then -- Vérifie qu'aucune clé n'est chargée
    print("Aucune clé secrète n'est chargée, retour au menu principal")
    MainMenu()
    return false -- Si elle est absente retour au menu principal
  end
  print("ASSUREZ VOUS D'AVOIR CHARGE LA CLE CORRESPONDANT")
  print("A LA PHRASE CHIFFREE")
  print("Nous vous invitons à écrire ou coller votre phrase chiffrée.")
  print("Elle vous sera affichée après déchiffrement et vous retournerez")
  print("au menu principal")
  local phrase = tostring(io.read()) -- Conversion forcée en string pour éviter une injection
  local uncrypted = Decrypt(phrase,key) -- Execute la fonction de déchiffrement
  if not uncrypted then
    CleanMenu()
    print("Une erreur est survenue. Votre contenu chiffré")
    print("semble contenir des caractères non pris en charge")
    print("ou la mauvaise clé a été renseignée.")
    print("Veuillez la vérifier")
    MainMenu()
    return
  end
  CleanMenu() -- Permet de n'afficher que la phrase déchiffrée
  print(uncrypted) -- Affiche la phrase déchiffrée
  print("\n")
  MainMenu() -- Retour au menu principal
end

function KeyMenu() -- Menu de gestion des clés
  print("===========================================")
  print("GESTION DES CLES")
  print("===========================================")
  if not key then -- Vérifie qu'aucune clé n'est chargée
    print("Aucune clé n'a été chargée, que souhaitez-vous faire ?")
    print("1 - Générer une clé")
    print("2 - Importer une clé")
    print("Saisissez un chiffre puis faites Entrée pour valider votre choix")
    local opt = tonumber(io.read()) -- Lit le choix effectué
    if opt == 1 then
      KeyGenMenu() -- Ouvre le menu selon le choix fait
    elseif opt == 2 then
      KeyImportMenu()
    else
      FailMessage() -- Erreur en cas de mauvais choix
    end
  else -- Si une clé est chargée (variable "key" non nulle)
    print("Une clé est actuellement chargée, que souhaitez-vous faire ?")
    print("1 - Supprimer la clé actuelle")
    print("2 - Retourner au menu principal")
    local opt = tonumber(io.read())
    if opt == 1 then
      key = nil -- Réinitialise la clé
      print("\nClé déchargée ! Vous allez être redirigé vers le menu principal")
      MainMenu() -- Retour au menu
    elseif opt == 2 then
      MainMenu() -- Retour au menu sans toucher la clé
    else
      FailMessage() -- Si mauvais choix effectué
    end
  end
end

function KeyGenMenu() -- Menu de génération de clé
  print("===========================================")
  print("GENERATION DE CLE")
  print("===========================================")
  print("Une clé va vous être générée et affichée.")
  print("Vous serez ensuite redirigé vers le menu principal")
  print("Veuillez la garder dans un lieu sûr et à l'abri des regards")
  print("Appuyez sur Entrée lorsque la clé est récupérée\n")
  local k = KeyGen() -- Execute le script de génération de clé
  key = k -- Affecte la clé générée à la variable "key"
  io.read() -- Attend qu'une touche soit activée par le client pour nettoyer et masquer la clé
  CleanMenu()
  print("Clé chargée dans le script !")
  MainMenu()
end

function KeyImportMenu()
  print("===========================================")
  print("IMPORTATION DE CLE")
  print("===========================================")
  print("Veuillez coller votre clé :")
  local k = tostring(io.read()) -- Conversion forcée en string pour éviter une injection
  if k == nil or k == "" then -- Vérifie que le client n'a pas juste fait Entrée
    print("Aucune clé renseignée")
    MainMenu()
    return false
  end
  if string.len(k) > 392 or string.len(k) < 392 then -- Vérifie que la clé contienne tous les caractères nécessaires
    print("Clé invalide ou caractères manquants / en trop")
    MainMenu()
    return false -- Renvoie vers le menu dans le cas contraire
  end
  CleanMenu() -- Permet d'éviter que la clé chargée ne soit visible
  print("Chargement de la clé en cours...")
  local lk = KeyImport(k) -- Execute la fonction d'importation de clé
  key = lk -- Affecte la clé importée à la variable "key"
  print("Clé chargée !")
  print("Retour au menu principal")
  MainMenu() -- Retour au menu principal
end
