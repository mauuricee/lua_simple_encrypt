math.randomseed(os.time()) -- Pour ne jamais avoir la même clé

function TableToString(tbl) -- Permet de transformer une table en string (via GHUB)
    local result = ""
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            result = result .. "" .. k
        end

        if type(v) == "table" then
            result = result .. TableToString(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result..""..v..""
        end
        result = result .. ""
    end
    return result
end

function indexOf(t, val) -- Permet de repérér un mot dans une WordList pendant le décryptage
    for i, v in pairs(t) do
        if v == val then
            return i
        end
    end
    return false
end

function PrintTable(t) -- Permet d'imprimer tous les élements d'une table
  if not (type(t) == "table") then
    print("L'élément n'est pas une table")
    return false
  end
  for k,v in pairs(t) do
    print(v)
  end
end

function CheckASCIIChar(s) -- Vérifie que les caractères écrits sont compris dans la table ASCII
  local slen = string.len(s) -- Longueur de la phrase écrite
  for i = 1,slen do -- Pour chaque caractère
    local char = string.sub(s,i,i) -- Isole le caractère
    local charnum = string.byte(char) -- Le convertit en décimale correspondant à la table ASCII
    if charnum > 128 then -- Si le décimal obtenu n'est pas dans la table
      return false -- Renvoie faux
    end
  end
  return true -- Renvoie vrai
end

function KeyGen() -- Fonction générant une WordList
  local wlist = {}
  for i = 1,128 do -- La Table ASCII comportant 128 bits
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
    table.insert(wlist,TableToString(word)) -- Insère chaque mot généré dans la WordList
  end
  print("\n")
  print(TableToString(wlist))
  return wlist
end

function KeyImport(s)
  local wlist = {}
  local wstart = 1
  local wend = 4
  for i = 1,128 do
    local word = string.sub(s,wstart,wend)
    table.insert(wlist,word)
    wstart = wstart+4
    wend = wend+4
  end
  return wlist
end

function Encrypt(s,t) -- Fonction cryptant un texte alphanumérique avec une WordList
  if not CheckASCIIChar(s) then -- Si les caractères ne sont pas sur la table ASCII
    return false -- Renvoie faux
  end
  local wlist = t
  local snum = string.len(s) -- Longueur de la phrase
  local sres = {} -- Table qui contiendra la phrase cryptée
  for i = 1,snum do -- Boucle se répétant pour chaque caractère de la phrase
    local sb = string.sub(s,i,i) -- Permet d'isoler chaque caractère dans la boucle
    sb = tonumber(string.byte(sb)) -- Permet de convertir le caractère en décimal selon la table ASCII
    sb = wlist[sb] -- Permet d'obtenir le mot de la WordList renseignée correspondant
    table.insert(sres,sb) -- Insère chaque mot de cryptage dans la phrase
  end
  return TableToString(sres) -- Renvoie une phrase cryptée convertie en string
end

function Decrypt(s,t)
  if not CheckASCIIChar(s) then -- Si les caractères ne sont pas sur la table ASCII
    return false -- Renvoie faux
  end
  local wlist = t
  local crypted = s
  local cryptedtable = {} -- Prépare la table pour isoler chaque mot de la phrase cryptée
  local uncrypted = {} -- Prépare la table de la phrase décryptée
  local snum = (tonumber(string.len(crypted)))/4 -- Permet d'obtenir le nombre de caractères quand décrypté
  if not (type(snum) == "number" and math.floor(snum) == snum) then -- Vérifie le cas précédent
    return false
  end
  local wstart = 1
  local wend = 4 -- Longueur de chaque mot
  for i = 1,snum do -- Pour chaque mot de la phrase cryptée
    local w = string.sub(crypted, wstart, wend) -- Permet d'isoler un mot de la phrase cryptée
    table.insert(cryptedtable,w) -- Insère le mot dans la table
    wstart = wstart+4 -- Passe au mot suivant
    wend = wend+4
  end
  for k,v in pairs(cryptedtable) do -- Boucle permettant le décryptage
    if not indexOf(wlist,v) then -- Si contenu non trouvé
      MainMenu()
      return false
    end
    local char = string.char(tonumber(indexOf(wlist,v))) -- Convertit selon la WordList
    table.insert(uncrypted,char) -- Ajoute le caractère déchiffré dans la table
  end
  return TableToString(uncrypted) -- Renvoie la phrase décryptée
end