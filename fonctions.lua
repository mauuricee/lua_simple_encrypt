math.randomseed(os.time()) -- Pour ne jamais avoir la même clé

local byte, len, find, sub, concat = string.byte, string.len, string.find, string.sub, table.concat

local Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz123456789!!#$%&'()*+,-./:;<=>?`{|}~^_éàè@êâûöä"

local Base = 98

function indexOf(t, val) -- Permet de repérér un mot dans une WordList pendant le décryptage
    for i, v in pairs(t) do
        if v == val then
            return i
        end
    end
    return false
end

function ReturnBase(s)
  if byte(s) == 32 then return 98 end
  local baseID = find(Charset,s)
  if baseID ~= nil then
    return baseID
  end
  return false
end

function ReturnChar(n)
  if n > 98 then
    return false
  end
  if n == 98 then
    return " "
  end
  return sub(Charset, n, n)
end


function CheckBaseChar(s) -- Vérifie que les caractères écrits sont compris dans la base des caractères
  local slen = len(s) -- Longueur de la phrase écrite
  for i = 1,slen do -- Pour chaque caractère
    local char = string.sub(s,i,i) -- Isole le caractère
    local charnum = ReturnBase(char) -- Le convertit en chiffre selon la base
    if charnum > Base then -- Si le décimal obtenu n'est pas dans la table
      return false -- Renvoie faux
    end
  end
  return true -- Renvoie vrai
end

function KeyGen() -- Fonction générant une WordList
  local wlist = {}
  for i = 1,Base do -- La Table ASCII comportant 128 bits
    local word = {}
    for w = 1,4 do -- Chaque mot est composé de 4 caractères
      local chart = 0
      local chartest = math.random(1,2)
      if chartest == 1 then -- Si la variable de test est égale à 1
        chart = math.random(97,122) -- Génère un nombre qui donnera une lettre miniscule
      else
        chart = math.random(65,90) -- Sinon cela générera une lettre majuscule
      end
      chart = string.char(chart) -- Convertit le nombre décimal en caractère ASCII correspondant
      table.insert(word,chart) -- Insère dans le mot le caractère
    end
    table.insert(wlist,concat(word)) -- Insère chaque mot généré dans la WordList
  end
  print("\n")
  print(concat(wlist))
  return wlist
end

function KeyImport(s)
  local wlist = {}
  local wstart = 1
  local wend = 4
  for i = 1,Base do
    local word = string.sub(s,wstart,wend)
    table.insert(wlist,word)
    wstart = wstart+4
    wend = wend+4
  end
  return wlist
end

function Encrypt(s,t) -- Fonction cryptant un texte alphanumérique avec une WordList
  if not CheckBaseChar(s) then -- Si les caractères ne sont pas sur la table ASCII
    return false -- Renvoie faux
  end
  local wlist = t
  local snum = len(s) -- Longueur de la phrase
  local sres = {} -- Table qui contiendra la phrase cryptée
  for i = 1,snum do -- Boucle se répétant pour chaque caractère de la phrase
    local sb = sub(s,i,i) -- Permet d'isoler chaque caractère dans la boucle
    sb = tonumber(ReturnBase(sb)) -- Permet de convertir le caractère en décimal selon la table ASCII
    sb = wlist[sb] -- Permet d'obtenir le mot de la WordList renseignée correspondant
    table.insert(sres,sb) -- Insère chaque mot de cryptage dans la phrase
  end
  return concat(sres) -- Renvoie une phrase cryptée convertie en string
end

function Decrypt(s,t)
  if not CheckBaseChar(s) then -- Si les caractères ne sont pas sur la table ASCII
    return false -- Renvoie faux
  end
  local wlist = t
  local crypted = s
  local cryptedtable = {} -- Prépare la table pour isoler chaque mot de la phrase cryptée
  local uncrypted = {} -- Prépare la table de la phrase décryptée
  local snum = tonumber(len(crypted))/4 -- Permet d'obtenir le nombre de caractères quand décrypté
  local wstart = 1
  local wend = 4 -- Longueur de chaque mot
  for i = 1,snum do -- Pour chaque mot de la phrase cryptée
    local w = sub(crypted, wstart, wend) -- Permet d'isoler un mot de la phrase cryptée
    table.insert(cryptedtable,w) -- Insère le mot dans la table
    wstart = wstart+4 -- Passe au mot suivant
    wend = wend+4
  end
  for i,v in pairs(cryptedtable) do -- Boucle permettant le décryptage
    if not indexOf(wlist,v) then -- Si contenu non trouvé
      MainMenu()
      return "La mauvaise clé semble avoir été renseignée."
    end
    local char = ReturnChar(indexOf(wlist,v)) -- Convertit selon la WordList
    table.insert(uncrypted,char) -- Ajoute le caractère déchiffré dans la table
  end
  return concat(uncrypted) -- Renvoie la phrase décryptée
end
