﻿; TradeMacro Add-on to POE-ItemInfo
; IGN: Eruyome


PriceCheck:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_PriceCheckHotkey()
	}
Return

TradeFunc_PriceCheckHotkey(priceCheckTest = false, itemData = "") {
	Global TradeOpts, Item

	SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event
	TradeFunc_PreventClipboardGarbageAfterInit()
	
	; simulate clipboard change to test item pricing
	If (priceCheckTest) {
		Clipboard :=
		Clipboard := itemData
	} Else {
		scancode_c := Globals.Get("Scancodes").c
		Send ^{%scancode_c%}
	}
	Sleep 250
	TradeFunc_Main()
	SuspendPOEItemScript = 0 ; Allow Item info to handle clipboard change event
}

AdvancedPriceCheck:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_AdvancedPriceCheckHotkey()
	}
Return

TradeFunc_AdvancedPriceCheckHotkey(priceCheckTest = false, itemData = "") {
	Global TradeOpts, Item

	SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event
	TradeFunc_PreventClipboardGarbageAfterInit()
	
	; simulate clipboard change to test item pricing
	If (priceCheckTest) {
		Clipboard :=
		Clipboard := itemData
	} Else {
		scancode_c := Globals.Get("Scancodes").c
		Send ^{%scancode_c%}
	}
	Sleep 250
	TradeFunc_Main(false, true)
	SuspendPOEItemScript = 0 ; Allow Item info to handle clipboard change event
}

OpenSearchOnPoeTrade:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_OpenSearchOnPoeTradeHotkey()
	}
Return

TradeFunc_OpenSearchOnPoeTradeHotkey(priceCheckTest = false, itemData = "") {
	Global TradeOpts, Item

	SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event
	TradeFunc_PreventClipboardGarbageAfterInit()

	; simulate clipboard change to test item pricing
	If (priceCheckTest) {
		Clipboard :=
		Clipboard := itemData
	} Else {
		scancode_c := Globals.Get("Scancodes").c
		Send ^{%scancode_c%}
	}
	Sleep 250
	TradeFunc_Main(true)
	SuspendPOEItemScript = 0 ; Allow ItemInfo to handle clipboard change event
}

OpenSearchOnPoEApp:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_OpenSearchOnPoeAppHotkey()
	}
Return

TradeFunc_OpenSearchOnPoeAppHotkey(priceCheckTest = false, itemData = "") {
	Global TradeOpts, Item

	SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event
	TradeFunc_PreventClipboardGarbageAfterInit()
	
	clipPrev :=
	; simulate clipboard change to test item pricing
	If (priceCheckTest) {
		Clipboard :=
		Clipboard := itemData
	} Else {
		clipPrev := Clipboard
		scancode_c := Globals.Get("Scancodes").c
		Send ^{%scancode_c%}
	}
	Sleep 250
	
	TradeFunc_DoParseClipboard()
	
	If (Item.Name or Item.BaseName) {
		itemContents := TradeUtils.UriEncode(Clipboard)
		url := "https://poeapp.com/#/item-import/" + itemContents
		Clipboard := clipPrev
		TradeFunc_OpenUrlInBrowser(url)	
	}
	SuspendPOEItemScript = 0 ; Allow ItemInfo to handle clipboard change event
}

ShowItemAge:
	IfWinActive, ahk_group PoEWindowGrp
	{
		Global TradeOpts, Item
		If (!TradeOpts.AccountName) {
			;ShowTooltip("No Account Name specified in settings menu.")
			ShowTooltip("Укажите имя своей учетной записи POE в меню настроек.")
			return
		}
		SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event
		TradeFunc_PreventClipboardGarbageAfterInit()
		
		scancode_c := Globals.Get("Scancodes").c
		Send ^{%scancode_c%}
		Sleep 250
		TradeFunc_Main(false, false, false, true)
		SuspendPOEItemScript = 0 ; Allow Item info to handle clipboard change event
	}
Return

OpenWiki:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_OpenWikiHotkey()
	}
Return

TradeFunc_OpenWikiHotkey(priceCheckTest = false, itemData = "") {
	Global TradeOpts, Item

	SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event

	If (priceCheckTest) {
		Clipboard :=
		Clipboard := itemData
	} Else {
		Send ^{sc02E}
	}
	Sleep 250
	TradeFunc_DoParseClipboard()

	If (!Item.Name and TradeOpts.OpenUrlsOnEmptyItem) {
		If (TradeOpts.WikiAlternative) {
			;http://poedb.tw/us/item.php?n=The+Doctor
			;TradeFunc_OpenUrlInBrowser("http://poedb.tw/us/")
			TradeFunc_OpenUrlInBrowser("http://poedb.tw/ru/")
		} Else {
			;TradeFunc_OpenUrlInBrowser("http://pathofexile.gamepedia.com/")	
			TradeFunc_OpenUrlInBrowser("https://pathofexile-ru.gamepedia.com/")
		}
	}
	Else {
		UrlAffix := ""
		UrlPage := ""
		If (TradeOpts.WikiAlternative) {
			; uses poedb.tw
			UrlPage := "item.php?n="
			
			;По этому URL нельзя искать опознанные уникальные предметы! Проверять на исправление!!!
			;If (Item.IsUnique or Item.IsGem or Item.IsDivinationCard or Item.IsCurrency) {
			If (((Item.IsUnique or Item.IsRelic) and Item.IsUnidentified) or Item.IsGem or Item.IsDivinationCard or Item.IsCurrency) {
				;UrlAffix := Item.Name
				UrlAffix := Item.Name_En
			;URL для опознанных уникальных предметов!
			} Else If (Item.IsUnique or Item.IsRelic) {
				UrlPage := "unique.php?n="
				UrlAffix := Item.Name_En
			} Else If (Item.IsFlask) {
				UrlPage := "search.php?Search="
				UrlAffix := Item.SubType
			} Else If (Item.IsMap) {
				UrlPage := "area.php?n="				
				;UrlAffix := RegExMatch(Item.SubType, "i)Unknown Map") ? Item.BaseName : Item.SubType
				UrlAffix := RegExMatch(Item.SubType, "i)Unknown Map") ? Item.BaseName_En : Item.SubType
			;} Else If (RegExMatch(Item.Name, "i)Sacrifice At") or RegExMatch(Item.Name, "i)Fragment of") or RegExMatch(Item.Name, "i)Mortal ") or RegExMatch(Item.Name, "i)Offering to ") or RegExMatch(Item.Name, "i)'s Key") or RegExMatch(Item.Name, "i)Breachstone")) {
			} Else If (RegExMatch(Item.Name_En, "i)Sacrifice At") or RegExMatch(Item.Name_En, "i)Fragment of") or RegExMatch(Item.Name_En, "i)Mortal ") or RegExMatch(Item.Name_En, "i)Offering to ") or RegExMatch(Item.Name_En, "i)'s Key") or RegExMatch(Item.Name_En, "i)Breachstone")) {
				;UrlAffix := Item.Name
				UrlAffix := Item.Name_En
			} Else {
				;UrlAffix := Item.BaseName
				UrlAffix := Item.BaseName_En
			}				
		}
		Else {
			UrlPage := ""
			
			If (Item.IsUnique or Item.IsGem or Item.IsDivinationCard or Item.IsCurrency) {
				UrlAffix := Item.Name
			} Else If (Item.IsFlask or Item.IsMap) {
				UrlAffix := Item.SubType
			;} Else If (RegExMatch(Item.Name, "i)Sacrifice At") or RegExMatch(Item.Name, "i)Fragment of") or RegExMatch(Item.Name, "i)Mortal ") or RegExMatch(Item.Name, "i)Offering to ") or RegExMatch(Item.Name, "i)'s Key") or RegExMatch(Item.Name, "i)Breachstone")) {
			} Else If (RegExMatch(Item.Name_En, "i)Sacrifice At") or RegExMatch(Item.Name_En, "i)Fragment of") or RegExMatch(Item.Name_En, "i)Mortal ") or RegExMatch(Item.Name_En, "i)Offering to ") or RegExMatch(Item.Name_En, "i)'s Key") or RegExMatch(Item.Name_En, "i)Breachstone")) {
				UrlAffix := Item.Name
			} Else {
				UrlAffix := Item.BaseName
			}
		}

		If (StrLen(UrlAffix) > 0) {
			If (TradeOpts.WikiAlternative) {
				UrlAffix := StrReplace(UrlAffix," ","+")
				;WikiUrl := "http://poedb.tw/us/" UrlPage . UrlAffix
				WikiUrl := "http://poedb.tw/ru/" UrlPage . UrlAffix
			} Else {				
				UrlAffix := StrReplace(UrlAffix," ","_")
				;WikiUrl := "http://pathofexile.gamepedia.com/" UrlPage . UrlAffix
				WikiUrl := "https://pathofexile-ru.gamepedia.com/" UrlPage . UrlAffix
			}
			TradeFunc_OpenUrlInBrowser(WikiUrl)
		}
	}

	SuspendPOEItemScript = 0 ; Allow Item info to handle clipboard change event
	If (not TradeOpts.CopyUrlToClipboard) {
		SetClipboardContents("")	
	}	
}

SetCurrencyRatio:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_SetCurrencyRatio()
	}
Return

TradeFunc_SetCurrencyRatio() {
	Global TradeOpts, Item

	SuspendPOEItemScript = 1 ; This allows us to handle the clipboard change event

	TradeFunc_PreventClipboardGarbageAfterInit()
	scancode_c := Globals.Get("Scancodes").c
	Send ^{%scancode_c%}
	Sleep 250
	TradeFunc_DoParseClipboard()
	
	If (not Item.name or (not Item.IsCurrency or Item.IsEssence or Item.IsDivinationCard)) {
		;ShowToolTip("Item not supported by this function.`nWorks only on currency.")
		ShowToolTip("Предмет не поддерживается этой функцией.`nРаботает только с валютой.")
		Return
	}
	
	tags := TradeGlobals.Get("CurrencyTags")	
	;debugprintarray(tags)
	
	windowPosY := Round(A_ScreenHeight / 2)
	windowPosX := Round(A_ScreenWidth / 2)
	windowTitle := "Set currency ratio"
	
	color := "000000"
	
	Gui, CurrencyRatio:Destroy
	Gui, CurrencyRatio:New, +hwndCurrencyRatioHwnd
	Gui, CurrencyRatio:Font, s8 c%color%, Verdana
	Gui, CurrencyRatio:Color, ffffff, ffffff
	
	Gui, CurrencyRatio:Add, Text, x10, % "You want to sell your"
	Gui, CurrencyRatio:Font, cGreen bold
	itemName := Item.BaseName ? Item.name " " Item.BaseName "." : Item.Name "(s)."
	Gui, CurrencyRatio:Add, Text, x+5 yp+0, % itemName
	Gui, CurrencyRatio:Font, c%color% norm
	
	;Gui, CurrencyRatio:Add, Text, x10, % "Select what you want to receive for the amount of currency that you want to sell."	
	Gui, CurrencyRatio:Add, Text, x10 y+10, % "Input the "
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x+0 yp+0, % "minimum "
	Gui, CurrencyRatio:Font, norm
	Gui, CurrencyRatio:Add, Text, x+0 yp+0, % "amounts that you want to sell and receive"
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x+0 yp+0, % " per single trade"
	Gui, CurrencyRatio:Font, norm
	Gui, CurrencyRatio:Add, Text, x10, % "instead of the amounts that you want to sell and receive in total."	
	
	delimitedListString := ""
	For key, c in tags.currency {
		If (not RegExMatch(c.Text, "i)blessing of | shard")) {
			If (Item.Name != "Chaos Orb") {
				delimiter := RegExMatch(c.Text, "i)Chaos Orb") ? "||" : "|" 
			} Else {
				delimiter := RegExMatch(c.Text, "i)Exalted Orb") ? "||" : "|"
			}
			
			If (c.short) {
				delimitedListString .= c.short delimiter	
			} Else {
				delimitedListString .= c.Text delimiter
			}			
		}		
	}
	For key, c in tags.fragments {		
		If (RegExMatch(c.Text, "i)Splinter of ")) {
			If (c.short) {
				delimitedListString .= c.short "|"
			} Else {
				delimitedListString .= c.Text "|"
			}			
		}
	}
	
	global SelectCurrencyRatioReceiveCurrency := ""
	global SelectCurrencyRatioReceiveAmount := ""
	global SelectCurrencyRatioSellCurrency := Item.name
	global SelectCurrencyRatioSellAmount := ""
	global SelectCurrencyRatioReceiveRatio := ""
	
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x15 y+15 w60, % "Sell:"
	Gui, CurrencyRatio:Font, c%color% norm
	Gui, CurrencyRatio:Add, Edit, x+10 yp-3 w55 vSelectCurrencyRatioSellAmount
	Gui, CurrencyRatio:Add, Text, x+14 yp+3 w276, % Item.name
	
	Gui, CurrencyRatio:Add, GroupBox, x7 y+10 w485 h83,
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x15 yp+15 w60, % "Receive:"
	Gui, CurrencyRatio:Font, c%color% norm
	Gui, CurrencyRatio:Add, Edit, x+10 yp-3 w55 vSelectCurrencyRatioReceiveAmount
	Gui, CurrencyRatio:Add, DropDownList, x+10 yp+0 w280 vSelectCurrencyRatioReceiveCurrency, % delimitedListString
	
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x220 y+5 w100, % "- OR USE -"
	;Gui, CurrencyRatio:Add, Picture, w15 h-1 x10 y+10, %A_ScriptDir%\resources\images\info-blue.png
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x15 y+8 w60 +BackgroundTrans hwndCurrencyRatioInfoTT, % "Ratio*:"
	Gui, CurrencyRatio:Font, norm
	Gui, CurrencyRatio:Add, Text, x+10 yp+0, % Item.name "  1 :"
	
	Gui, CurrencyRatio:Add, Edit, x+8 yp-3 w55 vSelectCurrencyRatioReceiveRatio, 
	Gui, CurrencyRatio:Add, Text, x+8 yp+3, % "[Receive Currency]"

	Gui, CurrencyRatio:Add, Button, x7 y+15 w80 gSelectCurrencyRatioPreview, Preview
	Gui, CurrencyRatio:Add, Text, x+15 yp+3 w260,
	Gui, CurrencyRatio:Add, Button, x+15 yp-3 w116 gSelectCurrencyRatioSubmit, Copy to clipboard
	
	msg := "This UI creates a note that can be used with premium stash tabs to set prices "
	msg .= "`n" "by right-clicking an item and pasting it into the ""Note"" field."
	Gui, CurrencyRatio:Add, Text, x10 y+15, % msg
	
	Gui, CurrencyRatio:Font, bold
	Gui, CurrencyRatio:Add, Text, x10 y+13, % "*"
	Gui, CurrencyRatio:Font, norm
	Gui, CurrencyRatio:Font, s7
	msg := "Using a ratio ignores any receive amount. The macro may change the sell amount"
	msg .= "`n" "while trying to calculate a good (integer) receive amount."
	Gui, CurrencyRatio:Add, Text, x+4 yp-1, % msg
	Gui, CurrencyRatio:Font, s8
	
	Gui, CurrencyRatio:Font, s7 bold
	Gui, CurrencyRatio:Add, Text, x10 y+10, % "Your trade will be listed on all trade-sites."
	
	Gui, CurrencyRatio:Show, center AutoSize, % windowTitle

	SuspendPOEItemScript = 0 ; Allow ItemInfo to handle clipboard change event
}

CustomInputSearch:
	IfWinActive, ahk_group PoEWindowGrp
	{
		TradeFunc_CustomSearchGui()
	}
Return

ChangeLeague:
	IfWinActive, ahk_group PoEWindowGrp
	{
		Global TradeOpts
		TradeFunc_ChangeLeague()
	}
Return

