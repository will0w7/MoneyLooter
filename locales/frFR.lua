---@class MoneyLooter
local MoneyLooter = select(2, ...)

---@class ML_Locales
local Locales = MoneyLooter.Locales

Locales.frFR = function()
  local L = {}
  L["START"] = "Démarrer"
  L["CONTINUE"] = "Continuer"
  L["PAUSE"] = "Pause"
  L["RESET"] = "Réinitialiser"
  L["TIME_LABEL"] = "Temps:"
  L["GOLD_LABEL"] = "Or:"
  L["ITEMS_LABEL"] = "Objets:"
  L["GPH_LABEL"] = "GPH:"
  L["PRICIEST_LABEL"] = "Le plus cher:"
  L["USAGE"] = [[====== |cFFd8de35Informations d'utilisation de MoneyLooter|r ======
  |cFF36e8e6/ml|r : Activer/Désactiver l'affichage
  |cFF36e8e6/ml|r |cFFf1f488help|r : Afficher l'aide
  |cFF36e8e6/ml|r |cFFf1f488show|r : Afficher MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488hide|r : Masquer MoneyLooter
  |cFF36e8e6/ml|r |cFFf1f488info|r : Afficher les informations sur l'addon.
  |cFF36e8e6/ml|r |cFFf1f488custom 'chaîne TSM personnalisée'|r : Définit la chaîne TSM utilisée pour le calcul du prix. Si vide, renvoie la chaîne TSM actuelle.
    Exemples: /ml custom dbmarket
              /ml custom
  |cFF36e8e6/ml|r |cFFf1f488mprice 'valeur'|r : Définit le seuil minimal de prix pour une qualité.
            mpricex : Toutes les qualités disponibles.
            mprice1 : Qualité 1 - Normale - Blanche
            mprice2 : Qualité 2 - Peu courante - Verte
            mprice3 : Qualité 3 - Rare - Bleue
            mprice4 : Qualité 4 - Épique - Pourpre
      Les autres qualités utiliseront le prix du vendeur, s'il est disponible.
    Exemples: /ml mprice1 50 s
              /ml mprice2 5000
              /ml mprice3 500 g
              /ml mprice4 5 c
      Le format de prix pour mprice est un nombre suivi de g (or), s (argent) ou c (cuivre). Si seul le nombre est fourni, l'or est utilisé par défaut.
  |cFF36e8e6Version de l'addon:|r ]]
  L["WELCOME"] =
  "Bienvenue dans |cFFd8de35Money Looter|r! Utilisez |cFF36e8e6/ml|r |cFFf1f488help|r pour les options de l'addon."
  L["CLOSE"] = "|cFF36e8e6/ml|r |cFFf1f488show|r : Afficher à nouveau |cFFd8de35MoneyLooter|r"
  L["INFO"] = "|cFFd8de35Money Looter|r est un addon léger et rapide pour le suivi de butin, créé par Will0w7."
  L["TSM_NOT_AVAILABLE"] = "|cFFd8de35Money Looter:|r TSM n'est pas disponible."
  L["TSM_CUSTOM_STRING_NOT_VALID"] =
  "|cFFd8de35Money Looter:|r La chaîne TSM indiquée est invalide et n'a pas été définie: "
  L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35Money Looter:|r La chaîne TSM indiquée est valide et a été définie: "
  L["TSM_CUSTOM_STRING"] = "|cFFd8de35Money Looter:|r Utilisation de la chaîne TSM suivante: "
  L["NEW_DB_VERSION"] =
  "|cFFd8de35Money Looter:|r Une nouvelle version de la base de données a été détectée, mise à jour en cours…"
  L["DB_UPDATED"] = "|cFFd8de35Money Looter:|r La base de données a été mise à jour avec succès!"
  L["MPRICE_ERROR"] = "|cFFd8de35Money Looter:|r Le seuil minimal de prix indiqué est invalide: "
  L["MPRICE_VALID"] = "|cFFd8de35Money Looter:|r Le seuil minimal de prix indiqué est valide et a été défini:"
  L["MPRICE_QUALITY_1"] = "Normale"
  L["MPRICE_QUALITY_2"] = "Peu courante"
  L["MPRICE_QUALITY_3"] = "Rare"
  L["MPRICE_QUALITY_4"] = "Épique"
  L["MPRICE_QUALITY_99"] = "Toutes les qualités"
  L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35Money Looter:|r Monnaie non reconnue, vérifiez l'entrée."
  L["MPRICE_COIN_G"] = "Or"
  L["MPRICE_COIN_S"] = "Argent"
  L["MPRICE_COIN_C"] = "Cuivre"
  L["FORCE_VENDOR_PRICE_ENABLED"] =
  "|cFFd8de35Money Looter:|r Prix vendeur forcé activé. Seuls les prix de vente du vendeur seront utilisés."
  L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35Money Looter:|r Prix vendeur forcé désactivé."
  return L
end