; Prepare Request Parameters and send Post Request
; openSearchInBrowser : set to true to open the search on poe.trade instead of showing the tooltip
; isAdvancedPriceCheck : set to true If the GUI to select mods should be openend
; isAdvancedPriceCheckRedirect : set to true If the search is triggered from the GUI
; isItemAgeRequest : set to true to check own listed items age
TradeFunc_Main(openSearchInBrowser = false, isAdvancedPriceCheck = false, isAdvancedPriceCheckRedirect = false, isItemAgeRequest = false)
{
	LeagueName := TradeGlobals.Get("LeagueName")
	Global Item, ItemData, TradeOpts, mapList, uniqueMapList, Opts

	; When redirected from AdvancedPriceCheck form the clipboard has already been parsed
	if(!isAdvancedPriceCheckRedirect) {
		TradeFunc_DoParseClipboard()
	}

	iLvl     := Item.Level

	; cancel search If Item is empty
	If (!Item.Name) {
		If (TradeOpts.OpenUrlsOnEmptyItem and openSearchInBrowser) {
			TradeFunc_OpenUrlInBrowser("https://poe.trade")
		}
		return
	}

	If (Item.IsRelic) {
		Item.IsUnique := true
	}

	If (Opts.ShowMaxSockets != 1) {
		TradeFunc_SetItemSockets()
	}

	Stats := {}
	Stats.Quality := Item.Quality
	DamageDetails := Item.DamageDetails
	;Name := Item.Name
	Name := Item.Name_En	
	Name_Ru := Item.Name
	
	Item.xtype		:= ""
	Item.UsedInSearch	:= {}
	Item.UsedInSearch.iLvl	:= {}
	For key, val in Item.UsedInSearch {
		If (isObject(val)) {
			Item[key] := {}
		} Else {
			Item[key] := 
		}
	}

	RequestParams			:= new RequestParams_()
	RequestParams.league	:= LeagueName
	RequestParams.has_buyout := "1"

	 	If (!Item.IsJewel and !Item.IsLeaguestone and Item.RarityLevel > 1 and Item.RarityLevel < 4 and !Item.IsFlask or (Item.IsJewel and not Item.RarityLevel = 4 and isAdvancedPriceCheckRedirect)) { 
		IgnoreName := true
	}
	If (Item.RarityLevel > 0 and Item.RarityLevel < 4 and (Item.IsWeapon or Item.IsArmour or Item.IsRing or Item.IsBelt or Item.IsAmulet)) {
		IgnoreName := true
	}
	If (Item.IsRelic) {
		IgnoreName := false
	}
	If (Item.IsBeast) {
		If (Item.IsUnique) {
			IgnoreName := false
		} Else {
			IgnoreName := true
		}		
	}

	If (Item.IsLeagueStone) {
		ItemData.Affixes := TradeFunc_AddCustomModsToLeaguestone(ItemData.Affixes, Item.Charges)
	}

	; check if the item implicit mod is an enchantment or corrupted. retrieve this mods data.
	Enchantment := false
	Corruption  := false

	If (Item.hasImplicit) {
		Enchantment := TradeFunc_GetEnchantment(Item, Item.SubType)
		Corruption  := Item.IsCorrupted ? TradeFunc_GetCorruption(Item) : false
		; наличие зачарования
		Item.IsEnchantment  := Enchantment ? true : false
	}

	If (Item.IsWeapon or Item.IsQuiver or Item.IsArmour or Item.IsLeagueStone or Item.IsBeast or (Item.IsFlask and Item.RarityLevel > 1) or Item.IsJewel or (Item.IsMap and Item.RarityLevel > 1) of Item.IsBelt or Item.IsRing or Item.IsAmulet)
	{
		hasAdvancedSearch := true
	}

	; Harbinger fragments/maps are unique but not flagged as such on poe.trade
	;If (RegExMatch(Item.Name, "i)(First|Second|Third|Fourth) Piece of.*|The Beachhead.*")) {
	If (RegExMatch(Item.Name_En, "i)(First|Second|Third|Fourth) Piece of.*|The Beachhead.*")) {
		Item.IsUnique 	:= false
	}

	If (!Item.IsUnique or Item.IsBeast) {
		; TODO: improve this
		If (Item.IsBeast) {
			Item.BeastData.GenusMod 		:= {}
			Item.BeastData.GenusMod.name_orig	:= "(beast) Genus: " Item.BeastData.Genus
			Item.BeastData.GenusMod.name		:= RegExReplace(Item.BeastData.GenusMod.name_orig, "i)\d+", "#")
			Item.BeastData.GenusMod.param		:= TradeFunc_FindInModGroup(TradeGlobals.Get("ModsData")["bestiary"], Item.BeastData.GenusMod)
		}

		preparedItem  := TradeFunc_PrepareNonUniqueItemMods(ItemData.Affixes, Item.Implicit, Item.RarityLevel, Enchantment, Corruption, Item.IsMap, Item.IsBeast)
		preparedItem.maxSockets	:= Item.maxSockets
		preparedItem.iLvl		:= Item.level
		;preparedItem.Name		:= Item.Name
		preparedItem.Name_Ru	:= Item.Name
		preparedItem.Name		:= Item.Name_En
		;preparedItem.BaseName	:= Item.BaseName
		preparedItem.BaseName_Ru	:= Item.BaseName
		preparedItem.BaseName	:= Item.BaseName_En
		preparedItem.Rarity		:= Item.RarityLevel
		preparedItem.BeastData	:= Item.BeastData
		If (Item.isShaperBase or Item.isElderBase or Item.IsAbyssJewel) {
			preparedItem.specialBase	:= Item.isShaperBase ? "Shaper Base" : ""
			preparedItem.specialBaseRu	:= Item.isShaperBase ? "База Создателя" : ""
			preparedItem.specialBase	:= Item.isElderBase ? "Elder Base" : preparedItem.specialBase
			preparedItem.specialBaseRu	:= Item.isElderBase ? "База Древнего" : preparedItem.specialBaseRu
		}		
		Stats.Defense := TradeFunc_ParseItemDefenseStats(ItemData.Stats, preparedItem)
		Stats.Offense := TradeFunc_ParseItemOffenseStats(DamageDetails, preparedItem)

		If (isAdvancedPriceCheck and hasAdvancedSearch) {
			If (Enchantment.Length()) {
				TradeFunc_AdvancedPriceCheckGui(preparedItem, Stats, ItemData.Sockets, ItemData.Links, "", Enchantment)
			}
			Else If (Corruption.Length()) {
				TradeFunc_AdvancedPriceCheckGui(preparedItem, Stats, ItemData.Sockets, ItemData.Links, "", Corruption)
			}
			Else { 
				TradeFunc_AdvancedPriceCheckGui(preparedItem, Stats, ItemData.Sockets, ItemData.Links)
			}
			return
		}
		Else If (isAdvancedPriceCheck and not hasAdvancedSearch) {
			;ShowToolTip("Advanced search not available for this item.")
			ShowToolTip("Расширенный поиск недоступен для этого предмета.")
			return
		}
	}

	If (Item.IsUnique) {
		; returns mods with their ranges of the searched item if it is unique and has variable mods
		uniqueWithVariableMods :=
		uniqueWithVariableMods := TradeFunc_FindUniqueItemIfItHasVariableRolls(Name, Item.IsRelic)	

		; Return if the advanced search was used but the checked item doesn't have variable mods
		If (!uniqueWithVariableMods and isAdvancedPriceCheck and not Enchantment.Length() and not Corruption.Length()) {
			;ShowToolTip("Advanced search not available for this item (no variable mods)`nor item is new and the necessary data is not yet available/updated.")
			ShowToolTip("Расширенный поиск недоступен для этого предмета (моды не распознаны)`nили предмет является новым, и необходимые данные еще недоступны / не обновлены.")
			return
		}

		UniqueStats := TradeFunc_GetUniqueStats(Name, Item.IsRelic)
			
 		If (uniqueWithVariableMods or Corruption.Length() or Enchantment.Length()) { 
		Gui, SelectModsGui:Destroy

			preparedItem :=
			preparedItem := TradeFunc_GetItemsPoeTradeUniqueMods(uniqueWithVariableMods)	
			preparedItem := TradeFunc_RemoveAlternativeVersionsMods(preparedItem, ItemData.Affixes)
			If (not preparedItem.Name and not preparedItem.mods.length()) {
				preparedItem := {}
				preparedItem.Name := Item.Name
				preparedItem.maxSockets := Item.maxSockets
				preparedItem.IsUnique := Item.IsUnique
				preparedItem.class := Item.SubType
			}						
			preparedItem.maxSockets 	:= Item.maxSockets
			preparedItem.isCorrupted	:= Item.isCorrupted
			preparedItem.isRelic	:= Item.isRelic
			preparedItem.iLvl 		:= Item.level
			preparedItem.Name_Ru	:= Item.Name
			;preparedItem.BaseName	:= Item.BaseName
			preparedItem.BaseName	:= Item.BaseName_En
			preparedItem.BaseName_Ru	:= Item.BaseName
			Stats.Defense := TradeFunc_ParseItemDefenseStats(ItemData.Stats, preparedItem)
			Stats.Offense := TradeFunc_ParseItemOffenseStats(DamageDetails, preparedItem)

			; open TradeFunc_AdvancedPriceCheckGui to select mods and their min/max values
			If (isAdvancedPriceCheck) {
				UniqueStats := TradeFunc_GetUniqueStats(Name)

				If (Enchantment.Length()) {
					TradeFunc_AdvancedPriceCheckGui(preparedItem, Stats, ItemData.Sockets, ItemData.Links, UniqueStats, Enchantment)
				}
				Else If (Corruption.Length()) {
					TradeFunc_AdvancedPriceCheckGui(preparedItem, Stats, ItemData.Sockets, ItemData.Links, UniqueStats, Corruption)
				}
				Else {
					TradeFunc_AdvancedPriceCheckGui(preparedItem, Stats, ItemData.Sockets, ItemData.Links, UniqueStats)
				}
				return
			}
		}
		Else {
			RequestParams.name   := Trim(StrReplace(Name, "Superior", ""))
			Item.UsedInSearch.FullName := true
		}

		; only find items that can have the same amount of sockets
		If (Item.MaxSockets = 6) {
			RequestParams.ilevel_min  := 50
			Item.UsedInSearch.iLvl.min:= 50
		}
		Else If (Item.MaxSockets = 5) {
			RequestParams.ilevel_min := 35
			RequestParams.ilevel_max := 49
			Item.UsedInSearch.iLvl.min := 35
			Item.UsedInSearch.iLvl.max := 49
		}
		Else If (Item.MaxSockets = 5) {
			RequestParams.ilevel_min := 35
			Item.UsedInSearch.iLvl.min := 35
		}
		; is (no 1-hand or shield or unset ring or helmet or glove or boots) but is weapon or armor
		Else If ((not Item.IsFourSocket and not Item.IsThreeSocket and not Item.IsSingleSocket) and (Item.IsWeapon or Item.IsArmour) and Item.Level < 35) {
			RequestParams.ilevel_max := 34
			Item.UsedInSearch.iLvl.max := 34
		}

		; set links to max for corrupted items with 3/4 max sockets if the own item is fully linked
		If (Item.IsCorrupted and TradeOpts.ForceMaxLinks) {
			If (Item.MaxSockets = 4 and ItemData.Links = 4) {
				RequestParams.link_min := 4
			}
			Else If (Item.MaxSockets = 3 and ItemData.Links = 3) {
				RequestParams.link_min := 3
			}
		}
		
		; special bases (elder/shaper)
		If (Item.IsShaperBase or Item.IsElderBase) {
			If (Item.IsShaperBase) {
				RequestParams.Shaper := 1
				Item.UsedInSearch.specialBase := "Shaper"
				Item.UsedInSearch.specialBaseRu := "Создателя"
			}
			Else If (Item.IsElderBase) {
				RequestParams.Elder := 1
				Item.UsedInSearch.specialBase := "Elder"
				Item.UsedInSearch.specialBaseRu := "Древнего"
			}
		}
	}

	; ignore mod rolls unless the TradeFunc_AdvancedPriceCheckGui is used to search
	AdvancedPriceCheckItem := TradeGlobals.Get("AdvancedPriceCheckItem")
	If (isAdvancedPriceCheckRedirect) {
		; submitting the AdvancedPriceCheck Gui sets TradeOpts.Set("AdvancedPriceCheckItem") with the edited item (selected mods and their min/max values)
		s := TradeGlobals.Get("AdvancedPriceCheckItem")
		Loop % s.mods.Length() {
			If (s.mods[A_Index].selected > 0) {
				modParam := new _ParamMod()
				modParam.mod_name := s.mods[A_Index].param
				modParam.mod_min := s.mods[A_Index].min
				modParam.mod_max := s.mods[A_Index].max
				RequestParams.modGroups[1].AddMod(modParam)
			}
		}
		Loop % s.stats.Length() {
			If (s.stats[A_Index].selected > 0) {
				; defense
				If (InStr(s.stats[A_Index].Param, "Armour")) {
					RequestParams.armour_min  := (s.stats[A_Index].min > 0) ? s.stats[A_Index].min : ""
					RequestParams.armour_max  := (s.stats[A_Index].max > 0) ? s.stats[A_Index].max : ""
				}
				Else If (InStr(s.stats[A_Index].Param, "Evasion")) {
					RequestParams.evasion_min := (s.stats[A_Index].min > 0) ? s.stats[A_Index].min : ""
					RequestParams.evasion_max := (s.stats[A_Index].max > 0) ? s.stats[A_Index].max : ""
				}
				Else If (InStr(s.stats[A_Index].Param, "Energy")) {
					RequestParams.shield_min  := (s.stats[A_Index].min > 0) ? s.stats[A_Index].min : ""
					RequestParams.shield_max  := (s.stats[A_Index].max > 0) ? s.stats[A_Index].max : ""
				}
				Else If (InStr(s.stats[A_Index].Param, "Block")) {
					RequestParams.block_min  := (s.stats[A_Index].min > 0)  ? s.stats[A_Index].min : ""
					RequestParams.block_max  := (s.stats[A_Index].max > 0)  ? s.stats[A_Index].max : ""
				}

				; offense
				Else If (InStr(s.stats[A_Index].Param, "Physical")) {
					RequestParams.pdps_min  := (s.stats[A_Index].min > 0)  ? s.stats[A_Index].min : ""
					RequestParams.pdps_max  := (s.stats[A_Index].max > 0)  ? s.stats[A_Index].max : ""
				}
				Else If (InStr(s.stats[A_Index].Param, "Elemental")) {
					RequestParams.edps_min  := (s.stats[A_Index].min > 0)  ? s.stats[A_Index].min : ""
					RequestParams.edps_max  := (s.stats[A_Index].max > 0)  ? s.stats[A_Index].max : ""
				}
			}
		}

		; handle item sockets
		If (s.UseSockets) {
			RequestParams.sockets_min := ItemData.Sockets
			Item.UsedInSearch.Sockets := ItemData.Sockets
		}
		If (s.UseSocketsMaxFour) {
			RequestParams.sockets_min := 4
			Item.UsedInSearch.Sockets := 4
		}
		If (s.UseSocketsMaxThree) {
			RequestParams.sockets_min := 3
			Item.UsedInSearch.Sockets := 3
		}

		; handle item links
		If (s.UseLinks) {
			RequestParams.link_min	:= ItemData.Links
			Item.UsedInSearch.Links	:= ItemData.Links
		}
		If (s.UseLinksMaxFour) {
			RequestParams.link_min	:= 4
			Item.UsedInSearch.Links	:= 4
		}
		If (s.UseLinksMaxThree) {
			RequestParams.link_min	:= 3
			Item.UsedInSearch.Links	:= 3
		}

		If (s.UsedInSearch) {
			Item.UsedInSearch.Enchantment := s.UsedInSearch.Enchantment
			Item.UsedInSearch.CorruptedMod:= s.UsedInSearch.Corruption
		}

		If (s.useIlvl) {
			RequestParams.ilvl_min := s.minIlvl
			Item.UsedInSearch.iLvl.min := true
		}

		If (s.useBase) {
			If (Item.IsBeast) {
				modParam := new _ParamMod()
				modParam.mod_name := Item.BeastData.GenusMod.param
				modParam.mod_min := ""
				RequestParams.modGroups[1].AddMod(modParam)
				Item.UsedInSearch.Type := Item.BaseType ", " Item.BeastData.Genus
			} Else {
				;RequestParams.xbase := Item.BaseName
				RequestParams.xbase := Item.BaseName_En
				;Item.UsedInSearch.ItemBase := Item.BaseName
				Item.UsedInSearch.ItemBaseRu := Item.BaseName
				Item.UsedInSearch.ItemBase := Item.BaseName_En
			}			
		}

		If (s.onlineOverride) {
			RequestParams.online := ""
		}
		
		; special bases (elder/shaper)
		If (s.useSpecialBase) {
			If (Item.IsShaperBase) {
				RequestParams.Shaper := 1
			}
			Else If (Item.IsElderBase) {
				RequestParams.Elder := 1
			}
		}
		
		; abyssal sockets 
		If (s.useAbyssalSockets) {
			RequestParams.sockets_a_min := s.abyssalSockets
			RequestParams.sockets_a_max := s.abyssalSockets
		}		
	}

	; prepend the item.subtype to match the options used on poe.trade
	;If (RegExMatch(Item.SubType, "i)Mace|Axe|Sword")) {
	; в русской версии ItemInfo тип Sceptre определяется корректно
	If (RegExMatch(Item.SubType, "i)Mace|Axe|Sword|Sceptre")) {
		If (Item.IsThreeSocket) {
			;If (RegExMatch(Item.BaseName, "i)Sceptre")) {			
			If (RegExMatch(Item.SubType, "i)Sceptre")) {
				Item.xtype := "Sceptre"
			} Else {
				Item.xtype := "One Hand " . Item.SubType	
			}
			
		}
		Else {
			Item.xtype := "Two Hand " . Item.SubType
		}
	}

	; Fix Body Armour subtype
	If (RegExMatch(Item.SubType, "i)BodyArmour")) {
		Item.xtype := "Body Armour"
	}

	; remove "Superior" from item name to exclude it from name search
	If (!IgnoreName) {
		RequestParams.name   := Trim(StrReplace(Name, "Superior", ""))
		If (Item.IsRelic) {
			RequestParams.rarity := "relic"
			Item.UsedInSearch.Rarity := "Relic"
		} Else If (Item.IsUnique) {
			RequestParams.rarity := "unique"
			;RequestParams.xbase  := Item.BaseName
			RequestParams.xbase  := Item.BaseName_En
		}
		Item.UsedInSearch.FullName := true
	} Else If (!Item.isUnique and AdvancedPriceCheckItem.mods.length() <= 0) {
		;isCraftingBase         := TradeFunc_CheckIfItemIsCraftingBase(Item.BaseName)
		isCraftingBase         := TradeFunc_CheckIfItemIsCraftingBase(Item.BaseName_En)
		hasHighestCraftingILvl := TradeFunc_CheckIfItemHasHighestCraftingLevel(Item.SubType, iLvl)
		; xtype = Item.SubType (Helmet)
		; xbase = Item.BaseName (Eternal Burgonet)

		;If desired crafting base and not isAdvancedPriceCheckRedirect
 		If (isCraftingBase and not Enchantment.Length() and not Corruption.Length() and not isAdvancedPriceCheckRedirect) { 
			;RequestParams.xbase := Item.BaseName
			RequestParams.xbase := Item.BaseName_En
			;Item.UsedInSearch.ItemBase := Item.BaseName
			Item.UsedInSearch.ItemBaseRu := Item.BaseName
			Item.UsedInSearch.ItemBase := Item.BaseName_En
			; If highest item level needed for crafting
			If (hasHighestCraftingILvl) {
				RequestParams.ilvl_min := hasHighestCraftingILvl
				Item.UsedInSearch.iLvl.min := hasHighestCraftingILvl
			}
		} Else If (Enchantment.param and not isAdvancedPriceCheckRedirect) {
			modParam := new _ParamMod()
			modParam.mod_name := Enchantment.param
			modParam.mod_min  := Enchantment.min
			modParam.mod_max  := Enchantment.max
			RequestParams.modGroups[1].AddMod(modParam)
			Item.UsedInSearch.Enchantment := true
		} 		
		Else If (Enchantment.Length() and not isAdvancedPriceCheckRedirect) {		
			For key, val in Enchantment {
				If (val.param) {
					modParam := new _ParamMod()
					modParam.mod_name := val.param
					modParam.mod_min  := val.min
					modParam.mod_max  := val.max
					RequestParams.modGroups[key].AddMod(modParam)
					Item.UsedInSearch.Enchantment := true
				}			
			}	
		} 
		Else If (Corruption.Length() and not isAdvancedPriceCheckRedirect) {
			For key, val in Corruption {
				If (val.param) {
					modParam := new _ParamMod()
					modParam.mod_name := val.param
					modParam.mod_min  := (val.min) ? val.min : ""
					RequestParams.modGroups[key].AddMod(modParam)
					Item.UsedInSearch.CorruptedMod := true		
				}			
			}	
		} Else {
			RequestParams.xtype := (Item.xtype) ? Item.xtype : Item.SubType
			If (not Item.IsBeast) {
				Item.UsedInSearch.Type := (Item.xtype) ? Item.xtype : Item.SubType
			}
		}
		
		If (Item.IsShaperBase) {
			RequestParams.Shaper := 1
			Item.UsedInSearch.specialBase := "Shaper"
			Item.UsedInSearch.specialBaseRu := "Создателя"
		} Else {		
			RequestParams.Shaper := 0
		} 
		
		If (Item.IsElderBase) {
			RequestParams.Elder := 1
			Item.UsedInSearch.specialBase := "Elder"
			Item.UsedInSearch.specialBaseRu := "Древнего"
		} Else {			
			RequestParams.Elder := 0
		}
	} Else {
		RequestParams.xtype := (Item.xtype) ? Item.xtype : Item.SubType
		If (not Item.IsBeast) {
			Item.UsedInSearch.Type := (Item.xtype) ? Item.GripType . " " . Item.SubType : Item.SubType	
		}
	}
	

	;handle abyssal sockets for the default search
	If (AdvancedPriceCheckItem.mods.length() <= 0) {
		If (Item.AbyssalSockets > 0) {
			RequestParams.sockets_a_min := Item.AbyssalSockets
			RequestParams.sockets_a_max := Item.AbyssalSockets
			Item.UsedInSearch.AbyssalSockets := (Item.AbyssalSockets > 0) ? Item.AbyssalSockets : ""
		}	
	}

	; make sure to not look for unique items when searching rare/white/magic items
	If (!Item.IsUnique) {
		RequestParams.rarity := "non_unique"
	}
	
	; handle beasts
	If (Item.IsBeast) {
		If (!Item.IsUnique) {
			RequestParams.Name := ""
		}
		
		RequestParams.xtype := Item.BaseType
		If (not isAdvancedPriceCheckRedirect) {
			Item.UsedInSearch.Type := Item.BaseType ", " Item.BeastData.Genus
		}
		
		/*
			add genus
			*/		
		If (not isAdvancedPriceCheckRedirect) {
			modParam := new _ParamMod()
			modParam.mod_name := TradeFunc_FindInModGroup(TradeGlobals.Get("ModsData")["bestiary"], Item.BeastData.GenusMod)
			modParam.mod_min  := ""
			RequestParams.modGroups[1].AddMod(modParam)	
		}

		; legendary beasts:
		; Farric Wolf Alpha, Fenumal Scorpion, Fenumal Plaqued Arachnid, Farric Frost Hellion Alpha,  Farric Lynx ALpha, Saqawine Vulture,
		; Craicic Chimeral, Saqawine Cobra, Craicic Maw, Farric Ape, Farric Magma Hound, Craicic Vassal, Farric Pit Hound, Craicic Squid,  
		; Farric Taurus, Fenumal Scrabbler, Farric Goliath, Fenumal Queen, Saqawine Blood Viper, Fenumal Devourer, Farric Ursa, Fenumal Widow, 
		; Farric Gargantuan, Farric Chieftain, Farric Ape, Farrci Flame Hellion Alpha, Farrci Goatman, Craicic Watcher, Saqawine Retch, 
		; Saqawine Chimeral, Craicic Shield Crab, Craicic Sand Spitter, Craicic Savage Crab, Saqawine Rhoa
		
		; portal beasts:
		; Farric Tiger Alpha, Craicic Spider Crab, Fenumal Hybrid Arachnid, Saqawine Rhex
		
		; aspect beasts:
		; "Farrul, First of the Plains", "Craiceann, First of the Deep", "Fenumus, First of the Night", "Saqawal, First of the Sky"
		/*
			add beast name and base/subtype
			*/
		skipBeastMods := false
		If (Item.BeastData.IsLegendaryBeast or Item.BeastData.IsPortalBeast) {
			RequestParams.Name := Item.BeastData.BeastBase
			Item.UsedInSearch.BeastBase := true
			skipBeastMods := true			
		}	
		If (Item.BeastData.IsAspectBeast) {
			RequestParams.Name := Item.BeastData.BeastName
			Item.UsedInSearch.FullName := true
			skipBeastMods := true
		}
		
		/* 
			add beastiary mods
			*/
		If (not isAdvancedPriceCheckRedirect and not skipBeastMods) {			
			If (not isAdvancedPriceCheck) {		
				
				useOnlyThisBeastMod := ""
				For key, imod in preparedItem.mods {
					; http://poecraft.com/bestiary
					; craicis presence is valuable, requires ilvl 70+
					If (RegExMatch(imod.param, "i)(Craicic Presence)", match) and Item.Level >= 70) {
						useOnlyThisBeastMod := match1
					}					
					
					; crimson flock, putrid flight, unstable swarm 80+
					If (RegExMatch(imod.param, "i)(Crimson Flock|Putrid Flight|Unstable Swarm)", match) and Item.Level >= 80) {
						useOnlyThisBeastMod := match1
					}
				}
				
				For key, imod in preparedItem.mods {
					If (imod.param) {	; exists on poe.trade
						If ((StrLen(useOnlyThisBeastMod) and RegExMatch(imod.param, "i)" useOnlyThisBeastMod "")) or (not StrLen(useOnlyThisBeastMod))) {								
							modParam := new _ParamMod()
							modParam.mod_name := imod.param
							modParam.mod_min  := ""
							RequestParams.modGroups[1].AddMod(modParam)
							
							If (StrLen(useOnlyThisBeastMod)) {
								RequestParams.ilvl_min := 70
							}
						}
					}				
				}
			}			
		}
	}
	
	; league stones
	If (Item.IsLeagueStone) {
		; only manually add these mods if they don't already exist (created by advanced search)
		temp_name := "(leaguestone) Can only be used in Areas with Monster Level # or below"
		If (not TradeFunc_FindModInRequestParams(RequestParams, temp_name)) {
			; mod does not exist on poe.trade: "Can only be used in Areas with Monster Level # or above"
			If (Item.AreaMonsterLevelReq.logicalOperator = "above") {
				; do nothing, min (above) requirement has no correlation with item level, only with the mods spawned on the stone
				; stones with the same name should have the same "above" requirement so we ignore it
			} Else If (Item.AreaMonsterLevelReq.logicalOperator = "between") {
				; stones with the same name should have the same "above" requirement so we ignore it
				; the upper limit value ("below") depends on the item level, it should be limit = (ilvl + 11)
				; so we could use the max item level parameter with some buffer (not sure about the + 11).
				RequestParams.ilvl_max := Item.AreaMonsterLevelReq.lvl_upper + 15
				Item.UsedInSearch.iLvl.min := RequestParams.ilvl_max
			} Else {
				modParam := new _ParamMod()
				modParam.mod_name := temp_name

				If (Item.AreaMonsterLevelReq.lvl) {
					modParam.mod_min  := Item.AreaMonsterLevelReq.lvl_upper - 10
					modParam.mod_max  := Item.AreaMonsterLevelReq.lvl_upper
					RequestParams.modGroups[1].AddMod(modParam)
					Item.UsedInSearch.AreaMonsterLvl := "Area Level: " modParam.mod_min " - " modParam.mod_max
				} Else {
					; add second mod group to exclude area restrictions
					RequestParams.AddModGroup("Not", 1)
					RequestParams.modGroups[RequestParams.modGroups.MaxIndex()].AddMod(modParam)
					Item.UsedInSearch.AreaMonsterLvl := "Area Level: no restriction"
				}
			}
		}

		If (Item.Charges.max > 1) {
			temp_name := "(leaguestone) Currently has # Charges"
			If (not TradeFunc_FindModInRequestParams(RequestParams, temp_name)) {
				modParam := new _ParamMod()
				modParam.mod_name := "(leaguestone) Currently has # Charges"
				modParam.mod_min  := Item.Charges.Current
				modParam.mod_max  := Item.Charges.Current
				RequestParams.modGroups[1].AddMod(modParam)
				Item.UsedInSearch.Charges:= "Charges: " Item.Charges.Current
			}
		}
	}

	; don't overwrite advancedItemPriceChecks decision to include/exclude sockets/links
	If (not isAdvancedPriceCheckRedirect) {
		; handle item sockets
		; maybe don't use this for unique-items as default
		If (ItemData.Sockets >= 5 and not Item.IsUnique) {
			RequestParams.sockets_min := ItemData.Sockets
			Item.UsedInSearch.Sockets := ItemData.Sockets
		}
		If (ItemData.Sockets >= 6) {
			RequestParams.sockets_min := ItemData.Sockets
			Item.UsedInSearch.Sockets := ItemData.Sockets
		}
		; handle item links
		If (ItemData.Links >= 5) {
			RequestParams.link_min := ItemData.Links
			Item.UsedInSearch.Links := ItemData.Links
		}
	}

	; handle corruption
	If (Item.IsCorrupted and TradeOpts.CorruptedOverride and not Item.IsDivinationCard) {
		If (TradeOpts.Corrupted = "Either") {
			RequestParams.corrupted := ""
			;Item.UsedInSearch.Corruption := "Either"
			; возможно не корректный перевод
			Item.UsedInSearch.Corruption := "другой"
		}
		Else If (TradeOpts.Corrupted = "Yes") {
			RequestParams.corrupted := "1"
			;Item.UsedInSearch.Corruption := "Yes"
			Item.UsedInSearch.Corruption := "Да"
		}
		Else If (TradeOpts.Corrupted = "No") {
			RequestParams.corrupted := "0"
			;Item.UsedInSearch.Corruption := "No"
			Item.UsedInSearch.Corruption := "Нет"
		}
	}
	Else If (Item.IsCorrupted and not Item.IsDivinationCard) {
		RequestParams.corrupted := "1"
		;Item.UsedInSearch.Corruption := "Yes"
		Item.UsedInSearch.Corruption := "Да"
	}
	Else If (TradeOpts.Corrupted = "Either" and TradeOpts.CorruptedOverride) {
		RequestParams.corrupted := ""
		;Item.UsedInSearch.Corruption := "Either"
		; возможно не корректный перевод
		Item.UsedInSearch.Corruption := "другой"
	}
	Else {
		RequestParams.corrupted := "0"
		;Item.UsedInSearch.Corruption := "No"
		Item.UsedInSearch.Corruption := "Нет"
	}

	If (Item.IsMap) {
		; add Item.subtype to make sure to only find maps
		;RegExMatch(Item.Name, "i)The Beachhead.*", isHarbingerMap)
		RegExMatch(Item.Name_En, "i)The Beachhead.*", isHarbingerMap)
		RegExMatch(Item.SubType, "i)Unknown Map", isUnknownMap)
		;isElderMap := RegExMatch(Item.Name, ".*?Elder .*") and Item.MapTier = 16
		isElderMap := RegExMatch(Item.Name_En, ".*?Elder .*") and Item.MapTier = 16
		
		mapTypes := TradeGlobals.Get("ItemTypeList")["Map"]
		typeFound := TradeUtils.IsInArray(Item.SubType, mapTypes)
		
		If (not isHarbingerMap and not isUnknownMap and typeFound) {
			RequestParams.xbase := Item.SubType
			RequestParams.xtype := ""		
			If (isElderMap) {
				RequestParams.name := "Elder"
			}
		} Else {
			RequestParams.xbase := ""
			RequestParams.xtype := "Map"
		}
		
		If (not Item.IsUnique) {
			If (StrLen(isHarbingerMap)) {
				; Beachhead Map workaround (unique but not flagged as such on poe.trade)
				;RequestParams.name := Item.Name				
				RequestParams.name := Item.Name_En
			} Else If (not typeFound) {
				;RequestParams.name := Item.Name
				RequestParams.name := Item.Name_En
				RequestParams.level_min := Item.MapTier
				RequestParams.level_max := Item.MapTier
			} Else If (not isElderMap) {
				RequestParams.name := ""
			}
		}
		
		If (StrLen(isUnknownMap)) {
			;RequestParams.xbase := Item.BaseName
			RequestParams.xbase := Item.BaseName_En
			;Item.UsedInSearch.type := Item.BaseName
			Item.UsedInSearch.type := Item.BaseName_En
			Item.UsedInSearch.typeRu := Item.BaseName
		}
	}

	; handle gems
	If (Item.IsGem) {
		RequestParams.xtype := Item.BaseType
		
		foundOnPoeTrade := false
		;_xbase := TradeFunc_CompareGemNames(Trim(RegExReplace(Item.Name, "i)support|superior")), foundOnPoeTrade)
		_xbase := TradeFunc_CompareGemNames(Trim(RegExReplace(Item.Name_En, "i)support|superior")), foundOnPoeTrade)
		If (not foundOnPoeTrade) {
			;RequestParams.name := Trim(RegExReplace(Item.Name, "i)support|superior"))
			RequestParams.name := Trim(RegExReplace(Item.Name_En, "i)support|superior"))
		} Else {
			RequestParams.xbase := _xbase
			RequestParams.name := ""	
		}
		
		If (TradeOpts.GemQualityRange > 0) {
			RequestParams.q_min := Item.Quality - TradeOpts.GemQualityRange
			RequestParams.q_max := Item.Quality + TradeOpts.GemQualityRange
		}
		Else {
			RequestParams.q_min := Item.Quality
		}
		; match exact gem level if enhance, empower or enlighten
		If (InStr(Name, "Empower") or InStr(Name, "Enlighten") or InStr(Name, "Enhance")) {
			RequestParams.level_min := Item.Level
			RequestParams.level_max := Item.Level
		}
		Else If (TradeOpts.GemLevelRange > 0 and Item.Level >= TradeOpts.GemLevel) {
			RequestParams.level_min := Item.Level - TradeOpts.GemLevelRange
			RequestParams.level_max := Item.Level + TradeOpts.GemLevelRange
		}
		Else If (Item.Level >= TradeOpts.GemLevel) {
			RequestParams.level_min := Item.Level
		}
		
		; experiment with values and maybe add an option
		;If ((RegExMatch(Item.Name, "i)Empower|Enhance|Enlighten") or Item.Level >= 19) and TradeOpts.UseGemXP) {
		If ((RegExMatch(Item.Name_En, "i)Empower|Enhance|Enlighten") or Item.Level >= 19) and TradeOpts.UseGemXP) {
			If (Item.Experience >= TradeOpts.GemXPThreshold) {			
				RequestParams.progress_min := Item.Experience
				RequestParams.progress_max := ""
				Item.UsedInSearch.ItemXP := Item.Experience
			}
		}	
	}

	; handle divination cards and jewels
	If (Item.IsDivinationCard or Item.IsJewel) {
		RequestParams.xtype := Item.BaseType
		If (Item.IsJewel and Item.IsUnique) {
			RequestParams.xbase := Item.SubType
		}
		; TODO: add request param (not supported yet)
		If (Item.IsAbyssJewel) {
			;RequestParams. := 1
			;Item.UsedInSearch.abyssJewel := 1 
		}
	}

	; predicted pricing (poeprices.info - machine learning)
	If (Item.RarityLevel > 2 and Item.RarityLevel < 4 and not (Item.IsCurrency or Item.IsDivinationCard or Item.IsEssence or Item.IsProphecy or Item.IsMap or Item.IsMapFragment or Item.IsGem or Item.IsBeast)) {		
		If ((Item.IsJewel or Item.IsFlask or Item.IsLeaguestone)) {
			If (Item.RarityLevel = 2) {
				itemEligibleForPredictedPricing := false	
			} Else {
				itemEligibleForPredictedPricing := true
			}
		}
		Else If (not (Item.RarityLevel = 3 and Item.IsUnidentified)) { ; filter out unid rare items
			itemEligibleForPredictedPricing := true

		}		
	}
	
	; show item age
	If (isItemAgeRequest) {
		;RequestParams.name        := Item.Name
		; если имя не конвертируется в английское (для редких предметов и не только), то будем использовать базовое имя
		; данный способ не совсем корректен, т.к. возможен случай продажи двух редких предметов с одинаковой базой
		RequestParams.name        := (RegExMatch(Item.Name_En, "[а-яА-ЯёЁ]+")) ? Item.BaseName_En : Item.Name_En
		RequestParams.has_buyout  := ""
		RequestParams.seller      := TradeOpts.AccountName
		RequestParams.q_min       := Item.Quality
		RequestParams.q_max       := Item.Quality
		RequestParams.rarity      := Item.IsRelic ? "relic" : Item.Rarity
		RequestParams.link_min    := ItemData.Links ? ItemData.Links : ""
		RequestParams.link_max    := ItemData.Links ? ItemData.Links : ""
		RequestParams.sockets_min := ItemData.Sockets ? ItemData.Sockets : ""
		RequestParams.sockets_max := ItemData.Sockets ? ItemData.Sockets : ""
		RequestParams.identified  := (!Item.IsUnidentified) ? "1" : "0"
		RequestParams.corrupted   := (Item.IsCorrupted) ? "1" : "0"
		RequestParams.enchanted   := (Enchantment.Length()) ? "1" : "0"
		; change values a bit to accommodate for rounding differences
		RequestParams.armour_min  := Stats.Defense.TotalArmour.Value - 2
		RequestParams.armour_max  := Stats.Defense.TotalArmour.Value + 2
		RequestParams.evasion_min := Stats.Defense.TotalEvasion.Value - 2
		RequestParams.evasion_max := Stats.Defense.TotalEvasion.Value + 2
		RequestParams.shield_min  := Stats.Defense.TotalEnergyShield.Value - 2
		RequestParams.shield_max  := Stats.Defense.TotalEnergyShield.Value + 2

		If (Item.IsGem) {
			RequestParams.level_min := Item.Level
			RequestParams.level_max := Item.Level
		}
		Else If (Item.Level and not Item.IsDivinationCard and not Item.IsCurrency) {
			RequestParams.ilvl_min := Item.Level
			RequestParams.ilvl_max := Item.Level
		}
	}
	
		
	/*
		parameter fixes
	*/
	If (StrLen(RequestParams.xtype) and StrLen(RequestParams.xbase)) {
		; Some type and base combinations on poe.trade are different than the ones in-game (Tyrant's Sekhem for example)
		; If we have the base we don't need the type though.
		RequestParams.xtype := ""
	}

	If (openSearchInBrowser) {
		If (!TradeOpts.BuyoutOnly) {
			RequestParams.has_buyout := ""
		}
	}
	
	; для самоцветов, если имя не сконвертировалось и если не задано игнорирование имени, то отправляем базовое английское имя
	If (Item.IsJewel and not Item.IsUnique and not IgnoreName) {
		RequestParams.name := (RegExMatch(Item.Name_En, "[а-яА-ЯёЁ]+")) ? Item.BaseName_En : Item.Name_En
	}
	
	If (TradeOpts.Debug) {
		;console.log(RequestParams)
		console.log(RequestParams)
	}
			
	; исключаем предметы поиск для которых будет некорректен
	If (((RegExMatch(RequestParams.name, "[а-яА-ЯёЁ]+") or RegExMatch(RequestParams.xbase, "[а-яА-ЯёЁ]+") or not (StrLen(RequestParams.name) or StrLen(RequestParams.xtype) or StrLen(RequestParams.xbase))) and not isAdvancedPriceCheck) or (isAdvancedPriceCheck and Item.IsUnique and not uniqueWithVariableMods)) {
		ShowToolTip("Поиск недоступен для этого предмета.")
		return
	}
	
	Payload := RequestParams.ToPayload()

	/*
		Create second payload for exact currency search (backup search if no results were found with primary currency)
		*/		
	If (not Item.IsCurrency and TradeOpts.ExactCurrencySearch) {
		Payload_alt := Payload
		Item.UsedInSearch.ExactCurrency := true
		
		ExactCurrencySearchOptions := TradeGlobals.Get("ExactCurrencySearchOptions").poetrade
		If (buyout_currency := ExactCurrencySearchOptions[TradeOpts.CurrencySearchHave]) {
			Payload .= "&buyout_currency=" TradeUtils.UriEncode(buyout_currency)
		}
		If (buyout_currency := ExactCurrencySearchOptions[TradeOpts.CurrencySearchHave2]) {
			Payload_alt .= "&buyout_currency=" TradeUtils.UriEncode(buyout_currency)
		}
	}	
	
	/*
		decide how to handle the request (open in browser on a specific site or make a POST/GET request to parse the results)
		*/	
	If (openSearchInBrowser) {
		;ShowToolTip("Opening search in your browser... ")
		ShowToolTip("Открытие страницы поиска в браузере... ")
	} Else If (not (TradeOpts.UsePredictedItemPricing and itemEligibleForPredictedPricing)) {
		;ShowToolTip("Requesting search results... ")
		ShowToolTip("Запрос результатов поиска... ")
	}

	ParsingError	:= ""
	currencyUrl	:= ""
	;If (Item.IsCurrency and !Item.IsEssence and TradeFunc_CurrencyFoundOnCurrencySearch(Item.Name)) {
	If (Item.IsCurrency and not Item.IsEssence and TradeFunc_CurrencyFoundOnCurrencySearch(Item.Name_En)) {
		If (!TradeOpts.AlternativeCurrencySearch) {
			;Html := TradeFunc_DoCurrencyRequest(Item.Name, openSearchInBrowser, 0, currencyUrl, error)
			Html := TradeFunc_DoCurrencyRequest(Item.Name_En, openSearchInBrowser, 0, currencyUrl, error)
			If (error) {
				ParsingError := Html
			}
		}
		Else {
			; Update currency data if last update is older than 30min
			last := TradeGlobals.Get("LastAltCurrencyUpdate")
			diff  := A_NowUTC
			EnvSub, diff, %last%, Seconds
			If (diff > 1800) {
				GoSub, ReadPoeNinjaCurrencyData
			}
		}
	}
	Else If (not openSearchInBrowser and TradeOpts.UsePredictedItemPricing and itemEligibleForPredictedPricing and not isAdvancedPriceCheckRedirect and not isItemAgeRequest) {
		requestCurl := ""
		Html := TradeFunc_DoPoePricesRequest(ItemData.FullText, requestCurl)
	}
	Else If (not openSearchInBrowser) {
		Html := TradeFunc_DoPostRequest(Payload, openSearchInBrowser)
	}

	If (openSearchInBrowser) {
		If (TradeOpts.PoENinjaSearch and (url := TradeFunc_GetPoENinjaItemUrl(TradeOpts.SearchLeague, Item))) {
			TradeFunc_OpenUrlInBrowser(url)
			If (not TradeOpts.CopyUrlToClipboard) {
				SetClipboardContents("")	
			}
		} Else {
			;If (Item.IsCurrency and !Item.IsEssence and TradeFunc_CurrencyFoundOnCurrencySearch(Item.Name)) {
			If (Item.IsCurrency and !Item.IsEssence and TradeFunc_CurrencyFoundOnCurrencySearch(Item.Name_En)) {
				ParsedUrl1 := currencyUrl
			}
			Else {
				; using GET request instead of preventing the POST request redirect and parsing the url
				parsedUrl1 := "http://poe.trade/search?" Payload
				; redirect was prevented to get the url and open the search on poe.trade instead
				;RegExMatch(Html, "i)href=""(https?:\/\/.*?)""", ParsedUrl)
			}

			If (StrLen(ParsingError)) {
				ShowToolTip("")
				ShowToolTip(ParsingError)
			} Else {
				TradeFunc_OpenUrlInBrowser(ParsedUrl1)
				If (not TradeOpts.CopyUrlToClipboard) {
					SetClipboardContents("")	
				}
			}
		}
	}
	;Else If (Item.isCurrency and !Item.IsEssence and TradeFunc_CurrencyFoundOnCurrencySearch(Item.Name)) {
	Else If (Item.isCurrency and !Item.IsEssence and TradeFunc_CurrencyFoundOnCurrencySearch(Item.Name_En)) {
		; Default currency search
		If (!TradeOpts.AlternativeCurrencySearch) {
			ParsedData := TradeFunc_ParseCurrencyHtml(Html, Payload, ParsingError)
		}
		; Alternative currency search (poeninja)
		Else {
			;ParsedData := TradeFunc_ParseAlternativeCurrencySearch(Item.Name, Payload)
			ParsedData := TradeFunc_ParseAlternativeCurrencySearch(Item.Name_En, Payload)
		}

		SetClipboardContents("")
		ShowToolTip("")
		ShowToolTip(ParsedData)
	}
	Else If (TradeOpts.UsePredictedItemPricing and itemEligibleForPredictedPricing and not isAdvancedPriceCheckRedirect and not isItemAgeRequest) {		
		SetClipboardContents("")
	
		If (TradeFunc_ParsePoePricesInfoErrorCode(Html, requestCurl)) {
			If (TradeOpts.UsePredictedItemPricingGui) {
				TradeFunc_ShowPredictedPricingFeedbackUI(Html)
			} Else {
				ParsedData := TradeFunc_ParsePoePricesInfoData(Html)
				ShowToolTip("")
				ShowToolTip(ParsedData)
			}			
		}
	}
	Else {
		; Check item age
		If (isItemAgeRequest) {
			;Item.UsedInSearch.SearchType := "Item Age Search"
			;Item.UsedInSearch.SearchType := "Поиск Возраста предмета"
			Item.UsedInSearch.SearchType := "Поиск: Возраст - как долго предмет находится в продаже"
		}
		Else If (isAdvancedPriceCheckRedirect) {
			;Item.UsedInSearch.SearchType := "Advanced"
			Item.UsedInSearch.SearchType := "Расширенном"
		}
		Else {
			;Item.UsedInSearch.SearchType := "Default"
			Item.UsedInSearch.SearchType := "По умолчанию"
		}
		
		; add second request for payload_alt (exact currency search fallback request)		
		searchResults := TradeFunc_ParseHtmlToObj(Html, Payload, iLvl, Enchantment, isItemAgeRequest, isAdvancedPriceCheckRedirect)
		If (not searchResults.results and StrLen(Payload_alt)) {
			Html := TradeFunc_DoPostRequest(Payload_alt, openSearchInBrowser)
			ParsedData := TradeFunc_ParseHtml(Html, Payload_alt, iLvl, Enchantment, isItemAgeRequest, isAdvancedPriceCheckRedirect)
		}
		Else {
			ParsedData := TradeFunc_ParseHtml(Html, Payload, iLvl, Enchantment, isItemAgeRequest, isAdvancedPriceCheckRedirect)	
		}

		SetClipboardContents("")
		ShowToolTip("")
		ShowToolTip(ParsedData)
	}

	TradeGlobals.Set("AdvancedPriceCheckItem", {})
}

TradeFunc_GetPoENinjaItemUrl(league, item) {	
	url := "https://poe.ninja/"

	If (league = "tmpstandard") {
		url .= "challenge/"
	} Else If (league = "tmphardcore") {
		url .= "challengehc/"
	} Else If (league = "standard") {
		url .= "standard/"
	} Else If (league = "hardcore") {
		url .= "hardcore/"
	} Else If (RegExMatch(league, "i)hc") and RegExMatch(league, "i)event")) {
		url .= "eventhc/"
	} Else If (RegExMatch(league, "i)event")) {
		url .= "event/"
	}
	
	If (Item.hasImplicit) {
		Enchantment := TradeFunc_GetEnchantment(Item, Item.SubType)
	}
	
	url_suffix := ""
	If (item.IsDivinationCard) {
		url_suffix := "divinationcards"
	} Else If (item.IsProphecy) {
		url_suffix := "prophecies"
	} Else If (item.IsFragment) {
		;url_suffix := "fragments"	; currently not supported (no filter)
	} Else If (item.IsGem) {
		;url_suffix := "skill-gems"	; supported but using poe.trade for this may be the better choice
	} Else If (item.IsEssence) {
		url_suffix := "essences"
	} Else If (item.SubType = "Helmet" and Enchantment[1].name) {
		url_suffix := "helmet-enchants"
	} Else If (item.IsUnique) {
		If (item.IsMap) {
			url_suffix := "unique-maps"
		} Else If (item.IsJewel) {
			url_suffix := "unique-jewels"
		} Else If (item.IsFlask) {
			url_suffix := "unique-flasks"
		} Else If (item.IsWeapon or item.IsQuiver) {
			url_suffix := "unique-weapons"
		} Else If (item.IsArmour) {
			url_suffix := "unique-armours"
		} Else If (item.IsRing or Item.IsBelt or Item.IsAmulet) {
			url_suffix := "unique-accessories"
		}
	} Else If (item.IsMap) {
		url_suffix := "maps"
	}
	
	; filters
	url_params := "?"
	url_param_1 := "name="
	url_param_2 := "&tier="
	
	If (item.IsMap) {
		;url_param_arg_1 := TradeUtils.UriEncode(Item.BaseName)
		url_param_arg_1 := TradeUtils.UriEncode(Item.BaseName_En)
		url_param_arg_2 := TradeUtils.UriEncode(Item.MapTier)
		url_params .= url_param_1 . url_param_arg_1 . url_param_2 . url_param_arg_2
	}
	Else If (item.SubType = "Helmet" and Enchantment.Length()) {
		url_param_arg_1 := TradeUtils.UriEncode(Enchantment[1].name)
		url_params .= url_param_1 . url_param_arg_1
	}
	Else {
		;url_param_arg_1 := TradeUtils.UriEncode(Item.Name)
		url_param_arg_1 := TradeUtils.UriEncode(Item.Name_En)
		url_params .= url_param_1 . url_param_arg_1
	}
	
	If (url_suffix) {
		Return url . url_suffix . url_params
	} Else {
		Return false
	}
}

TradeFunc_AddCustomModsToLeaguestone(ItemAffixes, Charges) {
	If (Item.AreaMonsterLevelReq.lvl) {
		ItemAffixes .= "`nCan only be used in Areas with Monster Level " Item.AreaMonsterLevelReq.lvl " or below"
	}

	If (Charges.max > 1) {
		ItemAffixes .= "`nCurrently has " Item.Charges.Current " Charges"
	}

	return ItemAffixes
}

; parse items defense stats
TradeFunc_ParseItemDefenseStats(stats, mods){
	Global ItemData
	iStats := {}
	debugOutput := ""

	;RegExMatch(stats, "i)chance to block ?:.*?(\d+)", Block)
	RegExMatch(stats, "i)Шанс заблокировать удар ?:.*?(\d+)", Block)
	;RegExMatch(stats, "i)armour ?:.*?(\d+)"         , Armour)
	RegExMatch(stats, "i)Броня ?:.*?(\d+)"         , Armour)
	;RegExMatch(stats, "i)energy shield ?:.*?(\d+)"  , EnergyShield)
	RegExMatch(stats, "i)Энерг. щит ?:.*?(\d+)"  , EnergyShield)
	;RegExMatch(stats, "i)evasion rating ?:.*?(\d+)" , Evasion)
	RegExMatch(stats, "i)Уклонение ?:.*?(\d+)" , Evasion)
	;RegExMatch(stats, "i)quality ?:.*?(\d+)"        , Quality)
	RegExMatch(stats, "i)Качество ?:.*?(\d+)"        , Quality)

	;RegExMatch(ItemData.Affixes, "i)(\d+).*maximum.*?Energy Shield"  , affixFlatES)
	RegExMatch(ItemData.Affixes, "i)(\d+).*к максимуму.*?энергетического щита"  , affixFlatES)
	;RegExMatch(ItemData.Affixes, "i)(\d+).*maximum.*?Armour"         , affixFlatAR)
	;RegExMatch(ItemData.Affixes, "i)(\d+).*к.*?броне"         , affixFlatAR)
	; исключим частный случай
	If (not RegExMatch(ItemData.Affixes, "i)(\d+).*к.*?броне приспешников")) {
		RegExMatch(ItemData.Affixes, "i)(\d+).*к.*?броне", affixFlatAR)
	}
	;RegExMatch(ItemData.Affixes, "i)(\d+).*maximum.*?Evasion"        , affixFlatEV)
	RegExMatch(ItemData.Affixes, "i)(\d+).*к.*?уклонению"        , affixFlatEV)
	;RegExMatch(ItemData.Affixes, "i)(\d+).*increased.*?Energy Shield", affixPercentES)
	RegExMatch(ItemData.Affixes, "i)(\d+).*(увеличение|повышени).*?энергетического щита", affixPercentES)
	;RegExMatch(ItemData.Affixes, "i)(\d+).*increased.*?Evasion"      , affixPercentEV)
	RegExMatch(ItemData.Affixes, "i)(\d+).*(увеличение|повышени).*?уклонения"      , affixPercentEV)
	;RegExMatch(ItemData.Affixes, "i)(\d+).*increased.*?Armour"       , affixPercentAR)
	RegExMatch(ItemData.Affixes, "i)(\d+).*(увеличение|повышени).*?брони"       , affixPercentAR)

	; calculate items base defense stats
	baseES := TradeFunc_CalculateBase(EnergyShield1, affixPercentES1, Quality1, affixFlatES1)
	baseAR := TradeFunc_CalculateBase(Armour1      , affixPercentAR1, Quality1, affixFlatAR1)
	baseEV := TradeFunc_CalculateBase(Evasion1     , affixPercentEV1, Quality1, affixFlatEV1)
	
	; calculate items Q20 total defense stats
	Armour       := TradeFunc_CalculateQ20(baseAR, affixFlatAR1, affixPercentAR1)
	EnergyShield := TradeFunc_CalculateQ20(baseES, affixFlatES1, affixPercentES1)
	Evasion      := TradeFunc_CalculateQ20(baseEV, affixFlatEV1, affixPercentEV1)

	; calculate items Q20 defense stat min/max values
	Affixes := StrSplit(ItemData.Affixes, "`n")

	For key, mod in mods.mods {
		For i, affix in Affixes {
			;affix := RegExReplace(affix, "i)(\d+.?\d+?)", "#")
			affix := RegExReplace(affix, "((\d+){1,3})", "#")
			affix := RegExReplace(affix, "i)# %", "#%")
			affix := Trim(RegExReplace(affix, "\s", " "))
			name :=  Trim(mod.name)			

			; конвертируем названия аффиксов в английские варианты
			affix := AdpRu_ConvertRuOneModToEn(affix)

			If ( affix = name ){
				; ignore mods like " ... per X dexterity"
				If (RegExMatch(affix, "i) per ")) {
				;If (RegExMatch(affix, "i) за ")) {
					continue
				}
				If (RegExMatch(affix, "i)#.*to maximum.*?Energy Shield"  , affixFlatES)) {
					If (not mod.isVariable) {
						min_affixFlatES    := mod.values[1]
						max_affixFlatES    := mod.values[1]
					}
					Else {
						min_affixFlatES    := mod.ranges[1][1]
						max_affixFlatES    := mod.ranges[1][2]
					}
					debugOutput .= affix "`nmax es : " min_affixFlatES " - " max_affixFlatES "`n`n"
				}
				If (RegExMatch(affix, "i)#.*to maximum.*?Armour"         , affixFlatAR)) {
					If (not mod.isVariable) {
						min_affixFlatAR    := mod.values[1]
						max_affixFlatAR    := mod.values[1]
					}
					Else {
						min_affixFlatAR    := mod.ranges[1][1]
						max_affixFlatAR    := mod.ranges[1][2]
					}
					debugOutput .= affix "`nmax ar : " min_affixFlatAR " - " max_affixFlatAR "`n`n"
				}
				If (RegExMatch(affix, "i)#.*to maximum.*?Evasion"        , affixFlatEV)) {
					If (not mod.isVariable) {
						min_affixFlatEV    := mod.values[1]
						max_affixFlatEV    := mod.values[1]
					}
					Else {
						min_affixFlatEV    := mod.ranges[1][1]
						max_affixFlatEV    := mod.ranges[1][2]
					}
					debugOutput .= affix "`nmax ev : " min_affixFlatEV " - " max_affixFlatEV "`n`n"
				}
				If (RegExMatch(affix, "i)#.*increased.*?Energy Shield"   , affixPercentES)) {
					If (not mod.isVariable) {
						min_affixPercentES := mod.values[1]
						max_affixPercentES := mod.values[1]
					}
					Else {
						min_affixPercentES := mod.ranges[1][1]
						max_affixPercentES := mod.ranges[1][2]
					}
					debugOutput .= affix "`ninc es : " min_affixPercentES " - " max_affixPercentES "`n`n"
				}
				If (RegExMatch(affix, "i)#.*increased.*?Evasion"         , affixPercentEV)) {
					If (not mod.isVariable) {
						min_affixPercentEV := mod.values[1]
						max_affixPercentEV := mod.values[1]
					}
					Else {
						min_affixPercentEV := mod.ranges[1][1]
						max_affixPercentEV := mod.ranges[1][2]
					}
					debugOutput .= affix "`ninc ev : " min_affixPercentEV " - " max_affixPercentEV "`n`n"
				}
				If (RegExMatch(affix, "i)#.*increased.*?Armour"          , affixPercentAR)) {
					If (not mod.isVariable) {
						min_affixPercentAR := mod.values[1]
						max_affixPercentAR := mod.values[1]
					}
					Else {
						min_affixPercentAR := mod.ranges[1][1]
						max_affixPercentAR := mod.ranges[1][2]
					}
					debugOutput .= affix "`ninc ar : " min_affixPercentAR " - " max_affixPercentAR "`n`n"
				}
			}
		}
	}

	min_Armour       := Round(TradeFunc_CalculateQ20(baseAR, min_affixFlatAR, min_affixPercentAR))
	max_Armour       := Round(TradeFunc_CalculateQ20(baseAR, max_affixFlatAR, max_affixPercentAR))
	min_EnergyShield := Round(TradeFunc_CalculateQ20(baseES, min_affixFlatES, min_affixPercentES))
	max_EnergyShield := Round(TradeFunc_CalculateQ20(baseES, max_affixFlatES, max_affixPercentES))
	min_Evasion      := Round(TradeFunc_CalculateQ20(baseEV, min_affixFlatEV, min_affixPercentEV))
	max_Evasion      := Round(TradeFunc_CalculateQ20(baseEV, max_affixFlatEV, max_affixPercentEV))

	iStats.TotalBlock			:= {}
	iStats.TotalBlock.Value 		:= Block1
	iStats.TotalBlock.Name  		:= "Block Chance"
	iStats.TotalBlock.Name_Ru 		:= "Шанс блока"
	iStats.TotalArmour			:= {}
	iStats.TotalArmour.Value		:= Armour
	iStats.TotalArmour.Name		:= "Armour"
	iStats.TotalArmour.Name_Ru		:= "Броня"
	iStats.TotalArmour.Base		:= baseAR
	iStats.TotalArmour.min  		:= min_Armour
	iStats.TotalArmour.max  		:= max_Armour
	iStats.TotalEnergyShield		:= {}
	iStats.TotalEnergyShield.Value:= EnergyShield
	iStats.TotalEnergyShield.Name	:= "Energy Shield"
	iStats.TotalEnergyShield.Name_Ru	:= "Энерг. щит"
	iStats.TotalEnergyShield.Base	:= baseES
	iStats.TotalEnergyShield.min 	:= min_EnergyShield
	iStats.TotalEnergyShield.max	:= max_EnergyShield
	iStats.TotalEvasion			:= {}
	iStats.TotalEvasion.Value	:= Evasion
	iStats.TotalEvasion.Name		:= "Evasion Rating"
	iStats.TotalEvasion.Name_Ru		:= "Уклонение"
	iStats.TotalEvasion.Base		:= baseEV
	iStats.TotalEvasion.min		:= min_Evasion
	iStats.TotalEvasion.max		:= max_Evasion
	iStats.Quality				:= Quality1

	If (TradeOpts.Debug) {
		;console.log(output)
		console.log(debugOutput)
	}

	Return iStats
}

TradeFunc_CalculateBase(total, affixPercent, qualityPercent, affixFlat){
	SetFormat, FloatFast, 5.2
	If (total) {
		affixPercent  := (affixPercent) ? (affixPercent / 100) : 0
		affixFlat     := (affixFlat) ? affixFlat : 0
		qualityPercent:= (qualityPercent) ? (qualityPercent / 100) : 0
		base := Round((total / (1 + affixPercent + qualityPercent)) - affixFlat)
		Return base
	}
	return
}
TradeFunc_CalculateQ20(base, affixFlat, affixPercent){
	SetFormat, FloatFast, 5.2
	If (base) {
		affixPercent  := (affixPercent) ? (affixPercent / 100) : 0
		affixFlat     := (affixFlat) ? affixFlat : 0
		total := (base + affixFlat) * (1 + affixPercent + (20 / 100))
		Return total
	}
	return
}

; parse items dmg stats
TradeFunc_ParseItemOffenseStats(Stats, mods) {
	Global ItemData
	iStats := {}
	debugOutput :=
	
	nameRuToEn := {"физического":"Physical", "огня":"Fire", "холода":"Cold", "молнии":"Lightning", "хаосом":"Chaos"}

	;RegExMatch(ItemData.Stats, "i)Physical Damage ?:.*?(\d+)-(\d+)", match)
	RegExMatch(ItemData.Stats, "i)Физический урон ?:.*?(\d+)-(\d+)", match)
	physicalDamageLow := match1
	physicalDamageHi  := match2
	;RegExMatch(ItemData.Stats, "i)Attacks per Second ?: ?(\d+.?\d+)", match)
	RegExMatch(ItemData.Stats, "i)Атак в секунду ?: ?(\d+){1,3}", match)
	AttacksPerSecond := match1
	;RegExMatch(ItemData.Affixes, "i)(\d+).*increased.*?Physical Damage", match)
	RegExMatch(ItemData.Affixes, "i)(\d+).*увеличение.*?физического урона", match)
	affixPercentPhys := match1
	;RegExMatch(ItemData.Affixes, "i)Adds\D+(\d+)\D+(\d+).*Physical Damage", match)
	RegExMatch(ItemData.Affixes, "i)Добавляет\D+(\d+)\D+(\d+).*физического урона", match)
	affixFlatPhysLow := match1
	affixFlatPhysHi  := match2

	Affixes := StrSplit(ItemData.Affixes, "`n")
	For key, mod in mods.mods {
		For i, affix in Affixes {
			;If (RegExMatch(affix, "i)(\d+.?\d+?).*increased Attack Speed", match)) {
			If (RegExMatch(affix, "i)(\d+){1,3}.*повышение скорости атаки", match)) {
				affixAttackSpeed := match1
			}

			nname :=
			;If (RegExMatch(affix, "Adds.*Lightning Damage")) {
			If (RegExMatch(affix, "Добавляет.*урона от молнии")) {
				; приводим строку к виду, например: Добавляет от 1 до # урона от молнии
				;affix := RegExReplace(affix, "i)to (\d+)", "to #")
				affix := RegExReplace(affix, "i)до (\d+)", "до #")
				;affix := RegExReplace(affix, "i)to (\d+.*?\d+?)", "to #")
				affix := RegExReplace(affix, "i)до (\d+.*?\d+?)", "до #")
				
				If (not mod.isVariable) {
					; меняет первое значение
					;nname := RegExReplace(mod.name, "i)(Adds )(#)( Lightning Damage)", "$1" mod.values[1] " to #$3")
					; в ru версии два # поэтому строка немного другая
					nname := RegExReplace(mod.name_ru, "i)(Добавляет от )(#)( до # урона от молнии)", "$1" mod.values[1] "$3")
				}
			}
			Else {
				;affix := RegExReplace(affix, "i)(\d+ to \d+)", "#")
				affix := RegExReplace(affix, "i)(от \d+ до \d+)", "#")
				affix := RegExReplace(affix, "i)(\d+.*?\d+?)", "#")
			}
			affix := RegExReplace(affix, "i)# %", "#%")
			affix := Trim(RegExReplace(affix, "\s", " "))
			;nname := StrLen(nname) ? Trim(nname) : Trim(mod.name)			
			nname := StrLen(nname) ? Trim(nname) : Trim(RegExReplace(mod.name_ru, "от # до #", "#"))
			
			If ( affix = nname ){
				match :=
				; ignore mods like " ... per X dexterity" and "damage to spells"
				;If (RegExMatch(affix, "i) per | to spells")) {
				If (RegExMatch(affix, "i) за | к чарам")) {
					continue
				}
				;If (RegExMatch(affix, "i)Adds.*#.*(Physical|Fire|Cold|Chaos) Damage", dmgType)) {
				If (RegExMatch(affix, "Добавляет.*#.*(физического) урона", dmgType) or RegExMatch(affix, "Добавляет.*#.*урона от (огня|холода)", dmgType) or RegExMatch(affix, "Добавляет.*#.*урона (хаосом)", dmgType)) {
					dmgType1 := nameRuToEn[dmgType1]
					If (not mod.isVariable) {
						min_affixFlat%dmgType1%Low    := mod.values[1]
						min_affixFlat%dmgType1%Hi     := mod.values[2]
						max_affixFlat%dmgType1%Low    := mod.values[1]
						max_affixFlat%dmgType1%Hi     := mod.values[2]
					}
					Else {
						min_affixFlat%dmgType1%Low    := mod.ranges[1][1]
						min_affixFlat%dmgType1%Hi     := mod.ranges[1][2]
						max_affixFlat%dmgType1%Low    := mod.ranges[2][1]
						max_affixFlat%dmgType1%Hi     := mod.ranges[2][2]
					}
					debugOutput .= affix "`nflat " dmgType1 " : " min_affixFlat%dmgType1%Low " - " min_affixFlat%dmgType1%Hi " to " max_affixFlat%dmgType1%Low " - " max_affixFlat%dmgType1%Hi "`n`n"
				}
				;If (RegExMatch(affix, "i)Adds.*(\d+) to #.*(Lightning) Damage", match)) {
				If (RegExMatch(affix, "i)Добавляет.*(\d+) до #.*урона от (молнии)", match)) {
					match2 := nameRuToEn[match2]
					If (not mod.isVariable) {
						min_affixFlat%match2%Low    := match1
						min_affixFlat%match2%Hi     := match1
						max_affixFlat%match2%Low    := mod.values[2]
						max_affixFlat%match2%Hi     := mod.values[2]
					}
					Else {
						min_affixFlat%match2%Low    := match1
						min_affixFlat%match2%Hi     := match1
						max_affixFlat%match2%Low    := mod.ranges[1][1]
						max_affixFlat%match2%Hi     := mod.ranges[1][2]
					}
					debugOutput .= affix "`nflat " match2 " : " min_affixFlat%match2%Low " - " min_affixFlat%match2%Hi " to " max_affixFlat%match2%Low " - " max_affixFlat%match2%Hi "`n`n"
				}
				;If (RegExMatch(affix, "i)#.*increased Physical Damage")) {
				If (RegExMatch(affix, "i)#.*увеличение физического урона")) {
					If (not mod.isVariable) {
						min_affixPercentPhys    := mod.values[1]
						max_affixPercentPhys    := mod.values[1]
					}
					Else {
						min_affixPercentPhys    := mod.ranges[1][1]
						max_affixPercentPhys    := mod.ranges[1][2]
					}
					debugOutput .= affix "`ninc Phys : " min_affixPercentPhys " - " max_affixPercentPhys "`n`n"
				}
				;If (RegExMatch(affix, "i)#.*increased Attack Speed")) {
				If (RegExMatch(affix, "i)#.*повышение скорости атаки")) {
					If (not mod.isVariable) {
						min_affixPercentAPS     := mod.values[1] / 100
						max_affixPercentAPS     := mod.values[1] / 100
					}
					Else {
						min_affixPercentAPS     := mod.ranges[1][1] / 100
						max_affixPercentAPS     := mod.ranges[1][2] / 100
					}
					debugOutput .= affix "`ninc attack speed : " min_affixPercentAPS " - " max_affixPercentAPS "`n`n"
				}
			}
		}
	}

	SetFormat, FloatFast, 5.2
	baseAPS      := (!affixAttackSpeed) ? AttacksPerSecond : AttacksPerSecond / (1 + (affixAttackSpeed / 100))
	basePhysLow  := TradeFunc_CalculateBase(physicalDamageLow, affixPercentPhys, Stats.Quality, affixFlatPhysLow)
	basePhysHi   := TradeFunc_CalculateBase(physicalDamageHi , affixPercentPhys, Stats.Quality, affixFlatPhysHi)

	minPhysLow   := Round(TradeFunc_CalculateQ20(basePhysLow, min_affixFlatPhysicalLow, min_affixPercentPhys))
	minPhysHi    := Round(TradeFunc_CalculateQ20(basePhysHi , max_affixFlatPhysicalLow, min_affixPercentPhys))
	maxPhysLow   := Round(TradeFunc_CalculateQ20(basePhysLow, min_affixFlatPhysicalHi , max_affixPercentPhys))
	maxPhysHi    := Round(TradeFunc_CalculateQ20(basePhysHi , max_affixFlatPhysicalHi , max_affixPercentPhys))
	min_affixPercentAPS := (min_affixPercentAPS) ? min_affixPercentAPS : 0
	max_affixPercentAPS := (max_affixPercentAPS) ? max_affixPercentAPS : 0

	SetFormat, FloatFast, 5.4
	minAPS       := baseAPS * (1 + min_affixPercentAPS)
	maxAPS       := baseAPS * (1 + max_affixPercentAPS)
	For key, val in mods.stats {
		If (val.name = "APS") {
			If (val.ranges[1][1]) {
				minAPS := val.ranges[1][1]
			}
			If (val.ranges[1][2]) {
				maxAPS := val.ranges[1][2]
			}
		}
	}

	iStats.PhysDps        := {}
	iStats.PhysDps.Name   := "Physical Dps (Q20)"
	iStats.PhysDps.Name_Ru   := "Физический Dps (Q20)"
	iStats.PhysDps.Value  := (Stats.Q20Dps > 0) ? (Stats.Q20Dps - Stats.EleDps - Stats.ChaosDps) : Stats.PhysDps
	iStats.PhysDps.Min    := Floor(((minPhysLow + minPhysHi) / 2) * minAPS)
	iStats.PhysDps.Max    := Ceil(((maxPhysLow + maxPhysHi) / 2) * maxAPS)
	iStats.EleDps         := {}
	iStats.EleDps.Name    := "Elemental Dps"
	iStats.EleDps.Name_Ru   := "Стихийный Dps"
	iStats.EleDps.Value   := Stats.EleDps
	iStats.EleDps.Min     := Floor(TradeFunc_CalculateEleDps(min_affixFlatFireLow, max_affixFlatFireLow, min_affixFlatColdLow, max_affixFlatColdLow, min_affixFlatLightningLow, max_affixFlatLightningLow, minAPS))
	iStats.EleDps.Max     := Ceil(TradeFunc_CalculateEleDps(min_affixFlatFireHi, max_affixFlatFireHi, min_affixFlatColdHi, max_affixFlatColdHi, min_affixFlatLightningHi, max_affixFlatLightningHi, maxAPS))

	debugOutput .= "Phys DPS: " iStats.PhysDps.Value "`n" "Phys Min: " iStats.PhysDps.Min "`n" "Phys Max: " iStats.PhysDps.Max "`n" "EleDps: " iStats.EleDps.Value "`n" "Ele Min: " iStats.EleDps.Min "`n" "Ele Max: "  iStats.EleDps.Max

	If (TradeOpts.Debug) {
		;console.log(debugOutput)
		console.log(debugOutput)
	}
	SetFormat, FloatFast, 5.2

	Return iStats
}

TradeFunc_CalculateEleDps(fireLo, fireHi, coldLo, coldHi, lightLo, lightHi, aps) {
	dps := 0
	fireLo  := fireLo  > 0 ? fireLo  : 0
	fireHi  := fireHi  > 0 ? fireHi  : 0
	coldLo  := coldLo  > 0 ? coldLo  : 0
	coldHi  := coldHi  > 0 ? coldHi  : 0
	lightLo := lightLo > 0 ? lightLo : 0
	lightHi := lightHi > 0 ? lightHi : 0

	If (TradeOpts.Debug) {
		;console.log("((" fireLo " + " fireHi " + " coldLo " + " coldHi " + " lightLo " + " lightHi ") / 2) * " aps " )")
		console.log("((" fireLo " + " fireHi " + " coldLo " + " coldHi " + " lightLo " + " lightHi ") / 2) * " aps " )")
	}
	dps := ((fireLo + fireHi + coldLo + coldHi + lightLo + lightHi) / 2) * aps
	dps := Round(dps, 1)

	return dps
}

TradeFunc_CompareGemNames(name, ByRef found = false) {
	poeTradeNames := TradeGlobals.Get("GemNameList")
	If(poeTradeNames.Length() < 1) {
		return name
	}
	Else {
		Loop, % poeTradeNames.Length() {
			stack := Trim(RegExReplace(poeTradeNames[A_Index], "i)support", ""))
			If (stack = name) {
				found := true
				return poeTradeNames[A_Index]
			}
		}
		return name
	}
}

TradeFunc_GetUniqueStats(name, isRelic = false) {
	items := isRelic ? TradeGlobals.Get("VariableRelicData") : TradeGlobals.Get("VariableUniqueData")
	For i, uitem in items {
		If (name = uitem.name) {
			Return uitem.stats
		}
	}
}

; copied from PoE-ItemInfo because there it'll only be called If the option "ShowMaxSockets" is enabled
TradeFunc_SetItemSockets() {
	Global Item

	If (Item.IsWeapon or Item.IsArmour)
	{
		If (Item.Level >= 50) {
			Item.MaxSockets := 6
		}
		Else If (Item.Level >= 35) {
			Item.MaxSockets := 5
		}
		Else If (Item.Level >= 25) {
			Item.MaxSockets := 4
		}
		Else If (Item.Level >= 1) {
			Item.MaxSockets := 3
		}
		Else	{
			Item.MaxSockets := 2
		}

		If (Item.IsFourSocket and Item.MaxSockets > 4) {
			Item.MaxSockets := 4
		}
		Else If (Item.IsThreeSocket and Item.MaxSockets > 3) {
			Item.MaxSockets := 3
		}
		Else If (Item.IsSingleSocket)	{
			Item.MaxSockets := 1
		}
	}
}

TradeFunc_CheckIfItemIsCraftingBase(type){
	bases := TradeGlobals.Get("CraftingData")
	For i, base in bases {
		If (type = base) {
			Return true
		}
	}
	Return false
}

TradeFunc_CheckIfItemHasHighestCraftingLevel(subtype, iLvl){
	If (RegExMatch(subtype, "i)Helmet|Gloves|Boots|Body Armour|Shield|Quiver")) {
		Return (iLvl >= 84) ? 84 : false
	}
	Else If (RegExMatch(subtype, "i)Weapon")) {
		Return (iLvl >= 83) ? 83 : false
	}
	Else If (RegExMatch(subtype, "i)Belt|Amulet|Ring")) {
		Return (iLvl >= 83) ? 83 : false
	}
	Return false
}

TradeFunc_DoParseClipboard()
{
	Global Opts, Globals
	CBContents := GetClipboardContents()
	CBContents := PreProcessContents(CBContents)

	Globals.Set("ItemText", CBContents)
	Globals.Set("TierRelativeToItemLevelOverride", Opts.TierRelativeToItemLevel)

	ParsedData := ParseItemData(CBContents)
}

TradeFunc_DoPostRequest(payload, openSearchInBrowser = false) {
	UserAgent   := TradeGlobals.Get("UserAgent")
	cfduid      := TradeGlobals.Get("cfduid")
	cfClearance := TradeGlobals.Get("cfClearance")

	postData 	:= payload
	payLength	:= StrLen(postData)
	url 		:= "http://poe.trade/search"
	options	:= ""

	reqHeaders	:= []
	reqHeaders.push("Connection: keep-alive")
	reqHeaders.push("Cache-Control: max-age=0")
	reqHeaders.push("Origin: http://poe.trade")
	reqHeaders.push("Upgrade-Insecure-Requests: 1")
	reqHeaders.push("Content-type: application/x-www-form-urlencoded; charset=UTF-8")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
	reqHeaders.push("Referer: http://poe.trade/")
	If (StrLen(UserAgent)) {
		reqHeaders.push("User-Agent: " UserAgent)
		reqHeaders.push("Cookie: __cfduid=" cfduid "; cf_clearance=" cfClearance)
	}

	html := PoEScripts_Download(url, postData, reqHeaders, options, false)

	If (TradeOpts.Debug) {
		FileDelete, %A_ScriptDir%\temp\DebugSearchOutput.html
		FileAppend, %html%, %A_ScriptDir%\temp\DebugSearchOutput.html
	}

	Return, html
}

TradeFunc_DoPoePricesRequest(RawItemData, ByRef retCurl) {
	RawItemData := RegExReplace(RawItemData, "<<.*?>>|<.*?>")
	EncodedItemData := StringToBase64UriEncoded(RawItemData, true)
	
	postData 	:= "l=" UriEncode(TradeGlobals.Get("LeagueName")) "&i=" EncodedItemData
	payLength	:= StrLen(postData)
	url 		:= "https://www.poeprices.info/api"

	options	:= "RequestType: GET"
	options	.= "`n" "ReturnHeaders: skip"
	options	.= "`n" "TimeOut: 10"
	reqHeaders := []
	
	reqHeaders.push("Connection: keep-alive")
	reqHeaders.push("Cache-Control: max-age=0")
	reqHeaders.push("Origin: https://poeprices.info")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
	
	;ShowToolTip("Getting price prediction... ")
	ShowToolTip("Получение прогноза цены... ")
	retCurl := true
	response := PoEScripts_Download(url, postData, reqHeaders, options, false, false, false, "", "", true, retCurl)
	
	If (TradeOpts.Debug) {
		FileDelete, %A_ScriptDir%\temp\DebugSearchOutput.html
		FileAppend, %response%, %A_ScriptDir%\temp\DebugSearchOutput.html
	}

	responseObj := {}
	Try {
		responseObj := JSON.Load(response)
	} Catch e {
		responseObj.failed := "ERROR: Parsing response failed, invalid JSON! "
	}
	
	If (not isObject(responseObj)) {		
		responseObj := {}
	}
	
	If (not StrLen(response)) {
		responseObj.failed := "ERROR: Parsing response failed, empty response! "
	}
	
	; temporary debug log
	If (true) {
		arr := {}
		arr.RawItemData := RawItemData
		arr.EncodedItemata := EncodedItemData
		arr.League := TradeGlobals.Get("LeagueName")
		TradeFunc_LogPoePricesRequest(arr, request, "poe_prices_debug_log.txt")
	}

	responseObj.added := {}
	responseObj.added.encodedData := EncodedItemData
	responseObj.added.league := TradeGlobals.Get("LeagueName")
	responseObj.added.requestUrl := url "?" postData
	responseObj.added.browserUrl := url "?" postData "&w=1"

	Return responseObj
}

TradeFunc_MapCurrencyNameToID(name) {
	; map the actual ingame name of the currency to the one used on poe.trade and get the corresponding ID
	name := RegExReplace(name, "i) ", "_")
	name := RegExReplace(name, "i)'", "")
	mappedName := TradeCurrencyNames.eng[name]
	ID := TradeGlobals.Get("CurrencyIDs")[mappedName]

	Return ID
}

; Get currency.poe.trade html
; Either at script start to parse the currency IDs or when searching to get currency listings
TradeFunc_DoCurrencyRequest(currencyName = "", openSearchInBrowser = false, init = false, ByRef currencyURL = "", ByRef error = 0) {
	UserAgent   := TradeGlobals.Get("UserAgent")
	cfduid      := TradeGlobals.Get("cfduid")
	cfClearance := TradeGlobals.Get("cfClearance")

	If (init) {
		Url := "http://currency.poe.trade/"
	}
	Else {
		LeagueName := TradeGlobals.Get("LeagueName")
		IDs := TradeGlobals.Get("CurrencyIDs")
		Have:= TradeOpts.CurrencySearchHave
		If (Have = currencyName) {
			Have := TradeOpts.CurrencySearchHave2
		}

		; currently not necessary
		; idWant := TradeFunc_MapCurrencyNameToID(currencyName)
		; idHave := TradeFunc_MapCurrencyNameToID(TradeOpts.CurrencySearchHave)

		idWant := IDs[currencyName]
		idHave := IDs[Have]
		minStockSize := 0

		If (idWant and idHave) {
 			Url := "http://currency.poe.trade/search?league=" . TradeUtils.UriEncode(LeagueName) . "&online=x&want=" . idWant . "&have=" . idHave . "&stock=" . minStockSize 
			currencyURL := Url
		} Else {
			errorMsg = Couldn't find currency "%currencyname%" on poe.trade's currency search.`n`nThis search needs to know the currency names used on poe.trades currency page.`n`nEither this item doesn't exist on that page or parsing and mapping the poe.trade`nnames to the actual names failed. Please report this issue.
			error := 1
			Return, errorMsg
		}
	}

	postData 	:= ""
	options	:= ""

	reqHeaders	:= []
	If (StrLen(UserAgent)) {
		reqHeaders.push("User-Agent: " UserAgent)
		authHeaders.push("User-Agent: " UserAgent)
		reqHeaders.push("Cookie: __cfduid=" cfduid "; cf_clearance=" cfClearance)
		authHeaders.push("Cookie: __cfduid=" cfduid "; cf_clearance=" cfClearance)
	} Else {
		reqHeaders.push("User-Agent:Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36")
	}

	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
	reqHeaders.push("Accept-Encoding:gzip, deflate")
	reqHeaders.push("Accept-Language:de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4")
	reqHeaders.push("Connection:keep-alive")
	reqHeaders.push("Referer:http://poe.trade/")
	reqHeaders.push("Upgrade-Insecure-Requests:1")

	html := PoEScripts_Download(url, postData, reqHeaders, options, false)

	If (init) {
		TradeFunc_ParseCurrencyIDs(html)
		Return
	}

	If (TradeOpts.Debug) {
		FileDelete, %A_ScriptDir%\temp\DebugSearchOutput.txt
		FileAppend, %html%, %A_ScriptDir%\temp\DebugSearchOutput.txt
	}

	Return, html
}

; Open given Url with default Browser
TradeFunc_OpenUrlInBrowser(Url) {
	Global TradeOpts
	
	openWith :=
	If (TradeOpts.CopyUrlToClipboard) {	
		SuspendPOEItemScript := 1
		Clipboard = %Url%		
		SuspendPOEItemScript := 0
		shortenedUrl := StrLen(Url) > 50 ? SubStr(Url, 1, 50) "..." : Url
		;ShowToolTip("Copied URL to clipboard:`n`n" shortenedUrl)
		ShowToolTip("URL скопирован в буфер обмена:`n`n" shortenedUrl)
		Return
	}	
	Else If (TradeFunc_CheckBrowserPath(TradeOpts.BrowserPath, false)) {
		openWith := TradeOpts.BrowserPath
		OpenWebPageWith(openWith, Url)
	}
	Else If (TradeOpts.OpenWithDefaultWin10Fix) {
		openWith := AssociatedProgram("html")
		OpenWebPageWith(openWith, Url)
	}
	Else {
		Run %Url%
	}
}

TradeFunc_CurrencyFoundOnCurrencySearch(currencyName) {
	id := TradeGlobals.Get("CurrencyIDs")[currencyName]
	Return StrLen(id) > 0 ? 1 : 0
}

; Parse currency.poe.trade to get all available currencies and their IDs
TradeFunc_ParseCurrencyIDs(html) {
	; remove linebreaks and replace multiple spaces with a single one
	StringReplace, html,html, `r,, All
	StringReplace, html,html, `n,, All
	html := RegExReplace(html,"\s+"," ")

	categoryBlocks := []
	Pos		:= 0
	While Pos := RegExMatch(html, "i)id=""cat-want-(.*?)(id=""cat-want-|id=""cat-have-|input)", match, Pos + (StrLen(match1) ? StrLen(match1) : 1)) {
		categoryBlocks.push(match1)
	}

	RegExMatch(html, "is)id=""currency-want"">(.*?)input", match)
	startStringCurrency	:= "<div data-tooltip"
	startStringOthers	:= "<div class=""currency-selectable"

	Currencies := {}

	For key, val in categoryBlocks {
		Loop {
			start := key > 2 ? startStringOthers : startStringCurrency
			CurrencyBlock 	:= TradeUtils.HtmlParseItemData(val, start . "(.*?)>", val)
			CurrencyName 	:= TradeUtils.HtmlParseItemData(CurrencyBlock, "title=""(.*?)""")
			CurrencyID 	:= TradeUtils.HtmlParseItemData(CurrencyBlock, "data-id=""(.*?)""")
			CurrencyName 	:= StrReplace(CurrencyName, "&#39;", "'")

			If (!CurrencyName) {
				TradeGlobals.Set("CurrencyIDs", Currencies)
				break
			}

			match1 := match1
			match1 := SubStr(match1, StrLen(CurrencyBlock))

			Currencies[CurrencyName] := CurrencyID
		}
	}

	If (!Currencies["Chaos Orb"]) {
		Currencies := TradeCurrencyIDsFallback
	}

	TradeGlobals.Set("CurrencyIDs", Currencies)
}

; Parse currency.poe.trade to display tooltip with first X listings
TradeFunc_ParseCurrencyHtml(html, payload, ParsingError = "") {
	Global Item, ItemData, TradeOpts
	LeagueName := TradeGlobals.Get("LeagueName")

	If (StrLen(ParsingError)) {
		Return, ParsingError
	}
	
	

	;Title := Item.Name
	Title := Item.Name " (англ. " Item.Name_En ")"
	Title .= " (" LeagueName ")"
	Title .= "`n------------------------------ `n"
	NoOfItemsToShow := TradeOpts.ShowItemResults

	Title .= StrPad("IGN" ,10)
	;Title .= StrPad("| Ratio",20)
	Title .= StrPad("| Курс",20)
/* ширину колонки будем расчитывать динамически
	;Title .= "| " . StrPad("Buy  ",20, "Left")
	Title .= "| " . StrPad("Купить  ",21, "Left")
*/	

	nameCurr := ""
	sizeNameCurr := 0
	; верхняя часть таблицы до фразы "Купить"
	Title_head := Title
	Title := ""
	
	;Title .= StrPad("Pay",18)
	;Title .= StrPad(" <=   Оплатить",20)
	Title .= StrPad(" <=   Заплатить",20)
	;Title .= StrPad("| Stock",8)
	Title .= StrPad("| В наличии  ",8)
	Title .= "`n"

	Title .= StrPad("----------" ,10)
	Title .= StrPad("--------------------",20)
	Title .= StrPad("--------------------",20)
	Title .= StrPad("--------------------",18)
	;Title .= StrPad("--------",8)
	Title .= StrPad("----------------",8)
	Title .= "`n"
	
	SetFormat, float, 0.4

	While A_Index < NoOfItemsToShow {
		Offer       := TradeUtils.StrX( html,   "data-username=""",     N, 0, "Contact Seller"   , 1,1, N )
		SellCurrency:= TradeUtils.StrX( Offer,  "data-sellcurrency=""", 1,19, """"        , 1,1, T )
		SellValue   := TradeUtils.StrX( Offer,  "data-sellvalue=""",    1,16, """"        , 1,1, T )
		BuyValue    := TradeUtils.StrX( Offer,  "data-buyvalue=""",     1,15, """"        , 1,1, T )
		BuyCurrency := TradeUtils.StrX( Offer,  "data-buycurrency=""",  1,18, """"        , 1,1, T )
		AccountName := TradeUtils.StrX( Offer,  "data-ign=""",          1,10, """"        , 1,1    )

		RatioBuying := BuyValue / SellValue
		RatioSelling  := SellValue / BuyValue

		Pos   := RegExMatch(Offer, "si)displayoffer-bottom(.*)", StockMatch)
		Loop, Parse, StockMatch, `n, `r
		{
			RegExMatch(TradeUtils.CleanUp(A_LoopField), "i)Stock:? ?(\d+) ", StockMatch)
			If (StockMatch) {
				Stock := StockMatch1
			}
		}

		Pos := RegExMatch(Offer, "si)displayoffer-primary(.*)<.*displayoffer-centered", Display)
		P := ""
		DisplayNames := []
		Loop {
			Column := TradeUtils.StrX( Display1, "column", P, 0, "</div", 1,1, P )
			RegExMatch(Column, ">(.*)<", Column)
			Column := RegExReplace(Column1, "\t|\r|\n", "")
			If (StrLen(Column) < 1) {
				Break
			}
			Column := StrReplace(Column, "&#39;", "'")
			; получим русское название валюты
			Column := AdpRu_ConvertBuyoutCurrencyEnToRu(Column)
			DisplayNames.Push(Column)
		}
		If (DisplayNames[1]) { ; исключаем отображение пустых строк
			subAcc := TradeFunc_TrimNames(AccountName, 10, true)
			Title .= StrPad(subAcc,10)
			Title .= StrPad("| " . "1 <-- " . TradeUtils.ZeroTrim(RatioBuying)            ,20)
			;Title .= StrPad("| " . StrPad(DisplayNames[1] . " " . StrPad(TradeUtils.ZeroTrim(SellValue), 4, "left"), 17, "left") ,20)
			Title .= StrPad("| " . StrPad(DisplayNames[1] . " " . StrPad(TradeUtils.ZeroTrim(SellValue), 4, "left"), 17, "left") ,19)
			;Title .= StrPad("<= " . StrPad(TradeUtils.ZeroTrim(BuyValue), 4) . " " . DisplayNames[3] ,20)
			Title .= StrPad(" <= " . StrPad(TradeUtils.ZeroTrim(BuyValue), 4) . " " . DisplayNames[3] ,20)
			Title .= StrPad("| " . Stock,8)
			Title .= "`n"
		}
		
		; по имени покупаемой валюты вычисляем размер столбца
		If (not nameCurr) {
			nameCurr := DisplayNames[1]
			sizeNameCurr := StrLen(nameCurr)
			;sizeNameCurr := sizeNameCurr < 16 ? 17 : sizeNameCurr + 5
			;sizeNameCurr := sizeNameCurr < 16 ? 19 : sizeNameCurr + 5
			;sizeNameCurr := sizeNameCurr < 16 ? sizeNameCurr + 6 : sizeNameCurr + 5
			;sizeNameCurr := sizeNameCurr + 5
			sizeNameCurr := sizeNameCurr < 13 ? sizeNameCurr + 6 : sizeNameCurr + 5
		}
	}

	; нижняя часть таблицы после фразы "Купить"
	Title_body := Title
	
	Title := ""
	
	;Title .= "| " . StrPad("Buy  ",20, "Left")
	; добавляем недостающий заголовок с заданной шириной
	Title .= "| " . StrPad("Купить  ",sizeNameCurr, "Left")
	
	; формируем итоговую строку
	Title_head .= Title
	Title := Title_head
	Title .= Title_body

	Return, Title
}

TradeFunc_ParseAlternativeCurrencySearch(name, payload) {
	Global Item, ItemData, TradeOpts
	
	LeagueName	:= RegexReplace(TradeGlobals.Get("LeagueName"), "\s")
	shortName		:= Trim(RegExReplace(name,  "Orb\s?|\s?of| Cartographer's", ""))
	;shortTitleName	:= Trim(RegExReplace(Item.Name,  " Cartographer's", ""))
	shortTitleName	:= Trim(RegExReplace(Item.Name_En,  " Cartographer's", ""))

	Title := StrPad(shortTitleName " (" LeagueName ")", 44)
	Title .= StrPad("provided by poe.ninja", 25, "left")
	Title .= "`n---------------------------------------------------------------------`n"

	Title .= StrPad("" , 11)
	Title .= StrPad("|| Buy (" shortName ")" , 28)
	Title .= StrPad("|| Sell (" shortName ")", 28)
	Title .= "`n"
	Title .= StrPad("===========||==========================||============================", 40)
	Title .= "`n"

	Title .= StrPad("Time" , 11)
	Title .= StrPad("|| Pay (Chaos)", 15)
	Title .= StrPad("| Get", 13)

	Title .= StrPad("|| Pay", 14)
	Title .= StrPad("| Get (Chaos)", 15)

	Title .= "`n"
	Title .= StrPad("-----------||-------------|------------||------------|---------------", 40)

	currencyData :=
	For key, val in CurrencyHistoryData {
		If (val.currencyTypeName = name) {
			currencyData := val
			break
		}
	}

	prices		:= {}
	prices.pay	:= {}
	prices.receive	:= {}
	prices.pay.pay	:= []
	prices.pay.get	:= []
	prices.pay.highestDigitPay	:= 1
	prices.pay.highestDigitGet	:= 1
	prices.receive.pay	:= []
	prices.receive.get	:= []
	prices.receive.highestDigitPay	:= 1
	prices.receive.highestDigitGet	:= 1

	arr := ["receive", "pay"]
	SetFormat, float, 0.6

	For arrKey, arrVal in arr {
		tmpCurrent := currencyData[arrVal].value

		For key, val in currencyData[arrVal "SparkLine"].data {
			; turn null values into 0
			val := val >= 0 ? val : 0
			tmp := tmpCurrent * (1 - val / 100)

			priceGet := tmp > 1 ? 1 : Round(1 / tmp, 2)
			pricePay := tmp > 1 ? Round(tmp, 2) : 1

			prices[arrVal].get.push(priceGet)
			prices[arrVal].pay.push(pricePay)

			testGet := StrLen(RegExReplace(priceGet,  "\..*", ""))
			testPay := StrLen(RegExReplace(pricePay,  "\..*", ""))

			prices[arrVal].highestDigitGet := testGet > prices[arrVal].highestDigitGet ? testGet : prices[arrVal].highestDigitGet
			prices[arrVal].highestDigitPay := testPay > prices[arrVal].highestDigitPay ? testPay : prices[arrVal].highestDigitPay
		}
	}

	SetFormat, float, 0.4

	Loop % prices.receive.pay.length() {
		If (A_Index = 1) {
			date := "Currently"
		} Else {
			date := A_Index > 2 ? A_Index - 1 " days ago" : A_Index - 1 " day ago"
		}

		Title .= "`n"
		Title .= StrPad(date, 11)

		buyPayPart1 := RegExReplace(prices.receive.pay[A_Index], "\..*")
		buyPayPart2 := RegExMatch(prices.receive.pay[A_Index], ".*\.") ? RegExReplace(prices.receive.pay[A_Index], ".*\.", ".") : ""
		buyGetPart1 := RegExReplace(prices.receive.get[A_Index], "\..*")
		buyGetPart2 := RegExMatch(prices.receive.get[A_Index], ".*\.") ? RegExReplace(prices.receive.get[A_Index], ".*\.", ".") : ""
		If (prices.receive.pay[A_Index] > 0) {
			Title .= StrPad("|| " StrPad(buyPayPart1, prices.receive.highestDigitPay, "left") StrPad(buyPayPart2, 2), 15)
		} Else {
			Title .= StrPad("|| no data", 15)
		}
		If (prices.receive.get[A_Index] > 0) {
			Title .= StrPad("| "  StrPad(buyGetPart1, prices.receive.highestDigitGet, "left") StrPad(buyGetPart2, 2), 13)
		} Else {
			Title .= StrPad("| no data", 13)
		}

		sellGetPart1 := RegExReplace(prices.pay.get[A_Index], "\..*")
		sellGetPart2 := RegExMatch(prices.pay.get[A_Index], ".*\.") ? RegExReplace(prices.pay.get[A_Index], ".*\.", ".") : ""
		sellPayPart1 := RegExReplace(prices.pay.pay[A_Index], "\..*")
		sellPayPart2 := RegExMatch(prices.pay.pay[A_Index], ".*\.") ? RegExReplace(prices.pay.pay[A_Index], ".*\.", ".") : ""
		If (prices.pay.pay[A_Index] > 0) {
			Title .= StrPad("|| " StrPad(sellPayPart1, prices.pay.highestDigitPay, "left") StrPad(sellPayPart2, 2), 14)
		} Else {
			Title .= StrPad("|| no data", 14)
		}
		If (prices.pay.get[A_Index] > 0) {
			Title .= StrPad("| "  StrPad(sellGetPart1, prices.pay.highestDigitGet, "left") StrPad(sellGetPart2, 2), 15)
		} Else {
			Title .= StrPad("| no data", 15)
		}
	}

	Return Title
}

; Calculate average and median price of X listings
TradeFunc_GetMeanMedianPrice(html, payload, ByRef errorMsg = ""){
	itemCount := 1
	prices := []
	average := 0
	Title := ""
	error := 0

	; loop over the first 99 results If possible, otherwise over as many as are available
	accounts := []
	NoOfItemsToCount := 99
	NoOfItemsSkipped := 0
	While A_Index <= NoOfItemsToCount {
		ItemBlock 	:= TradeUtils.HtmlParseItemData(html, "<tbody id=""item-container-" A_Index - 1 """(.*?)<\/tbody>", html)
		AccountName 	:= TradeUtils.HtmlParseItemData(ItemBlock, "data-seller=""(.*?)""")
		AccountName	:= RegexReplace(AccountName, "i)^\+", "")
		;ChaosValue 	:= TradeUtils.HtmlParseItemData(ItemBlock, "data-name=""price_in_chaos""(.*?)>")
		Currency	 	:= TradeUtils.HtmlParseItemData(ItemBlock, "has-tip.*currency-(.*?)""", rest)
		CurrencyV	 	:= TradeUtils.HtmlParseItemData(rest, ">(.*?)<", rest)
		RegExMatch(CurrencyV, "i)\d+(\.|,?\d+)?", match)
		CurrencyV		:= match

		; skip multiple results from the same account
		If (TradeOpts.RemoveMultipleListingsFromSameAccount) {
			If (TradeUtils.IsInArray(AccountName, accounts)) {
				NoOfItemsToShow := NoOfItemsToShow + 1
				NoOfItemsSkipped := NoOfItemsSkipped + 1
				continue
			} Else {
				accounts.Push(AccountName)
			}
		}

		If (StrLen(CurrencyV) <= 0) {
			Continue
		}  Else {
			itemCount++
		}

		CurrencyName := TradeUtils.Cleanup(Currency)
		CurrencyValue := TradeUtils.Cleanup(CurrencyV)

		; add chaos-equivalents (chaos prices) together and count results
		If (StrLen(CurrencyValue) > 0) {
			SetFormat, float, 6.2
			chaosEquivalent := 0

			mappedCurrencyName := TradeFunc_MapCurrencyPoeTradeNameToIngameName(CurrencyName)
			chaosEquivalentSingle := ChaosEquivalents[mappedCurrencyName]
			chaosEquivalent := CurrencyValue * chaosEquivalentSingle
			If (!chaosEquivalentSingle) {
				error++
			}

			StringReplace, FloatNumber, chaosEquivalent, ., `,, 1
			average += chaosEquivalent
			prices[itemCount-1] := chaosEquivalent
		}
	}

	If (error) {
		errorMsg := "Couldn't find the chaos equiv. value for " error " item(s). Please report this."
	}

	; calculate average and median prices (truncated median, too)
	If (prices.MaxIndex() > 0) {
		; average
		average := average / (itemCount - 1)

		; truncated mean
		trimPercent := 20
		topTrim	:= prices.MaxIndex() - prices.MaxIndex() * (trimPercent / 100)
		bottomTrim:= prices.MaxIndex() * (trimPercent / 100)
		avg := 0
		avgCount := 0
		
		Loop, % prices.MaxIndex() {
			If (A_Index <= bottomTrim or A_Index >= topTrim) {
				continue
			}
			avg += prices[A_Index]
			avgCount++
		}
		truncMean := Round(avg / avgCount, 2)
		
		; median
		If (prices.MaxIndex()&1) {
			; results count is odd
			index1 := Floor(prices.MaxIndex()/2)
			index2 := Ceil(prices.MaxIndex()/2)
			median := (prices[index1] + prices[index2]) / 2
			If (median > 2) {
				median := Round(median, 2)
			}
		}
		Else {
			; results count is even
			index := Floor(prices.MaxIndex()/2)
			median := prices[index]
			If (median > 2) {
				median := Round(median, 2)
			}
		}

		length := (StrLen(average) > StrLen(median)) ? StrLen(average) : StrLen(median)
		
		;desc1 := "Average price: "
		desc1 := "Средняя  цена: "
		;desc2 := "Trimmed Mean (" trimPercent "%):"
		desc2 := "Усеченное среднее (" trimPercent "%):"
		;desc3 := "Median price: "
		desc3 := "Медианная цена: "
		dlength := (dlength > StrLen(desc2)) ? StrLen(desc1) : StrLen(desc2)
		dlength := (dlength > StrLen(desc3)) ? dlength : StrLen(desc3)		
		
		;Title .= StrPad(desc1, dlength, "right") StrPad(average, length, "left") " chaos (" prices.MaxIndex() " results"
		Title .= StrPad(desc1, dlength, "right") StrPad(average, length, "left") " хаосов (" prices.MaxIndex() " результатов"
		;Title .= (NoOfItemsSkipped > 0) ? ", " NoOfItemsSkipped " removed by Acc. Filter" : ""
		Title .= (NoOfItemsSkipped > 0) ? ", " NoOfItemsSkipped " удалено фильтром уч.зап." : ""
		Title .= ") `n"
		
		;Title .= StrPad(desc2, dlength, "right") StrPad(truncMean, length, "left") " chaos (" prices.MaxIndex() " results"
		Title .= StrPad(desc2, dlength, "right") StrPad(truncMean, length, "left") " хаосов (" prices.MaxIndex() " результатов"		
		;Title .= (NoOfItemsSkipped > 0) ? ", " NoOfItemsSkipped " removed by Acc. Filter" : ""
		Title .= (NoOfItemsSkipped > 0) ? ", " NoOfItemsSkipped " удалено фильтром уч.зап." : ""
		Title .= ") `n"

		;Title .= StrPad(desc3, dlength, "right") StrPad(median, length, "left") " chaos (" prices.MaxIndex() " results"
		Title .= StrPad(desc3, dlength, "right") StrPad(median, length, "left") " хаосов (" prices.MaxIndex() " результатов"		
		;Title .= (NoOfItemsSkipped > 0) ? ", " NoOfItemsSkipped " removed by Acc. Filter" : ""
		Title .= (NoOfItemsSkipped > 0) ? ", " NoOfItemsSkipped " удалено фильтром уч.зап." : ""
		Title .= ") `n`n"		
	}
	Return Title
}

TradeFunc_MapCurrencyPoeTradeNameToIngameName(CurrencyName) {
	; map poe.trade currency names to actual ingame names
	mappedCurrencyName := ""
	For key, val in TradeCurrencyNames.eng {
		If (val = CurrencyName) {
			mappedCurrencyName := RegExReplace(key, "i)_", " ")
		}
	}

	; if mapping the exact name failed try to map it a bit less strict (example, poe.trade uses "chrome" for currencies and "chromatic" for items)
	If (!StrLen(mappedCurrencyName)) {
		For key, val in TradeCurrencyNames.eng {
			tempKey := RegExReplace(key, "i)_", " ")
			If (InStr(tempKey, CurrencyName, 0)) {
				mappedCurrencyName := tempKey
			}
		}
	}

	Return mappedCurrencyName
}

; Parse poe.trade search result html to object
TradeFunc_ParseHtmlToObj(html, payload, iLvl = "", ench = "", isItemAgeRequest = false, isAdvancedSearch = false) {
	Global Item, ItemData, TradeOpts
	LeagueName := TradeGlobals.Get("LeagueName")
	
	;median_average := TradeFunc_GetMeanMedianPrice(html, payload, error)	
	
	; Target HTML Looks like the ff:
     ; <tbody id="item-container-97" class="item" data-seller="Jobo" data-sellerid="458008"
	; data-buyout="15 chaos" data-ign="Lolipop_Slave" data-league="Essence" data-name="Tabula Rasa Simple Robe"
	; data-tab="This is a buff" data-x="10" data-y="9"> <tr class="first-line">
	

	NoOfItemsToShow := TradeOpts.ShowItemResults
	results := []
	accounts := {}
	
	While A_Index < NoOfItemsToShow {
		result := {}
		
		ItemBlock 	:= TradeUtils.HtmlParseItemData(html, "<tbody id=""item-container-" A_Index - 1 """(.*?)<\/tbody>", html)
		AccountName 	:= TradeUtils.HtmlParseItemData(ItemBlock, "data-seller=""(.*?)""")
		AccountName	:= RegexReplace(AccountName, "i)^\+", "")
		Buyout 		:= TradeUtils.HtmlParseItemData(ItemBlock, "data-buyout=""(.*?)""")
		IGN			:= TradeUtils.HtmlParseItemData(ItemBlock, "data-ign=""(.*?)""")
		AFK			:= TradeUtils.HtmlParseItemData(ItemBlock, "class="".*?(label-afk).*?"".*?>")

		If (not AccountName) {
			continue
		}
		Else {
			itemsListed++
		}

		; skip multiple results from the same account
		If (TradeOpts.RemoveMultipleListingsFromSameAccount and not isItemAgeRequest) {
			If (accounts[AccountName]) {
				NoOfItemsToShow += 1
				accounts[AccountName] += 1
				continue
			} Else {
				accounts[AccountName] := 1
			}
		}
		result.accountName := AccountName
		result.ign := IGN
		result.afk := StrLen(AFK) ? true : false

		; get item age
		Pos := RegExMatch(ItemBlock, "i)class=""found-time-ago"">(.*?)<", Age)
		result.age := Age1
		
		Pos := RegExMatch(ItemBlock, "i)data-name=""ilvl"">.*: ?(\d+?)<", iLvl, Pos)
		result.itemLevel := iLvl1
		
		If (Item.IsGem) {
			; get gem quality, level and xp
			RegExMatch(ItemBlock, "i)data-name=""progress"".*<b>\s?(\d+)\/(\d+)\s?<\/b>", GemXP_Flat)
			RegExMatch(ItemBlock, "i)data-name=""progress"">\s*?Experience:.*?([0-9.]+)\s?%", GemXP_Percent)
			Pos := RegExMatch(ItemBlock, "i)data-name=""q"".*?data-value=""(.*?)""", Q, Pos)
			Pos := RegExMatch(ItemBlock, "i)data-name=""level"".*?data-value=""(.*?)""", LVL, Pos)
			
			result.gemData := {}
			result.gemData.xpFlat := GemXP_Flat1
			result.gemData.xpPercent := GemXP_Percent1
			result.gemData.quality := Q1
			result.gemData.level := LVL1
		}

		; buyout price
		RegExMatch(Buyout, "i)([-.0-9]+) (.*)", BuyoutText)
		RegExMatch(BuyoutText1, "i)(\d+)(.\d+)?", BuyoutPrice)
		
		If (TradeOpts.ShowPricesAsChaosEquiv and not TradeOpts.ExactCurrencySearch) {
			; translate buyout to chaos equivalent
			RegExMatch(Buyout, "i)\d+(\.|,?\d+)?(.*)", match)
			CurrencyName := TradeUtils.Cleanup(match2)

			mappedCurrencyName		:= TradeFunc_MapCurrencyPoeTradeNameToIngameName(CurrencyName)
			chaosEquivalentSingle	:= ChaosEquivalents[mappedCurrencyName]
			chaosEquivalent		:= BuyoutPrice * chaosEquivalentSingle
			RegExMatch(chaosEquivalent, "i)(\d+)(.\d+)?", BuyoutPrice)

			If (chaosEquivalentSingle) {
				BuyoutPrice    := (BuyoutPrice2) ? BuyoutPrice1 . BuyoutPrice2 : BuyoutPrice1
				BuyoutCurrency := "chaos"
			}
		}
		Else {
			BuyoutPrice    := (BuyoutPrice2) ? BuyoutPrice1 . BuyoutPrice2 : BuyoutPrice1
			BuyoutCurrency := BuyoutText2
		}
		
		result.buyoutPrice := BuyoutPrice
		result.buyoutCurrency := BuyoutCurrency	

		results.push(result)
	}
	
	data := {}
	data.results := results
	data.accounts := accounts

	Return data
}


; Parse poe.trade html to display the search result tooltip with X listings
TradeFunc_ParseHtml(html, payload, iLvl = "", ench = "", isItemAgeRequest = false, isAdvancedSearch = false) {
	Global Item, ItemData, TradeOpts
	LeagueName := TradeGlobals.Get("LeagueName")

	;seperatorBig := "`n---------------------------------------------------------------------`n"
	seperatorBig := "`n----------------------------------------------------------------------------------`n"

	; Target HTML Looks like the ff:
     ; <tbody id="item-container-97" class="item" data-seller="Jobo" data-sellerid="458008"
	; data-buyout="15 chaos" data-ign="Lolipop_Slave" data-league="Essence" data-name="Tabula Rasa Simple Robe"
	; data-tab="This is a buff" data-x="10" data-y="9"> <tr class="first-line">
	If (not Item.IsGem and not Item.IsDivinationCard and not Item.IsJewel and not Item.IsCurrency and not Item.IsMap) {
		showItemLevel := true
	}

	;Name := (Item.IsRare and not Item.IsMap) ? Item.Name " " Item.BaseName : Item.Name
	Name := (Item.IsRare and not Item.IsMap) ? Item.Name " " Item.BaseName " (англ. " Item.BaseName_En ")" : Item.Name 
	;Title := Trim(StrReplace(Name, "Superior", ""))
	Title := Trim(StrReplace(Name, "высокого качества", ""))
	
	If (Item.IsUnique or Item.IsDivinationCard or Item.IsCurrency or Item.IsMapFragment or Item.IsProphecy or Item.RarityLevel = 1 or (Item.IsFlask and Item.RarityLevel = 2)) {
		Title := Title . " (англ. " Item.Name_En ")"
	}

	If (Item.IsMap && !Item.isUnique) {
		; map fix (wrong Item.name on magic/rare maps)
		Title :=
		;newName := Trim(StrReplace(Item.Name, "Superior", ""))
		newName := Trim(StrReplace(Item.Name, "высокого качества", ""))
		
		; prevent duplicate name on white and magic maps
		;If (newName != Item.SubType) {
		If (newName != Item.BaseName) {
			;s := Trim(RegExReplace(Item.Name, "Superior", ""))
			s := Trim(newName)
			;s := Trim(StrReplace(s, Item.SubType, ""))
			s := Trim(StrReplace(s, Item.BaseName, ""))
			Title .= "(" RegExReplace(s, " +", " ") ") "
		}

		;Title .= Trim(StrReplace(Item.SubType, "Superior", ""))
		Title .= Item.BaseName
		If (Item.BaseName !=  Item.BaseName_En)
		{
			Title .= " [англ. " Item.BaseName_En "] "
		}
		Else If (not Item.BaseName and Item.IsUnidentified)
		{
			Title .= " [англ. " Item.SubType "] "
		}
	}

	; add corrupted tag
	If (Item.IsCorrupted) {
		;Title .= " [Corrupted] "
		Title .= " [Осквернено] "
	}

	; add gem quality and level
	If (Item.IsGem) {
		Title := Item.Name ", Q" Item.Quality "%"
		Title .= " (англ. " Item.Name_En ")"
		If (Item.Level >= 16) {
			Title := Item.Name ", " Item.Level "`/" Item.Quality "%"
			Title .= " (англ. " Item.Name_En ")"
		}
	}
	; add item sockets and links
	If (ItemData.Sockets >= 5) {
		;Title := Name " " ItemData.Sockets "s" ItemData.Links "l"
		Title := Name " (англ. " Item.Name_En ")" " " ItemData.Sockets "s" ItemData.Links "l" 
	}
	If (showItemLevel) {
		Title .= ", iLvl: " iLvl
	}

	Title .= ", (" LeagueName ")"
	Title .= seperatorBig

	; add notes what parameters where used in the search
	ShowFullNameNote := false
	If (not Item.IsUnique and not Item.IsGem and not Item.IsDivinationCard) {
		ShowFullNameNote := true
	}

	If (Item.UsedInSearch) {
		If (isItemAgeRequest) {
			Title .= Item.UsedInSearch.SearchType
		}
		Else {
			;Title .= "Used in " . Item.UsedInSearch.SearchType . " Search: "
			Title .= "Используется в " . Item.UsedInSearch.SearchType . " поиске: "
			;Title .= (Item.UsedInSearch.Enchantment)  ? "Enchantment " : ""
			Title .= (Item.UsedInSearch.Enchantment)  ? "Зачарование " : ""
			;Title .= (Item.UsedInSearch.CorruptedMod) ? "Corr. Implicit " : ""
			Title .= (Item.UsedInSearch.CorruptedMod) ? "Оскверн. мод " : ""
			Title .= (Item.UsedInSearch.Sockets)      ? "| " . Item.UsedInSearch.Sockets . "S " : ""
			;Title .= (Item.UsedInSearch.AbyssalSockets) ? "| " . Item.UsedInSearch.AbyssalSockets . " Abyss Sockets " : "" 
			Title .= (Item.UsedInSearch.AbyssalSockets) ? "| " . "Гнезд бездны " . Item.UsedInSearch.AbyssalSockets . " " : "" 
			Title .= (Item.UsedInSearch.Links)        ? "| " . Item.UsedInSearch.Links   . "L " : ""
			If (Item.UsedInSearch.iLvl.min and Item.UsedInSearch.iLvl.max) {
				Title .= "| iLvl (" . Item.UsedInSearch.iLvl.min . "-" . Item.UsedInSearch.iLvl.max . ")"
			}
			Else {
				Title .= (Item.UsedInSearch.iLvl.min) ? "| iLvl (>=" . Item.UsedInSearch.iLvl.min . ") " : ""
				Title .= (Item.UsedInSearch.iLvl.max) ? "| iLvl (<=" . Item.UsedInSearch.iLvl.max . ") " : ""
			}

			;Title .= (Item.UsedInSearch.FullName and ShowFullNameNote) ? "| Full Name " : ""
			Title .= (Item.UsedInSearch.FullName and ShowFullNameNote) ? "| Полное имя " : ""
			;Title .= (Item.UsedInSearch.BeastBase and ShowFullNameNote) ? "| Beast Base " : ""
			Title .= (Item.UsedInSearch.BeastBase and ShowFullNameNote) ? "| База существа " : ""
			Title .= (Item.UsedInSearch.Rarity) ? "(" Item.UsedInSearch.Rarity ") " : ""
			;Title .= (Item.UsedInSearch.Corruption and not Item.IsMapFragment and not Item.IsDivinationCard and not Item.IsCurrency)   ? "| Corrupted (" . Item.UsedInSearch.Corruption . ") " : ""
			Title .= (Item.UsedInSearch.Corruption and not Item.IsMapFragment and not Item.IsDivinationCard and not Item.IsCurrency)   ? "| Осквернено (" . Item.UsedInSearch.Corruption . ") " : ""
			Title .= (Item.UsedInSearch.ItemXP) ?  "| XP (>= 70%) " : ""
			;Title .= (Item.UsedInSearch.Type) ? "| Type (" . Item.UsedInSearch.Type . ") " : ""			
			;Title .= (Item.UsedInSearch.Type) ? "| Тип (" . Item.UsedInSearch.TypeRu . ") " : ""
			Title .= (Item.UsedInSearch.Type) ? "| Тип (" . Item.UsedInSearch.Type . ") " : ""
			;Title .= (Item.UsedInSearch.abyssJewel) ? "| Abyss Jewel " : ""
			Title .= (Item.UsedInSearch.abyssJewel) ? "| Самоцвет Бездны " : ""
			;Title .= (Item.UsedInSearch.ItemBase and ShowFullNameNote) ? "| Base (" . Item.UsedInSearch.ItemBase . ") " : ""
			Title .= (Item.UsedInSearch.ItemBase and ShowFullNameNote) ? "| База (" . Item.UsedInSearch.ItemBaseRu . ") " : ""
			;Title .= (Item.UsedInSearch.specialBase) ? "| " . Item.UsedInSearch.specialBase . " Base " : ""
			Title .= (Item.UsedInSearch.specialBase) ? "| " . "База: " . Item.UsedInSearch.specialBaseRu . " " : ""
			Title .= (Item.UsedInSearch.Charges) ? "`n" . Item.UsedInSearch.Charges . " " : ""
			Title .= (Item.UsedInSearch.AreaMonsterLvl) ? "| " . Item.UsedInSearch.AreaMonsterLvl . " " : ""
			
			If (Item.IsBeast and not Item.IsUnique) {
				;Title .= (Item.UsedInSearch.SearchType = "Default") ? "`n" . "!! Added special bestiary mods to the search !!" : ""	
				Title .= (Item.UsedInSearch.SearchType = "По умолчанию") ? "`n" . "!! К поиску добавлены специальные моды бестиария !!" : ""	
			} Else {
				;Title .= (Item.UsedInSearch.SearchType = "Default") ? "`n" . "!! Mod rolls are being ignored !!" : ""
				Title .= (Item.UsedInSearch.SearchType = "По умолчанию") ? "`n" . "!! Текущие значения модов игнорируются !!" : ""
				If (Item.UsedInSearch.ExactCurrency) {
					;Title .= "`n" . "!! Using exact currency option !!"
					Title .= "`n" . "!! Используется точный вариант валюты !!"
				}
			}
		}
		Title .= seperatorBig
	}

	; add average and median prices to title
	If (not isItemAgeRequest) {
		Title .= TradeFunc_GetMeanMedianPrice(html, payload, error)
		If (StrLen(error)) {
			Title .= error "`n`n"
		}
	} Else {
		Title .= "`n"
	}

	NoOfItemsToShow := TradeOpts.ShowItemResults
	; add table headers to tooltip
	;Title .= TradeFunc_ShowAcc(StrPad("Account",10), "|")
	Title .= TradeFunc_ShowAcc(StrPad("Аккаунт",12), "|")
	Title .= StrPad("IGN",20)
	;Title .= StrPad(StrPad("| Price ", 19, "right") . "|",20,"left")
	Title .= StrPad(StrPad("| Цена ", 28, "right") . "|",20,"left")

	If (Item.IsGem) {
		; add gem headers
		Title .= StrPad("Q. |",6,"left")
		Title .= StrPad("Lvl |",6,"left")
		Title .= StrPad("Xp |",6,"left")
	}
	If (showItemLevel) {
		; add ilvl
		Title .= StrPad("iLvl |",7,"left")
	}
	;Title .= StrPad("   Age",8)
	Title .= StrPad("   Возраст",8)
	Title .= "`n"

	; add table head underline
	Title .= TradeFunc_ShowAcc(StrPad("------------",12), "-")
	;Title .= StrPad("--------------------",20)
	Title .= StrPad("---------------------------",20)
	;Title .= StrPad("--------------------",19,"left")	
	Title .= StrPad("---------------------",19,"left")	
	If (Item.IsGem) {
		Title .= StrPad("------",6,"left")
		Title .= StrPad("------",6,"left")
		Title .= StrPad("------",6,"left")
	}
	If (showItemLevel) {
		Title .= StrPad("-------",8,"left")
	}
	;Title .= StrPad("----------",8,"left")
	Title .= StrPad("------------- ",11,"left")
	Title .= "`n"

	; add search results to tooltip in table format
	accounts := []
	itemsListed := 0
	While A_Index < NoOfItemsToShow {
		ItemBlock 	:= TradeUtils.HtmlParseItemData(html, "<tbody id=""item-container-" A_Index - 1 """(.*?)<\/tbody>", html)
		AccountName 	:= TradeUtils.HtmlParseItemData(ItemBlock, "data-seller=""(.*?)""")
		AccountName	:= RegexReplace(AccountName, "i)^\+", "")
		Buyout 		:= TradeUtils.HtmlParseItemData(ItemBlock, "data-buyout=""(.*?)""")
		IGN			:= TradeUtils.HtmlParseItemData(ItemBlock, "data-ign=""(.*?)""")

		If (not AccountName) {
			continue
		}
		Else {
			itemsListed++
		}

		; skip multiple results from the same account
		If (TradeOpts.RemoveMultipleListingsFromSameAccount and not isItemAgeRequest) {
			If (TradeUtils.IsInArray(AccountName, accounts)) {
				NoOfItemsToShow := NoOfItemsToShow + 1
				continue
			} Else {
				accounts.Push(AccountName)
			}
		}

		; get item age
		Pos := RegExMatch(ItemBlock, "i)class=""found-time-ago"">(.*?)<", Age)

		If (showItemLevel) {
			; get item level
			Pos := RegExMatch(ItemBlock, "i)data-name=""ilvl"">.*: ?(\d+?)<", iLvl, Pos)
		}
		If (Item.IsGem) {
			; get gem quality, level and xp
			RegExMatch(ItemBlock, "i)data-name=""progress"".*<b>\s?(\d+)\/(\d+)\s?<\/b>", GemXP_Flat)
			RegExMatch(ItemBlock, "i)data-name=""progress"">\s*?Experience:.*?([0-9.]+)\s?%", GemXP_Percent)
			Pos := RegExMatch(ItemBlock, "i)data-name=""q"".*?data-value=""(.*?)""", Q, Pos)
			Pos := RegExMatch(ItemBlock, "i)data-name=""level"".*?data-value=""(.*?)""", LVL, Pos)
		}

		; trim account and ign
		subAcc := TradeFunc_TrimNames(AccountName, 12, true)
		subIGN := TradeFunc_TrimNames(IGN, 20, true)

		Title .= TradeFunc_ShowAcc(StrPad(subAcc,12), "|")
		Title .= StrPad(subIGN,20)

		; buyout price
		RegExMatch(Buyout, "i)([-.0-9]+) (.*)", BuyoutText)
		RegExMatch(BuyoutText1, "i)(\d+)(.\d+)?", BuyoutPrice)

		If (TradeOpts.ShowPricesAsChaosEquiv) {
			; translate buyout to chaos equivalent
			RegExMatch(Buyout, "i)\d+(\.|,?\d+)?(.*)", match)
			CurrencyName := TradeUtils.Cleanup(match2)

			mappedCurrencyName		:= TradeFunc_MapCurrencyPoeTradeNameToIngameName(CurrencyName)
			chaosEquivalentSingle	:= ChaosEquivalents[mappedCurrencyName]
			chaosEquivalent		:= BuyoutPrice * chaosEquivalentSingle
			RegExMatch(chaosEquivalent, "i)(\d+)(.\d+)?", BuyoutPrice)

			If (chaosEquivalentSingle) {
				BuyoutPrice    := (BuyoutPrice2) ? StrPad(BuyoutPrice1 BuyoutPrice2, (3 - StrLen(BuyoutPrice1), "left")) : StrPad(StrPad(BuyoutPrice1, 2 + StrLen(BuyoutPrice1), "right"), 3 - StrLen(BuyoutPrice1), "left")
				;BuyoutCurrency := "chaos"
				BuyoutCurrency := "хаосов"
			}
		}
		Else {
			BuyoutPrice    := (BuyoutPrice2) ? StrPad(BuyoutPrice1 BuyoutPrice2, (3 - StrLen(BuyoutPrice1), "left")) : StrPad(StrPad(BuyoutPrice1, 2 + StrLen(BuyoutPrice1), "right"), 3 - StrLen(BuyoutPrice1), "left")
			;BuyoutCurrency := BuyoutText2
			BuyoutCurrency := AdpRu_ConvertBuyoutCurrencyEnToRu(BuyoutText2)
		}
		BuyoutText := StrPad(BuyoutPrice, 5, "left") . " " BuyoutCurrency
		;Title .= StrPad("| " . BuyoutText . "",19,"right")
		Title .= StrPad("| " . BuyoutText . "",28,"right")

		If (Item.IsGem) {
			; add gem info
			If (Q1 > 0) {
				Title .= StrPad("| " . StrPad(Q1,2,"left") . "% ",6,"right")
			} Else {
				Title .= StrPad("|  -  ",6,"right")
			}
			Title .= StrPad("| " . StrPad(LVL1,3,"left") . " " ,6,"right")
			
			If (GemXP_Percent1) {
				Title .= StrPad("| " . StrPad(GemXP_Percent1,2,"left") . "% ",6,"right")
			} Else {
				Title .= StrPad("|  -  ",6,"right")
			}
		}
		If (showItemLevel) {
			; add item level
			Title .= StrPad("| " . StrPad(iLvl1,3,"left") . "  |" ,8,"right")
		}
		Else {
			Title .= "|"
		}
		; add item age
		Title .= StrPad(TradeFunc_FormatItemAge(Age1),10)
		Title .= "`n"
	}
	;Title .= (itemsListed > 0) ? "" : "`nNo item found.`n"
	Title .= (itemsListed > 0) ? "" : "`nНичего не найдено.`n"
	;Title .= (isAdvancedSearch) ? "" : "`n`n" "Use Ctrl + Alt + D (default) instead for a more thorough search."
	Title .= (isAdvancedSearch) ? "" : "`n`n" "Нажмите Ctrl + Alt + D (по умолчанию) для расширенного поиска."

	Return, Title
}

TradeFunc_ParsePoePricesInfoErrorCode(response, request) {
	If (not response or not response.HasKey("error")) {
		ShowToolTip("")
		;ShowTooltip("ERROR: Request to poeprices.info timed out or`nreturned an invalid response! `n`nPlease take a look at the file ""temp\poeprices_log.txt"".")
		ShowTooltip("ОШИБКА: Запрос к poeprices.info просрочен или`nбыл получен неверный ответ! `n`nПодробнее ""temp\poeprices_log.txt"".")
		TradeFunc_LogPoePricesRequest(response, request)
		Return 0
	}
	Else If (response.error = "1") {
		ShowToolTip("")
		;ShowTooltip("No price prediction available. `n`nItem not found, insufficient sample data. ")
		;ShowTooltip("Прогноз цены недоступен. `n`nПредмет не найден, недостаточно данных образца. ")
		;ShowTooltip("Прогноз цены отсутствует. `n`nПредмет не найден, недостаточно данных образца. ")
		;ShowTooltip("Невозможно спрогнозировать цену. `n`nПредмет не найден, недостаточно данных для прогноза. ")
		ShowTooltip("Невозможно спрогнозировать цену. `n`nПредмет не найден, недостаточно данных для прогноза. ")
		Return 0
	}
	Else If (response.error = "2") {
		ShowToolTip("")
		;ShowTooltip("ERROR: Predicted search has encountered an unknown error! `n`nPlease take a look at the file ""temp\poeprices_log.txt"".") 
		ShowTooltip("ОШИБКА: При выполнении запроса произошла непредвиденная ошибка! `n`nПодробнее ""temp\poeprices_log.txt"".") 
		TradeFunc_LogPoePricesRequest(response, request)
		Return 0
	}
	Else If (response.error = "0") {
		min := response.HasKey("min") or response.HasKey("min_price") ? true : false
		max := response.HasKey("max") or response.HasKey("max_price") ? true : false		
		
		min_value := StrLen(response.min) ? response.min : response.min_price
		max_value := StrLen(response.max) ? response.max : response.max_price
		
		If (min and max) {
			If (not StrLen(min_value) and not StrLen(max_value)) {
				ShowToolTip("")
				;ShowTooltip("No price prediction available. `n`nItem not found, insufficient sample data.")
				ShowTooltip("Невозможно спрогнозировать цену. `n`nПредмет не найден, недостаточно данных для прогноза. ")
				Return 0
			}
		} Else If (not StrLen(min_value) and not StrLen(max_value)) {
			ShowToolTip("")
			;ShowTooltip("ERROR: Request to poeprices.info failed,`nno prices were returned! `n`nPlease take a look at the file ""temp\poeprices_log.txt"".")
			ShowTooltip("ОШИБКА: Запрос к poeprices.info не удался! `n`nПодробнее ""temp\poeprices_log.txt"".")
			TradeFunc_LogPoePricesRequest(response, request)
			Return 0
		}
		
		Return 1
	}
	Return 0
}

TradeFunc_LogPoePricesRequest(response, request, filename = "poeprices_log.txt") {
	text := "#####"
 	text .= "`n### " "Please post this log file below to https://www.pathofexile.com/forum/view-thread/1216141/."	
	text .= "`n### " "Try not to ""spam"" their thread if a few other reports with the same error description were posted in the last hours."	
	text .= "`n#####"	
	
	text .= "`n`n"
	text .= "Request and response:`n"
	Try {
		text .= JSON.Dump(response, "", 4)
	} Catch e {
		text .= response
	}	
	FileDelete, %A_ScriptDir%\temp\%filename%
	FileAppend, %text%, %A_ScriptDir%\temp\%filename%
	
	Return
}
	
TradeFunc_ParsePoePricesInfoData(response) {
	Global Item, ItemData, TradeOpts
	
	LeagueName := TradeGlobals.Get("LeagueName")

	;Name := (Item.IsRare and not Item.IsMap) ? Item.Name " " Item.BaseName : Item.Name
	Name := (Item.IsRare and not Item.IsMap) ? Item.Name_En " " Item.BaseName_En : Item.Name_En
	headLine := Trim(StrReplace(Name, "Superior", ""))
	; add corrupted tag
	If (Item.IsCorrupted) {
		headLine .= " [Corrupted] "
	}

	; add gem quality and level
	If (Item.IsGem) {
		;headLine := Item.Name ", Q" Item.Quality "%"
		headLine := Item.Name_En ", Q" Item.Quality "%"
		If (Item.Level >= 16) {
			;headLine := Item.Name ", " Item.Level "`/" Item.Quality "%"
			headLine := Item.Name_En ", " Item.Level "`/" Item.Quality "%"
		}
	}
	; add item sockets and links
	If (ItemData.Sockets >= 5) {
		headLine := Name " " ItemData.Sockets "s" ItemData.Links "l"
	}
	If (showItemLevel) {
		headLine .= ", iLvl: " iLvl
	}
	headLine .= ", (" LeagueName ")"

	lines := []
	lines.push(["~~ Predicted item pricing (via machine-learning) ~~", "center", true])
	lines.push([headLine, "left",  true])
	lines.push(["", "left"])
	lines.push(["   Price range: " Round(Trim(response.min), 2) " ~ " Round(Trim(response.max), 2) " " Trim(response.currency), "left"])
	lines.push(["", "left", true])
	lines.push(["", "left"])
	
	_details := TradeFunc_PreparePredictedPricingContributionDetails(response.pred_explanation, 40)
	lines.push(["Contribution to predicted price:", "left"])
	For _k, _v in _details {
		_line := _v.percentage " -> " _v.name 
		lines.push(["  " _line, "left"])
	}
	lines.push(["", "left"])
	
	lines.push(["Please consider supporting POEPRICES.INFO.", "left"])
	lines.push(["Financially or via feedback on this feature on their website.", "left"])
	
	maxWidth := 0
	For i, line in lines {
		maxWidth := StrLen(line[1]) > maxWidth ? StrLen(line[1]) : maxWidth
	}

	Title := ""
	For i, line in lines {
		If (RegExMatch(line[2], "i)center")) {
			diff := maxWidth - StrLen(line[1])			
			line[1] := StrPad(line[1], maxWidth - Floor(diff / 2), "left")
		}
		If (RegExMatch(line[2], "i)right")) {
			line[1] := StrPad(line[1], maxWidth, "left")
		}
		
		Title .= line[1] "`n"
		If (line[3]) {
			seperator := ""
			Loop, % maxWidth {
				seperator .= "-"
			}
			Title .= seperator "`n"
		}
	}
	
	Return Title
}

; Trim names/string and add dots at the end If they are longer than specified length
TradeFunc_TrimNames(name, length, addDots) {
	s := SubStr(name, 1 , length)
	If (StrLen(name) > length + 3 && addDots) {
		StringTrimRight, s, s, 3
		s .= "..."
	}
	Return s
}

; Add sellers accountname to string If that option is selected
TradeFunc_ShowAcc(s, addString) {
	If (TradeOpts.ShowAccountName = 1) {
		s .= addString
		Return s
	}
}

; format item age to be shorter
TradeFunc_FormatItemAge(age) {
	age := RegExReplace(age, "^a", "1")
	RegExMatch(age, "\d+", value)
	;RegExMatch(age, "i)month|week|yesterday|hour|minute|second|day", unit)
	; добавим год
	RegExMatch(age, "i)year|month|week|yesterday|hour|minute|second|day", unit)

	If (unit = "month") {
		;unit := " mo"
		unit := " мес."
	} Else If (unit = "week") {
		;unit := " week"
		unit := " нед."
	} Else If (unit = "day") {
		;unit := " day"
		unit := " дн."
	} Else If (unit = "yesterday") {
		;unit := " day"
		unit := " дн."
		value := "1"
	} Else If (unit = "hour") {
		;unit := " h"
		unit := " ч."
	} Else If (unit = "minute") {
		;unit := " min"
		unit := " мин."
	} Else If (unit = "second") {
		;unit := " sec"
		unit := " сек."
	} Else If (unit = "year") { ; добавим год
		;unit := " year"
		unit := " год."
	}

	s := " " StrPad(value, 3, left) unit

	Return s
}

class RequestParams_ {
	; these are special cases, for example by default, the string key "base" is used to retrieve or set the object's base object, so cannot be used for storing ordinary values with a normal assignment.
	xtype		:= ""
	xbase		:= ""
	xthread 		:= ""
	;

	league		:= ""
	name			:= ""
	dmg_min 		:= ""
	dmg_max 		:= ""
	aps_min 		:= ""
	aps_max 		:= ""
	crit_min 		:= ""
	crit_max 		:= ""
	dps_min 		:= ""
	dps_max		:= ""
	edps_min		:= ""
	edps_max		:= ""
	pdps_min 		:= ""
	pdps_max 		:= ""
	armour_min	:= ""
	armour_max	:= ""
	evasion_min	:= ""
	evasion_max 	:= ""
	shield_min 	:= ""
	shield_max 	:= ""
	block_min		:= ""
	block_max 	:= ""
	sockets_min 	:= ""
	sockets_max 	:= ""
	link_min 		:= ""
	link_max 		:= ""
	sockets_r 	:= ""
	sockets_g 	:= ""
	sockets_b 	:= ""
	sockets_w 	:= ""
	linked_r 		:= ""
	linked_g 		:= ""
	linked_b 		:= ""
	linked_w 		:= ""
	rlevel_min 	:= ""
	rlevel_max 	:= ""
	rstr_min 		:= ""
	rstr_max 		:= ""
	rdex_min 		:= ""
	rdex_max 		:= ""
	rint_min 		:= ""
	rint_max 		:= ""
	modGroups		:= [new _ParamModGroup()]
	q_min 		:= ""
	q_max 		:= ""
	level_min 	:= ""
	level_max 	:= ""
	ilvl_min 		:= ""
	ilvl_max		:= ""
	rarity 		:= ""
	seller 		:= ""
	identified 	:= ""
	corrupted		:= "0"
	online 		:= (TradeOpts.OnlineOnly == 0) ? "" : "x"
	has_buyout 	:= ""
	altart 		:= ""
	capquality 	:= "x"
	buyout_min 	:= ""
	buyout_max 	:= ""
	buyout_currency:= ""
	exact_currency	:= (TradeOpts.ExactCurrencySearch == 0) ? "" : "x"
	crafted		:= ""
	enchanted 	:= ""
	progress_min	:= ""
	progress_max	:= ""
	sockets_a_min	:= ""
	sockets_a_max	:= ""
	shaper		:= ""
	elder		:= ""
	map_series 	:= ""

	ToPayload() {
		modGroupStr := ""
		Loop, % this.modGroups.MaxIndex() {
			modGroupStr .= this.modGroups[A_Index].ToPayload()
		}

		p :=
		For key, val in this {
			; check if not array (modGroups for example are arrays)
			If (!this[key].MaxIndex()) {
				If (StrLen(val)) {
					; remove prefixed x for special keys
					argument := RegExReplace(key, "i)(x(base|thread|type))?(.*)", "$2$3")
					p .= "&" argument "=" TradeUtils.UriEncode(val)
				}
			}
		}
		p .= modGroupStr
		p := RegExReplace(p, "^&", "")

		Return p
	}

	AddModGroup(type, count, min = "", max = "") {
		this.modGroups.push(new _ParamModGroup())
		this.modGroups[this.modGroups.MaxIndex()].SetGroupOptions(type, count, min, max)
	}
}

CleanPayload(payload) {
	StringSplit, parameters, payload, `&
	params 	:= []
	i 		:= 1
	While (parameters%i%) {
		RegExMatch(parameters%i%, "=$", match)
		If (!match) {
			params.push(parameters%i%)
		}
		i++
	}

	payload := ""
	For key, val in params {
		payload .= val "&"
	}
	return payload
}

class _ParamModGroup {
	ModArray		:= []
	group_type	:= "And"
	group_min		:= ""
	group_max		:= ""
	group_count	:= 1

	ToPayload() {
		p := ""

		If (this.ModArray.Length() = 0) {
			this.AddMod(new _ParamMod())
		}
		this.group_count := this.ModArray.Length()
		Loop % this.ModArray.Length() {
			p .= this.ModArray[A_Index].ToPayload()
		}
		p .= "&group_type="  TradeUtils.UriEncode(this.group_type)
		p .= "&group_min="   TradeUtils.UriEncode(this.group_min)
		p .= "&group_max="   TradeUtils.UriEncode(this.group_max)
		p .= "&group_count=" TradeUtils.UriEncode(this.group_count)

		;p .= "&group_type=" this.group_type "&group_min=" this.group_min "&group_max=" this.group_max "&group_count=" this.group_count

		Return p
	}

	AddMod(paraModObj) {
		this.ModArray.Push(paraModObj)
	}

	SetGroupOptions(type, count, min = "", max = "") {
		this.group_type	:= type
		this.group_count	:= count
		this.group_min		:= min
		this.group_max		:= max
	}
	SetGroupType(type) {
		this.group_type := type
	}
	SetGroupMinMax(min = "", max = "") {
		this.group_min := min
		this.group_max := max
	}
	SetGroupCount(count) {
		this.group_count := count
	}
}

class _ParamMod {
	mod_name	:= ""
	mod_min	:= ""
	mod_max	:= ""
	mod_weight := ""

	ToPayload()
	{
		If (StrLen(this.mod_name)) {
			p .= "&mod_name=" TradeUtils.UriEncode(this.mod_name)
			p .= "&mod_min="  TradeUtils.UriEncode(this.mod_min) "&mod_max=" TradeUtils.UriEncode(this.mod_max)
			p .= "&mod_weight=" TradeUtils.UriEncode(this.mod_weight)
		}

		Return p
	}
}

TradeFunc_FindModInRequestParams(RequestParams, name) {
	For gkey, gval in RequestParams.modGroups {
		For mkey, mval in gval.ModArray {
			If (mval.mod_name == name) {
				Return true
			}
		}
	}
	Return False
}

; Return unique item with its variable mods and mod ranges if it has any
TradeFunc_FindUniqueItemIfItHasVariableRolls(name, isRelic = false)
{
	data := isRelic ? TradeGlobals.Get("VariableRelicData") : TradeGlobals.Get("VariableUniqueData")
	;For index, uitem in data {
	For index, uitem_ in data {

		If (uitem_.name = name) {
		
			; в данном месте необходимо клонирование объекта-массива, в противном случае в других функциях происходит затирание
			; части массива VariableUniqueData относящегося к текущему предмету и накопление чужих модов с предыдущего запроса
			uitem := AdpRu_ObjFullyClone(uitem_)

			;------------------------------------------
			; На текущий момент в оригинальной версии 2.8.0 нет поддержки уникальных предметов с переменными модами.
			; Добавим возможность расширенного поиска для предметов с переменными, а также с отсутствующими модами
			; - добавляем отсутствующие моды
			;------------------------------------------

			uniquesItemModEmpty := TradeGlobals.Get("uniquesItemModEmpty")
			; если уникальный предмет присутствует в списке (см. файл \data_trade\ru\uniquesItemModEmpty.txt)
			If (uniquesItemModEmpty[uitem.name]) {
				; добавляем отсутствующие моды
				uitem := AdpRu_AddUniqueVariableMods(uitem)
			}
			
			;------------------------------------------
			
			
			;------------------------------------------
			; добавим возможность включения в расширенный поиск имплицитных модов
			;------------------------------------------
			Global Item
			;If ((uitem.implicit or Item.Implicit) and not Item.IsEnchantment) {
			If ((uitem.implicit or Item.Implicit) and not Item.IsEnchantment) {
				maxIndex := Item.Implicit.MaxIndex()
				Loop, % maxIndex {
					; 
					val := Item.Implicit[A_Index]
					t_ru := TradeUtils.CleanUp(RegExReplace(val, "i)-?[\d\.]+", "#"))
					t := AdpRu_ConvertRuOneModToEn(t_ru)
					t := StrReplace(t, "# to #", "#")
					
					maxIndex_ := uitem.implicit.MaxIndex()
					If (maxIndex_) { ; если на оригинальном предмете есть собственный имплицит
						Loop, % maxIndex_ {
							v := uitem.implicit[A_Index]
							n := v.name

							RegExMatch(n, "i)(\+?" . t . ")", match)
							; если имплициты равны, т.е. на предмете собственный оригинальный имплицит
							If (match) {
								If (v.isVariable) {
									uitem.IsUnique := true
									Return uitem
								}
							} Else { ; если же имплициты не равны, то на предмете, возможно, имплицит измененный осквернением
								v.isVariable := true
								uitem.IsUnique := true
								; заменим оригинальное имя, на имя с предмета
								v.name := t
								; добавляем русское название мода
								v.name_ru := t_ru
								; добавляем оригинальную строку мода с предмета
								v.name_orig_item := val
								; пометим, что это имплицит
								v.IsImplicit := true
								; обнулим оригинальный диапазон значений
								v.ranges := []
								
								Return uitem
							}
						}						
					} Else { ; если же имплицит был добавлен 
						; то добавим его на оригинальный предмет
						uitem.implicit := []
						v := {}
						v.isVariable := true
						uitem.IsUnique := true
						; добавим имя имплицита с предмета
						v.name := t
						; добавляем русское имя
						v.name_ru := t_ru
						; добавляем оригинальную строку мода с предмета
						v.name_orig_item := val
						; пометим, что это имплицит
						v.IsImplicit := true
						; зададим пустой диапазон значений
						v.ranges := []
						
						uitem.implicit.push(v)
						
						Return uitem
					}
					
				}
			}						
			;------------------------------------------
			
			Loop % uitem.mods.Length() {
				If (uitem.mods[A_Index].isVariable) {
					uitem.IsUnique := true
					Return uitem
				}
			}
			If (uitem.hasVariant) {
				uitem.IsUnique := true
				Return uitem
			}
		}
	}
	Return 0
}

TradeFunc_RemoveAlternativeVersionsMods(Item_, Affixes) {
	Affixes	:= StrSplit(Affixes, "`n")
	i 		:= 0
	tempMods	:= []
	
	tempRuMods	:= {}
		
	; массив подготовленных модов с удаленными константами
	Item_.mods_const_ru := {}

	For k, v in Item_.mods {
		modFound := false
		For key, val in Affixes {
			
			; воспользуемся подготовленными аффиксами
			t         := tempRuMods[key].t
			t_ru      := tempRuMods[key].t_ru
			t_ru_full := tempRuMods[key].t_ru_full
			
			If (not t) { ; если аффиксы не подготовлены, то подготовим их
				
				; remove negative sign also			
				t_ru_full := TradeUtils.CleanUp(RegExReplace(val, "i)-?[\d\.]+", "#"))
		
				; для модов с константами
				t_ru := AdpRu_nameModNumToConst(t_ru_full)
				; если мод с константой
				If (t_ru.IsNameRuConst) {
					t := AdpRu_ConvertRuOneModToEn(t_ru.nameModConst)
				} Else {
					t := AdpRu_ConvertRuOneModToEn(t_ru_full)
				}
				
				t := TradeUtils.CleanUp(RegExReplace(t, "i)-?[\d\.]+", "#"))
				
				; избавимся от "+" в модах - есть моды у которых "+" расположен в середине
				t := StrReplace(t, "+", "")
				
				tempRuMods[key].t 		  := t
				tempRuMods[key].t_ru 	  := t_ru
				tempRuMods[key].t_ru_full := t_ru_full
			
			}

			;n := TradeUtils.CleanUp(RegExReplace(v.name_orig, "i)-?[\d\.]+|-?\(.+?\)", "#"))
			;n := TradeUtils.CleanUp(RegExReplace(v.param, "i)-?[\d\.]+", "#"))
			n := TradeUtils.CleanUp(RegExReplace(v.param, "i)-?[\d\.]+|-?\(.+?\)", "#"))
			
			; избавляемся от +
			n := TradeUtils.CleanUp(RegExReplace(n, "i)\+", ""))

;console_log(v.param, "v.param")
;console_log(t, "T")			
;console_log(n, "N")			

			;n := TradeUtils.CleanUp(n)

			; избавимся от "+" в модах - есть моды у которых "+" расположен в середине			
			;n := StrReplace(n, "+", "")
				
			; match with optional positive sign to match for example "-7% to cold resist" with "+#% to cold resist"
			;RegExMatch(n, "i)^(\+?" . t . ")$", match)
			RegExMatch(n, "i)(\+?" . t . ")", match)

			If (match) {
				modFound := true
				
				mod_name_full := Trim(val, " `t`n`r")
				; добавляем оригинальную строку мода с предмета
				;v.name_orig_item := mod_name_full
				
				; используется в сортировке
				v.sort := key
				
				; если мод с константой
				If (t_ru.IsNameRuConst) {
					; добавляем русское название мода
					v.name_ru := t_ru.nameModConst					
					; удалим из имени мода константу и сохраним измененнный мод в массиве
					Item_.mods_const_ru[mod_name_full] := AdpRu_ConverNameModToValue(mod_name_full, t_ru.nameModConst)				
				} Else {
					; добавляем русское название мода
					v.name_ru := t_ru_full					
				}
			}
		}

		If (modFound) {
			tempMods.push(v)
		}
	}
	
	If (v.isSort) {
		tempModsSort	:= []

		; меняем сортировку модов в соответствии с порядком следования их на предмете,
		; это необходимо для уникальных предметов с переменными модами (состав модов зависит от конкретного экземпляра предмета, а не от типа),
		; а также предметов с отсутствующими, либо не корректными модами в дата-файлах скрипта
		For key, val in Affixes {	
			For k, v in tempMods {				
				If (v.sort = key) {
					tempModsSort.push(v)
				}
			}
		}
		tempMods := tempModsSort
	}
	
	If (Item.Implicit.MaxIndex()) {
		; тоже для имплицита
		Global Item

		For k, v in Item_.implicit {
			modFound := false
			maxIndex := Item.Implicit.MaxIndex()
			Loop, % maxIndex {
				; 
				val := Item.Implicit[A_Index]
				t_ru := TradeUtils.CleanUp(RegExReplace(val, "i)-?[\d\.]+", "#"))
				t := AdpRu_ConvertRuOneModToEn(t_ru)				
				;n := TradeUtils.CleanUp(RegExReplace(v.name_orig, "i)-?[\d\.]+|-?\(.+?\)", "#"))
				;n := TradeUtils.CleanUp(RegExReplace(v.param, "i)-?[\d\.]+", "#"))
				n := TradeUtils.CleanUp(RegExReplace(v.param, "i)-?[\d\.]+|-?\(.+?\)", "#"))
				
				;n := TradeUtils.CleanUp(n)
				
				; избавляемся от +
				;n := TradeUtils.CleanUp(RegExReplace(n, "i)-|\+", ""))
				n := TradeUtils.CleanUp(RegExReplace(n, "i)\+", ""))

				; match with optional positive sign to match for example "-7% to cold resist" with "+#% to cold resist"
				;RegExMatch(n, "i)^(\+?" . t . ")$", match)
				RegExMatch(n, "i)(\+?" . t . ")", match)
				
				If (match) {
					modFound := true
					; добавляем русское название мода
					v.name_ru := t_ru
					; добавляем оригинальную строку мода с предмета
					v.name_orig_item := val
					; пометим, что это имплицит
					v.IsImplicit := true
				}
			}

			If (modFound) {			
				; добавляем имплицит к списку всех модов, первым
				tempMods.InsertAt(1,v)
			}		
		}
	}

;console_log(tempMods, "tempMods")
	Item_.mods := tempMods
	return Item_
}

; Return items mods and ranges
TradeFunc_PrepareNonUniqueItemMods(Affixes, Implicit, Rarity, Enchantment = false, Corruption = false, isMap = false, isBeast = false) {
	Affixes	:= StrSplit(Affixes, "`n")
	mods		:= []
	i		:= 0

	If (Implicit.maxIndex() and not Enchantment.Length() and not Corruption.Length()) {
		modStrings := Implicit
		For i, modString in modStrings {
			tempMods := ModStringToObject(modString, true)
			;For i, tempMod in tempMods { ; для обычных предметов в расширенном поиске имплицит воспринимался как мод, т.к. i используется в текущем цикле и становилось =2
			For j, tempMod in tempMods { 
				;--- добавим признак имплицита
				tempMod.IsImplicit := true
				;---
				mods.push(tempMod)
			}
		}
	}
;console_log(i, "i")
;console_log(Implicit, "Implicit")
	For key, val in Affixes {
		;If (!val or RegExMatch(val, "i)---")) {
		If (!val or RegExMatch(val, "i)---") or RegExMatch(val, "i)Неопознано")) { ; исключим строку "Неопознано" как аффикс
			continue
		}
		If (i >= 1 and (Enchantment.Length() or Corruption.Length())) {
			continue
		}
		If (i <= 1 and Implicit and Rarity = 1) {
			continue
		}

		temp := ModStringToObject(val, false)
		
		;combine mods if they have the same name and add their values
		For tempkey, tempmod in temp {
			found := false

			For key, mod in mods {
				;If (tempmod.name = mod.name) { ; оригинальная строка закоментирована - имплицит нельзя объединять с простым модом, т.к. предмет с завышенным значением имплицита может не существовать
				If (tempmod.name = mod.name and not mod.IsImplicit) {
					Index := 1
					Loop % mod.values.MaxIndex() {
						mod.values[Index] := mod.values[Index] + tempmod.values[Index]
						Index++
					}

					tempStr  := RegExReplace(mod.name_orig, "i)([.0-9]+)", "#")

					Pos		:= 1
					tempArr	:= []
					While Pos := RegExMatch(tempmod.name_orig, "i)([.0-9]+)", value, Pos + (StrLen(value) ? StrLen(value) : 0)) {
						tempArr.push(value)
					}

					Pos		:= 1
					Index	:= 1
					While Pos := RegExMatch(mod.name_orig, "i)([.0-9]+)", value, Pos + (StrLen(value) ? StrLen(value) : 0)) {
						tempStr := StrReplace(tempStr, "#", value + tempArr[Index],, 1)
						Index++
					}
					mod.name_orig := tempStr
					found := true
				}
			}
			If (tempmod.name and !found) {
				mods.push(tempmod)
			}
		}
	}

	; adding the values (value array) fails in the above loop, so far I have no idea why,
	; as a workaround we take the values from the mod description (where it works and use them)
	For key, mod in mods {
		mod.values := []
		Pos		:= 1
		Index	:= 1
		While Pos := RegExMatch(mod.name_orig, "i)([.0-9]+)", value, Pos + (StrLen(value) ? StrLen(value) : 0)) {
			mod.values.push(value)
			Index++
		}
	}

	mods := CreatePseudoMods(mods, True)

	tempItem		:= {}
	tempItem.mods	:= []
	tempItem.mods	:= mods
	tempItem.isBeast := isBeast
	
	; конвертируем русские названия модов в их английские варианты
	; сохраняем русские названия модов в отдельном параметре
	AdpRu_ConvertRuModToEn(tempItem)

	temp			:= TradeFunc_GetItemsPoeTradeMods(tempItem, isMap)
	tempItem.mods	:= temp.mods
	tempItem.IsUnique := false

	Return tempItem
}

TradeFunc_CheckIfTempModExists(needle, mods) {
	For key, val in mods {
		If (RegExMatch(val.name, "i)" needle "")) {
			Return true
		}
	}
	Return false
}

; Add poe.trades mod names to the items mods to use as POST parameter
TradeFunc_GetItemsPoeTradeMods(_item, isMap = false) {
	mods := TradeGlobals.Get("ModsData")

	; use this to control search order (which group is more important)
	For k, imod in _item.mods {
		If (_item.isBeast) {			
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["bestiary"], _item.mods[k])
			}		
		}
		Else {
			; check total and then implicits first if mod is implicit, otherwise check later
			If (_item.mods[k].type == "implicit" and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["[total] mods"], _item.mods[k])
				If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
					_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["implicit"], _item.mods[k])
				}
			}
			; --------------------------
			; некоторые моды из лиги бестиарий могут быть на любом редком предмете, например			
			; - Grants Level # Aspect of the Crab Skill
			; - Grants Level # Aspect of the Avian Skill
			; Но эти моды присутствуют в файле \data_trade\mods.json только в разделе "bestiary", а 
			; в разделе "explicit" их нет, соответственно в расширенном поиске они отображаются как отсутствующие на poe.trade.
			; Поэтому данный код нужен до момента добавления таких модов в файл \data_trade\mods.json в раздел "explicit" оригинального скрипта,
			; после чего его можно удалить
			If (not _item.isBeast) {			
				If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
					_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["bestiary"], _item.mods[k])
				}		
			}
			; --------------------------
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["[total] mods"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["[pseudo] mods"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["explicit"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["shaped"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["elder"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["abyss jewels"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["unique explicit"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["crafted"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["implicit"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["enchantments"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["map mods"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["prophecies"], _item.mods[k])
			}
			If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
				_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["leaguestone"], _item.mods[k])
			}
			
			; Handle special mods like "Has # Abyssal Sockets" which technically has no rolls but different mod variants.
			; It's also not available on poe.trade as a mod but as a seperate form option.		
			If (RegExMatch(_item.mods[k].name, "i)Has # Abyssal (Socket|Sockets)")) {
				_item.mods[k].showModAsSeperateOption := true
			}
		}
	}

	Return _item
}

; Add poe.trades mod names to the items mods to use as POST parameter
TradeFunc_GetItemsPoeTradeUniqueMods(_item) {
	mods := TradeGlobals.Get("ModsData")
	For k, imod in _item.mods {
		_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["unique explicit"], _item.mods[k])
		If (StrLen(_item.mods[k]["param"]) < 1) {
			_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["explicit"], _item.mods[k])
		}
		If (StrLen(_item.mods[k]["param"]) < 1) {
			_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["[total] mods"], _item.mods[k])
		}
		If (StrLen(_item.mods[k]["param"]) < 1) {
			_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["[pseudo] mods"], _item.mods[k])
		}
		If (StrLen(_item.mods[k]["param"]) < 1 and not isMap) {
			_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["abyss jewels"], _item.mods[k])
		}
		If (StrLen(_item.mods[k]["param"]) < 1) {
			_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["map mods"], _item.mods[k])
		}
		If (StrLen(_item.mods[k]["param"]) < 1) {
			_item.mods[k]["param"] := TradeFunc_FindInModGroup(mods["leaguestone"], _item.mods[k])
		}
		
		; Handle special mods like "Has # Abyssal Sockets" which technically has no rolls but different mod variants.
		; It's also not available on poe.trade as a mod but as a seperate form option.		
		If (RegExMatch(_item.mods[k].name, "i)Has # Abyssal (Socket|Sockets)")) {
			_item.mods[k].showModAsSeperateOption := true
		}
;console_log(imod, "imod")		
	}
	
	; имплицит
	For k, imod in _item.implicit {
		;
		If (StrLen(_item.implicit[k]["param"]) < 1) {
	    	_item.implicit[k]["param"] := TradeFunc_FindInModGroup(mods["implicit"], _item.implicit[k])
		}
		If (StrLen(_item.implicit[k]["param"]) < 1) {
	    	_item.implicit[k]["param"] := TradeFunc_FindInModGroup(mods["enchantments"], _item.implicit[k])
		}
		;If (TradeOpts.Debug) {		
		;		console_log(imod, "imod")							
		;}
	}

;console_log(_item, "_item")	

	Return _item
}

; find mod in modgroup and return its name
TradeFunc_FindInModGroup(modgroup, needle, simpleRange = true, recurse = true) {
	matches := []
	editedNeedle := ""
		
	For j, mod in modgroup {
		s  := Trim(RegExReplace(mod, "i)\(pseudo\)|\(total\)|\(crafted\)|\(implicit\)|\(explicit\)|\(enchant\)|\(prophecy\)|\(leaguestone\)|\(beastiary\)", ""))
		If (simpleRange) {
			s  := RegExReplace(s, "# ?to ? #", "#")
		}
		s  := TradeUtils.CleanUp(s)
		ss := TradeUtils.CleanUp(needle.name)
		ss := RegExReplace(ss, "# ?to ?#", "#")
		st := TradeUtils.CleanUp(needle.name_orig)
		
		; для модов с числами, например "Имеет 1 гнездо" - для таких модов в файле должно быть соответствие полному названию с числовыми значениями
		;If (needle.name_orig_en != st)
		If (needle.name_orig_en and (needle.name_orig_en != st))
		{
			st := TradeUtils.CleanUp(needle.name_orig_en)
		}
		
		If (simpleRange) {
			; matches "1 to" in for example "adds 1 to (20-40) lightning damage"
			ss := RegExReplace(ss, "\d+ ?to ?#", "#")
		}

		;ss := RegExReplace(ss, "Monsters' skills Chain # additional times", "Monsters' skills Chain 2 additional times")
		;ss := RegExReplace(ss, "Has # socket", "Has 1 socket")
		editedNeedle := ss

		; push matches to array to find multiple matches (case sensitive variations)
		If (s = ss or s = st) {
			temp := {}
			temp.s := s
			temp.mod := mod
			matches.push(temp)
		}		
	}

	If (matches.Length()) {
		If (matches.Length() = 1) {
			Return matches[1].mod
		}
		Else {
			Loop % matches.Length()
			{
				; use == instead of = to search case sensitive, there is at least one case where this matters (Life regenerated per second)
				If (matches[A_Index].s == editedNeedle) {
					Return matches[A_Index].mod
				}
			}
		}
	}
	
	If (not matches[1] and recurse = true) {
		TradeFunc_FindInModGroup(modgroup, needle, false, false)
	} Else {
		Return ""
	}
}

TradeFunc_GetCorruption(_item) {
	mods     := TradeGlobals.Get("ModsData")
	corrMods := TradeGlobals.Get("CorruptedModsData")
	corrImplicits := []
	
	For key, val in _item.Implicit {
		RegExMatch(_item.Implicit[key], "i)([-.0-9]+)", value)
		;If (RegExMatch(imp, "i)Limited to:")) {
		If (RegExMatch(imp, "i)Максимум:")) {
			;return false
		}
		imp      := RegExReplace(_item.Implicit[key], "i)([-.0-9]+)", "#")
		corrMod  := {}
		For i, corr in corrMods {
			If (imp = corr) {
				For j, mod in mods["implicit"] {
					match := Trim(RegExReplace(mod, "i)\(implicit\)", ""))
					If (match = corr) {
						corrMod.param := mod
						corrMod.name  := _item.implicit[key]
					}
				}
			}
		}

		valueCount := 0
		Loop {
			If (!value%A_Index%) {
				break
			}
			valueCount++
		}
		If (StrLen(corrMod.param)) {
			If (valueCount = 1) {
				corrMod.min := value1
			}
			corrImplicits.push(corrMod)
		}
	}
	
	If (corrImplicits.Length()) {
		Return corrImplicits
	}
	Else {
		Return false
	}
}

TradeFunc_GetEnchantment(_item, type) {
	mods     := TradeGlobals.Get("ModsData")
	enchants := TradeGlobals.Get("EnchantmentData")
	enchImplicits := []

	group :=
	If (type = "Boots") {
		group := enchants.boots
	}
	Else If (type = "Gloves") {
		group := enchants.gloves
	}
	Else If (type = "Helmet") {
		group := enchants.helmet
	}

	For key, val in _item.Implicit {
		;RegExMatch(_item.implicit[key], "i)([.0-9]+)(%? to([.0-9]+))?", values)
		RegExMatch(_item.implicit[key], "i)([.0-9]+)(%? до([.0-9]+))?", values)
		imp      := RegExReplace(_item.implicit[key], "i)([.0-9]+)", "#")

		enchantment := {}
		If (group.length()) {
			For i, enchant in group {
				If (TradeUtils.CleanUp(imp) = enchant) {
					For j, mod in mods["enchantments"] {
						match := Trim(RegExReplace(mod, "i)\(enchant\)", ""))
						If (match = enchant) {
							enchantment.param := mod
							enchantment.name  := _item.implicit[key]
						}
					}
				}
			}
		}
		valueCount := 0
		Loop {
			If (!values%A_Index%) {
				break
			}
			valueCount++
		}

		If (StrLen(enchantment.param)) {
			If (valueCount = 1) {
				enchantment.min := values1
				enchantment.max := values1
			}
			Else If (valueCount = 3) {
				enchantment.min := values1
				enchantment.max := values3
			}
			enchImplicits.push(enchantment)
		}
	}
	
	If (enchImplicits.Length()) {
		Return enchImplicits
	}
	Else {
		Return false
	}
}

TradeFunc_GetModValueGivenPoeTradeMod(itemModifiers, poeTradeMod, mods_const_ru) {
	If (StrLen(poeTradeMod) < 1) {
		ErrorMsg := "Mod not found on poe.trade!"
		Return ErrorMsg
	}
	poeTradeMod_ValueTypes := TradeFunc_CountValuesAndReplacedValues(poeTradeMod)
	
	Loop, Parse, itemModifiers, `n, `r
	{
		If StrLen(A_LoopField) = 0
		{
			Continue ; Not interested in blank lines
		}
		
		ModStr := ""
		CurrValues := []
		;CurrLine_ValueTypes := TradeFunc_CountValuesAndReplacedValues(A_LoopField)		; лишний вызов - нигде не используется
		
		;CurrValue := TradeFunc_GetActualValue(A_LoopField, poeTradeMod_ValueTypes)
		
		; есть моды с константами идущими первыми в имени мода
		; в результате извлечение значения мода работает не корректно
		; такие моды необходимо обработать подготовив их к извлечению значения удалив константу
		_A_LoopField_ := mods_const_ru[A_LoopField]
		_A_LoopField_ := _A_LoopField_ ? _A_LoopField_ : A_LoopField
		CurrValue := TradeFunc_GetActualValue(_A_LoopField_, poeTradeMod_ValueTypes)
			
		If (CurrValue ~= "\d+") {
			; handle value range
			;RegExMatch(CurrValue, "(\d+) ?(-|to) ?(\d+)", values)
			RegExMatch(CurrValue, "(\d+) ?(-|до) ?(\d+)", values)
			If (values3) {
				CurrValues.Push(values1)
				CurrValues.Push(values3)
				;CurrValue := values1 " to " values3
				CurrValue := values1 " до " values3
				;ModStr := StrReplace(A_LoopField, CurrValue, "# to #")
				ModStr := StrReplace(A_LoopField, CurrValue, "# до #")
			}
			; handle single value
			Else {
				CurrValues.Push(CurrValue)
				ModStr := StrReplace(A_LoopField, CurrValue, "#")
			}

			; remove negative sign since poe.trade mods are always positive
			ModStr := RegExReplace(ModStr, "^-#", "#")
			ModStr := StrReplace(ModStr, "+")
			; replace multi spaces with a single one
			ModStr := RegExReplace(ModStr, " +", " ")
			
			; конвертируем мод в английский вариант
			ModStr := AdpRu_ConvertRuOneModToEn(ModStr)
			; избавляемся от "+" в моде для поетрейда, т.к. существуют моды в которых он присутствует
			poeTradeMod_ := StrReplace(poeTradeMod, "+")			
			poeTradeMod_ := RegExReplace(poeTradeMod_, " +", " ")
			
			;If (RegExMatch(poeTradeMod, "i).*" ModStr "$")) {
			If (RegExMatch(poeTradeMod_, "i).*" ModStr "$")) {
				Return CurrValues
			}
		}
	}
}

; Get value while being able to ignore some, depending on their position
; ValueTypes = ["value", "replaced"]
TradeFunc_GetActualValue(ActualValueLine, ValueTypes)
{
	returnValue 	:= ""	
	Pos		:= 0
	Count 	:= 0
	; Leaves "-" in for negative values, example: "Ventor's Gamble"
	;While Pos	:= RegExMatch(ActualValueLine, "\+?(-?\d+(?: to -?\d+|\.\d+)?)", value, Pos + (StrLen(value) ? StrLen(value) : 1)) {
	While Pos	:= RegExMatch(ActualValueLine, "\+?(-?\d+(?: до -?\d+|\.\d+)?)", value, Pos + (StrLen(value) ? StrLen(value) : 1)) {
		Count++		
		If (InStr(ValueTypes[Count], "Replaced", 0)) {			
			; Formats "1 to 2" as "1-2"
			;StringReplace, Result, value1, %A_SPACE%to%A_SPACE%, -
			StringReplace, Result, value1, %A_SPACE%до%A_SPACE%, -
			returnValue := Trim(RegExReplace(Result, ""))	
		}
	}
	
	return returnValue
}

; Get actual values from a line of the ingame tooltip as numbers
; that can be used in calculations.
TradeFunc_GetActualValues(ActualValueLine)
{
	values := []
	
	Pos		:= 0
	; Leaves "-" in for negative values, example: "Ventor's Gamble"
	;While Pos	:= RegExMatch(ActualValueLine, "\+?(-?\d+(?: to -?\d+|\.\d+)?)", value, Pos + (StrLen(value) ? StrLen(value) : 1)) {
	While Pos	:= RegExMatch(ActualValueLine, "\+?(-?\d+(?: до -?\d+|\.\d+)?)", value, Pos + (StrLen(value) ? StrLen(value) : 1)) {
		; Formats "1 to 2" as "1-2"
		;StringReplace, Result, value1, %A_SPACE%to%A_SPACE%, -
		StringReplace, Result, value1, %A_SPACE%до%A_SPACE%, -
		values.push(Trim(RegExReplace(Result, "")))
	}
	
	return values
}

TradeFunc_CountValuesAndReplacedValues(ActualValueLine)
{
	values := []
	
	Pos		:= 0
	Count	:= 0
	; Leaves "-" in for negative values, example: "Ventor's Gamble"
	While Pos	:= RegExMatch(ActualValueLine, "\+?(-?\d+(?: to -?\d+|\.\d+)?)|\+?(-?#(?: to -?#)?)", value, Pos + (StrLen(value) ? StrLen(value) : 1)) {
	;While Pos	:= RegExMatch(ActualValueLine, "\+?(-?\d+(?: до -?\d+|\.\d+)?)|\+?(-?#(?: до -?#)?)", value, Pos + (StrLen(value) ? StrLen(value) : 1)) {
		Count++
		If (value1) {
			values.push("value")
		}
		Else If (value2) {
			values.push("replaced")
		}
	}

	return values
}


TradeFunc_GetNonUniqueModValueGivenPoeTradeMod(itemModifiers, poeTradeMod, ByRef keepOrigModName = false) {
	If (StrLen(poeTradeMod) < 1) {
		;ErrorMsg := "Mod not found on poe.trade!"
		ErrorMsg := "Мод не найден на poe.trade!"
		Return ErrorMsg
	}

	CurrValue	:= ""
	CurrValues:= []
	CurrValue := GetActualValue(itemModifiers.name_orig)
	
	If (CurrValue ~= "\d+") {
		; handle value range
		RegExMatch(CurrValue, "(\d+) ?(-|to) ?(\d+)", values)

		If (values3) {
			CurrValues.Push(values1)
			CurrValues.Push(values3)
			CurrValue := values1 " to " values3
			;ModStr := StrReplace(itemModifiers.name_orig, CurrValue, "#")
			ModStr := StrReplace(itemModifiers.name_orig_en, CurrValue, "#")
		}
		; handle single value
		Else {
			CurrValues.Push(CurrValue)
			;ModStr := StrReplace(itemModifiers.name_orig, CurrValue, "#")
			ModStr := StrReplace(itemModifiers.name_orig_en, CurrValue, "#")
		}
		; в случае если оригинальное имя не было сконвертировано
		If (itemModifiers.name_orig_en = itemModifiers.name_orig) {
			; мы не можем сравнивать оригинальную строку на русском языке с модами poeTradeMod, поэтому
			ModStr := RegExReplace(itemModifiers.name, "i)# to #", "#") ; но возможны ошибки с оригинальными именами модов
		}
		
		ModStr := StrReplace(ModStr, "+")
		; replace multi spaces with a single one
		ModStr := RegExReplace(ModStr, " +", " ")
		poeTradeMod := RegExReplace(poeTradeMod, "# ?to ? #", "#")
		poeTradeMod := StrReplace(poeTradeMod, "+")
		
		; избавляемся от "+" в модах poeTrade		
		poeTradeMod := RegExReplace(poeTradeMod, " +", " ")

		If (RegExMatch(poeTradeMod, "i).*" ModStr "$")) {
			Return CurrValues
		} Else If (RegExMatch(poeTradeMod, "i).*" itemModifiers.name_orig "$")) {
			keepOrigModName := true
			Return 
		}
	}
}

; Create custom search GUI
TradeFunc_CustomSearchGui() {
	Global
	Gui, CustomSearch:Destroy
	Gui, CustomSearch:Color, ffffff, ffffff
	customSearchItemTypes := TradeGlobals.Get("ItemTypeList")

	CustomSearchTypeList := ""
	CustomSearchBaseList := ""
	For type, bases in customSearchItemTypes {
		CustomSearchTypeList .= "|" . type
		For key, base in bases {
			CustomSearchBaseList .= "|" . base
		}
	}

	Gui, CustomSearch:Add, Edit, w480 vCustomSearchName

	; Type
	Gui, CustomSearch:Add, Text, x10 y+10, Type
	Gui, CustomSearch:Add, DropDownList, x+10 yp-4 vCustomSearchType, %CustomSearchTypeList%
	; Rarity
	Gui, CustomSearch:Add, Text, x+10 yp+4 w50, Rarity
	Gui, CustomSearch:Add, DropDownList, x+10 yp-4 w90 vCustomSearchRarity, any||Normal|Magic|Rare|Unique
	; Sockets
	Gui, CustomSearch:Add, Text, x+10 yp+4 w50, Sockets
	Gui, CustomSearch:Add, Edit, x+10 yp-4 w30 vCustomSearchSocketsMin
	Gui, CustomSearch:Add, Text, x+6 yp+4 w10, -
	Gui, CustomSearch:Add, Edit, x+0 yp-4 w30 vCustomSearchSocketsMax

	; Base
	Gui, CustomSearch:Add, Text, x10 y+10, Base
	Gui, CustomSearch:Add, DropDownList, x+10 yp-4 vCustomSearchBase, %CustomSearchBaseList%
	; Corrupted
	Gui, CustomSearch:Add, Text, x+10 yp+4 w50, Corrupted
	Gui, CustomSearch:Add, DropDownList, x+10 yp-4 w90 vCustomSearchCorrupted, either||Yes|No
	; Links
	Gui, CustomSearch:Add, Text, x+10 yp+4 w50, Links
	Gui, CustomSearch:Add, Edit, x+10 yp-4 w30 vCustomSearchLinksMin
	Gui, CustomSearch:Add, Text, x+6 yp+4 w10, -
	Gui, CustomSearch:Add, Edit, x+0 yp-4 w30 vCustomSearchLinksMax

	; Quality
	Gui, CustomSearch:Add, Text, x10 y+10 w40, Quality
	Gui, CustomSearch:Add, Edit, x+10 yp-4 w30 vCustomSearchQualityMin
	Gui, CustomSearch:Add, Text, x+6 yp+4 w10, -
	Gui, CustomSearch:Add, Edit, x+0 yp-4 w30 vCustomSearchQualityMax

	; Level/Tier
	Gui, CustomSearch:Add, Text, x175 yp+4 w40, Level/Tier
	Gui, CustomSearch:Add, Edit, x+10 yp-4 w30 vCustomSearchLevelMin
	Gui, CustomSearch:Add, Text, x+6 yp+4 w10, -
	Gui, CustomSearch:Add, Edit, x+0 yp-4 w30 vCustomSearchLevelMax

	; ItemLevel
	Gui, CustomSearch:Add, Text, x335 yp+4 w50, ItemLevel
	Gui, CustomSearch:Add, Edit, x+10 yp-4 w30 vCustomSearchItemLevelMin
	Gui, CustomSearch:Add, Text, x+6 yp+4 w10, -
	Gui, CustomSearch:Add, Edit, x+0 yp-4 w30 vCustomSearchItemLevelMax

	; Buttons
	Gui, CustomSearch:Add, Button, x10 gSubmitCustomSearch hwndCSearchBtnHwnd, &Search
	Gui, CustomSearch:Add, Button, x+10 yp+0 gOpenCustomSearchOnPoeTrade Default, Op&en on poe.trade
	Gui, CustomSearch:Add, Button, x+10 yp+0 gCloseCustomSearch, &Close
	Gui, CustomSearch:Add, Text, x+10 yp+4 cGray, (Use Alt + S/C to submit a button)

	Gui, CustomSearch:Show, w500 , Custom Search
}

TradeFunc_CreateItemPricingTestGUI() {
	Global
	Gui, PricingTest:Destroy
	Gui, PricingTest:Color, ffffff, ffffff

	Gui, PricingTest:Add, Text, x10 y10 w480, Input item information/data
	Gui, PricingTest:Add, Edit, x10 w480 y+10 R30 vPricingTestItemInput

	Gui, PricingTest:Add, Button, x10 gSubmitPricingTestDefault , &Normal
	Gui, PricingTest:Add, Button, x+10 yp+0 gSubmitPricingTestAdvanced, &Advanced
	Gui, PricingTest:Add, Button, x+10 yp+0 gOpenPricingTestOnPoeTrade, Op&en on poe.trade
	Gui, PricingTest:Add, Button, x+10 yp+0 gSubmitPricingTestWiki, Open &Wiki
	Gui, PricingTest:Add, Button, x+10 yp+0 gSubmitPricingTestParsing, Parse (&Tooltip)
	Gui, PricingTest:Add, Button, x+10 yp+0 gSubmitPricingTestParsingObject, Parse (&Object)
	Gui, PricingTest:Add, Button, x10 yp+40 gClosePricingTest, &Close
	Gui, PricingTest:Add, Text, x+10 yp+4 cGray, (Use Alt + N/A/E/W/C/T/O to submit a button)

	Gui, PricingTest:Show, w500 , Item Pricing Test
}

TradeFunc_PreparePredictedPricingContributionDetails(details, nameLength) {
	arr := []
	longest := 0
	For key, val in details {
		obj := {}
		name := val[1]
		shortened := RegExReplace(Trim(name), "^\(.*?\)")
		obj.name := shortened
		obj.name := (StrLen(shortened) > nameLength ) ? Trim(SubStr(obj.name, 1, nameLength) "...") : Trim(StrPad(obj.name, nameLength + 3))
		obj.contribution := val[2] * 100 
		obj.percentage := Trim(obj.contribution " %")
		longest := (longest > StrLen(obj.percentage)) ? longest : StrLen(obj.percentage)
		
		arr.push(obj)
	}
	For key, val in arr {
		val.percentage := StrPad(val.percentage, longest, "left", " ")
	}
	Return arr
}

TradeFunc_ShowPredictedPricingFeedbackUI(data) {
	Global
	
	;_Name := (Item.IsRare and not Item.IsMap) ? Item.Name " " Item.BaseName : Item.Name
	_Name := (Item.IsRare and not Item.IsMap) ? Item.Name_En " " Item.BaseName_En : Item.Name_En
	_NameRu := (Item.IsRare and not Item.IsMap) ? Item.Name " " Item.BaseName : Item.Name
	
	_headLine := Trim(StrReplace(_Name, "Superior", ""))
	; add corrupted tag
	If (Item.IsCorrupted) {
		_headLine .= " [Corrupted] "
	}

	; add gem quality and level
	If (Item.IsGem) {
		;_headLine := Item.Name ", Q" Item.Quality "%"
		_headLine := Item.Name_En ", Q" Item.Quality "%"
		If (Item.Level >= 16) {
			;_headLine := Item.Name ", " Item.Level "`/" Item.Quality "%"
			_headLine := Item.Name_En ", " Item.Level "`/" Item.Quality "%"
		}
	}
	; add item sockets and links
	If (ItemData.Sockets >= 5) {
		_headLine := _Name " " ItemData.Sockets "s" ItemData.Links "l"
	}
	If (showItemLevel) {
		_headLine .= ", iLvl: " iLvl
	}
	_headLine .= ", (" TradeGlobals.Get("LeagueName") ")"
	
	
	Gui, PredictedPricing:Destroy
	Gui, PredictedPricing:Color, ffffff, ffffff
	
	Gui, PredictedPricing:Margin, 10, 10

	Gui, PredictedPricing:Font, bold s8, Verdana
	;Gui, PredictedPricing:Add, Text, BackgroundTrans, Priced using machine learning algorithms.
	Gui, PredictedPricing:Add, Text, BackgroundTrans, Оценивается с использованием алгоритмов машинного обучения..
	Gui, PredictedPricing:Add, Text, BackgroundTrans x+5 yp+0 cRed, (Close with ESC)
	
	_details := TradeFunc_PreparePredictedPricingContributionDetails(data.pred_explanation, 40)
	_contributionOffset := _details.Length() * 24
	_groupBoxHeight := _contributionOffset + 83
	
	Gui, PredictedPricing:Add, GroupBox, w400 h%_groupBoxHeight% y+10 x10, Results
	;Gui, PredictedPricing:Font, norm s10, Consolas
	Gui, PredictedPricing:Font, norm s10, Consolas
	Gui, PredictedPricing:Add, Text, yp+25 x20 w380 BackgroundTrans, % _headLine
	;Gui, PredictedPricing:Font, norm bold, Consolas
	Gui, PredictedPricing:Font, norm bold, Consolas
	;Gui, PredictedPricing:Add, Text, x20 w90 y+10 BackgroundTrans, % "Price range: "
	Gui, PredictedPricing:Add, Text, x20 w90 y+10 BackgroundTrans, % "Ценовой диапазон: "
	;Gui, PredictedPricing:Font, norm, Consolas
	Gui, PredictedPricing:Font, norm, Consolas
	Gui, PredictedPricing:Add, Text, x+5 yp+0 BackgroundTrans, % Round(Trim(data.min), 2) " ~ " Round(Trim(data.max), 2) " " Trim(data.currency)
	Gui, PredictedPricing:Add, Text, x20 w300 y+10 BackgroundTrans, % "Contribution to predicted price: "	
	
	; mod importance graph
	Gui, PredictedPricing:Font, s8
	For _k, _v in _details {
		If (StrLen(_v.name)) {
			_line := _v.percentage " -> " _v.name 
			Gui, PredictedPricing:Add, Text, x30 w350 y+4 BackgroundTrans, % _line	
		}		
	}
	
	; browser url
	_url := data.added.browserUrl
	Gui, PredictedPricing:Add, Link, x245 y+12 cBlue BackgroundTrans, <a href="%_url%">Open on poeprices.info</a>
	
	Gui, PredictedPricing:Font, norm s8 italic, Verdana
	Gui, PredictedPricing:Add, Text, BackgroundTrans x15 y+20 w390, % "You can disable this GUI in favour of a simple result tooltip. Settings menu -> under 'Search' group. Or even disable this predicted search entirely."
		
	Gui, PredictedPricing:Font, bold s8, Verdana
	Gui, PredictedPricing:Add, GroupBox, w400 h230 y+20 x10, Feedback
	Gui, PredictedPricing:Font, norm, Verdana
	
	Gui, PredictedPricing:Add, Text, x20 yp+25 BackgroundTrans, You think the predicted price range is?
	Gui, PredictedPricing:Add, Progress, x16 yp+18 w2 h56 BackgroundRed hwndPredictedPricingHiddenControl1
	GuiControl, Hide, % PredictedPricingHiddenControl1
	Gui, PredictedPricing:Add, Radio, x20 yp+2 vPredictionPricingRadio1 Group BackgroundTrans, Low
	Gui, PredictedPricing:Add, Radio, x20 yp+20 vPredictionPricingRadio2 BackgroundRed, Fair
	Gui, PredictedPricing:Add, Radio, x20 yp+20 vPredictionPricingRadio3 BackgroundTrans, High
	
	Gui, PredictedPricing:Add, Text, x20 yp+30 BackgroundTrans, % "Add comment (max. 1000 characters):"
	Gui, PredictedPricing:Add, Edit, x20 yp+20 w380 r4 limit1000 vPredictedPricingComment, 
	
	Gui, PredictedPricing:Add, Text, x100 y+10 cRed hwndPredictedPricingHiddenControl2, Please select a rating first!
	GuiControl, Hide, % PredictedPricingHiddenControl2
	Gui, PredictedPricing:Add, Button, x260 w90 yp-5 gPredictedPricingSendFeedback, Send && Close
	Gui, PredictedPricing:Add, Button, x+11 w40 gPredictedPricingClose, Close
	
	Gui, PredictedPricing:Font, bold s8, Verdana
	Gui, PredictedPricing:Add, Text, x15 y+20 cGreen BackgroundTrans, % "This feature is powered by poeprices.info!"
	Gui, PredictedPricing:Font, norm, Verdana
	Gui, PredictedPricing:Add, Link, x15 y+5 cBlue BackgroundTrans, <a href="https://www.paypal.me/poeprices/5">Support them via PayPal</a>
	Gui, PredictedPricing:Add, Text, x+5 yp+0 cDefault BackgroundTrans, % "or"
	Gui, PredictedPricing:Add, Link, x+5 yp+0 cBlue BackgroundTrans, <a href="https://www.patreon.com/bePatron?u=5966037">Patreon</a>
	
	; invisible fields
	Gui, PredictedPricing:Add, Edit, x+0 yp+0 w0 h0 ReadOnly vPredictedPricingEncodedData, % data.added.encodedData
	Gui, PredictedPricing:Add, Edit, x+0 yp+0 w0 h0 ReadOnly vPredictedPricingLeague, % data.added.League
	Gui, PredictedPricing:Add, Edit, x+0 yp+0 w0 h0 ReadOnly vPredictedPricingMin, % data.min
	Gui, PredictedPricing:Add, Edit, x+0 yp+0 w0 h0 ReadOnly vPredictedPricingMax, % data.max
	Gui, PredictedPricing:Add, Edit, x+0 yp+0 w0 h0 ReadOnly vPredictedPricingCurrency, % data.currency
	
	Gui, PredictedPricing:Color, FFFFFF	
	Gui, PredictedPricing:Show, AutoSize, Predicted Item Pricing
	ControlFocus, Send && Close, Predicted Item Pricing
}

; Open Gui window to show the items variable mods, select the ones that should be used in the search and set their min/max values
TradeFunc_AdvancedPriceCheckGui(advItem, Stats, Sockets, Links, UniqueStats = "", ChangedImplicit = "") {
	;https://autohotkey.com/board/topic/9715-positioning-of-controls-a-cheat-sheet/
	Global

	;prevent advanced gui in certain cases
	If (not advItem.mods.Length() and not (ChangedImplicit or ChangedImplicit.Length())) {
		;ShowTooltip("Advanced search not available for this item.")
		If (Item.IsUnidentified) { ; отключим отображение окна расширенного поиска для неопознанного предмета
			ShowTooltip("Расширенный поиск не доступен для этого предмета, т.к. предмет неопознан.")
		} Else {
			ShowTooltip("Расширенный поиск не доступен для этого предмета.")		
		}
		Return
	}
	
	;--------------------
	; отключаем отображение окна расширенного поиска для предметов содержащих только моды, которые не могут быть включены в поиск,
	; в противном случае будет отображено пустое окно расширенного поиска без модов
	;--------------------
	conty := 0
	Loop % advItem.mods.Length() {
		hidePseudo := advItem.mods[A_Index].hideForTradeMacro ? true : false
		; allow non-variable mods if the item has variants to better identify the specific version/variant
		invalidUnique := (not advItem.mods[A_Index].isVariable and not advItem.hasVariant and advItem.IsUnique)

		If ( not (invalidUnique or hidePseudo or not StrLen(advItem.mods[A_Index].name))) {
			conty++
		} 
	}
	If (not conty) {
		ShowTooltip("Расширенный поиск не доступен для этого предмета.")
		return
	}
	;--------------------

	TradeFunc_ResetGUI()
	advItem := TradeFunc_DetermineAdvancedSearchPreSelectedMods(advItem, Stats)

	ValueRangeMin := advItem.IsUnique ? TradeOpts.AdvancedSearchModValueRangeMin : TradeOpts.AdvancedSearchModValueRangeMin / 2
	ValueRangeMax := advItem.IsUnique ? TradeOpts.AdvancedSearchModValueRangeMax : TradeOpts.AdvancedSearchModValueRangeMax / 2

	Gui, SelectModsGui:Destroy
	Gui, SelectModsGui:Color, ffffff, ffffff
	;Gui, SelectModsGui:Add, Text, x10 y12, Percentage to pre-calculate min/max values (halved for non-unique items):
	;Gui, SelectModsGui:Add, Text, x10 y12, Процентный диапазон для предварительного расчета мин./макс. значений (в два раза меньше для не-уникальных предметов):
	Gui, SelectModsGui:Add, Text, x10 y12, Диапазон мин./макс. значений (для не-уникальных предметов в два раза меньше):
	Gui, SelectModsGui:Add, Text, x+5 yp+0 cGreen, % ValueRangeMin "`% / " ValueRangeMax "`%"
	;Gui, SelectModsGui:Add, Text, x10 y+8, This calculation considers the (unique) item's mods difference between their min and max value as 100`%.
	;Gui, SelectModsGui:Add, Text, x10 y+8, Этот расчет учитывает для модов (уникальных) предметов разницу между их мин. и макс. значением как 100`%.
	Gui, SelectModsGui:Add, Text, x10 y+8, Этот расчет учитывает разницу между мин. и макс. значениями как 100`%.

	line :=
	Loop, 500 {
		line := line . "-"
	}

	; Item "nameplate" including sockets and links
	If (true) {
		;itemName := advItem.name
		itemName := advItem.name_ru
		itemNameEn := ""
		;If (not RegExMatch(advItem.name, "[а-яА-ЯёЁ ]+"))
		If (not advItem.name = advItem.name_ru)
		{
			itemNameEn := " (англ. " advItem.name ")"
		}
		;itemType := advItem.BaseName
		itemType := advItem.BaseName_Ru
		If (advItem.Rarity = 1) {
			iPic 	:= "bg-normal"
			tColor	:= "cc8c8c8"
		} Else If (advItem.Rarity = 2) {
			iPic 	:= "bg-magic"
			tColor	:= "c8787fe"
		} Else If (advItem.Rarity = 3) {
			iPic 	:= "bg-rare"
			tColor	:= "cfefe76"
		} Else If (advItem.isUnique) {
			iPic 	:= "bg-unique"
			tColor	:= "cAF5F1C"
		}
		
		image := A_ScriptDir "\resources\images\" iPic ".png"
		If (FileExist(image)) {
			Gui, SelectModsGui:Add, Picture, w800 h30 x0 yp+20, %image%
		}	
		;Gui, SelectModsGui:Add, Text, x14 yp+9 %tColor% BackgroundTrans, %itemName%
		Gui, SelectModsGui:Add, Text, x14 yp+9 %tColor% BackgroundTrans, %itemName%%itemNameEn%
		If (advItem.Rarity > 2 or advItem.isUnique) {
			Gui, SelectModsGui:Add, Text, x14 yp+0 x+5 cc8c8c8 BackgroundTrans, %itemType%
		}
		If (advItem.isRelic) {
			Gui, SelectModsGui:Add, Text, x+10 yp+0 cGreen BackgroundTrans, Relic
		}
		If (advItem.isCorrupted) {
			;Gui, SelectModsGui:Add, Text, x+10 yp+0 cD20000 BackgroundTrans, (Corrupted)
			Gui, SelectModsGui:Add, Text, x+10 yp+0 cD20000 BackgroundTrans, (Осквернено)
		}
		If (advItem.maxSockets > 0) {
			tLinksSockets := "S (" Sockets "/" advItem.maxSockets ")"
			If (advItem.maxSockets > 1) {
				tLinksSockets .= " - " "L (" Links "/" advItem.maxSockets ")"
			}
			Gui, SelectModsGui:Add, Text, x+10 yp+0 cc8c8c8 BackgroundTrans, %tLinksSockets%
		}

		Gui, SelectModsGui:Add, Text, x0 w800 yp+13 cBlack BackgroundTrans, %line%
	}

	ValueRangeMin	:= ValueRangeMin / 100
	ValueRangeMax	:= ValueRangeMax / 100

	; calculate length of first column
	modLengthMax	:= 0
	modGroupBox	:= 0
	Loop % advItem.mods.Length() {
		invalidUnique := (not advItem.mods[A_Index].isVariable and not advItem.hasVariant and advItem.IsUnique)
		If (invalidUnique) {
			continue
		}
		;tempValue := StrLen(advItem.mods[A_Index].name)
		tempValue := StrLen(advItem.mods[A_Index].name_ru)

		; увеличим поле для имени псевдо-модов
		If (advItem.mods[A_Index].type = "pseudo")
		{
			tempValue := tempValue + 6
		}

		If (modLengthMax < tempValue ) {
			modLengthMax := tempValue
			modGroupBox := modLengthMax * 6
		}
	}


	; для случая когда моды не распознаны
	If (not modLengthMax) {
		modLengthMax := 25
		modGroupBox := modLengthMax * 6
	}
	Loop % ChangedImplicit.Length() {
		tempValue := StrLen(ChangedImplicit[A_Index].param)
		If (modLengthMax < tempValue ) {
			modLengthMax := tempValue
			modGroupBox := modLengthMax * 6
		}
		modGroupBox := StrLen(ChangedImplicit.name) * 6
	}
	modGroupBox := modGroupBox + 10
	modCount := advItem.mods.Length()

	; calculate row count and mod box height
	statCount := 0
	For i, stat in Stats.Defense {
		statCount := (stat.value) ? statCount + 1 : statCount
	}
	For i, stat in Stats.Offense {
		statCount := (stat.value) ? statCount + 1 : statCount
	}
	statCount := (ChangedImplicit) ? statCount + 1 : statCount

	boxRows := modCount * 3 + statCount * 3

	modGroupYPos := 4
	;Gui, SelectModsGui:Add, Text, x14 y+%modGroupYPos% w%modGroupBox%, Mods
	Gui, SelectModsGui:Add, Text, x14 y+%modGroupYPos% w%modGroupBox%, Моды
	;Gui, SelectModsGui:Add, Text, x+10 yp+0 w90, min
	Gui, SelectModsGui:Add, Text, x+10 yp+0 w90, мин
	;Gui, SelectModsGui:Add, Text, x+10 yp+0 w45, current
	Gui, SelectModsGui:Add, Text, x+0 yp+0 w45, текущий
	;Gui, SelectModsGui:Add, Text, x+10 yp+0 w90, max
	Gui, SelectModsGui:Add, Text, x+20 yp+0 w90, макс
	;Gui, SelectModsGui:Add, Text, x+10 yp+0 w30, Select
	Gui, SelectModsGui:Add, Text, x+0 yp+0 w30, Выбрать

	line :=
	Loop, 500 {
		line := line . "-"
	}
	Gui, SelectModsGui:Add, Text, x0 w700 yp+13, %line%

	;add defense stats
	j := 1

	For i, stat in Stats.Defense {
		If (stat.value) {
			xPosMin := modGroupBox + 25
			yPosFirst := ( j = 1 ) ? 20 : 25

			If (!stat.min or !stat.max or (stat.min = stat.max) and advItem.IsUnique) {
				continue
			}

			If (stat.Name != "Block Chance") {
				stat.value   := Round(stat.value)
				statValueQ20 := Round(stat.value)
			}

			; calculate values to prefill min/max fields
			; assume the difference between the theoretical max and min value as 100%
			If (advItem.IsUnique) {
				statValueMin := Round(statValueQ20 - ((stat.max - stat.min) * valueRangeMin))
				statValueMax := Round(statValueQ20 + ((stat.max - stat.min) * valueRangeMax))
			}
			Else {
				statValueMin := Round(statValueQ20 - (statValueQ20 * valueRangeMin))
				statValueMax := Round(statValueQ20 + (statValueQ20 * valueRangeMax))
			}

			; prevent calculated values being smaller than the lowest possible min value or being higher than the highest max values
			If (advItem.IsUnique) {
				statValueMin := Floor((statValueMin < stat.min) ? stat.min : statValueMin)
				statValueMax := Floor((statValueMax > stat.max) ? stat.max : statValueMax)
			}

			If (not TradeOpts.PrefillMinValue) {
				statValueMin :=
			}
			If (not TradeOpts.PrefillMaxValue) {
				statValueMax :=
			}

			minLabelFirst  := advItem.isUnique ? "(" Floor(statValueMin) : ""
			minLabelSecond := advItem.isUnique ? ")" : ""
			maxLabelFirst  := advItem.isUnique ? "(" Floor(statValueMax) : ""
			maxLabelSecond := advItem.isUnique ? ")" : ""

			;Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%							, % "(Total Q20) " stat.name
			Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%							, % "(Total Q20) " stat.name_ru
			Gui, SelectModsGui:Add, Edit, x%xPosMin% yp-3 w40 vTradeAdvancedStatMin%j% r1	, % statValueMin
			Gui, SelectModsGui:Add, Text, x+5  yp+3       w45 cGreen					, % minLabelFirst minLabelSecond
			Gui, SelectModsGui:Add, Text, x+10 yp+0       w45 r1						, % Floor(statValueQ20)
			Gui, SelectModsGui:Add, Edit, x+10 yp-3       w40 vTradeAdvancedStatMax%j% r1	, % statValueMax
			Gui, SelectModsGui:Add, Text, x+5  yp+3       w45 cGreen					, % maxLabelFirst maxLabelSecond
			checkedState := stat.PreSelected ? "Checked" : ""
			Gui, SelectModsGui:Add, CheckBox, x+10 yp+1       vTradeAdvancedStatSelected%j% %checkedState%

			TradeAdvancedStatParam%j% := stat.name
			j++
		}
	}

	If (j > 1) {
		Gui, SelectModsGui:Add, Text, x0 w700 yp+18 cc9cacd, %line%
	}

	k := 1
	;add dmg stats
	For i, stat in Stats.Offense {
		If (stat.value) {
			xPosMin := modGroupBox + 25
			yPosFirst := ( j = 1 ) ? 20 : 25

			If (!stat.min or !stat.max or (stat.min == stat.max) and advItem.IsUnique) {
				continue
			}

			; calculate values to prefill min/max fields
			; assume the difference between the theoretical max and min value as 100%
			If (advItem.IsUnique) {
				;statValueMin := Round(stat.value - ((stat.max - stat.min) * valueRangeMin))
				; вариант на случай, когда в настройках устанавливается разница между минимальным и текущим значением в ноль, а максимальное не используется - тогда округление
				; производиться не должно, в противном случае округляется в большую сторону и предметы с максимальным роллом урона не находятся
				statValueMin := valueRangeMin ? Round(stat.value - ((stat.max - stat.min) * valueRangeMin)) : stat.value - ((stat.max - stat.min) * valueRangeMin)
				statValueMax := Round(stat.value + ((stat.max - stat.min) * valueRangeMax))
			}
			Else {
				;statValueMin := Round(stat.value - (stat.value * valueRangeMin))
				; аналогично
				statValueMin := valueRangeMin ? Round(stat.value - (stat.value * valueRangeMin)) : stat.value - (stat.value * valueRangeMin)
				statValueMax := Round(stat.value + (stat.value * valueRangeMax))
			}

			; prevent calculated values being smaller than the lowest possible min value or being higher than the highest max values
			If (advItem.IsUnique) {
				statValueMin := Floor((statValueMin < stat.min) ? stat.min : statValueMin)
				statValueMax := Floor((statValueMax > stat.max) ? stat.max : statValueMax)
			}

			If (not TradeOpts.PrefillMinValue) {
				statValueMin :=
			}
			If (not TradeOpts.PrefillMaxValue) {
				statValueMax :=
			}

			minLabelFirst  := advItem.isUnique ? "(" Floor(stat.min) : ""
			minLabelSecond := advItem.isUnique ? ")" : ""
			maxLabelFirst  := advItem.isUnique ? "(" Floor(stat.max) : ""
			maxLabelSecond := advItem.isUnique ? ")" : ""

			;Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%						  , % stat.name
			Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%						  , % stat.name_ru
			Gui, SelectModsGui:Add, Edit, x%xPosMin% yp-3 w40 vTradeAdvancedStatMin%j% r1, % statValueMin
			Gui, SelectModsGui:Add, Text, x+5  yp+3       w45 cGreen				  , % minLabelFirst minLabelSecond
			Gui, SelectModsGui:Add, Text, x+10 yp+0       w45 r1					  , % Floor(stat.value)
			Gui, SelectModsGui:Add, Edit, x+10 yp-3       w40 vTradeAdvancedStatMax%j% r1, % statValueMax
			Gui, SelectModsGui:Add, Text, x+5  yp+3       w45 cGreen				  , % maxLabelFirst maxLabelSecond
			checkedState := stat.PreSelected ? "Checked" : ""
			Gui, SelectModsGui:Add, CheckBox, x+10 yp+1       vTradeAdvancedStatSelected%j% %checkedState%

			TradeAdvancedStatParam%j% := stat.name
			j++
			TradeAdvancedStatsCount := j
			k++
		}
	}

	If (k > 1) {
		Gui, SelectModsGui:Add, Text, x0 w700 yp+18 cc9cacd, %line%
	}

	e := 0
	; Enchantment or Corrupted Implicit
	If (ChangedImplicit.Length()) {
		xPosMin := modGroupBox + 25
		yPosFirst := 20 ; ( j > 1 ) ? 20 : 30
		xPosMin := xPosMin + 40 + 5 + 45 + 10 + 45 + 10 + 40 + 5 + 45 + 10 ; edit/text field widths and offsets	
		
		For key, val in ChangedImplicit {
			e++
			modValueMin := val.min
			modValueMax := val.max
			displayName := val.name			
			
			If (key > 1) {
				yPosFirst := 20
			}
			
			Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%, % displayName
			Gui, SelectModsGui:Add, CheckBox, x%xPosMin% yp+1 vTradeAdvancedSelected%e%

			TradeAdvancedModMin%e% 		:= val.min
			TradeAdvancedModMax%e% 		:= val.max
			TradeAdvancedParam%e%  		:= val.param
			TradeAdvancedIsImplicit%e%	:= true	
			}
	}
	TradeAdvancedImplicitCount := e

	If (ChangedImplicit) {
		Gui, SelectModsGui:Add, Text, x0 w700 yp+18 cc9cacd, %line%
	}

	; add mods
	l := 1
	p := 1
	TradeAdvancedNormalModCount := 0
	ModNotFound := false
	PreCheckNormalMods := TradeOpts.AdvancedSearchCheckMods ? "Checked" : ""
	Loop % advItem.mods.Length() {
		hidePseudo := advItem.mods[A_Index].hideForTradeMacro ? true : false
		; allow non-variable mods if the item has variants to better identify the specific version/variant
		invalidUnique := (not advItem.mods[A_Index].isVariable and not advItem.hasVariant and advItem.IsUnique)
		If (invalidUnique or hidePseudo or not StrLen(advItem.mods[A_Index].name)) {
			continue
		}
		xPosMin := modGroupBox + 25

		; matches "1 to #" in for example "adds 1 to # lightning damage"
		; may be replaced later with original name
		If (RegExMatch(advItem.mods[A_Index].name, "i)Adds (\d+(.\d+)?) to #.*Damage", match)) {
			;displayName := RegExReplace(advItem.mods[A_Index].name, "\d+(.\d+)? to #", "#")
			displayName := RegExReplace(advItem.mods[A_Index].name_ru, "от # до #", "#")
			staticValue := match1
		}
		Else {
			;displayName := advItem.mods[A_Index].name
			displayName := advItem.mods[A_Index].name_ru
			displayName := RegExReplace(displayName, "i)от # до #", "#")
			staticValue :=
		}
		; оригинальный код здесь работает некорректно - не проходит проверка ">1" и дальнейший код работает с учетом этой ошибки ;)
		If (advItem.mods[A_Index].ranges.Length() > 1) {
			theoreticalMinValue := advItem.mods[A_Index].ranges[1][1]
			theoreticalMaxValue := advItem.mods[A_Index].ranges[2][2]
		}
		Else {
			; use staticValue to create 2 ranges; for example (1 to 50) to (1 to 70) instead of only having 1 to (50 to 70)
			If (staticValue) {
				theoreticalMinValue := staticValue
				theoreticalMaxValue := advItem.mods[A_Index].ranges[1][2]
			}
			Else {
				theoreticalMinValue := advItem.mods[A_Index].ranges[1][1] ? advItem.mods[A_Index].ranges[1][1] : 0
				theoreticalMaxValue := advItem.mods[A_Index].ranges[1][2] ? advItem.mods[A_Index].ranges[1][2] : 0
			}
		}

		SetFormat, FloatFast, 5.2
		ErrorMsg :=
		If (advItem.IsUnique) {
			;modValues := TradeFunc_GetModValueGivenPoeTradeMod(ItemData.Affixes, advItem.mods[A_Index].param)
			modValues := TradeFunc_GetModValueGivenPoeTradeMod(ItemData.Affixes, advItem.mods[A_Index].param, advItem.mods_const_ru)
			; извлекаем значение имплицита
			If (advItem.mods[A_Index].IsImplicit and advItem.mods[A_Index].isVariable) {
				;modValues := TradeFunc_GetModValueGivenPoeTradeMod(advItem.mods[A_Index].name_orig_item, advItem.mods[A_Index].param, advItem.mods[A_Index].name_ru, advItem.mods[A_Index].IsNameRuConst)
				modValues := TradeFunc_GetModValueGivenPoeTradeMod(advItem.mods[A_Index].name_orig_item, advItem.mods[A_Index].param, advItem.mods_const_ru)
			}
		}
		Else {
			useOriginalModName := false
			modValues := TradeFunc_GetNonUniqueModValueGivenPoeTradeMod(advItem.mods[A_Index], advItem.mods[A_Index].param, useOriginalModName)
			If (useOriginalModName) {
				displayName := advItem.mods[A_Index].name_orig
			}
		}
		
		If (modValues.Length() > 1) {
			modValue := (modValues[1] + modValues[2]) / 2
		}
		Else {
			If (StrLen(modValues) > 10) {
				; error msg
				ErrorMsg := modValues
				ModNotFound := true
			}
			modValue := modValues[1]
		}

		switchValue :=
		; make sure that the lower vaule is always min (reduced mana cost of minion skills)
		If (StrLen(theoreticalMinValue) and StrLen(theoreticalMaxValue)) {
			If (theoreticalMinValue > theoreticalMaxValue) {
				switchValue		:= theoreticalMinValue
				theoreticalMinValue := theoreticalMaxValue
				theoreticalMaxValue := switchValue
			}
		}

		If (advItem.mods[A_Index].isVariable or not advItem.IsUnique) {	
			; calculate values to prefill min/max fields
			; assume the difference between the theoretical max and min value as 100%
			If (advItem.mods[A_Index].ranges[1]) {
				If (not StrLen(switchValue)) {
					modValueMin := modValue - ((theoreticalMaxValue - theoreticalMinValue) * valueRangeMin)
					modValueMax := modValue + ((theoreticalMaxValue - theoreticalMinValue) * valueRangeMax)
				} Else {
					modValueMin := modValue - ((theoreticalMaxValue - theoreticalMinValue) * valueRangeMin)
					modValueMax := modValue + ((theoreticalMaxValue - theoreticalMinValue) * valueRangeMax)
				}
			} Else {
				modValueMin := modValue - (modValue * valueRangeMin)
				modValueMax := modValue + (modValue * valueRangeMax)
			}

			; floor/Ceil values only if greater than 2, in case of leech/regen mods, use Abs() to support negative numbers
			modValueMin := (Abs(modValueMin) > 2) ? Floor(modValueMin) : modValueMin
			modValueMax := (Abs(modValueMax) > 2) ? Ceil(modValueMax) : modValueMax

			; prevent calculated values being smaller than the lowest possible min value or being higher than the highest max values
			If (advItem.mods[A_Index].ranges[1]) {
				modValueMin := TradeUtils.ZeroTrim((modValueMin < theoreticalMinValue and not staticValue) ? theoreticalMinValue : modValueMin)
				modValueMax := TradeUtils.ZeroTrim((modValueMax > theoreticalMaxValue) ? theoreticalMaxValue : modValueMax)
			}

			; create Labels to show unique items min/max rolls
			If (advItem.mods[A_Index].ranges[2][1]) {
				minLF := "(" TradeUtils.ZeroTrim((advItem.mods[A_Index].ranges[1][1] + advItem.mods[A_Index].ranges[1][2]) / 2) ")"
				maxLF := "(" TradeUtils.ZeroTrim((advItem.mods[A_Index].ranges[2][1] + advItem.mods[A_Index].ranges[2][2]) / 2) ")"
			}
			Else If (staticValue) {
				minLF := "(" TradeUtils.ZeroTrim((staticValue + advItem.mods[A_Index].ranges[1][1]) / 2) ")"
				maxLF := "(" TradeUtils.ZeroTrim((staticValue + advItem.mods[A_Index].ranges[1][2]) / 2) ")"
			}
			Else {
				minLF := "(" TradeUtils.ZeroTrim(advItem.mods[A_Index].ranges[1][1]) ")"
				maxLF := "(" TradeUtils.ZeroTrim(advItem.mods[A_Index].ranges[1][2]) ")"
			}
			
			; make sure that the lower value is always min (reduced mana cost of minion skills)
			If (not StrLen(switchValue)) {
				minLabelFirst	:= minLF
				maxLabelFirst	:= maxLF
			} Else {
				minLabelFirst	:= maxLF
				maxLabelFirst	:= minLF
			}
		}
		Else {
			modValueMin := ""
			modValueMax := ""
		}

		If (not TradeOpts.PrefillMinValue or ErrorMsg) {
			modValueMin :=
		}
		If (not TradeOpts.PrefillMaxValue or ErrorMsg) {
			modValueMax :=
		}

		yPosFirst := ( l > 1 ) ? 25 : 20
		; increment index if the item has an enchantment
		index := A_Index + e

		isPseudo := advItem.mods[A_Index].type = "pseudo" ? true : false
		If (isPseudo) {
			If (p = 1) {
				; add line if first pseudo mod
				Gui, SelectModsGui:Add, Text, x0 w700 y+5 cc9cacd, %line%
				yPosFirst := 20
			}
			p++
			; change color if pseudo mod
			color := "cGray"
		}
		Else {
			TradeAdvancedNormalModCount++
		}

		state := modValue and (advItem.mods[A_Index].isVariable or not advItem.IsUnique) ? 0 : 1

		;Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%  %color% vTradeAdvancedModName%index%			, % isPseudo ? "(pseudo) " . displayName : displayName
		Gui, SelectModsGui:Add, Text, x15 yp+%yPosFirst%  %color% vTradeAdvancedModName%index%			, % isPseudo ? "(псевдо) " . displayName : displayName
		Gui, SelectModsGui:Add, Edit, x%xPosMin% yp-3 w40 vTradeAdvancedModMin%index% r1 Disabled%state% 	, % modValueMin
		Gui, SelectModsGui:Add, Text, x+5  yp+3       w45 cGreen                  		 				, % (advItem.mods[A_Index].ranges[1]) ? minLabelFirst : ""
		Gui, SelectModsGui:Add, Text, x+10 yp+0       w45 r1     		                         		, % TradeUtils.ZeroTrim(modValue)
		Gui, SelectModsGui:Add, Edit, x+10 yp-3       w40 vTradeAdvancedModMax%index% r1 Disabled%state% 	, % modValueMax
		Gui, SelectModsGui:Add, Text, x+5  yp+3       w45 cGreen 			                       		, % (advItem.mods[A_Index].ranges[1]) ? maxLabelFirst : ""
		checkEnabled := ErrorMsg ? 0 : 1
		; pre-select mods according to the options in the settings menu
		If (checkEnabled) {
			checkedState := (advItem.mods[A_Index].PreSelected or TradeOpts.AdvancedSearchCheckMods or (not advItem.mods[A_Index].isVariable and advItem.IsUnique)) ? "Checked" : ""
			Gui, SelectModsGui:Add, CheckBox, x+10 yp+1 %checkedState% vTradeAdvancedSelected%index%
		}
		Else {
			Gui, SelectModsGui:Add, Picture, x+10 yp+1 hwndErrorPic 0x0100, %A_ScriptDir%\resources\images\error.png
		}
		
		; отделим имплицит линией
		If (advItem.mods[A_Index].IsImplicit) {
			Gui, SelectModsGui:Add, Text, x0 w700 yp+18 cc9cacd, %line%
		}

		color := "cBlack"

		TradeAdvancedParam%index% := advItem.mods[A_Index].param
		l++
		TradeAdvancedModsCount := l
	}
	
	/*
		Prepare some special options
		*/
		
	abyssalSockets := 0	
	Loop % advItem.mods.Length() {
		If (advItem.mods[A_Index].showModAsSeperateOption) {
			If (RegExMatch(advItem.mods[A_Index].name, "i)^Has # Abyssal (Socket|Sockets)$")) {
				abyssalSockets := advItem.mods[A_Index].values[1]
			}
		}
	}
	
	m := 1

	; Links and Sockets
	If (advItem.mods.Length()) {
		Gui, SelectModsGui:Add, Text, x0 w700 y+5 cc9cacd, %line%
	}
	
	If (abyssalSockets) {
		;Gui, SelectModsGui:Add, CheckBox, x15 y+10 vTradeAdvancedUseAbyssalSockets Checked, % "Abyssal Sockets: " abyssalSockets
		Gui, SelectModsGui:Add, CheckBox, x15 y+10 vTradeAdvancedUseAbyssalSockets Checked, % "Гнезд Бездны: " abyssalSockets
		Gui, SelectModsGui:Add, Edit, x+0 yp+0 w0 vTradeAdvancedAbyssalSockets, % abyssalSockets
	}

	If (Sockets >= 5) {
		m++
		;text := "Sockets: " . Trim(Sockets)
		text := "Гнезд: " . Trim(Sockets)
		If (Links >= 5) {
			Gui, SelectModsGui:Add, CheckBox, x15 y+10 vTradeAdvancedUseSockets, % text
		} Else {
			Gui, SelectModsGui:Add, CheckBox, x15 y+10 vTradeAdvancedUseSockets Checked, % text
		}
	}
	Else If (Sockets <= 4 and advItem.maxSockets = 4) {
		m++
		;text := "Sockets (max): 4"
		text := "Гнезд (макс): 4"
		Gui, SelectModsGui:Add, CheckBox, x15 y+10 vTradeAdvancedUseSocketsMaxFour, % text
	}
	Else If (Sockets <= 3 and advItem.maxSockets = 3) {
		m++
		;text := "Sockets (max): 3"
		text := "Гнезд (макс): 3"
		Gui, SelectModsGui:Add, CheckBox, x15 y+10 vTradeAdvancedUseSocketsMaxThree, % text
	}

	If (Links >= 5) {
		offset := (m > 1 ) ? "+10" : "15"
		m++
		;text := "Links:  " . Trim(Links)
		text := "Связи:  " . Trim(Links)
		Gui, SelectModsGui:Add, CheckBox, x%offset% yp+0 vTradeAdvancedUseLinks Checked, % text
	}
	Else If (Links <= 4 and advItem.maxSockets = 4) {
		offset := (m > 1 ) ? "+10" : "15"
		m++
		;text := "Links (max): 4"
		text := "Связи (макс): 4"
		Gui, SelectModsGui:Add, CheckBox, x%offset% yp+0 vTradeAdvancedUseLinksMaxFour, % text
	}
	Else If (Links <= 3 and advItem.maxSockets = 3) {
		offset := (m > 1 ) ? "+10" : "15"
		m++
		;text := "Links (max): 3"
		text := "Связи (макс): 3"
		Gui, SelectModsGui:Add, CheckBox, x%offset% yp+0 vTradeAdvancedUseLinksMaxThree, % text
	}

	; ilvl
	offsetX := (m = 1) ? "15" : "+10"
	offsetY := (m = 1) ? "20" : "+0"
	iLvlCheckState := ""
	iLvlValue		:= ""
	If (advItem.specialBase or advItem.IsBeast) {
		iLvlCheckState := TradeOpts.AdvancedSearchCheckILVL ? "Checked" : ""
		iLvlValue := advItem.iLvl ; use itemlevel to fill the box in any case (elder/shaper)
	}
	Else If (TradeOpts.AdvancedSearchCheckILVL) {
		iLvlCheckState := "Checked"
		iLvlValue		:= advItem.iLvl
	}
	Else {
		If (advItem.maxSockets > 1) {
			If (advItem.iLvl >= 50 and advItem.maxSockets > 5) {
				iLvlValue := 50
			} Else If (advItem.iLvl >= 35 and advItem.maxSockets > 4) {
				iLvlValue := 35
			} Else If (advItem.iLvl >= 25 and advItem.maxSockets > 3) {
				iLvlValue := 25
			} Else If (advItem.iLvl >= 2 and advItem.maxSockets > 2) {
				iLvlValue := 2
			}
			iLvlCheckState := "Checked"
		}
		Else {
			iLvlValue := advItem.iLvl
		}
	}
	;Gui, SelectModsGui:Add, CheckBox, x%offsetX% yp%offsetY% vTradeAdvancedSelectedILvl %iLvlCheckState%, % "iLvl (min)"
	Gui, SelectModsGui:Add, CheckBox, x%offsetX% yp%offsetY% vTradeAdvancedSelectedILvl %iLvlCheckState%, % "iLvl (мин)"
	Gui, SelectModsGui:Add, Edit    , x+1 yp-3 w30 vTradeAdvancedMinILvl , % iLvlValue

	; item base
	If (advItem.IsBeast) {
		baseCheckState := "Checked"
		;Gui, SelectModsGui:Add, CheckBox, x+15 yp+3 vTradeAdvancedSelectedItemBase %baseCheckState%, % "Use Genus (" advItem.BeastData.Genus ")"
		Gui, SelectModsGui:Add, CheckBox, x+15 yp+3 vTradeAdvancedSelectedItemBase %baseCheckState%, % "Использовать Род (" advItem.BeastData.Genus ")"
	} Else {
		baseCheckState := TradeOpts.AdvancedSearchCheckBase ? "Checked" : ""
		;Gui, SelectModsGui:Add, CheckBox, x+15 yp+3 vTradeAdvancedSelectedItemBase %baseCheckState%, % "Use Item Base"
		Gui, SelectModsGui:Add, CheckBox, x+15 yp+3 vTradeAdvancedSelectedItemBase %baseCheckState%, % "Использовать базу предмета"
	}

	If (advItem.specialBase) {
		;Gui, SelectModsGui:Add, CheckBox, x+15 yp+0 vTradeAdvancedSelectedSpecialBase Checked, % advItem.specialBase 
		Gui, SelectModsGui:Add, CheckBox, x+15 yp+0 vTradeAdvancedSelectedSpecialBase Checked, % advItem.specialBaseRu
	}

	Item.UsedInSearch.SearchType := "Advanced"
	; closes this window and starts the search
	offset := (m > 1) ? "+25" : "+15"
	;Gui, SelectModsGui:Add, Button, x10 y%offset% gAdvancedPriceCheckSearch hwndSearchBtnHwnd Default, &Search
	Gui, SelectModsGui:Add, Button, x10 y%offset% gAdvancedPriceCheckSearch hwndSearchBtnHwnd Default, Пои&ск

	; open search on poe.trade instead
	;Gui, SelectModsGui:Add, Button, x+10 yp+0 gAdvancedOpenSearchOnPoeTrade, Op&en on poe.trade
	Gui, SelectModsGui:Add, Button, x+10 yp+0 gAdvancedOpenSearchOnPoeTrade, От&крыть на poe.trade

	; override online state
	;Gui, SelectModsGui:Add, CheckBox, x+10 yp+5 vTradeAdvancedOverrideOnlineState, % "Show offline results"
	Gui, SelectModsGui:Add, CheckBox, x+10 yp+5 vTradeAdvancedOverrideOnlineState, % "Показ. офлайн-результ."
	
	; защита на определенные случаи вариантов предметов, когда xPosMin пустой
	If (not xPosMin) {
		xPosMin := 0
	}
	
	; add some widths and margins to align the checkox with the others on the right side
	RightPos := xPosMin + 40 + 5 + 45 + 10 + 45 + 10 + 40 + 5 + 45 + 10
	;RightPosText := RightPos - 100
	RightPosText := RightPos - 117
	;Gui, SelectModsGui:Add, Text, x%RightPosText% yp+0, Check normal mods
	Gui, SelectModsGui:Add, Text, x%RightPosText% yp+0, Выбрать обычн. моды
	Gui, SelectModsGui:Add, CheckBox, x%RightPos% yp+0 %PreCheckNormalMods% vTradeAdvancedSelectedCheckAllMods gAdvancedCheckAllMods, % ""

	If (ModNotFound) {
		Gui, SelectModsGui:Add, Picture, x10 y+16, %A_ScriptDir%\resources\images\error.png
		;Gui, SelectModsGui:Add, Text, x+10 yp+2 cRed,One or more mods couldn't be found on poe.trade
		Gui, SelectModsGui:Add, Text, x+10 yp+2 cRed,Один или несколько модов не найдены на poe.trade
	}
	Gui, SelectModsGui:Add, Text, x10 y+14 cGray, (Используйте Alt + С / К для нажатия кнопок)
	;Gui, SelectModsGui:Add, Text, x10 y+14 cGreen, Please support poe.trade by disabling adblock
	Gui, SelectModsGui:Add, Text, x10 y+8 cGreen, Пожалуйста, поддержите poe.trade, отключив adblock (блокировку рекламы)
	;Gui, SelectModsGui:Add, Link, x+5 yp+0 cBlue, <a href="https://poe.trade">visit</a>
	Gui, SelectModsGui:Add, Link, x+5 yp+0 cBlue, <a href="https://poe.trade">посетить</a>
	;Gui, SelectModsGui:Add, Text, x+10 yp+0 cGray, (Use Alt + S/E to submit a button)	
	;Gui, SelectModsGui:Add, Link, x10 yp+18 cBlue, <a href="https://poe-trademacro.github.io/SupportTradeMacro/">Support PoE-TradeMacro by spending some of your CPU usage.</a>
	Gui, SelectModsGui:Add, Link, x10 yp+18 cBlue, <a href="https://poe-trademacro.github.io/SupportTradeMacro/">Поддержать PoE-TradeMacro, предоставив в пользование часть ресурсов Вашего CPU.</a>

	windowWidth := modGroupBox + 40 + 5 + 45 + 10 + 45 + 10 + 40 + 5 + 45 + 10 + 65
	windowWidth := (windowWidth > 510) ? windowWidth : 510
	AdvancedSearchLeagueDisplay := TradeGlobals.Get("LeagueName")
	;Gui, SelectModsGui:Show, w%windowWidth% , Select Mods to include in Search - %AdvancedSearchLeagueDisplay%
	Gui, SelectModsGui:Show, w%windowWidth% , Выберите моды для включения в поиск - %AdvancedSearchLeagueDisplay%
}

TradeFunc_DetermineAdvancedSearchPreSelectedMods(advItem, ByRef Stats) {
	Global TradeOpts

	FlatMaxLifeSelected			:= 0
	PercentMaxLifeSelected		:= 0
	TotalEnergyShieldSelected	:= 0
	FlatEnergyShieldSelected		:= 0
	PercentEnergyShieldSelected	:= 0

	; make sure that normal mods aren't marked as selected if they are included in existing pseudo mods, for example life -> total life
	; and that mods aren't selected if they are included in defense stats, for example energy shield
	If (Stats.Defense.TotalEnergyShield.Value > 0 and TradeOpts.AdvancedSearchCheckTotalES) {
		Stats.Defense.TotalEnergyShield.PreSelected := 1
		TotalEnergyShieldSelected := 1
	}

	If (Stats.Offense.EleDps.Value > 0 and TradeOpts.AdvancedSearchCheckEDPS) {
		Stats.Offense.EleDps.PreSelected	:= 1
	}
	If (Stats.Offense.PhysDps.Value > 0 and TradeOpts.AdvancedSearchCheckPDPS) {
		Stats.Offense.PhysDps.PreSelected	:= 1
	}

	i := advItem.mods.maxIndex()
	Loop, % i {
		FlatLife		:= RegExMatch(advItem.mods[i].name, "i).* to maximum Life$")
		PercentLife	:= RegExMatch(advItem.mods[i].name, "i).* increased maximum Life$")
		FlatES		:= RegExMatch(advItem.mods[i].name, "i).* to maximum Energy Shield$")
		PercentES		:= RegExMatch(advItem.mods[i].name, "i).* increased maximum Energy Shield$")
		EleRes		:= RegExMatch(advItem.mods[i].name, "i).* total Elemental Resistance$")

		If (FlatLife and TradeOpts.AdvancedSearchCheckTotalLife and not FlatMaxLifeSelected) {
			advItem.mods[i].PreSelected	:= 1
			FlatMaxLifeSelected			:= 1
		}
		If (PercentLife and TradeOpts.AdvancedSearchCheckTotalLife and not PercentMaxLifeSelected) {
			advItem.mods[i].PreSelected	:= 1
			PercentMaxLifeSelected		:= 1
		}

		; only select flat ES/percent ES when no defense stat is present (for example on rings, belts, jewels, amulets)
		If ((FlatES or PercentES) and TradeOpts.AdvancedSearchCheckES and not TotalEnergyShieldSelected) {
			advItem.mods[i].PreSelected		:= 1
			If (FlatES) {
				FlatEnergyShieldSelected		:= 1
			} Else {
				PercentEnergyShieldSelected	:= 1
			}
		}

		If (EleRes and TradeOpts.AdvancedSearchCheckTotalEleRes) {
			advItem.mods[i].PreSelected	:= 1
		}

		i--
	}

	Return advItem
}

AdvancedCheckAllMods:
	ImplicitCount := TradeAdvancedImplicitCount
	EmptySelect := 0
	GuiControlGet, IsChecked, SelectModsGui:, TradeAdvancedSelectedCheckAllMods
	Loop, 20 {
		If ((A_Index) > (TradeAdvancedNormalModCount + ImplicitCount + EmptySelect) or (ImplicitCount = A_Index)) {
			continue
		}
		Else {
			state := IsChecked ? 1 : 0
			GuiControl, SelectModsGui:, TradeAdvancedSelected%A_Index%, %state%
			GuiControlGet, TempModName, SelectModsGui:, TradeAdvancedModName%A_Index%
			If (StrLen(TempModName) < 1) {
				EmptySelect++
			}
		}
	}
Return

AdvancedPriceCheckSearch:
	TradeFunc_HandleGuiSubmit()
	TradeFunc_Main(false, false, true)
return

AdvancedOpenSearchOnPoeTrade:
	TradeFunc_HandleGuiSubmit()
	TradeFunc_Main(true, false, true)
return

TradeFunc_ResetGUI() {
	Global
	Loop {
		If (TradeAdvancedModMin%A_Index% or TradeAdvancedParam%A_Index%) {
			TradeAdvancedParam%A_Index%	:=
			TradeAdvancedSelected%A_Index%:=
			TradeAdvancedModMin%A_Index%	:=
			TradeAdvancedModMax%A_Index%	:=
			TradeAdvancedModName%A_Index%	:=
		}
		Else If (A_Index >= 20) {
			TradeAdvancedStatCount :=
			break
		}
	}

	Loop {
		If (TradeAdvancedStatMin%A_Index% or TradeAdvancedStatParam%A_Index%) {
			TradeAdvancedStatParam%A_Index%	:=
			TradeAdvancedStatSelected%A_Index%	:=
			TradeAdvancedStatMin%A_Index%		:=
			TradeAdvancedStatMax%A_Index%		:=
		}
		Else If (A_Index >= 20) {
			TradeAdvancedModCount :=
			break
		}
	}

	TradeAdvancedUseSockets			:=
	TradeAdvancedUseLinks			:=
	TradeAdvancedUseSocketsMaxThree	:=
	TradeAdvancedUseLinksMaxThree		:=
	TradeAdvancedUseSocketsMaxFour	:=
	TradeAdvancedUseLinksMaxFour		:=
	TradeAdvancedSelectedILvl		:=
	TradeAdvancedMinILvl			:=
	TradeAdvancedSelectedItemBase		:=
	TradeAdvancedSelectedSpecialBase	:=
	TradeAdvancedSelectedCheckAllMods	:=
	TradeAdvancedImplicitCount		:=
	TradeAdvancedNormalModCount		:=
	TradeAdvancedOverrideOnlineState	:=
	TradeAdvancedUseAbyssalSockets	:=
	TradeAdvancedAbyssalSockets		:=

	TradeGlobals.Set("AdvancedPriceCheckItem", {})
}

TradeFunc_HandleGuiSubmit() {
	Global

	Gui, SelectModsGui:Submit
	newItem := {mods:[], stats:[], UsedInSearch : {}}
	mods  := []
	stats := []

	Loop {
		mod := {param:"",selected:"",min:"",max:""}
		If (TradeAdvancedSelected%A_Index%) {
			mod.param    := TradeAdvancedParam%A_Index%
			mod.selected := TradeAdvancedSelected%A_Index%
			mod.min      := TradeAdvancedModMin%A_Index%
			mod.max      := TradeAdvancedModMax%A_Index%
			; has Enchantment
			If (RegExMatch(TradeAdvancedParam%A_Index%, "i)enchant") and mod.selected) {
				newItem.UsedInSearch.Enchantment := true
			}
			; has Corrupted Implicit
			Else If (TradeAdvancedIsImplicit%A_Index% and mod.selected) {
				newItem.UsedInSearch.CorruptedMod := true
			}

			mods.Push(mod)
		}
		Else If (A_Index >= 20) {
			break
		}
	}

	Loop {
		stat := {param:"",selected:"",min:"",max:""}
		If (TradeAdvancedStatMin%A_Index% or TradeAdvancedStatMax%A_Index%) {
			stat.param    := TradeAdvancedStatParam%A_Index%
			stat.selected := TradeAdvancedStatSelected%A_Index%
			stat.min      := TradeAdvancedStatMin%A_Index%
			stat.max      := TradeAdvancedStatMax%A_Index%

			stats.Push(stat)
		}
		Else If (A_Index >= 20) {
			break
		}
	}

	newItem.mods				:= mods
	newItem.stats				:= stats
	newItem.useSockets			:= TradeAdvancedUseSockets
	newItem.useLinks			:= TradeAdvancedUseLinks
	newItem.useSocketsMaxThree	:= TradeAdvancedUseSocketsMaxThree
	newItem.useLinksMaxThree		:= TradeAdvancedUseLinksMaxThree
	newItem.useSocketsMaxFour	:= TradeAdvancedUseSocketsMaxFour
	newItem.useLinksMaxFour		:= TradeAdvancedUseLinksMaxFour
	newItem.useIlvl			:= TradeAdvancedSelectedILvl
	newItem.minIlvl			:= TradeAdvancedMinILvl
	newItem.useBase			:= TradeAdvancedSelectedItemBase
	newItem.useSpecialBase		:= TradeAdvancedSelectedSpecialBase
	newItem.onlineOverride		:= TradeAdvancedOverrideOnlineState
	newItem.useAbyssalSockets 	:= TradeAdvancedUseAbyssalSockets
	newItem.abyssalSockets		:= TradeAdvancedAbyssalSockets

	TradeGlobals.Set("AdvancedPriceCheckItem", newItem)
	Gui, SelectModsGui:Destroy
	TradeFunc_ActivatePoeWindow()
}

class TradeUtils {
	; also see https://github.com/ahkscript/awesome-AutoHotkey
	; and https://autohotkey.com/boards/viewtopic.php?f=6&t=53
	IsArray(obj) {
		Return !!obj.MaxIndex()
	}
	
	; careful : circular references crash the script.
	; https://autohotkey.com/board/topic/69542-objectclone-doesnt-create-a-copy-keeps-references/#entry440561
	ObjFullyClone(obj)
	{
		nobj := obj.Clone()
		for k,v in nobj
			if IsObject(v)
				nobj[k] := A_ThisFunc.(v)
		return nobj
	}

	; Trim trailing zeros from numbers
	ZeroTrim(number) {
		RegExMatch(number, "(\d+)\.?(.+)?", match)
		If (StrLen(match2) < 1) {
			Return number
		} Else {
			trail := RegExReplace(match2, "0+$", "")
			number := (StrLen(trail) > 0) ? match1 "." trail : match1
			Return number
		}
	}

	IsInArray(el, array) {
		For i, element in array {
			If (el = "") {
				Return false
			}
			If (element = el) {
				Return true
			}
		}
		Return false
	}

	CleanUp(in) {
		StringReplace, in, in, `n,, All
		StringReplace, in, in, `r,, All
		Return Trim(in)
	}


	Arr_concatenate(p*) {
		res := Object()
		For each, obj in p
			For each, value in obj
				res.Insert(value)
		return res
	}

	; ------------------------------------------------------------------------------------------------------------------ ;
	; TradeUtils.StrX Function for parsing html, see simple example usage at https://gist.github.com/thirdy/9cac93ec7fd947971721c7bdde079f94
	; ------------------------------------------------------------------------------------------------------------------ ;

	; Cleanup TradeUtils.StrX Function and Google Example from https://autohotkey.com/board/topic/47368-TradeUtils.StrX-auto-parser-for-xml-html
	; By SKAN

	;1 ) H = HayStack. The "Source Text"
	;2 ) BS = BeginStr. Pass a String that will result at the left extreme of Resultant String
	;3 ) BO = BeginOffset.
	; Number of Characters to omit from the left extreme of "Source Text" while searching for BeginStr
	; Pass a 0 to search in reverse ( from right-to-left ) in "Source Text"
	; If you intend to call TradeUtils.StrX() from a Loop, pass the same variable used as 8th Parameter, which will simplify the parsing process.
	;4 ) BT = BeginTrim.
	; Number of characters to trim on the left extreme of Resultant String
	; Pass the String length of BeginStr If you want to omit it from Resultant String
	; Pass a Negative value If you want to expand the left extreme of Resultant String
	;5 ) ES = EndStr. Pass a String that will result at the right extreme of Resultant String
	;6 ) EO = EndOffset.
	; Can be only True or False.
	; If False, EndStr will be searched from the end of Source Text.
	; If True, search will be conducted from the search result offset of BeginStr or from offset 1 whichever is applicable.
	;7 ) ET = EndTrim.
	; Number of characters to trim on the right extreme of Resultant String
	; Pass the String length of EndStr If you want to omit it from Resultant String
	; Pass a Negative value If you want to expand the right extreme of Resultant String
	;8 ) NextOffset : A name of ByRef Variable that will be updated by TradeUtils.StrX() with the current offset, You may pass the same variable as Parameter 3, to simplify data parsing in a loop

	StrX(H,  BS="",BO=0,BT=1,   ES="",EO=0,ET=1,  ByRef N="" )
	{
		Return SubStr(H,P:=(((Z:=StrLen(ES))+(X:=StrLen(H))+StrLen(BS)-Z-X)?((T:=InStr(H,BS,0,((BO
            <0)?(1):(BO))))?(T+BT):(X+1)):(1)),(N:=P+((Z)?((T:=InStr(H,ES,0,((EO)?(P+1):(0))))?(T-P+Z
		+(0-ET)):(X+P)):(X)))-P)
	}
	; v1.0-196c 21-Nov-2009 www.autohotkey.com/forum/topic51354.html
	; | by Skan | 19-Nov-2009


	; ------------------------------------------------------------------------------------------------------------------ ;
	; TradeUtils.HtmlParseItemData, alternative Function for parsing html with simple regex
	; ------------------------------------------------------------------------------------------------------------------ ;

	HtmlParseItemData(ByRef html, regex, ByRef htmlOut = "", leftOffset = 0) {
		; last capture group captures the remaining string
		Pos := RegExMatch(html, "isO)" . regex . "(.*)", match)

		If (match.count() >= 2) {
			htmlOut := match[match.count()]
		}
		If (Pos and leftOffset) {
			offset  := SubStr(html, Pos - leftOffset, leftOffset)
			htmlOut := offset . htmlOut
		}
		Return match.value(1)
	}

	UriEncode(Uri, Enc = "UTF-8")
	{
		TradeUtils.StrPutVar(Uri, Var, Enc)
		f := A_FormatInteger
		SetFormat, IntegerFast, H
		Loop
		{
			Code := NumGet(Var, A_Index - 1, "UChar")
			If (!Code)
				Break
			If (Code >= 0x30 && Code <= 0x39 ; 0-9
				|| Code >= 0x41 && Code <= 0x5A ; A-Z
				|| Code >= 0x61 && Code <= 0x7A) ; a-z
				Res .= Chr(Code)
			Else
				Res .= "%" . SubStr(Code + 0x100, -1)
		}
		SetFormat, IntegerFast, %f%
		Return, Res
	}

	UriDecode(Uri, Enc = "UTF-8")
	{
		Pos := 1
		Loop
		{
			Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
			If (Pos = 0)
				Break
			VarSetCapacity(Var, StrLen(Code) // 3, 0)
			StringTrimLeft, Code, Code, 1
			Loop, Parse, Code, `%
				NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
			StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
		}
		Return, Uri
	}

	StrPutVar(Str, ByRef Var, Enc = "")
	{
		Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
		VarSetCapacity(Var, Len, 0)
		Return, StrPut(Str, &Var, Enc)
	}
}

OverwriteSettingsWidthTimer:
	o := Globals.Get("SettingsUIWidth")

	If (o) {
		Globals.Set("SettingsUIWidth", 963)
		SetTimer, OverwriteSettingsWidthTimer, Off
	}
Return

OverwriteSettingsHeightTimer:
	o := Globals.Get("SettingsUIHeight")

	If (o) {
		Globals.Set("SettingsUIHeight", 665)
		SetTimer, OverwriteSettingsHeightTimer, Off
	}
Return

OverwriteAboutWindowSizesTimer:
	o := Globals.Get("AboutWindowHeight")
	l := Globals.Get("AboutWindowWidth")

	If (o and l) {
		Globals.Set("AboutWindowHeight", 400)
		Globals.Set("AboutWindowWidth", 880)
		TradeFunc_CreateTradeAboutWindow()
		SetTimer, OverwriteAboutWindowSizesTimer, Off
	}
Return

ChangeScriptListsTimer:
	o := Globals.Get("ScriptList")
	l := Globals.Get("UpdateNoteFileList")

	If (o and l.Length()) {
		o.push(A_ScriptDir "\TradeMacroMain")
		o.push(A_ScriptDir "\PoE-TradeMacro_(Fallback)")
		Global.Set("ScriptList", o)

		l.push([A_ScriptDir "\resources\Updates_Trade.txt","TradeMacro"])
		Global.Set("UpdateNoteFileList", l)

		SetTimer, ChangeScriptListsTimer, Off
	}
Return

OverwriteSettingsNameTimer:
	o := Globals.Get("SettingsUITitle")

	If (o) {
		RelVer := TradeGlobals.Get("ReleaseVersion")
		;Menu, Tray, Tip, Path of Exile TradeMacro %RelVer%
		Menu, Tray, Tip, Path of Exile TradeMacro ru %RelVer%
		OldMenuTrayName := Globals.Get("SettingsUITitle")
		NewMenuTrayName := TradeGlobals.Get("SettingsUITitle")
		Menu, Tray, UseErrorLevel
		Menu, Tray, Rename, % OldMenuTrayName, % NewMenuTrayName
		If (ErrorLevel = 0) {
			Menu, Tray, Icon, %A_ScriptDir%\resources\images\poe-trade-bl.ico
			Globals.Set("SettingsUITitle", TradeGlobals.Get("SettingsUITitle"))
			SetTimer, OverwriteSettingsNameTimer, Off
		}
		Menu, Tray, UseErrorLevel, off
	}
Return

OverwriteUpdateOptionsTimer:
	If (InititalizedItemInfoUserOptions) {
		TradeFunc_SyncUpdateSettings()
	}
Return

BringPoEWindowToFrontAfterInit:
	TradeFunc_ActivatePoeWindow()
	SetTimer, BringPoEWindowToFrontAfterInit, OFF
Return

OpenGithubWikiFromMenu:
	repo := TradeGlobals.Get("GithubRepo")
	user := TradeGlobals.Get("GithubUser")
	TradeFunc_OpenUrlInBrowser("https://github.com/" user "/" repo "/wiki")
Return

;Функция для открытия темы TradeMacro на русском форуме
OpenRuForumTradeMacroFromMenu:
	TradeFunc_OpenUrlInBrowser("https://ru.pathofexile.com/forum/view-post/359261")
Return

OpenPayPal:
	url := "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4ZVTWJNH6GSME"
	TradeFunc_OpenUrlInBrowser(url)
Return

TradeSettingsUI_BtnOK:
	Global TradeOpts
	Gui, Submit
	SavedTradeSettings := true
	Sleep, 50
	WriteTradeConfig()
	UpdateTradeSettingsUI()
Return

TradeSettingsUI_BtnCancel:
	Gui, Cancel
Return

TradeSettingsUI_BtnDefaults:
	Gui, Cancel
	Sleep, 75
	ReadTradeConfig(A_ScriptDir "\resources\default_UserFiles")
	Sleep, 75
	UpdateTradeSettingsUI()
	ShowSettingsUI()
Return

TradeSettingsUI_ChkCorruptedOverride:
	GuiControlGet, IsChecked,, CorruptedOverride
	If (Not IsChecked) {
		GuiControl, Disable, Corrupted
	}
	Else	{
		GuiControl, Enable, Corrupted
	}
Return

ReadPoeNinjaCurrencyData:
	; Disable hotkey until currency data was parsed
	key := TradeOpts.ChangeLeagueHotKey
	loggedCurrencyRequestAtStartup := loggedCurrencyRequestAtStartup ? loggedCurrencyRequestAtStartup : false
	loggedTempLeagueCurrencyRequest := loggedTempLeagueCurrencyRequest ? loggedTempLeagueCurrencyRequest : false
	usedFallback := false
	If (TempChangingLeagueInProgress) {
		;ShowToolTip("Changing league to " . TradeOpts.SearchLeague " (" . TradeGlobals.Get("LeagueName") . ")...", true)
		ShowToolTip("Изменение лиги на " . TradeOpts.SearchLeague " (" . TradeGlobals.Get("LeagueName") . ")...", true)
	}
	sampleValue	:= ChaosEquivalents["Chaos Orb"]
	league		:= TradeUtils.UriEncode(TradeGlobals.Get("LeagueName"))
	fallback		:= ""
	isFallback	:= false
	file			:= A_ScriptDir . "\temp\currencyData.json"
	fallBackDir	:= A_ScriptDir . "\data_trade"
	url			:= "https://poe.ninja/api/Data/GetCurrencyOverview?league=" . league
	parsedJSON	:= CurrencyDataDowloadURLtoJSON(url, sampleValue, false, isFallback, league, "PoE-TradeMacro", file, fallBackDir, usedFallback, loggedCurrencyRequestAtStartup, loggedTempLeagueCurrencyRequest)

	; fallback to Standard and Hardcore league if used league seems to not be available
	If (!parsedJSON.currencyDetails.length()) {
		isFallback	:= true
		If (InStr(league, "Hardcore", 0) or RegExMatch(league, "HC")) {
			league	:= "Hardcore"
			fallback	:= "Hardcore"
		} Else {
			league	:= "Standard"
			fallback	:= "Standard"
		}

		url			:= "https://poe.ninja/api/Data/GetCurrencyOverview?league=" . league
		parsedJSON	:= CurrencyDataDowloadURLtoJSON(url, sampleValue, true, isFallback, league, "PoE-TradeMacro", file, fallBackDir, usedFallback, loggedCurrencyRequestAtStartup, loggedTempLeagueCurrencyRequest)
	}
	global CurrencyHistoryData := parsedJSON.lines
	TradeGlobals.Set("LastAltCurrencyUpdate", A_NowUTC)

	global ChaosEquivalents	:= {}
	For key, val in CurrencyHistoryData {
		currencyBaseName	:= RegexReplace(val.currencyTypeName, "[^a-z A-Z]", "")
		ChaosEquivalents[currencyBaseName] := val.chaosEquivalent
	}
	ChaosEquivalents["Chaos Orb"] := 1

	If (TempChangingLeagueInProgress) {
		;msg := "Changing league to " . TradeOpts.SearchLeague " (" . TradeGlobals.Get("LeagueName") . ") finished."
		msg := "Изменение лиги на " . TradeOpts.SearchLeague " (" . TradeGlobals.Get("LeagueName") . ") завершено."
		;msg .= "`n- Requested chaos equivalents and currency history from poe.ninja."
		msg .= "`n- Запрошены эквиваленты хаоса и история валютных курсов от poe.ninja."
		;msg .= StrLen(fallback) ? "`n- Using data from " fallback " league since the requested data is not available." : ""
		msg .= StrLen(fallback) ? "`n- Используются данные из " fallback " лиги, поскольку запрошенные данные недоступны." : ""
		ShowToolTip(msg, true)
	}

	TempChangingLeagueInProgress := False
Return

TradeFunc_DowloadURLtoJSON(url, sampleValue, critical = false, league = "") {
	;errorMsg := "Parsing the currency data (json) from poe.ninja failed.`n"
	;errorMsg .= "This should only happen when the servers are down / unavailable."
	;errorMsg .= "`n`n"
	;errorMsg .= "Using archived data from a fallback file. League: """ league """."
	;errorMsg .= "`n`n"
	;errorMsg .= "This can fix itself when the servers are up again and the data gets updated automatically or if you restart the script at such a time."
	
	errorMsg := "Разбор данных (json) о валюте с сайта poe.ninja не удался.`n"
	errorMsg .= "Такое возможно, когда серверы отключены/недоступны."
	errorMsg .= "`n`n"
	errorMsg .= "Будут использованы архивные данные из резервного файла. Лига: """ league """."
	errorMsg .= "`n`n"
	errorMsg .= "Это может быть исправлено, когда серверы снова заработают/станут доступны,`n"
	errorMsg .= "и данные будут обновляться автоматически." 
	errorMsg .= "`n`n"
	errorMsg .= "Попробуйте перезапустить скрипт через некоторое время."
	errorMsg .= "`n`n"

	errors := 0
	Try {
		UrlDownloadToFile, %url%, %A_ScriptDir%\temp\currencyData.json
		FileRead, JSONFile, %A_ScriptDir%\temp\currencyData.json
		parsedJSON := JSON.Load(JSONFile)

		; first currency data parsing (script start)
		If (critical and not sampleValue or not parsedJSON.lines.length()) {
			errors++
		}
	} Catch error {
		; first currency data parsing (script start)
		If (critical and not sampleValue) {
			errors++
		}
	}

	If (errors and critical and not sampleValue) {
		MsgBox, 16, PoE-TradeMacro - Error, %errorMsg%
		FileRead, JSONFile, %A_ScriptDir%\data_trade\currencyData_Fallback_%league%.json
		parsedJSON := JSON.Load(JSONFile)
	}

	Return parsedJSON
}

CloseCookieWindow:
	Gui, CookieWindow:Cancel
Return

ContinueAtConnectionFailure:
	Gui, ConnectionFailure:Cancel
Return

OpenCookieFile:
	Run, %A_ScriptDir%\temp\cookie_data.txt
Return

DeleteCookies:
	TradeFunc_ClearWebHistory()
	Run, Run_TradeMacro.ahk
	ExitApp
Return

OpenPageInInternetExplorer:
	RegRead, iexplore, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\iexplore.exe
	Run, %iexplore% http://poe.trade
Return

ReloadScriptAtCookieError:
	scriptName := "Run_TradeMacro.ahk"
	Run, "%A_AhkPath%" "%A_ScriptDir%\%scriptName%"
Return

TradeAboutDlg_GitHub:
	repo := TradeGlobals.Get("GithubRepo")
	user := TradeGlobals.Get("GithubUser")
	TradeFunc_OpenUrlInBrowser("https://github.com/" user "/" repo)
Return

TradeVisitForumsThread:
	TradeFunc_OpenUrlInBrowser("https://www.pathofexile.com/forum/view-thread/1757730")
Return

CloseCustomSearch:
	TradeFunc_ResetCustomSearchGui()
	Gui, CustomSearch:Destroy
	TradeFunc_ActivatePoeWindow()
Return

TradeFunc_ResetCustomSearchGui() {
	CustomSearchName		:=
	CustomSearchType		:=
	CustomSearchBase		:=
	CustomSearchRarity		:=
	CustomSearchCorrupted	:=
	CustomSearchSocketsMin	:=
	CustomSearchSocketsMax	:=
	CustomSearchLinksMin	:=
	CustomSearchLinksMax	:=
	CustomSearchQualityMin	:=
	CustomSearchQualityMax	:=
	CustomSearchLevelMin	:=
	CustomSearchLevelMax	:=
	CustomSearchItemLevelMin	:=
	CustomSearchItemLevelMax	:=
}

OpenCustomSearchOnPoeTrade:
	TradeFunc_HandleCustomSearchSubmit(true)
Return

SubmitCustomSearch:
	TradeFunc_HandleCustomSearchSubmit()
Return

DebugTestItemPricing:
	TradeFunc_CreateItemPricingTestGUI()
Return

ClosePricingTest:
	PricingTestItemInput :=
	Gui, PricingTest:Destroy
Return

OpenPricingTestOnPoeTrade:
	Gui, PricingTest:Submit, Nohide
	TradeFunc_OpenSearchOnPoeTradeHotkey(true, PricingTestItemInput)
Return

SubmitPricingTestDefault:
	Gui, PricingTest:Submit, Nohide
	TradeFunc_PriceCheckHotkey(true, PricingTestItemInput)
Return

SubmitPricingTestAdvanced:
	Gui, PricingTest:Submit, Nohide
	TradeFunc_AdvancedPriceCheckHotkey(true, PricingTestItemInput)
Return

SubmitPricingTestWiki:
	Gui, PricingTest:Submit, Nohide
	TradeFunc_OpenWikiHotkey(true, PricingTestItemInput)
Return

SubmitPricingTestParsing:
	Gui, PricingTest:Submit, Nohide
	SuspendPOEItemScript = 1
	Clipboard := PricingTestItemInput
	ParseClipBoardChanges(true)
	SuspendPOEItemScript = 0
Return

SubmitPricingTestParsingObject:
	Gui, PricingTest:Submit, Nohide
	SuspendPOEItemScript = 1
	Clipboard := PricingTestItemInput
	ParseClipBoardChanges(true)
	DebugTmpObject			:= {}
	DebugTmpObject.Item		:= Item
	DebugTmpObject.ItemData	:= ItemData
	DebugPrintArray(DebugTmpObject)
	SuspendPOEItemScript = 0
Return

TradeFunc_HandleCustomSearchSubmit(openInBrowser = false) {
	Global
	Gui, CustomSearch:Submit

	If (CustomSearchName or CustomSearchType or CustomSearchBase) {
		RequestParams := new RequestParams_()
		LeagueName := TradeGlobals.Get("LeagueName")
		RequestParams.name   := CustomSearchName
		RequestParams.league := LeagueName
		Item.Name := CustomSearchName

		StringLower, CustomSearchRarity, CustomSearchRarity

		RequestParams.xtype		:= CustomSearchType         ? CustomSearchType : ""
		RequestParams.xbase		:= CustomSearchBase         ? CustomSearchBase : ""
		RequestParams.rarity	:= CustomSearchRarity       ? CustomSearchRarity : ""
		RequestParams.link_min	:= CustomSearchLinksMin     ? CustomSearchLinksMin : ""
		RequestParams.link_max	:= CustomSearchLinksMax     ? CustomSearchLinksMax : ""
		RequestParams.q_min		:= CustomSearchQualityMin   ? CustomSearchQualityMin : ""
		RequestParams.q_max		:= CustomSearchQualityMax   ? CustomSearchQualityMax : ""
		RequestParams.sockets_min:= CustomSearchSocketsMin   ? CustomSearchSocketsMin : ""
		RequestParams.sockets_max:= CustomSearchSocketsMax   ? CustomSearchSocketsMax : ""
		RequestParams.level_min 	:= CustomSearchLevelMin     ? CustomSearchLevelMin : ""
		RequestParams.level_max	:= CustomSearchLevelMax     ? CustomSearchLevelMax : ""
		RequestParams.ilvl_min 	:= CustomSearchItemLevelMin ? CustomSearchItemLevelMin : ""
		RequestParams.ilvl_max 	:= CustomSearchItemLevelMax ? CustomSearchItemLevelMax : ""

		If (CustomSearchCorrupted = "Yes") {
			RequestParams.corrupted := "1"
		} Else If (CustomSearchCorrupted = "No") {
			RequestParams.corrupted := "0"
		} Else {
			RequestParams.corrupted := "x"
		}
		Item.UsedInSearch.Corruption := CustomSearchCorrupted

		Payload := RequestParams.ToPayload()
		If (openInBrowser) {
			ShowToolTip("")
			Html := TradeFunc_DoPostRequest(Payload, true)
			RegExMatch(Html, "i)href=""\/(search\/.*?)\/live", ParsedUrl)
			TradeFunc_OpenUrlInBrowser("http://poe.trade/" ParsedUrl1)
		}
		Else {
			;ShowToolTip("Requesting search results... ")
			ShowToolTip("Запрос результатов поиска... ")
			Html := TradeFunc_DoPostRequest(Payload)
			ParsedData := TradeFunc_ParseHtml(Html, Payload)
			SetClipboardContents(ParsedData)

			ShowToolTip("")
			ShowToolTip(ParsedData, true)
		}
	}
	GoSub, CloseCustomSearch
}

TradeFunc_ChangeLeague() {
	Global
	If (TempChangingLeagueInProgress = true) {
		; Return while league is being changed in case of enabled alternative currency search.
		; Downloading and parsing the data from poe.ninja takes a moment.
		Return
	}

	leagues := TradeGlobals.Get("Leagues")

	index:= 0
	i	:= 0
	For key, val in leagues {
		i++
		If (SearchLeague == key) {
			index := i
		}
	}
	j	:= 0
	first:= ""
	next := ""
	For key, val in leagues {
		j++
		If (j = i) {
			first:= key
		}
		If ((index - 1) = j) {
			next	:= key
		}
	}

	NewSearchLeague := (next) ? next : first
	; Call Submit for the settings UI, otherwise we can't set the new league if the UI was last closed via close button or "x"
	Gui, Submit
	SearchLeague := TradeFunc_CheckIfLeagueIsActive(NewSearchLeague)
	TradeGlobals.Set("LeagueName", TradeGlobals.Get("Leagues")[SearchLeague])
	WriteTradeConfig()
	UpdateTradeSettingsUI()

	TempChangingLeagueInProgress := True
	GoSub, ReadPoeNinjaCurrencyData
}

TradeFunc_PreventClipboardGarbageAfterInit() {
	Global
	
	If (not TradeGlobals.Get("FirstSearchTriggered")) {
		Clipboard := ""
	}
	TradeGlobals.Set("FirstSearchTriggered", true)
}

ResetWinHttpProxy:
	PoEScripts_RunAsAdmin()
	RunWait %comspec% /c netsh winhttp reset proxy ,,Hide
	Run, "%A_AhkPath%" "%A_ScriptDir%\Run_TradeMacro.ahk"
	ExitApp
Return

TrackUserCount:
	Run, "%A_AhkPath%" "%A_ScriptDir%\lib\IEComObjectTestCall.ahk" "%userDirectory%"
Return

Kill_CookieDataExe:
	Try {
		WinKill % "ahk_pid " cdePID
	} Catch e {

	}
	SetTimer, Kill_CookieDataExe, Off
Return

SelectModsGuiGuiEscape:
	; trademacro advanced search 
	Gui, SelectModsGui:Cancel
	TradeFunc_ActivatePoeWindow()
Return

CustomSearchGuiEscape:
	Gui, CustomSearch:Cancel
	TradeFunc_ActivatePoeWindow()
Return

CurrencyRatioGuiEscape:
	Gui, CurrencyRatio:Cancel
	TradeFunc_ActivatePoeWindow()
Return

PricingTestGuiEscape:
	Gui, PricingTest:Cancel
	TradeFunc_ActivatePoeWindow()
Return

CookieWindowGuiEscape:
	Gui, CookieWindow:Cancel
Return

ConnectionFailureGuiEscape:
	Gui, ConnectionFailure:Cancel
Return

PredictedPricingGuiEscape:
	Gui, PredictedPricing:Destroy
	TradeFunc_ActivatePoeWindow()
Return

PredictedPricingClose:
	Gui, PredictedPricing:Destroy
	TradeFunc_ActivatePoeWindow()
Return

PredictedPricingSendFeedback:
	Gui, PredictedPricing:Submit, NoHide
	If (PredictionPricingRadio1 or PredictionPricingRadio2 or PredictionPricingRadio3) {
		Gui, PredictedPricing:Destroy
	} Else {
		GuiControl, Show, % PredictedPricingHiddenControl1
		GuiControl, Show, % PredictedPricingHiddenControl2
		Return
	}

	TradeFunc_ActivatePoeWindow()
	_rating := ""
	If (PredictionPricingRadio1) {
		_rating := "Low"
	} Else If (PredictionPricingRadio2) {
		_rating := "Fair"
	} Else If (PredictionPricingRadio3) {
		_rating := "High"
	}
	
	_prices := {}
	_prices.min := PredictedPricingMin
	_prices.max := PredictedPricingMax
	_prices.currency := PredictedPricingCurrency
	TradeFunc_PredictedPricingSendFeedback(_rating, PredictedPricingComment, PredictedPricingEncodedData, PredictedPricingLeague, _prices)
Return

SelectCurrencyRatioPreview:
	Gui, CurrencyRatio:Submit, NoHide
	TradeFunc_SelectCurrencyRatio(SelectCurrencyRatioSellCurrency, SelectCurrencyRatioSellAmount, SelectCurrencyRatioReceiveCurrency, SelectCurrencyRatioReceiveAmount, SelectCurrencyRatioReceiveRatio, true)
Return

SelectCurrencyRatioSubmit:
	Gui, CurrencyRatio:Submit
	TradeFunc_SelectCurrencyRatio(SelectCurrencyRatioSellCurrency, SelectCurrencyRatioSellAmount, SelectCurrencyRatioReceiveCurrency, SelectCurrencyRatioReceiveAmount, SelectCurrencyRatioReceiveRatio)
Return

TradeFunc_SelectCurrencyRatio(typeSell, amountSell, typeReceive, amountReceive, ratioReceive, isPreview = false) {
	tags := TradeGlobals.Get("CurrencyTags")
	
	id := ""
	For key, category in tags {
		For k, type in category {
			If (type.text = typeReceive or type.short = typeReceive) {
				id := type.id
			}
		}
	}
	
	note := "~price "
	If (not ratioReceive) {
		amountReceive := Round(amountReceive)
		amountSell := Round(amountSell)
		ratio1 := TradeUtils.ZeroTrim(Round(amountReceive / amountSell, 4))
		ratio2 := TradeUtils.ZeroTrim(Round(amountSell / amountReceive, 4))
		note .= amountReceive "/" amountSell " " id
	} Else {
		ratioReceive := RegExReplace(ratioReceive, ",", ".")
		ratio1 := ratioReceive
		ratio2 := TradeUtils.ZeroTrim(Round(1 / ratioReceive, 4))

		; loop over the sell amount, increasing and decreasing it until we get an integer receive amount (rounded 3 decimals).
		sVHi := amountSell
		sVLow := amountSell
		loops := 0
		Loop {
			rVHi := TradeUtils.ZeroTrim(Round(sVHi / ratio2, 3))
			rVLow := TradeUtils.ZeroTrim(Round(sVLow / ratio2, 3))
			
			If (RegExMatch(rVHi, "^\d+$")) {
				receiveValue := rVHi
				sellValue := sVHi
			} Else If (RegExMatch(rVLow, "^\d+$")) {
				receiveValue := rVLow	
				sellValue := sVLow
			}	
			
			sVHi++			
			If (A_Index & 0) {
				; decrease the sell amount only on even loops
				sVLow := sVLow > 1 ? sVLow - 1 : sVLow	
			}			
			loops := A_Index
		} Until receiveValue
		
		note .= receiveValue "/" sellValue " " id
	}
	
	If (not isPreview) {		
		Clipboard := note
		msg := "Copied note """ note """ to the clipboard"
		msg := loops > 1 ? msg " after changing the sell amount to better fit the ratio." : msg "."		
	}
	Else {
		msg := "Note preview """ note """ created"
		msg := loops > 1 ? msg " after changing the sell amount to better fit the ratio." : msg "." 
	}
	
	msg .= "`n`n" "This is equivalent to a ratio of:"
	msg .= "`n"   "    [" typeSell "]  1 : " ratio1 "  [" typeReceive "]"
	msg .= "`n"   "    [" typeSell "]  " ratio2 " : 1  [" typeReceive "]"
	ShowTooltip(msg)
	
	Return
}

TradeFunc_PredictedPricingSendFeedback(selector, comment, encodedData, league, price) {
	postData 	:= ""
	postData := selector ? postData "selector=" UriEncode(Trim(selector)) "&" : postData
	postData := comment ? postData "feedbacktxt=" UriEncode(comment) "&" : postData
	postData := encodedData ? postData "qitem_txt=" encodedData "&" : postData
	postData := price.min ? postData "min=" UriEncode(price.min "") "&" : postData
	postData := price.max ? postData "max=" UriEncode(price.max "") "&" : postData
	postData := price.currency ? postData "currency=" UriEncode(price.currency "") "&" : postData
	postData := league ? postData "league=" UriEncode(league) "&" : postData
	postData := postData "source=" UriEncode("poetrademacro") "&"

	If (TradeOpts.Debug) {
		postData := postData "debug=1" "&"	
	}
	postData := RegExReplace(postData, "(\&)$")

	payLength	:= StrLen(postData)
	url 		:= "https://www.poeprices.info/send_feedback"
	options	:= "ReturnHeaders: skip"
	options	.= "`n" "ValidateResponse: false"

	reqHeaders	:= []
	reqHeaders.push("Connection: keep-alive")
	reqHeaders.push("Cache-Control: max-age=0")
	reqHeaders.push("Origin: https://poeprices.info")
	reqHeaders.push("Content-type: application/x-www-form-urlencoded; charset=UTF-8")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")

	response := PoEScripts_Download(url, postData, reqHeaders, options, false)
	If (not RegExMatch(response, "i)^""?(low|fair|high)""?$")) {
		;ShowTooltip("ERROR: Sending feedback failed. ", true)
		ShowTooltip("ОШИБКА: Отправка отзыва не удалась. ", true)
	}
}

TradeFunc_ActivatePoeWindow() {
	If (not WinActive("ahk_group PoEWindowGrp")) {
		WinActivate, ahk_group PoEWindowGrp
	}
}