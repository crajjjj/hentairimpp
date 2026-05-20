Scriptname HentairimAdventure extends ActiveMagicEffect  

import b612
import IVDTVoiceCall
Import ExpressionsCall
import AdventureCall

IVDTControllerScript Property MasterScript Auto
SexLabFramework Property SexLab Auto 
SexLabThread CurrentThread = None
Bool PauseVoice = false
actor playerref
Actor[] Followers
;For Tracking Combat
Actor[] Enemies
Int TimesFollowerBleedingOut ;Sigh if Follower Bleedout Too many times
Float LastCombatStartTime ;real Seconds Since Last Combat Started
Float LastCombatEndTime ;real Seconds Since Last Combat Ended
Bool MadeCombatOpeningSpeech
Bool MadeEnemyEncounterSpeech

Float UpdateRate = 8.0
actor[] actorlist


Spell HentairimSeducedSpell
Spell HentairimNPCRequestSpell

b612_Spinicon Spinicon
Bool playerInCombat
Bool PlayerInSexScene
;idles
idle IdleNoteRead
idle Idlestudy
idle IdlestudyExit
idle IdleDrunkStart
idle IdleDrunkStop
idle IdleLaugh
idle IdleSurrender
Idle IdleWave
Idle IdleGive
Idle IdleDrinkPotion
Idle BaboFaintF_Loop
Idle BaboFaintF
Idle BaboDefeatPanting
Idle BaboDefeatKnockOutEnd
Idle BaboDefeatKnockOutStart
Idle BaboDefeatSurrender
Idle Babo_DefeatTraumaStand


;Essence Hunting
Float LastSeductionTime
string[] RequirementsEssence
int[] RequirementsEssenceCount
int[] RequirementsEssenceSatisfied
Bool RequirementsComplete
String[] HumanKeywords 
String[] CreatureKeywords

;Location Keywords
Keyword loctypedwelling
Keyword loctypetown
Keyword loctypecity
Keyword loctypeInn
Keyword loctypeplayerhouse
Keyword LocTypeDungeon


Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	PerformInitialization()
	playerref = game.getplayer()

EndEvent

Function PerformInitialization()
	if enableadventure == 0
		unRegisterForTheEvents()
		UnregisterForUpdate()
	else
		Printdebug("Perform Initialization")
		HumanKeywords = papyrusutil.stringsplit("Orc, Nord, Argonian, Breton, RedGuard, Dunmer, Altmer, Imperial, Khajiit, Bosmer" ,",")
		CreatureKeywords = papyrusutil.stringsplit("Dwarven, Vampire, Necro, Insect, Spriggan, Lycanthrope,Falmer, Ogre, Daedra, Predator, Nature, Canine, Horse, Marine, Goblin" ,",")
		printdebug("Register for Events")
		RegisterForTheEventsWeNeed()
		printdebug("Initialize Forms")
		InitializeForms()
		Spinicon = GetSpinicon()
		printdebug("Resolving Essence Requirements")
		ResolveEssenceRequirements()
		;remove drug effects if disabled
		if	!BodyEffectsAndDrugsEnabled()
			ClearDrugEffects(playerref, 0 )
		endif
		printdebug("Start Registering Update")
		RegisterForSingleUpdate(UpdateRate) 
	endif
EndFunction

Event OnKeyDown(Int keyCode)
	PrintDebug("OnKeyDown | keyCode=" + keyCode + " | directortoolskey=" + directortoolskey + " | PlayerInSexScene=" + PlayerInSexScene + " | IsInMenuMode=" + Utility.IsInMenuMode())

	If keyCode == directortoolskey && !Utility.IsInMenuMode() && !PlayerInSexScene
		PrintDebug("OnKeyDown | Conditions met — Opening Action Menu")
		OpenActionMenu()
	Else
		PrintDebug("OnKeyDown | Conditions not met — no action taken")
	EndIf
EndEvent

int directortoolskey
Function RegisterForTheEventsWeNeed()
	UnregisterForKey(directortoolskey)
	directortoolskey = JsonUtil.GetIntValue("HentairimDirector/Config.json", "directortoolskey" ,0)
	;Action Key
	RegisterForKey(directortoolskey) ; Same As Director Tools Key
	printdebug("Registered Hentairim Field Action Key : " + directortoolskey)
	RegisterForModEvent("HookAnimationStart", "HentairimAdventureSceneStart")
	RegisterForModEvent("HookStageStart", "HentairimAdventureStageStart")
	RegisterForModEvent("SexLabOrgasmSeparate", "HentairimAdventureOnOrgasm")
	RegisterForModEvent("HookAnimationEnd", "HentairimAdventureSceneEnd")	
	
	
		; Dialogue
	RegisterForMenu("Dialogue Menu")

	; Lockpicking
	RegisterForMenu("Lockpicking Menu")

	; Container / Looting
	RegisterForMenu("ContainerMenu")

	; Crafting menus
	RegisterForMenu("Crafting Menu")          ; Generic workbench / tanning rack
	RegisterForMenu("Smithing Menu")          ; Forge / anvil
	RegisterForMenu("Enchanting Menu")        ; Enchanting table
	RegisterForMenu("Alchemy Menu")           ; Alchemy lab

	; Inventory / Magic
	RegisterForMenu("InventoryMenu")          ; Player inventory
	RegisterForMenu("MagicMenu")              ; Spells, shouts, powers
	RegisterForMenu("StatsMenu")              ; Level-up and skill trees
	RegisterForMenu("FavoritesMenu")          ; Favorites quick menu
	RegisterForMenu("TweenMenu")              ; Big paperdoll menu (Tab menu)

	; Books / Reading
	RegisterForMenu("Book Menu")              ; Reading books and notes

	; Barter / Trading
	RegisterForMenu("BarterMenu")             ; Buying/selling with merchants

	; Sleep / Wait
	RegisterForMenu("Sleep/Wait Menu")        ; Sleeping or waiting

	; Journal / Quests
	RegisterForMenu("Journal Menu")           ; Quest log, system settings

	; Map
	RegisterForMenu("MapMenu")                ; World map and local maps

	; Level Up
	RegisterForMenu("LevelUp Menu")           ; Level-up confirmation screen

	; Gift / Pickpocket
	RegisterForMenu("GiftMenu")               ; Giving/taking items from NPCs
	RegisterForMenu("Training Menu")          ; NPC skill training
	RegisterForMenu("Book Menu")              ; Reading skill books
	RegisterForMenu("Lockpicking Menu")       ; Lockpick UI (already listed above)

		
	;Combat
	 RegisterForAnimationEvent(playerref, "weaponSwing")
	 RegisterForAnimationEvent(playerref, "PowerAttack_Start_End")
	 RegisterForAnimationEvent(playerref, "BowRelease")
	
	;Sleep
	Registerforsleep()
EndFunction

Function unRegisterForTheEvents()

	;Action Key
	unRegisterForKey(directortoolskey) ; Same As Director Tools Key

	unRegisterForModEvent("HookAnimationStart")
	unRegisterForModEvent("HookStageStart")
	unregisterForModEvent("SexLabOrgasmSeparate")
	unregisterForModEvent("HookAnimationEnd")	

		; Dialogue
	unregisterForMenu("Dialogue Menu")

	; Lockpicking
	unregisterForMenu("Lockpicking Menu")

	; Container / Looting
	unregisterForMenu("ContainerMenu")

	; Crafting menus
	unregisterForMenu("Crafting Menu")          ; Generic workbench / tanning rack
	unregisterForMenu("Smithing Menu")          ; Forge / anvil
	unregisterForMenu("Enchanting Menu")        ; Enchanting table
	unregisterForMenu("Alchemy Menu")           ; Alchemy lab

	; Inventory / Magic
	unregisterForMenu("InventoryMenu")          ; Player inventory
	unregisterForMenu("MagicMenu")              ; Spells, shouts, powers
	unregisterForMenu("StatsMenu")              ; Level-up and skill trees
	unregisterForMenu("FavoritesMenu")          ; Favorites quick menu
	unregisterForMenu("TweenMenu")              ; Big paperdoll menu (Tab menu)

	; Books / Reading
	unregisterForMenu("Book Menu")              ; Reading books and notes

	; Barter / Trading
	unregisterForMenu("BarterMenu")             ; Buying/selling with merchants

	; Sleep / Wait
	unregisterForMenu("Sleep/Wait Menu")        ; Sleeping or waiting

	; Journal / Quests
	unregisterForMenu("Journal Menu")           ; Quest log, system settings

	; Map
	unregisterForMenu("MapMenu")                ; World map and local maps

	; Level Up
	unregisterForMenu("LevelUp Menu")           ; Level-up confirmation screen

	; Gift / Pickpocket
	unregisterForMenu("GiftMenu")               ; Giving/taking items from NPCs
	unregisterForMenu("Training Menu")          ; NPC skill training
	unregisterForMenu("Book Menu")              ; Reading skill books
	unregisterForMenu("Lockpicking Menu")       ; Lockpick UI (already listed above)

		
	;Combat
	 unRegisterForAnimationEvent(playerref, "weaponSwing")
	 unRegisterForAnimationEvent(playerref, "PowerAttack_Start_End")
	 unRegisterForAnimationEvent(playerref, "BowRelease")
	;sleep
	Unregisterforsleep()
EndFunction

Function InitializeForms()
	;Loc Keywords
	loctypedwelling = Game.GetFormFromFile(0x130DC, "Skyrim.esm") as Keyword
	loctypetown = Game.GetFormFromFile(0x13166, "Skyrim.esm") as Keyword
	loctypecity = Game.GetFormFromFile(0x13168, "Skyrim.esm") as Keyword
	loctypeInn = Game.GetFormFromFile(0x1CB87, "Skyrim.esm") as Keyword
	loctypeplayerhouse = Game.GetFormFromFile(0xFC1A3, "Skyrim.esm") as Keyword
	LocTypeDungeon = Game.GetFormFromFile(0x130DB, "Skyrim.esm") as Keyword

	;Adventure Spells
	HentairimSeducedSpell = Game.GetFormFromFile(0x857, "Hentairim Director.esp") as Spell
	HentairimNPCRequestSpell = Game.GetFormFromFile(0x85A, "Hentairim Director.esp") as Spell
	
	;idles
	IdleNoteRead = Game.GetFormFromFile(0x89975, "Skyrim.esm") as idle
	Idlestudy = Game.GetFormFromFile(0x977ED, "Skyrim.esm") as idle
	IdlestudyExit = Game.GetFormFromFile(0x977EE, "Skyrim.esm") as idle
	IdleDrunkStart = Game.GetFormFromFile(0xCEFD0, "Skyrim.esm") as idle
	IdleDrunkStop = Game.GetFormFromFile(0xCEFD1, "Skyrim.esm") as idle
	IdleLaugh = Game.GetFormFromFile(0x75C5F, "Skyrim.esm") as idle
	IdleSurrender = Game.GetFormFromFile(0x105D47, "Skyrim.esm") as idle
	IdleWave = Game.GetFormFromFile(0x3EA32, "Skyrim.esm") as Idle
	IdleGive = Game.GetFormFromFile(0xB5E20, "Skyrim.esm") as Idle
	IdleDrinkPotion = Game.GetFormFromFile(0xD33B0, "Skyrim.esm") as Idle
	
	;Babo Idles
	BaboFaintF_Loop = Game.GetFormFromFile(0x86D, "Hentairim Director.esp") as idle
	BaboFaintF = Game.GetFormFromFile(0x86C, "Hentairim Director.esp") as idle
	BaboDefeatPanting = Game.GetFormFromFile(0x86A, "Hentairim Director.esp") as idle
	BaboDefeatKnockOutEnd = Game.GetFormFromFile(0x851, "Hentairim Director.esp") as idle
	BaboDefeatKnockOutStart = Game.GetFormFromFile(0x84F, "Hentairim Director.esp") as idle
	BaboDefeatSurrender = Game.GetFormFromFile(0x84E, "Hentairim Director.esp") as idle
	Babo_DefeatTraumaStand = Game.GetFormFromFile(0x843, "Hentairim Director.esp") as idle

endfunction

int	enableadventure
int usedonotdisturb
int	faintessenceperorgasm
int	getessenceevenwhenvictim
int teammategivesessence
int dayssincelastsexbeforecandrainessenceagain
int	seduceseconds
int	npcrequestcd
int	chancefornpcrequest
int	mindistancefornpcrequest
int	maxdistancefornpcrequest
int enableadventurevoice
int hoursbeforecanseduceagain
int minfollowerarousalforrape
int chanceforsleepingperverts
int	printdebug

float rapechancemultiplier
float seducechancemultiplier

int enabledrugs

Function InitializeConfig()
	Printdebug("Initialize Configs")
	String Config = "HentairimAdventure/config.json"
	
	enableadventure = JsonUtil.GetIntValue(Config, "enableadventure", 0)
	faintessenceperorgasm = JsonUtil.GetIntValue(Config, "faintessenceperorgasm", 1)
	getessenceevenwhenvictim = JsonUtil.GetIntValue(Config, "getessenceevenwhenvictim", 0)
	teammategivesessence = JsonUtil.GetIntValue(Config, "teammategivesessence", 0)
	dayssincelastsexbeforecandrainessenceagain = JsonUtil.GetIntValue(Config, "dayssincelastsexbeforecandrainessenceagain", 0)
	seduceseconds = JsonUtil.GetIntValue(Config, "seduceseconds", 0)
	npcrequestcd = JsonUtil.GetIntValue(Config, "npcrequestcd", 0)
	chancefornpcrequest = JsonUtil.GetIntValue(Config, "chancefornpcrequest", 0)
	mindistancefornpcrequest = JsonUtil.GetIntValue(Config, "mindistancefornpcrequest", 0)
	maxdistancefornpcrequest = JsonUtil.GetIntValue(Config, "maxdistancefornpcrequest", 0)
	enableadventurevoice = JsonUtil.GetIntValue(Config, "enableadventurevoice", 0)
	usedonotdisturb = JsonUtil.GetIntValue(Config, "usedonotdisturb", 0)
	hoursbeforecanseduceagain = JsonUtil.GetIntValue(Config, "hoursbeforecanseduceagain", 0)
	minfollowerarousalforrape = JsonUtil.GetIntValue(Config, "minfollowerarousalforrape", 0)
	
	chanceforsleepingperverts = JsonUtil.GetIntValue(Config, "chanceforsleepingperverts", 0)
	rapechancemultiplier = JsonUtil.GetFloatValue(Config, "rapechancemultiplier", 1.0)
	seducechancemultiplier = JsonUtil.GetFloatValue(Config, "seducechancemultiplier", 1.0)
	printdebug("seducechancemultiplier : " + seducechancemultiplier)
	printdebug = JsonUtil.GetIntValue(Config, "printdebug", 0)

Endfunction

Event OnPlayerLoadGame()
	
	InitializeConfig()
	Printdebug("Perform Maintenance on Director")
	MasterScript.Maintenance()
	PerformInitialization()
	
	string[] racekeys = sexlabregistry.GetAllRaceKeys(false)
	int C
	while C < racekeys.length
		JsonUtil.SetStringValue("SexlabRaceKeys.json",c,racekeys[c])
		c += 1
	endwhile
EndEvent

float SleepStartTime

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
    SleepStartTime = Masterscript.GetCurrentGameTimeHours()
EndEvent

Event OnSleepStop(bool abInterrupted)
  
EndEvent

Bool MadeFollowerDownComments = false
Int FollowerDownCount = 0
Event OnUpdate()
	Printdebug("on Update")
	
	if Masterscript.PCInSex()
		return
	endif
	
	if !playerInCombat
		Printdebug("Player Not In Combat. Process NPC Request and Bodily Effects")
		AssignSafeZoneNPCRequests()
		ProcessBodilyEffects(Playerref)
	endif
	
	if LastLocationType == 20 && !playerInCombat && !playerref.IsInCombat() && !MadeEnemyEncounterSpeech
		Printdebug("EncounterEnemyInDungeon")
		EncounterEnemyInDungeon()
		UpdateRate = 8
	elseif !playerInCombat && playerref.IsInCombat()
		Enemies = PO3_SKSEFunctions.GetCombatTargets(PlayerRef)
		CombatStart()
		MakeCombatOpeningSpeech()
		Printdebug("Player has entered combat!")
		UpdateRate = 3
	elseif playerInCombat && !playerref.IsInCombat()
		CombatEnd()
		Printdebug("Player has left combat.")
		UpdateRate = 8
	elseif playerInCombat
		Enemies = PO3_SKSEFunctions.GetCombatTargets(PlayerRef)
		if CanSaySomething()
			if !MadeFollowerDownComments && Followers[0].IsBleedingOut()
				if (Utility.randomint(1,100) < 75 && FollowerDownCount <= 10) || (Utility.randomint(1,100) < 35 && FollowerDownCount > 10)
					if FollowerDownCount > 10
						SocialPlaySigh(true)
					else
						if Utility.randomInt(1,2) == 1
							CombatPlayFollowerDown(True)
						else
							SocialPlayIWontForgiveYou(True)
						endif
					endif
					AddPausetoVoice(5)
				endif
				FollowerDownCount += 1
				MadeFollowerDownComments = true
			endif
		endif
	endif

    RegisterForSingleUpdate(UpdateRate) 
EndEvent

;--------------------Menu---------------
Event OnMenuOpen(String menuName)
    PrintDebug("Opened menu: " + menuName)
	
    If menuName == "Dialogue Menu"
        PrintDebug("Player entered dialogue")
		;Say Erm or Greet
		if CanSaySomething() && Utility.RandomInt(1,100) < 30
			if Utility.randomInt(1,8) == 1
				SocialPlayGreet()
			else
				SocialPlayErm()
			endif
			AddPausetoVoice(5)
		endif
  ;  ElseIf menuName == "InventoryMenu"
  ;      PrintDebug("Player opened inventory")
  ;  ElseIf menuName == "MagicMenu"
  ;      PrintDebug("Player opened spellbook")
  ;  ElseIf menuName == "StatsMenu"
  ;      PrintDebug("Player opened stats menu")
    ElseIf menuName == "Lockpicking Menu"
        PrintDebug("Player started lockpicking")
		if CanSaySomething() && Utility.RandomInt(1,100) < 30
			OthersPlayWorkOnSomething()
			AddPausetoVoice(5)
		endif
  ;  ElseIf menuName == "ContainerMenu"
   ;     PrintDebug("Player opened a container")
    ElseIf menuName == "BarterMenu"
        PrintDebug("Player is bartering with NPC")
		if CanSaySomething() && Utility.RandomInt(1,100) < 45
			OthersPlayStartBartering()
			AddPausetoVoice(5)
		endif
    ElseIf menuName == "Crafting Menu" || menuName == "Enchanting Menu" || menuName == "Alchemy Menu"
        PrintDebug("Player started crafting (smithing/tanning/etc.)")
		if CanSaySomething() && Utility.RandomInt(1,100) < 45
			OthersPlayWorkOnSomething()
			AddPausetoVoice(5)
		endif
    ElseIf menuName == "Book Menu"
        PrintDebug("Player opened a book/scroll")
		if CanSaySomething() && Utility.RandomInt(1,100) < 75
			SocialPlayHmm()
			AddPausetoVoice(5)
		endif
   ; ElseIf menuName == "Journal Menu"
   ;     PrintDebug("Player opened journal/quest log")
   ; ElseIf menuName == "MapMenu"
  ;      PrintDebug("Player opened the world map")
  ;  ElseIf menuName == "Training Menu"
  ;      PrintDebug("Player opened training menu")
    ElseIf menuName == "Sleep/Wait Menu"
        PrintDebug("Player opened wait/sleep menu")
		if CanSaySomething() && Utility.RandomInt(1,100) < 75
			OthersPlaySleepWait()
			AddPausetoVoice(5)
		endif
    ElseIf menuName == "LevelUp Menu"
        PrintDebug("Player opened level up screen")
		if CanSaySomething()
			OthersPlayLevelUp()
			AddPausetoVoice(5)
		endif
    Else
        PrintDebug("Unknown menu opened: " + menuName)
    EndIf
EndEvent

;--------------------Sexlab---------------
Event HentairimAdventureSceneStart(int aiThreadID, bool abHasPlayer) 
	;PrintDebug("Hentairim Adventure Scene Start")
	SexlabThread Thread = Sexlab.GetThread(aiThreadID)
	Actor[] Positions = Thread.GetPositions()
	
	;ignore scenes too far from player
	if positions[0].getdistance(Playerref) > 8000
		return
	endif
	int z
	while z < Positions.length
		AddDoNotDisturbSpell(Positions[z])
		z += 1
	endwhile
	
	if abHasPlayer
		Printdebug("Player In Sex Scene!, Pause Hentairim Adventure Voice")
		PlayerInSexScene = true
		PauseVoice = true
	EndIf
	
endevent

Event HentairimAdventureStageStart(int aiThreadID, bool abHasPlayer) 
	if !abHasPlayer
		return
	endIf
	
	if BodyEffectsAndDrugsEnabled()
		int failsafe = 0
		while Masterscript.isUpdating() && failsafe < 30
			utility.wait(1)
			failsafe += 1
		endwhile
		
		if MasterScript.IsGettingVaginallyPenetrated(Playerref)
			ModVaginalSensitivity(Playerref, -GetSensitiveBodySatiatePerStage())
		Endif
		
		if MasterScript.IsGettingAnallyPenetrated(Playerref)
			ModAnalSensitivity(Playerref, -GetSensitiveBodySatiatePerStage())
		endif
		
		if MasterScript.ActorIsgivingtitfuck(Playerref)
			ModBoobsSensitivity(Playerref, -GetSensitiveBodySatiatePerStage())
		endif
		
		; process each non player actor to see if its satisfyable PP
		if GetHugePPAddictionRemainingHours(PlayerRef) > 0 && !MasterScript.IsLeadIN(playerref)
			actor[] tmpactorlist = Masterscript.GetPlayerSceneActorlist()
			int z = 0
			while z < tmpactorlist.length
				; only satisfy addiction if penis meets threshold
				if Masterscript.CanActorSatisfyPCHugePPAddiction(tmpactorlist[z])
					ModHugePPAddiction(PlayerRef, -GetHugePPAddictionSatiatePerStage())
				endif
				z += 1
			endwhile
		endif
	
	endif
	
endevent

actor[] DrainedEssence

Event HentairimAdventureOnOrgasm(Form akAktor, Int aithread)
	actor char = akAktor as actor
	PrintDebug(char.getdisplayname() + " HentairimAdventureOnOrgasm: Event triggered | ThreadID=" + aithread)
	SexlabThread Thread = Sexlab.GetThread(aithread)
	
	if !Thread.HasPlayer()
		PrintDebug("HentairimAdventureOnOrgasm: Thread has no player, exiting early")
		return
	endif
	
	;Process Cum Addiction
	if BodyEffectsAndDrugsEnabled()
		PrintDebug("HentairimAdventureOnOrgasm: Body effects & drugs enabled")
		if MasterScript.IsSuckingOffOther(playerref) && MasterScript.ActorIsgettingSuckedOff(char)
			PrintDebug("HentairimAdventureOnOrgasm: Player sucking off other & " + char + " is getting sucked off → reducing cum addiction")
			ModCumAddiction(playerref , -GetCumAddictionSatiatePerOrgasm())
		endif
		
		if Char == Playerref && MasterScript.IsGettingPenetrated(playerref)
			PrintDebug("HentairimAdventureOnOrgasm: Player is getting penetrated → reducing sex addiction")
			ModSexAddiction(playerref , -GetSexAddictionSatiatePerOrgasm())
		endif
	else
		PrintDebug("HentairimAdventureOnOrgasm: Body effects & drugs disabled, skipping addiction processing")
	Endif
	
	;Process Essence Collection
	if char != Playerref && (!MasterScript.PCisVictim() || getessenceevenwhenvictim == 1) && (!char.isplayerteammate() || teammategivesessence == 1) && papyrusutil.countactor(DrainedEssence,char) <= 0
		PrintDebug("HentairimAdventureOnOrgasm: Essence drain check passed for " + char)
		if (Sexlab.DaysSinceLastSex(char) >= dayssincelastsexbeforecandrainessenceagain || !Sexlab.HadSex(char) || Sexlab.SexCount(char) <= 0) 
			PrintDebug("HentairimAdventureOnOrgasm: " + char + " eligible for essence drain")
			Bool CompletedRequirements = SatisfyEssenceRequirement(char , 1)
			PrintDebug("HentairimAdventureOnOrgasm: Essence requirement completed=" + CompletedRequirements)
			DrainedEssence = PapyrusUtil.PushActor(DrainedEssence,char)
			
			if CompletedRequirements
				PrintDebug("HentairimAdventureOnOrgasm: Requirements met, paying out essence reward")
				EssenceRewardsPayout()
			else
				PrintDebug("HentairimAdventureOnOrgasm: Requirements not met, skipping essence reward")
			endif
		else
			PrintDebug("HentairimAdventureOnOrgasm: " + char + " not eligible for essence drain yet")
		endif
	else
		PrintDebug("HentairimAdventureOnOrgasm: Essence drain skipped for " + char)
	endif
	
	if (!MasterScript.PCisVictim() || getessenceevenwhenvictim == 1) && playerref != char && (!char.isplayerteammate() || teammategivesessence == 1)
		PrintDebug("HentairimAdventureOnOrgasm: Adding faint essence reward: " + faintessenceperorgasm)
		AddFaintEssence(faintessenceperorgasm)
	else
		PrintDebug("HentairimAdventureOnOrgasm: Faint essence not added for " + char)
	endif
	
	PrintDebug("HentairimAdventureOnOrgasm: Event complete for " + char)
EndEvent


Function EssenceRewardsPayout()
	int Reward = GetEssenceRewardsValue()
	Masterscript.Announce("Essence Collection Complete! You Get " + Reward + " Premium Essence!" , icon = "Hentairim\Trophy.dds" ,PlaySFX = "Fanfare")
	AddPremiumEssence(Reward)
	ResolveEssenceRequirements(true)
Endfunction

Event HentairimAdventureSceneEnd(int aiThreadID, bool abHasPlayer) 
	PrintDebug("Hentairim Adventure Scene end")
	SexlabThread Thread = Sexlab.GetThread(aiThreadID)
	Actor[] Positions = Thread.GetPositions()
	int z
	while z < Positions.length
		RemoveDoNotDisturbSpell(Positions[z])
		z += 1
	endwhile
	
	if abHasPlayer
		Printdebug("Player In Sex Scene!, Pause Hentairim Adventure Voice")
		PlayerInSexScene = false
		PauseVoice = false
		DrainedEssence = new actor[1]
		DrainedEssence[0] = Playerref
	EndIf
endevent

;--------------Animation Event--------------------

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if CanSaySomething()
		If asEventName == "weaponSwing"
			PrintDebug("PC Weapon Swing")
			if utility.randomInt(1,100) < 40
				CombatPlayAttack()
			endif
		elseif asEventName == "PowerAttack_Start_End"
			PrintDebug("PC Weapon Power Attack Swing")
			if utility.randomInt(1,100) < 70
				CombatPlayPowerAttack()
			endif
		elseif asEventName == "BowRelease"
			PrintDebug("PC BowRelease")
			if utility.randomInt(1,100) < 40
				CombatPlayAttack()
			endif
		EndIf
		AddPausetoVoice(3)
	endif
EndEvent

;--------------Combat --------------------
Event OnEnterBleedout()
    printdebug("[OnEnterBleedout] Event fired")

    if CanSaySomething()
        printdebug("[OnEnterBleedout] CanSaySomething() = TRUE, calling CombatPlayBleedOut()")
        CombatPlayBleedOut()
    else
        printdebug("[OnEnterBleedout] CanSaySomething() = FALSE, skipping CombatPlayBleedOut()")
    endif

    AddPausetoVoice(5)
    printdebug("[OnEnterBleedout] Voice pause added (5s) -> End")
EndEvent

int HitTimesBelowquarterHealth
Bool CommentedDIfficultBattle
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    printdebug("[OnHit] Event fired: Aggressor=" + akAggressor + " Source=" + akSource + " Projectile=" + akProjectile + " PowerAttack=" + abPowerAttack + " SneakAttack=" + abSneakAttack + " BashAttack=" + abBashAttack + " HitBlocked=" + abHitBlocked)

    Actor Aggressor = akAggressor as Actor
    if akSource == None || Aggressor == None || Aggressor == PlayerRef || akSource as Spell != None || Playerref.GetActorValue("Health") <= 0
        return
    endif
	
	if Playerref.GetActorValue("Health") / Playerref.GetBaseActorValue("Health") < 0.25
		HitTimesBelowquarterHealth += 1
	endIf
	
    if CanSaySomething()
        printdebug("[OnHit] CanSaySomething() = TRUE, calling CombatPlayHit()")
		if HitTimesBelowQuarterHealth > 1 && !CommentedDIfficultBattle && utility.randomInt(1,100) <= 50
			CommentedDIfficultBattle = true
			CombatPlayDifficult()
			AddPausetoVoice(5)
		else
			CombatPlayHit()
		endIf

        if !MadeCombatOpeningSpeech ; attacked out of sight
            printdebug("[OnHit] No opening speech made yet -> waiting 3s then SocialPlayGrunt()")
            Utility.Wait(3)
			If CanSaySomething()
				SocialPlayGrunt()
				AddPausetoVoice(3)
			endif
            MadeCombatOpeningSpeech = true
            printdebug("[OnHit] Opening speech done")
        endif

        AddPausetoVoice(3)
        printdebug("[OnHit] Voice pause added (3s)")
    else
        printdebug("[OnHit] CanSaySomething() = FALSE, skipping")
    endif
EndEvent


;--------------------Adventure Actions-----------------------

Function OpenActionMenu()
    PrintDebug("[OpenActionMenu] Called")

    Actor Target = SelectActorMenu()
    PrintDebug("[OpenActionMenu] Target=" + Target)

    if !Target
        PrintDebug("[OpenActionMenu] FAIL: No target selected")
        Return
    Endif
	
	Followers = PO3_SKSEFunctions.GetPlayerFollowers()	
	PrintDebug("[OpenActionMenu] Followers count=" + Followers.Length)
		
    Int Selected
    b612_SelectList AdventureActionsMenu = GetSelectList()
	String[] AdventureActionsarr
	if Target == Playerref ;if selected actor is self
		AdventureActionsarr = StringUtil.Split("Check Essence Goal;Examine Myself;Entice Surroundings;Use Essence",";")
		PrintDebug("[OpenActionMenu] Target is Player, actions=" + AdventureActionsarr.Length)
	;elseif Playerref.IsInCombat()
	;	AdventureActionsarr = StringUtil.Split("Observe;Surrender;Rape",";")
	;	PrintDebug("[OpenActionMenu] Player in combat, base actions=" + AdventureActionsarr.Length)
		
	elseif Target.isplayerteammate() ;if selected actor is Teammate	
		AdventureActionsarr = StringUtil.Split("Observe;Have Sex;Entice Surroundings with Follower",";")
	else ;if selected actor is npc
		AdventureActionsarr = StringUtil.Split("Observe;Seduce;Rape",";")
		PrintDebug("[OpenActionMenu] Target is NPC, actions=" + AdventureActionsarr.Length)
		if Followers.length > 0
			AdventureActionsarr = Papyrusutil.PushString(AdventureActionsarr, "Dual Seduction")
			PrintDebug("[OpenActionMenu] Added Dual Seduction option")
			
			AdventureActionsarr = Papyrusutil.PushString(AdventureActionsarr, "Team Rape")
			PrintDebug("[OpenActionMenu] Added Team Rape option")
		endif

	endif
	
    Selected = AdventureActionsMenu.Show(AdventureActionsarr)
    PrintDebug("[OpenActionMenu] Selected index=" + Selected + " Action=" + AdventureActionsarr[Selected])
	
	if AdventureActionsarr[Selected] == "Check Essence Goal"

		;SheathWeapon(playerref)
		;playerref.playidle(IdleNoteRead)
		;Spinicon.Show("Checking Notes...")
		;utility.wait(3)
		ShowCurrentStatus()
		;Spinicon.Hide()
		;Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	elseif AdventureActionsarr[Selected] == "Examine Myself"
		ExamineOwnStatus()
	elseif AdventureActionsarr[Selected] == "Touch myself"
		Playerref.SetRestrained(true)
		SetAnimType(playerref,7)
		Utility.wait(8)
		SetAnimType(playerref,99)
		PLayerref.SetRestrained(false)
		;SexLab.StartSceneQuick(PlayerRef)
	elseif	AdventureActionsarr[Selected] == "Entice Surroundings"
		if Masterscript.GetCurrentGameTimeHours() - LastSeductionTime > hoursbeforecanseduceagain || LastSeductionTime == 0
			SeduceAroundMe()
		else
			float timePassed = MasterScript.GetCurrentGameTimeHours() - LastSeductionTime
			float hoursRemaining = HoursBeforeCanSeduceAgain

			if timePassed < HoursBeforeCanSeduceAgain
				hoursRemaining = HoursBeforeCanSeduceAgain - timePassed
			else
				hoursRemaining = 0
			endif
			Masterscript.Announce("You Can Seduce Again after " + math.ceiling(hoursRemaining) + " Hours", "Hentairim/Failed.dds" ,playsfx = "Buzzer")
		endif
	elseif AdventureActionsarr[Selected] == "Use Essence"
		PrintDebug("[OpenActionMenu] Trigger -> Use Essence")
		UseFaintEssence()
	elseif AdventureActionsarr[Selected] == "Look At"
	;	SheathWeapon(playerref)
		PrintDebug("[OpenActionMenu] Trigger -> Look At(Target=" + Target + ")")
		;FaceActor(PlayerRef , Target)
		;playerref.playidle(Idlestudy)
	;	utility.wait(5)
		
	;	playerref.playidle(IdlestudyExit)
	;elseif AdventureActionsarr[Selected] == "Flip Middle Finger"
	;	SheathWeapon(playerref)
	;	PrintDebug("[OpenActionMenu] Trigger -> Flip Middle Finger(Target=" + Target + ")")
	;	Target.SetRestrained(true)
	;	FaceActor(PlayerRef , Target)
	;	FaceActor(Target , PlayerRef)
	;	PlayAnim(Playerref, 51)
	;	utility.wait(1.2)
	;	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	;	ShowMiddleFinger(Target)	
	elseif AdventureActionsarr[Selected] == "Seduce"
	
		if  Masterscript.GetCurrentGameTimeHours() - LastSeductionTime > hoursbeforecanseduceagain || LastSeductionTime == 0
			Seduce(Target)
		else
			float timePassed = MasterScript.GetCurrentGameTimeHours() - LastSeductionTime
			float hoursRemaining = HoursBeforeCanSeduceAgain

			if timePassed < HoursBeforeCanSeduceAgain
				hoursRemaining = HoursBeforeCanSeduceAgain - timePassed
			else
				hoursRemaining = 0
			endif
			Masterscript.Announce("You Can Seduce Again after " + math.ceiling(hoursRemaining) + " Hours", "Hentairim/Failed.dds" ,playsfx = "Buzzer")
		endif
	elseif AdventureActionsarr[Selected] == "Dual Seduction"
		if Masterscript.GetCurrentGameTimeHours() - LastSeductionTime > hoursbeforecanseduceagain || LastSeductionTime == 0
			PrintDebug("[OpenActionMenu] Trigger -> Dual Seduction(Target=" + Target + ")")
			Actor Follower = SelectFollowerMenu()
			if Masterscript.GetActorArousal(Follower) < minfollowerarousalforrape
				PrintDebug("[OpenActionMenu] FAIL: Follower not aroused enough")
				Masterscript.Announce("Your Follower is Not Interested in Raping" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
				return
			endif
			SheathWeapon(playerref)
			SheathWeapon(Follower)
			PrintDebug("[OpenActionMenu] Follower=" + Follower)
			Int TargetSex = SexLab.GetSex(Target)
			if Follower && Sexlab.ValidateActor(Follower) > 0
				DualSeduction(Follower, Target)
			else
				Masterscript.Announce("Follower Is Not Available!" , "Hentairim/Failed.dds" ,playsfx = "Buzzer")
			endif
		else
			float timePassed = MasterScript.GetCurrentGameTimeHours() - LastSeductionTime
			float hoursRemaining = HoursBeforeCanSeduceAgain

			if timePassed < HoursBeforeCanSeduceAgain
				hoursRemaining = HoursBeforeCanSeduceAgain - timePassed
			else
				hoursRemaining = 0
			endif
			Masterscript.Announce("You Can Seduce Again after " + math.ceiling(hoursRemaining) + " Hours", "Hentairim/Failed.dds" ,playsfx = "Buzzer")
		endif
	elseif AdventureActionsarr[Selected] == "NPC Request"
		PrintDebug("[OpenActionMenu] Trigger -> NPC Request(Target=" + Target + ")")
		if !Target.HasSpell(HentairimNPCRequestSpell)
			Target.AddSpell(HentairimNPCRequestSpell)
		endif
	;elseif AdventureActionsarr[Selected] == "Surrender"
	;	if PO3_SKSEFunctions.IsPluginFound("BakaMotionData.esp")
	;		PlayBaboIdles(playerref, BaboDefeatSurrender)
	;	else
	;	SheathWeapon(playerref)

	;	Playerref.PlayIdle(IdleSurrender)
	;	Utility.wait(5)
	;	endif
		
	elseif AdventureActionsarr[Selected] == "Observe"
		PrintDebug("[OpenActionMenu] Trigger -> Observe(Target=" + Target + ")")

		GetExamineReport(Target)

	elseif AdventureActionsarr[Selected] == "Have Sex"
		if Masterscript.GetActorArousal(Target) < minfollowerarousalforrape
			Masterscript.Announce(Target.GetDisplayName() + "is Not Interested in Having Sex" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
		else
			sexlab.StartSceneQuick(Target, Playerref)
		endif
	elseif AdventureActionsarr[Selected] == "Entice Surroundings with Follower"
		if Masterscript.GetCurrentGameTimeHours() - LastSeductionTime > hoursbeforecanseduceagain || LastSeductionTime == 0
			SeduceAroundMeWithFollower(Target)
		else
			float timePassed = MasterScript.GetCurrentGameTimeHours() - LastSeductionTime
			float hoursRemaining = HoursBeforeCanSeduceAgain

			if timePassed < HoursBeforeCanSeduceAgain
				hoursRemaining = HoursBeforeCanSeduceAgain - timePassed
			else
				hoursRemaining = 0
			endif
			Masterscript.Announce("You Can Seduce Again after " + math.ceiling(hoursRemaining) + " Hours", "Hentairim/Failed.dds" ,playsfx = "Buzzer")
		endif
	elseif AdventureActionsarr[Selected] == "Rape"
		PrintDebug("[OpenActionMenu] Trigger -> Rape(Target=" + Target + ")")
		Float RapeSuccessChance = GetRapeSuccessChance(Playerref, Target , rapechancemultiplier)
		PrintDebug("[OpenActionMenu] RapeSuccessChance=" + RapeSuccessChance)

		if Utility.randomfloat(0 , 100) <= RapeSuccessChance
			PrintDebug("[OpenActionMenu] Rape roll success")
			int TargetSex = Sexlab.getsex(Target)
			int PlaYerSex = Sexlab.getsex(Playerref)
			PrintDebug("[OpenActionMenu] TargetSex=" + TargetSex + " PlayerSex=" + PlayerSex)
			if TargetSex == 0 || (TargetSex == 2 && PlayerSex == 1) ;female/futa pc ride male victim. female pc ride futa victim
				if PlayerSex == 2
					SexLab.TreatAsFemale(playerref)
				endif
				sexlab.StartSceneQuick(Playerref , Target , akSubmissive = Target , asTags = "~cowgirl,~Femdom ,~1ascg,~2ascg,~3ascg,~4ascg,-1asvp,,-2asvp,,-3asvp,-4asvp")
			elseif (TargetSex == 2 || TargetSex == 1) && PlayerSex == 2 ;futa pc fuck futa/female victim
				SexLab.TreatAsFemale(Target)
				sexlab.StartSceneQuick(Target, Playerref , akSubmissive = Target , asTags = "~vaginal,~anal,-cowgirl,-femdom")
			elseif TargetSex == 1 && PlayerSex == 1
				SexLab.TreatAsFuta(playerref)
				sexlab.StartSceneQuick(Target, Playerref , akSubmissive = Target , asTags = "~vaginal,~anal,-cowgirl,-femdom")
			elseif TargetSex > 2 ;creature
			
				SexLab.TreatAsFemale(playerref)
				sexlab.StartSceneQuick(Playerref,Target , akSubmissive = Target , asTags = "~vaginal,~anal")
			else
				sexlab.StartSceneQuick(Playerref,Target , akSubmissive = Target )
			EndIf
		else
			PrintDebug("[OpenActionMenu] Rape roll failed")
			ApplyDamagestats(Playerref, 0.3 ,0.3 , 0.3)
			Masterscript.Announce(Target.getdisplayname() + " Resisted your Rape Attempts! You Suffer Damage" ,"Hentairim/QuestionExclamationMark.dds",playsfx = "BadOutcome")
		EndIf
	elseif AdventureActionsarr[Selected] == "Team Rape"
		PrintDebug("[OpenActionMenu] Trigger -> Team Rape(Target=" + Target + ")")
		Actor Follower = SelectFollowerMenu()
		PrintDebug("[OpenActionMenu] Follower=" + Follower)
		if !Follower || Sexlab.ValidateActor(Follower) <= 0
			PrintDebug("[OpenActionMenu] FAIL: Follower not available")
			Masterscript.Announce("Follower Is Not Available!" , "Hentairim/Failed.dds" ,playsfx = "Buzzer")
			return
		endif
		
		if Masterscript.GetActorArousal(Follower) < minfollowerarousalforrape
			PrintDebug("[OpenActionMenu] FAIL: Follower not aroused enough")
			Masterscript.Announce("Your Follower is Not Interested in Raping" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
		elseif Utility.randomfloat(0 , 100) <= GetRapeSuccessChance(Playerref, Target,rapechancemultiplier, HasFollower = true)
			PrintDebug("[OpenActionMenu] Team Rape roll success")
			Int TargetSex = Sexlab.GetSex(Target)
		    Int PlayerSex = Sexlab.GetSex(Playerref)
			Int FollowerSex = Sexlab.GetSex(Follower)
			PrintDebug("[OpenActionMenu] TargetSex=" + TargetSex + " PlayerSex=" + PlayerSex + " FollowerSex=" + FollowerSex)
			
			if TargetSex == 0 || (TargetSex == 2 && PlayerSex == 1) ;female pc & follower femdom futa/male victim
				if FollowerSex == 2
					Sexlab.TreatAsFemale(Follower)
				endif
				sexlab.StartSceneQuick(Playerref, Follower, Target, akSubmissive = Target , asTags = "~cowgirl,~femdom")
			elseif ((TargetSex == 1 || TargetSex == 2) && PlayerSex == 2) || (TargetSex == 1) && PlayerSex == 1 ;futa PC & Follower x female/futa victim
				Sexlab.TreatAsFemale(Target)
				Sexlab.TreatAsFuta(Playerref)
				Sexlab.TreatAsFuta(Follower)
				sexlab.StartSceneQuick(Target, Playerref, Follower, akSubmissive = Target , asTags = "~Vaginal,~Anal, -femdom")
			elseif TargetSex >2 ; Creature
				
				Sexlab.TreatAsFemale(Playerref)
				Sexlab.TreatAsFemale(Follower)
				sexlab.StartSceneQuick(Playerref, Follower, Target, akSubmissive = Target , asTags = "~Vaginal,~Anal")
			else
				sexlab.StartSceneQuick(Target, Playerref, Follower, akSubmissive = Target)
			endif
		else
			PrintDebug("[OpenActionMenu] Team Rape roll failed")
			ApplyDamagestats(Playerref, 0.3 ,0.3 , 0.3)
			ApplyDamagestats(Follower, 0.3 ,0.3 , 0.3)
			Masterscript.Announce(Target.getdisplayname() + "Resisted your Rape Attempts! You and Your Follower Suffer Damage" ,"Hentairim/QuestionExclamationMark.dds" ,playsfx = "BadOutcome")
		endif
    endif

    PrintDebug("[OpenActionMenu] End")
EndFunction

Function SeduceAroundMe()
	Int SeduceTimerLimit
	
	if seduceseconds > 0
		AddDoNotDisturbSpell(Playerref)
		PlayRandomSeductionAnims(PlayerRef)
		SeduceTimerLimit = SeduceSeconds
		
		int SeduceExpressionCounter = 1
		printdebug("[Seduce] Starting expression loop with timer=" + SeduceTimerLimit)

		Spinicon.Show("Seducing....")

		;Play voice
		if CanSaySomething()
			HornyPlaySeduce()
			AddPausetoVoice(5)
		endif

		while SeduceTimerLimit > 0
			SeduceExpressionCounter = utility.randomInt(1,5)
			ExpressionsLookUp(PlayerRef , "Seduce" + SeduceExpressionCounter as String)
			printdebug("[Seduce] Expression step=" + SeduceExpressionCounter + " RemainingTimer=" + SeduceTimerLimit)

			Utility.Wait(utility.randomfloat(1,3))
			SeduceTimerLimit -= 1
		endwhile

		printdebug("[Seduce] Expression loop complete")
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		Spinicon.Hide()
	
	endif
	
	LastSeductionTime = Masterscript.GetCurrentGameTimeHours()

	if !FuckbyNPC(Playerref , false , none , true)
		RemoveDoNotDisturbSpell(Playerref)
		Masterscript.Announce("No One Around Wants to Have Sex!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
	endif

Endfunction

Function SeduceAroundMeWithFollower(Actor Follower)
	Int SeduceTimerLimit
	if seduceseconds > 0		
		AddDoNotDisturbSpell(Playerref)
		AddDoNotDisturbSpell(Follower)
		Follower.SetRestrained(true)
		SeduceTimerLimit = SeduceSeconds
		PlayRandomSeductionAnims(PlayerRef)
		PlayRandomSeductionAnims(Follower)

		int SeduceExpressionCounter = 1
		printdebug("[Seduce] Starting expression loop with timer=" + SeduceTimerLimit)

		Spinicon.Show("Seducing....")

		;Play voice
		if CanSaySomething()
			HornyPlaySeduce()
			AddPausetoVoice(5)
		endif

		while SeduceTimerLimit > 0
			SeduceExpressionCounter = utility.randomint(1,5)
			ExpressionsLookUp(PlayerRef , "Seduce" + SeduceExpressionCounter as String)
			SeduceExpressionCounter = utility.randomint(1,5)
			ExpressionsLookUp(Follower , "Seduce" + SeduceExpressionCounter as String)
			printdebug("[Seduce] Expression step=" + SeduceExpressionCounter + " RemainingTimer=" + SeduceTimerLimit)

			Utility.Wait(utility.randomfloat(1,3))
			SeduceExpressionCounter += 1
			SeduceTimerLimit -= 1
		endwhile

		printdebug("[Seduce] Expression loop complete")

		Spinicon.Hide()
		LastSeductionTime = Masterscript.GetCurrentGameTimeHours()
		Follower.SetRestrained(false)
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		Debug.SendAnimationEvent(Follower, "IdleForceDefaultState")
	endif

	if !FuckbyNPC(Playerref , false , Follower , true)
		RemoveDoNotDisturbSpell(Playerref)
		RemoveDoNotDisturbSpell(Follower)
		Masterscript.Announce("No One Around Wants to Have Sex!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
	endif

Endfunction

Function PlayRandomSeductionAnims(Actor char, Actor Target = none)
	int rand = utility.randomInt(1,4)
	if rand == 1 ;caress boobs
		FaceActor(char , Target)
		FaceActor(Target , char)
		PlayAnim(char, 3) 
	elseif rand == 2 ; flaunt ass
		FaceActor(char , Target, true)
		FaceActor(Target , char)
		PlayAnim(char, 4)
	elseif rand == 3 ;flaunt ass  head down
		FaceActor(char , Target, true)
		FaceActor(Target , char)
		PlayAnim(char, 2)
	elseif rand == 4 ;slut moves
		FaceActor(char , Target)
		FaceActor(Target , char)
		PlayAnim(char, 5)
	endif
	
	
Endfunction

Function Seduce(Actor char)
	
    printdebug("[Seduce] Called with char=" + char)

    if !char
        printdebug("[Seduce] FAIL: char is None")
        return
    EndIf
	Int SeduceTimerLimit
	if seduceseconds > 0	
		SeduceTimerLimit= SeduceSeconds

		AddDoNotDisturbSpell(Playerref)
		AddDoNotDisturbSpell(char)
		char.SetRestrained(True)
		
		PlayRandomSeductionAnims(Playerref , char)

		int SeduceExpressionCounter = 1
		printdebug("[Seduce] Starting expression loop with timer=" + SeduceTimerLimit)

		Spinicon.Show("Seducing....")

		;Play voice
		if CanSaySomething()
			HornyPlaySeduce()
			AddPausetoVoice(5)
		endif

		while SeduceTimerLimit > 0
			SeduceExpressionCounter = utility.randomInt(1,5)
			ExpressionsLookUp(PlayerRef , "Seduce" + SeduceExpressionCounter as String)
			printdebug("[Seduce] Expression step=" + SeduceExpressionCounter + " RemainingTimer=" + SeduceTimerLimit)

			Utility.Wait(utility.randomfloat(1,3))
			SeduceTimerLimit -= 1
		endwhile

		printdebug("[Seduce] Expression loop complete")
		char.SetRestrained(false)
		Spinicon.Hide()
		LastSeductionTime = Masterscript.GetCurrentGameTimeHours()
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	endif

	
	if Utility.randomfloat(1,100) <= GetSeduceSuccessChance(playerref,char,Masterscript.GetActorArousal(Char),seducechancemultiplier ,false)
		MasterScript.Announce(char.GetDisplayName() + " Is Aroused wants To Fuck!" , icon = "Hentairim/HeartLips.dds",playsfx = "chime")
		if !sexlab.StartSceneQuick(Playerref,char)
			RemoveDoNotDisturbSpell(Playerref)
			RemoveDoNotDisturbSpell(char)
			
		endif
	else	
		RemoveDoNotDisturbSpell(Playerref)
		RemoveDoNotDisturbSpell(char)
		Masterscript.Announce(char.GetDisplayName() + " Is Not Interested!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
	endif

EndFunction

Function DualSeduction(Actor Follower, Actor char)
    printdebug("[DualSeduction] Called with char=" + char + " follower=" + Follower)

    if !char
        printdebug("[DualSeduction] FAIL: char is None")
        return
    EndIf
	
		Int SeduceTimerLimit
		if seduceseconds > 0	
			SeduceTimerLimit = SeduceSeconds
			AddDoNotDisturbSpell(Playerref)
			AddDoNotDisturbSpell(Follower)
			AddDoNotDisturbSpell(char)
			char.SetRestrained(True)
			Follower.SetRestrained(True)
			
			
			PlayRandomSeductionAnims(PlayerRef,char)
			PlayRandomSeductionAnims(Follower,char)

			int SeduceExpressionCounter = 1
			printdebug("[DualSeduction] Starting expression loop with timer=" + SeduceTimerLimit)

			Spinicon.Show("Seducing....")

			;Play voice
			if CanSaySomething()
				HornyPlaySeduce()
			endif

			while SeduceTimerLimit > 0
				SeduceExpressionCounter = utility.randomInt(1,5)
				ExpressionsLookUp(PlayerRef , "Seduce" + SeduceExpressionCounter as String)
				SeduceExpressionCounter = utility.randomInt(1,5)
				ExpressionsLookUp(Follower , "Seduce" + SeduceExpressionCounter as String)
				printdebug("[DualSeduction] Expression step=" + SeduceExpressionCounter + " RemainingTimer=" + SeduceTimerLimit)

				Utility.Wait(utility.randomfloat(1,3))
				SeduceTimerLimit -= 1
			endwhile
			char.SetRestrained(false)
			Follower.SetRestrained(false)
			
			Debug.SendAnimationEvent(playerref, "IdleForceDefaultState")
			Debug.SendAnimationEvent(Follower, "IdleForceDefaultState")
			Debug.SendAnimationEvent(char, "IdleForceDefaultState")
		endif
		LastSeductionTime = Masterscript.GetCurrentGameTimeHours()
		if Utility.randomfloat(1,100) <= GetSeduceSuccessChance(playerref,char,Masterscript.GetActorArousal(Char),seducechancemultiplier , true)
			MasterScript.Announce(CHAR.GetDisplayName() + " Is Aroused wants To Fuck!" , icon = "Hentairim/HeartLips.dds",playsfx = "chime")
			if !sexlab.StartSceneQuick(CHAR, Playerref , Follower)
				RemoveDoNotDisturbSpell(Playerref)
				RemoveDoNotDisturbSpell(Follower)
				RemoveDoNotDisturbSpell(char)
			endif
		else	
			RemoveDoNotDisturbSpell(Playerref)
			RemoveDoNotDisturbSpell(Follower)
			RemoveDoNotDisturbSpell(char)
			Masterscript.Announce(CHAR.GetDisplayName() + " Is Not Interested!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
		endif
		
		Spinicon.Hide()
		LastSeductionTime = Masterscript.GetCurrentGameTimeHours()

EndFunction


Actor Function SelectActorMenu()
    printdebug("[SelectActorMenu] Called")
	
    Int Selected
    b612_SelectList ActorsMenu = GetSelectList()
	Actor[] ActorsNearby
    String[] ActorNamesArr
	
	ActorsNearby = GetNearbyActors()

    printdebug("[SelectActorMenu] Found " + ActorsNearby.length + " nearby actors")

    int z
    while z < ActorsNearby.length
        ActorNamesArr = PapyrusUtil.PushString(ActorNamesArr, ActorsNearby[z].GetDisplayName())
        printdebug("[SelectActorMenu] Added actor " + z + " -> " + ActorsNearby[z].GetDisplayName())
        z += 1
    EndWhile

    Selected = ActorsMenu.Show(ActorNamesArr)
    printdebug("[SelectActorMenu] Selected index=" + Selected)

    If Selected >= 0 && Selected < ActorsNearby.length
        printdebug("[SelectActorMenu] Selected actor=" + ActorsNearby[Selected].GetDisplayName())
        Return ActorsNearby[Selected]
    Else
        printdebug("[SelectActorMenu] No valid selection")
    EndIf
EndFunction

Actor Function SelectFollowerMenu()
    printdebug("[SelectFollowerMenu] Called")
	
    Int Selected
    b612_SelectList FollowersMenu = GetSelectList()
    String[] FollowersNamesArr
    Followers = PO3_SKSEFunctions.GetPlayerFollowers()

    printdebug("[SelectFollowerMenu] Found " + Followers.length + " Followers")

    int z
    while z < Followers.length
       FollowersNamesArr = PapyrusUtil.PushString(FollowersNamesArr, Followers[z].GetDisplayName())
        printdebug("[SelectFollowerMenu] Added actor " + z + " -> " + Followers[z].GetDisplayName())
        z += 1
    EndWhile
	
	if  Followers.length > 1
		Selected = FollowersMenu.Show(FollowersNamesArr)
		printdebug("[SelectFollowerMenu] Selected index=" + Selected)

		If Selected >= 0 && Selected < Followers.length
			printdebug("[SelectFollowerMenu] Selected actor=" + Followers[Selected].GetDisplayName())
			Return Followers[Selected]
		Else
			printdebug("[SelectFollowerMenu] No valid selection")
		EndIf
	elseif Followers.length == 1
		return Followers[0]
	else
		return none
	endif
EndFunction


Function OpenDebugMenu()
	Int Selected
    b612_SelectList DebugToolsMenu = GetSelectList()
	b612_ItemSelect ItemSelect = GetItemSelect()
    String[] DebugToolsArr = StringUtil.Split("Copy Inventory Item to Rewards",";")
	 Selected = DebugToolsMenu.Show(DebugToolsArr)
	if DebugToolsArr[Selected] == "Copy Inventory Item to Rewards"
	
	endif
Endfunction

Actor[] Function GetNearbyActors()
	int Distance = 100
	actor FoundOne
	Actor FoundTwo
	Actor FoundThree
	Actor tmpActor
	int z
	while z <= 10
		tmpactor = PO3_SKSEFunctions.GetRandomActorFromRef(playerref, Distance, true)

		if Sexlab.ValidateActor(tmpactor) > 0 && tmpactor != none && tmpactor != Foundone && tmpactor != FoundTwo && tmpactor != FoundThree
			if FoundOne == none
				FoundOne = tmpactor
				Printdebug(" FoundOne :" + FoundOne.getdisplayname())
			elseif FoundTwo == none 
				FoundTwo = tmpactor
				Printdebug(" FoundTwo :" + FoundTwo.getdisplayname())
			elseif  FoundThree == none 
				FoundThree  = tmpactor
				Printdebug(" FoundThree :" + FoundThree.getdisplayname())
			endif
		endif
		Distance += 20
		z += 1
	endwhile
	
	
		actor[] ActorListtmp = new actor[1] ; Create Array of actors
		ActorListtmp[0] = Playerref
		
		if FoundOne
			ActorListtmp = Papyrusutil.PushActor(ActorListtmp,FoundOne)
		endif
		
		if  FoundTwo
			ActorListtmp = Papyrusutil.PushActor(ActorListtmp,FoundTwo)
		endif 
		
		if  FoundThree
			ActorListtmp = Papyrusutil.PushActor(ActorListtmp,FoundThree)
		endif 

		return ActorListtmp


endfunction

Int Function GetRaceMaxGangbangActor(Actor SexActor)
	string actorrace = SexActor.GetRace().GetName()
	;POPULATE THE LIST
	if (stringutil.find(actorrace ,"Skeever") > -1 || stringutil.find(actorrace ,"Zombie") > -1 || stringutil.find(actorrace ,"Draugr") > -1 || stringutil.find(actorrace ,"Skeleton") > -1 || stringutil.find(actorrace ,"Dog") > -1 || actorrace == "Wolf" || stringutil.find(actorrace ,"Wolf") > -1 || stringutil.find(actorrace ,"Orc") > -1 || stringutil.find(actorrace ,"Ork") > -1 || stringutil.find(actorrace ,"Riekling") > -1 || stringutil.find(actorrace ,"goblin") > -1 || stringutil.find(actorrace ,"Falmer") > -1) && stringutil.find(actorrace ,"Horker") == -1 && stringutil.find(actorrace ,"mount") == -1 && stringutil.find(actorrace ,"Reaper") == -1
		return 3
	elseif  stringutil.find(actorrace ,"Werewolf") > -1 || stringutil.find(actorrace ,"bear") > -1 || stringutil.find(actorrace ,"Ogrim") > -1 || stringutil.find(actorrace ,"Ogre") > -1 || stringutil.find(actorrace ,"Chaurus") > -1 || stringutil.find(actorrace ,"Troll") > -1 || stringutil.find(actorrace ,"Horse") > -1 || stringutil.find(actorrace ,"Giant") > -1 || stringutil.find(actorrace ,"Gargoyle") > -1 || stringutil.find(actorrace ,"Flier") > -1 || stringutil.find(actorrace ,"Goblin") > -1 && stringutil.find(actorrace ,"reaper") == -1
		return 2 
	else
		return 1
	endif
	
endfunction

Actor Function GetFirstNearbyCreatureForSex(Int Distance)
	Actor tmpActor
	int z
	int maxcount = 0
	while z <= 10
		tmpactor = PO3_SKSEFunctions.GetRandomActorFromRef(playerref, Distance, true)

		if Sexlab.ValidateActor(tmpactor) > 0 && tmpactor != none && Sexlab.GetSex(tmpactor) >= 3
			return tmpactor
		endif
		Distance += 25
		z += 1
	endwhile
endfunction


function printdebug(string contents = "")
	if printdebug == 1
		miscutil.printconsole("Hentairim Adventure : " + contents)
	endif
endfunction

function WritetoErrorlogs(string Header = "Not Specified" ,String contents = "")
	JsonUtil.StringListAdd("ErrorLog.json", Header, " : " + contents, TRUE)
endfunction




;---------DO NOT DISTURB SPELL-------------

;When Spell is applied, Aggressors Will be Redirected to Other Combatants, and sheath if there are no one else. resume combat when spell is removed.
;Persist means Do Not Disturb Do Not Go Away After Sex, but persists for another 1000 Seconds(fallback). should be removed manually by another process instead of waiting for it to remove by itself. if persists if maintained.
Function AddDoNotDisturbSpell(Actor Char , Int Persist = 0)
	if usedonotdisturb == 1
		Masterscript.AddDoNotDisturbSpell(char,Persist)
	endif
endfunction

Function RemoveDoNotDisturbSpell(Actor Char)
	Masterscript.RemoveDoNotDisturbSpell(char)
endfunction

;---------------UTILS-----------------------
Float TimeofLastVoice
float function GetCurrentRealTimeSeconds()
	return Masterscript.GetCurrentRealTimeSeconds()
endFunction

Function AddPausetoVoice(float value) ;in seconds
	Storageutil.SetFloatvalue(None,"HentairimVoicePauseUntilSeconds", GetCurrentRealTimeSeconds() + Value)
EndFunction

Bool Function CanSaySomething()

	Float CurrentRealTimeSeconds = GetCurrentRealTimeSeconds()
	Float SUHentairimVoicePauseUntilSeconds = Storageutil.GetFloatvalue(None,"HentairimVoicePauseUntilSeconds",0)
	
	
	printdebug("CurrentRealTimeSeconds : " + CurrentRealTimeSeconds)
	printdebug("SUHentairimVoicePauseUntilSeconds : " + SUHentairimVoicePauseUntilSeconds)
	return enableadventurevoice == 1 && (CurrentRealTimeSeconds >= SUHentairimVoicePauseUntilSeconds && !PauseVoice)
EndFunction


Function FaceActor(Actor akActorToTurn, Actor akTargetActor, bool abShowBack = false)
    Masterscript.FaceActor(akActorToTurn, akTargetActor, abShowBack)
EndFunction


Function CombatStart()
    printdebug("CombatStart function started.")
    playerInCombat = true
    printdebug("playerInCombat set to: " + playerInCombat)
    LastCombatStartTime = GetCurrentRealTimeSeconds()
    printdebug("LastCombatStartTime set to: " + LastCombatStartTime)  
    
EndFunction

Function EncounterEnemyInDungeon()
	if CanSaySomething() && PO3_SKSEFunctions.IsDetectedByAnyone(Playerref)
		CombatPlayDungeonEnemyEncounter()
		MadeEnemyEncounterSpeech = true
	endif
endfunction

Function MakeCombatOpeningSpeech()
    printdebug("MakeCombatOpeningSpeech function started.")
    if !MadeCombatOpeningSpeech && CanSaySomething()
        printdebug("Speech has not been made yet. Updating enemies.")
        
        Enemies = PO3_SKSEFunctions.GetCombatTargets(PlayerRef)
        printdebug("Number of Enemies updated: " + Enemies.Length)
        
        If  NearbyHasEnemy()
            printdebug("Conditions met. Playing combat opening speech.")
            CombatPlayStateWithEnemy()
            MadeCombatOpeningSpeech = true
            printdebug("MadeCombatOpeningSpeech set to: " + MadeCombatOpeningSpeech)
        else
            printdebug("Conditions for combat speech were not met.")
        endif
    else
        printdebug("Combat opening speech already made.")
    endif
EndFunction

Function CombatEnd()
    printdebug("CombatEnd function started.")
	
    playerInCombat = false
	MadeEnemyEncounterSpeech = false
	MadeCombatOpeningSpeech = false
	MadeFollowerDownComments = false
    HitTimesBelowquarterHealth = 0
	CommentedDIfficultBattle = false
    If CanSaySomething() 
		if HitTimesBelowquarterHealth > 1
			printdebug("Playing Difficult combat end comments.")
			if utility.randomint(1,2) == 1
				CombatPlayDifficultEnd()
			else
				CombatPlayExhaustion()
			endif
		else
			printdebug("Playing combat end comments.")
			CombatPlayEndComments()
		endif
		AddPausetoVoice(6)
    else
        printdebug("Conditions for combat end speech were not met.")
    endif
EndFunction

Bool Function NearbyHasEnemy()
    printdebug("NearbyHasEnemy function started.")
    int z = 0
    Bool Result = false
    
    ; Correct loop for checking array length
    while z < Enemies.Length && !Result
        if PlayerRef.GetDistance(Enemies[z]) < 2000.0 && PlayerRef.HasLOS(Enemies[z] as ObjectReference)
            printdebug("Found a nearby enemy in line of sight at index: " + z)
            Result = true
        endif
        z += 1
    EndWhile
    printdebug("NearbyHasEnemy function returning: " + Result)
    Return Result
EndFunction

Function SetAnimType(actor char, Int Value)
	MasterScript.SetAnimType(char, Value)
EndFunction



Bool Function IsBroken(actor char)
	return MasterScript.IsBroken(char)
endfunction

Function PlayAnim(actor char, int value)
	MasterScript.PlayAnim( char, value)
Endfunction

;----------Essence Hunting

;String[] HumanKeywords
;String[] CreatureKeywords
;String[] HumanKeywords  = Orc, Nord, Argonian, Breton, RedGuard, Dunmer, Altmer, Imperial, Khajiit, Bosmer
;String[] CreatureKeywords = Dwarven, Vampire, Necro, Insect, Spriggan, Lycanthrope,Falmer, Ogre, Daedra, Predator, Nature, Canine, Horse, Marine, Goblin.

int Function GetEssenceRewardsValue()
    ; Check if arrays are valid and have the same length
    if (RequirementsEssence.Length == 0 || RequirementsEssenceCount.Length == 0 || RequirementsEssenceSatisfied.Length == 0 || RequirementsEssence.Length != RequirementsEssenceCount.Length || RequirementsEssence.Length != RequirementsEssenceSatisfied.Length)
        printdebug("GetEssenceRewardsValue: Requirements arrays are not properly initialized or are mismatched.")
        return 0
    endif

    int totalReward = 0
    int i = 0

	printdebug("GetEssenceRewardsValue: All requirements met! Calculating total reward.")
	i = 0
	while i < RequirementsEssence.Length
		string currentKeyword = RequirementsEssence[i]
		int currentCount = RequirementsEssenceCount[i]
		int difficulty = GetEssenceKeywordDifficulty(currentKeyword)

		int keywordReward = difficulty * currentCount
		totalReward += keywordReward
		printdebug("Reward for " + currentKeyword + ": Difficulty(" + difficulty + ") * Count(" + currentCount + ") = " + keywordReward)
		i += 1
	endwhile
	printdebug("GetEssenceRewardsValue: Total calculated reward: " + totalReward)
	return totalReward

EndFunction

Bool Function UseFaintEssence()
	Int Selected
    b612_SelectList FaintEssenceMenu = GetSelectList()
	String[] FaintEssenceMenuActionsarr
	FaintEssenceMenuActionsarr = StringUtil.Split("Consume Drug;Set Gacha Pickup;Roll Gacha;Convert Faint to Premium Essence;Redeem Pity;Reset Essence Goal",";")
	Selected = FaintEssenceMenu.show(FaintEssenceMenuActionsarr)
	if FaintEssenceMenuActionsarr[Selected] == "Consume Drug"
		 SelectDrugtoConsume()
	elseif FaintEssenceMenuActionsarr[Selected] == "Set Gacha Pickup"
		SetGachaPickup()
	elseif FaintEssenceMenuActionsarr[Selected] == "Roll Gacha"
		RollGacha()
	elseif FaintEssenceMenuActionsarr[Selected] == "Convert Faint to Premium Essence"
		b612_QuantitySlider QtySlider = GetQuantitySlider()
		int Count
		int Conversionrate = jsonutil.GetIntValue("Hentairimadventure/GachaConfig.json","premiumessenceconversionrate", 50)
		int MaxConvertible = GetFaintEssence() / Conversionrate
		Count = QtySlider.show("Convert How Many?", 0 , MaxConvertible)
		if Count > 0
			ConverttoPremiumEssence(Count)
		endif
		
	elseif FaintEssenceMenuActionsarr[Selected] == "Redeem Pity"
		RedeemPity()
	elseif FaintEssenceMenuActionsarr[Selected] == "Reset Essence Goal"
		if AddFaintEssence(-100)
			ResolveEssenceRequirements(true)
			Masterscript.Announce("Essence Goal Reset!")
		endif
	endif
EndFunction

int Function GetRemainingEssenceValue()

    int remainingValue = 0
    int i = 0

    while i < RequirementsEssence.Length
        string currentKeyword = RequirementsEssence[i]
        int required = RequirementsEssenceCount[i]
        int satisfied = RequirementsEssenceSatisfied[i]
        
        ; Calculate how much more is needed for this specific essence
        int needed = required - satisfied
        if needed < 0
            needed = 0 ; Should not happen if SatisfyEssenceRequirement caps correctly, but a safe guard
        endif

        int difficulty = GetEssenceKeywordDifficulty(currentKeyword)
        
        int keywordRemainingValue = needed * difficulty
        remainingValue += keywordRemainingValue
        
        printdebug("Remaining for " + currentKeyword + ": Needed(" + needed + ") * Difficulty(" + difficulty + ") = " + keywordRemainingValue)
        i += 1
    endwhile
    
    printdebug("GetRemainingEssenceValue: Total remaining value: " + remainingValue)
    return remainingValue
EndFunction

Function SelectDrugtoConsume()
	Int Selected
    b612_SelectList DrugMenu = GetSelectList()
	String[] DrugMenuarr
	DrugMenuarr = StringUtil.Split("Lactating Potion;Sensitivity Surpressing Potion;Addiction Surpressing Potion",";")
	Selected = DrugMenu.show(DrugMenuarr)
	if Selected >= 0
		if AddFaintEssence(-100)
			SheathWeapon(playerref)
			playerref.playidle(IdleDrinkPotion)
			utility.wait(3)
			if DrugMenuarr[Selected] == "Lactating Potion"
				AddDrug(Playerref , 1)
				Masterscript.Announce("You Started to Lactate!")
			elseif DrugMenuarr[Selected] == "Sensitivity Surpressing Potion"
				ModBodySensitivity(Playerref,-30)
				Announce("You Surpressed Some of your Sensitivity!")
			elseif DrugMenuarr[Selected] == "Addiction Surpressing Potion"
				ModCumAddiction(Playerref,-30)
				ModHugePPAddiction(Playerref,-30)
				ModSexAddiction(Playerref,-30)
				Announce("You Surpressed Some of your Addiction!")
			endif
		endif
	endif
endfunction

Function SatisfyAllRemainingRequirements()

    int i = 0
    while i < RequirementsEssence.Length
        RequirementsEssenceSatisfied[i] = RequirementsEssenceCount[i]
        i += 1
    endwhile

EndFunction

bool Function SatisfyEssenceRequirement(actor char, int amount)
    string collectedKeyword = GetActorEssenceKeyword(char)
    printdebug("SatisfyEssenceRequirement: Actor=" + char + " Amount=" + amount + " CollectedKeyword=" + collectedKeyword)

    int i = 0
    while i < RequirementsEssence.Length
        printdebug("Check Index=" + i + " RequirementKeyword=" + RequirementsEssence[i] + " CurrentSatisfied=" + RequirementsEssenceSatisfied[i] + " RequiredCount=" + RequirementsEssenceCount[i])
        
        if collectedKeyword == RequirementsEssence[i]
            printdebug("Match Found: Index=" + i + " Keyword=" + RequirementsEssence[i])
            RequirementsEssenceSatisfied[i] = (RequirementsEssenceSatisfied[i] + amount) as int
            if RequirementsEssenceSatisfied[i] > RequirementsEssenceCount[i]
                RequirementsEssenceSatisfied[i] = RequirementsEssenceCount[i]
			else
				MasterScript.Announce("You Collected " + collectedKeyword + " Essence")
            endif
            printdebug("Updated Index=" + i + " Keyword=" + RequirementsEssence[i] + " Satisfied=" + RequirementsEssenceSatisfied[i] + "/" + RequirementsEssenceCount[i])
            i = RequirementsEssence.Length
        endif
        i += 1
    endwhile

    bool allRequirementsMet = true
    i = 0
    while i < RequirementsEssence.Length
        if RequirementsEssenceSatisfied[i] < RequirementsEssenceCount[i]
            allRequirementsMet = false
            printdebug("Requirement Not Met: Index=" + i + " Keyword=" + RequirementsEssence[i] + " Satisfied=" + RequirementsEssenceSatisfied[i] + "/" + RequirementsEssenceCount[i])
            i = RequirementsEssence.Length
        endif
        i += 1
    endwhile

    printdebug("SatisfyEssenceRequirement: Returning " + allRequirementsMet)
    return allRequirementsMet
EndFunction

Function ShowCurrentStatus()
	PrintDebug("[ShowCurrentRequirements] Called")
	String msg
	; Check if arrays are valid and have the same length
	ResolveEssenceRequirements(false)
	PrintDebug("[ShowCurrentRequirements] Requirements resolved")

	if RequirementsEssence == None || RequirementsEssenceCount == None || RequirementsEssenceSatisfied == None || \
	   RequirementsEssence.Length != RequirementsEssenceCount.Length || RequirementsEssence.Length != RequirementsEssenceSatisfied.Length
		PrintDebug("[ShowCurrentRequirements] FAIL: Arrays not initialized or mismatched")
		Debug.MessageBox("Requirements are not properly initialized or are mismatched.")
		return
	endif

	PrintDebug("[ShowCurrentRequirements] Array lengths = " + RequirementsEssence.Length)

	
	msg = "--- Current Essence Targets ---\n"
	Int i = 0
	while i < RequirementsEssence.Length
		PrintDebug("[ShowCurrentRequirements] Loop iteration " + i)
		String keywordstr = RequirementsEssence[i]
		Int required = RequirementsEssenceCount[i]
		Int satisfied = RequirementsEssenceSatisfied[i]

		String status = ""
		If satisfied >= required
			status = " (Satisfied)"
			PrintDebug("[ShowCurrentRequirements] Requirement satisfied for " + keywordstr)
		Else
			PrintDebug("[ShowCurrentRequirements] Requirement NOT satisfied for " + keywordstr)
		EndIf

		msg += keywordstr + ": " + satisfied + "/" + required + status + "\n"
		
		PrintDebug("[ShowCurrentRequirements] Entry " + i + " = " + keywordstr + " | " + satisfied + "/" + required + status)

		i += 1
	EndWhile
	msg += "Premium Essence Points : " + GetPremiumEssence()  + " \n"
	PrintDebug("[ShowCurrentRequirements] Premium Essence Points = " + GetPremiumEssence())
	msg += "Faint Essence Points : " + GetFaintEssence() + " \n \n"
	PrintDebug("[ShowCurrentRequirements] Faint Essence Points = " + GetFaintEssence())

	
	PrintDebug("[ShowCurrentRequirements] Final message ready, showing messagebox")
	Debug.MessageBox(msg)
EndFunction

Function ExamineOwnStatus()
	PrintDebug("[ExamineOwnStatus] Called")
	String msg
	if Masterscript.IsBroken(Playerref)
		PrintDebug("[ShowCurrentRequirements] Player is broken – using broken player gibberish string")
		;broken player gibberish
		msg += Masterscript.GetStringAsset("BrokenPlayer", "playerbroken" ) + "\n \n"
		msg += "Hours Left To Recover Sanity = " + Masterscript.GetBrokenPoints(playerref)
	endif

	if MasterScript.HasLactatingSpell(Playerref)
		msg += "i am Lactating! \n"
	endif
	float PenisGrowthHours = GetPenisGrowthRemainingHours(playerref)
	If PenisGrowthHours > 0
		msg += "Penis Growth Remaining Hours : " + PenisGrowthHours  + " \n"
	endif
	;arousal
	msg += "\nArousal : " + Masterscript.GetActorArousal(Playerref) as int
	
	; Mental / general resistance
	msg += "\nMental Resistance : " + MasterScript.GetResistance()
	
	; Body sensitivity
	msg += "\n----Sensitivity----"
	int playersex = Sexlab.getsex(Playerref)
	if playersex == 1 || playersex == 2
		int SensitiveBodyRemainingHours = math.ceiling(GetSensitiveBodyRemainingHours(PlayerRef))
		if SensitiveBodyRemainingHours > 0
			msg	+= "\n Body Sensitivity Drug Remaining Hours : " + SensitiveBodyRemainingHours
		endif
		msg += "\n Vaginal : " + GetVaginalSensitivity(PlayerRef)
		msg += "\n Anal    : " + GetAnalSensitivity(PlayerRef)
		msg += "\n Boobs   : " + GetBoobsSensitivity(PlayerRef)
	EndIf
	
	if playersex == 0 || playersex == 2
		msg += "\n Penis  : " + GetPenileSensitivity(PlayerRef)
	endif	
		; Addictions
		msg += "\n----Addictions----"
		msg += "\n Cum Addiction    : " + GetCumAddiction(PlayerRef) + " (" + GetCumAddictionRemainingHours(PlayerRef) as int + " hrs)"
		msg += "\n Sex Addiction    : " + GetSexAddiction(PlayerRef) + " (" + GetSexAddictionRemainingHours(PlayerRef) as int + " hrs)"
		msg += "\n Huge PP Addiction: " + GetHugePPAddiction(PlayerRef) + " (" + GetHugePPAddictionRemainingHours(PlayerRef) as int + " hrs)"


	PrintDebug("[ExamineOwnStatus] Final message ready, showing messagebox")
	Debug.MessageBox(msg)
EndFunction

Function GetExamineReport(Actor char)
	String charname = char.getdisplayname()
	int Charsex = Sexlab.GetSex(Char)
	Bool HasRequiredEssence = ActorHasRequiredEssenceKeyword(char)
	String EssenceKeyword = GetActorEssenceKeyword(char)
	Bool IsHugePP = MasterScript.IsHugePP(char)
	int Arousal = Masterscript.GetActorArousal(char) as int
	String ArousalStringlookup
	string msg = "-----Checking Out " + charname + "-----\n"
	if Masterscript.IsBroken(Playerref)
		;Broken Gibberish instead of Proper Examination if broken
		if CharSex != 1  && Masterscript.IsBroken(Playerref)
			msg += Masterscript.GetStringAsset("BrokenPlayerLookingatCock", "playerbroken" ) + "\n"
		else
			msg += Masterscript.GetStringAsset("BrokenPlayer", "playerbroken" ) + "\n"
		endif
	endif
	;Check if NPC has required Essence	
	msg += "Essence Type : " + EssenceKeyword + "\n"
	if HasRequiredEssence
		msg += (Char.getdisplayname() + " Has " + EssenceKeyword + " Essence That I Need \n" )
	else
		msg +=(Char.getdisplayname() + " Does Not Have The Essence That I Need \n")
	endif
	;Check Arousal 
	msg += "\n Chance To Seduce : " + GetSeduceSuccessChance(Playerref , Char ,Masterscript.GetActorArousal(Char), Seducechancemultiplier)
	msg += "\n Chance To Rape : " + GetRapeSuccessChance(Playerref , Char , rapechancemultiplier)
	msg += "\n Arousal : " + Masterscript.GetActorArousal(Char) as int	
	
	;if has Huge PP Addiction
	if CharSex == 0 || charsex == 2
		if GetHugePPAddiction(Playerref) > 0
			if Masterscript.CanActorSatisfyPCHugePPAddiction(char)
				Msg += Masterscript.GetStringAsset("HugePPAddiction", "cansatisfy")
			else
				Msg += Masterscript.GetStringAsset("HugePPAddiction", "cannotsatisfy")
			endif
		endif
	endif
	
	if CanSaySomething() && utility.randomint(1,100) <= 50 && PlayerRef.isincombat()
		int PowerLevelDifference = GetPowerLevelDifference(Playerref , Char)
		if PowerLevelDifference >= 2
			CombatPlayStateWithStrongEnemy()
		else
			if utility.randomInt(1,2) == 1
				CombatPlayStateWithEnemy()
			else
				CombatPlayComments()
			endif
		endIf
		AddPausetoVoice(5)			
	endif	
	

	debug.messagebox(msg)
endfunction


Bool Function ActorHasRequiredEssenceKeyword(Actor akTargetActor)
    ; Ensure requirements are initialized before checking
    ResolveEssenceRequirements(false)
    
    ; Get the single essence keyword from the target actor
    string actorKeyword = GetActorEssenceKeyword(akTargetActor)
    
    ; Check if the actor has a valid keyword and if the requirements array is valid
    if actorKeyword == "" || RequirementsEssence == none || RequirementsEssence.Length == 0
        return false
    endif
    
    ; Loop through the stored requirements to find a matching keyword
    int i = 0
    while i < RequirementsEssence.Length
        string requiredKeyword = RequirementsEssence[i]
        
        ; Compare the actor's keyword to each required keyword
        if requiredKeyword == actorKeyword
            return true ; A match was found, so we can exit and return true
        endif
        
        i += 1
    endwhile

    return false
EndFunction

Function ResolveEssenceRequirements(bool Force = false)
	PrintDebug("[ResolveEssenceRequirements] Called with Force=" + Force)

	if Force
		PrintDebug("[ResolveEssenceRequirements] Force flag set → regenerating requirements")
		GenerateEssenceRequirements()
	elseif (RequirementsEssence == None || RequirementsEssence.Length == 0)
		PrintDebug("[ResolveEssenceRequirements] RequirementsEssence is None or empty → regenerating requirements")
		GenerateEssenceRequirements()
	else
		PrintDebug("[ResolveEssenceRequirements] Requirements already initialized → skipping regeneration")
	endif
EndFunction


float RequirementPercentIncrease = 0.10
; --- Main Function: Generates all requirements and initializes the satisfied count ---
Function GenerateEssenceRequirements()
	PrintDebug("[GenerateEssenceRequirements] Called")

	Int PlayerLevel = PlayerRef.GetLevel()
	Float levelMultiplier = 1.0 + (PlayerLevel / 5.0) * RequirementPercentIncrease
	Int numRequirements = 5 + (PlayerLevel / 10)
	if numRequirements > 10
		numRequirements = 10
	endif
	PrintDebug("[GenerateEssenceRequirements] PlayerLevel=" + PlayerLevel + " | LevelMultiplier=" + levelMultiplier + " | NumRequirements=" + numRequirements)

	; Combine all keywords into a single pool using PapyrusUtil
	String[] keywordPool = PapyrusUtil.MergeStringArray(HumanKeywords, CreatureKeywords)
	PrintDebug("[GenerateEssenceRequirements] KeywordPool length=" + keywordPool.Length)

	; Create empty arrays to build the results dynamically
	String[] tempEssence
	Int[] tempEssenceCount
	Int[] tempEssenceSatisfied

	Int randomIndex
	Int difficulty
	Int minCount
	Int maxCount

	; Loop to select unique keywords
	Int i = 0
	while i < numRequirements

		randomIndex = Utility.RandomInt(0, keywordPool.Length - 1)
		String selectedKeyword = keywordPool[randomIndex]
		PrintDebug("[GenerateEssenceRequirements] Getting keyword '" + selectedKeyword + "' at index " + randomIndex)

		tempEssence = PapyrusUtil.PushString(tempEssence, selectedKeyword)
		
		PrintDebug("[GenerateEssenceRequirements] Selected keyword '" + selectedKeyword + "'")

		keywordPool = papyrusutil.removestring(keywordPool,selectedKeyword)

		; Get difficulty and scale the count
		difficulty = GetEssenceKeywordDifficulty(tempEssence[i])
		PrintDebug("[GenerateEssenceRequirements] Keyword='" + tempEssence[i] + "' Difficulty=" + difficulty)

		if difficulty == 1
			minCount = 15
			maxCount = 25
		elseif difficulty == 2
			minCount = 10
			maxCount = 20
		elseif difficulty == 3
			minCount = 5
			maxCount = 15
		elseif difficulty == 4
			minCount = 3
			maxCount = 10
		elseif difficulty == 5
			minCount = 1
			maxCount = 5
		else ; Fallback for unlisted keywords
			minCount = 1
			maxCount = 1
			PrintDebug("[GenerateEssenceRequirements] WARNING: Keyword '" + tempEssence[i] + "' returned unknown difficulty")
		endif

		Int count = (Utility.RandomInt(minCount, maxCount) * levelMultiplier) as Int
		tempEssenceCount = PapyrusUtil.PushInt(tempEssenceCount, count)
		tempEssenceSatisfied = PapyrusUtil.PushInt(tempEssenceSatisfied, 0)

		PrintDebug("[GenerateEssenceRequirements] Requirement " + (i + 1) + ": " + tempEssence[i] + " | Count=" + count + " | Range=[" + minCount + "," + maxCount + "]")
		i += 1
	endwhile

	RequirementsEssence = tempEssence
	RequirementsEssenceCount = tempEssenceCount
	RequirementsEssenceSatisfied = tempEssenceSatisfied
	PrintDebug("RequirementsEssence :" + RequirementsEssence)
	PrintDebug("RequirementsEssenceCount :" + RequirementsEssenceCount)
	PrintDebug("RequirementsEssenceSatisfied :" + RequirementsEssenceSatisfied)
	PrintDebug("[GenerateEssenceRequirements] Generated " + RequirementsEssence.Length + " requirements successfully")
EndFunction

int Function GetEssenceKeywordDifficulty(string EssenceKeyword)
	String Path = "HentairimAdventure/EssenceDifficulty.json"
	PrintDebug("GetEssenceKeywordDifficulty: Looking up difficulty for [" + EssenceKeyword + "] in " + Path)
	
	int difficulty = JsonUtil.GetIntValue(Path, EssenceKeyword, 0)
	PrintDebug("GetEssenceKeywordDifficulty: Result for [" + EssenceKeyword + "] = " + difficulty)
	
	return difficulty
endFunction

String function GetActorEssenceKeyword(actor char)
	string RaceName = char.getleveledactorbase().GetRace().GetName()
	string DisplayName = char.getdisplayname()
	
	;playable RaceName
	if sexlab.GetSex(char) <= 2	
		if stringutil.find(DisplayName ,"Ghost") > -1 || stringutil.find(DisplayName ,"Spectre") > -1 
			return "Ethereal"
		elseif stringutil.find(RaceName ,"orc") > -1 || stringutil.find(RaceName ,"Orsimer") > -1
			return "Orc"
		elseIf stringutil.find(RaceName ,"Nord") > -1
			return "Nord"
		elseIf stringutil.find(RaceName ,"Argonian") > -1
			return "Argonian"
		elseIf stringutil.find(RaceName ,"Breton") > -1
			return "Breton"
		elseIf stringutil.find(RaceName ,"Red Guard") > -1 || stringutil.find(RaceName ,"RedGuard") > -1
			return "RedGuard"
		elseIf stringutil.find(RaceName ,"Dunmer") > -1 || stringutil.find(RaceName ,"Dark Elf") > -1
			return "Dunmer"
		elseIf stringutil.find(RaceName ,"Altmer") > -1 || stringutil.find(RaceName ,"High Elf") > -1
			return "Altmer"
		elseIf stringutil.find(RaceName ,"Imperial") > -1 
			return "Imperial"
		elseIf stringutil.find(RaceName ,"Khajiit") > -1 
			return "Khajiit"
		elseIf stringutil.find(RaceName ,"Bosmer") > -1 || stringutil.find(RaceName ,"Wood Elf") > -1
			return "Bosmer"
		endif
	elseif sexlab.GetSex(char) > 2
		if stringutil.find(DisplayName ,"Dwarven") > -1 || stringutil.find(RaceName ,"Dwarven") > -1
			return "Dwarven"
		elseif stringutil.find(DisplayName ,"Vampire") > -1 || stringutil.find(RaceName ,"Vampire") > -1
			return "Vampire"
		elseif stringutil.find(DisplayName ,"Draugr") > -1 || stringutil.find(RaceName ,"Draugr") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Zombie") > -1 || stringutil.find(RaceName ,"Zombie") > -1
			return "Necro"
		elseif  stringutil.find(DisplayName ,"Twin Head") > -1 || stringutil.find(DisplayName ,"TwinHead") > -1 || stringutil.find(RaceName ,"TwinHead") > -1
			return "Necro"
		elseif  stringutil.find(DisplayName ,"fogling") > -1 || stringutil.find(RaceName ,"fogling") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Butcher") > -1 || stringutil.find(RaceName ,"Butcher") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Lich") > -1 || stringutil.find(RaceName ,"Lich") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Ghoul") > -1 || stringutil.find(RaceName ,"Ghoul") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Fleshman") > -1 || stringutil.find(RaceName ,"Fleshman") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Bone") > -1 || stringutil.find(RaceName ,"Bone") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Skeleton") > -1 || stringutil.find(RaceName ,"Skeleton") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"undead") > -1 || stringutil.find(RaceName ,"undead") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Dragon Priest") > -1 || stringutil.find(RaceName ,"Dragon Priest") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Ash Man") > -1 || stringutil.find(RaceName ,"Ash man") > -1
			return "Necro"
		elseif stringutil.find(DisplayName ,"Chaurus") > -1 || stringutil.find(RaceName ,"Chaurus") > -1
			return "Insect"
		elseif stringutil.find(DisplayName ,"Ash Hopper") > -1 || stringutil.find(RaceName ,"Ash Hopper") > -1
			return "Insect"
		elseif stringutil.find(DisplayName ,"Spider") > -1 || stringutil.find(RaceName ,"Spider") > -1
			return "Insect"
		elseif stringutil.find(DisplayName ,"Cave Worm") > -1 || stringutil.find(RaceName ,"Cave Worm") > -1
			return "Insect"
		elseif stringutil.find(DisplayName ,"arachne") > -1 || stringutil.find(RaceName ,"arachne") > -1
			return "Insect"
		elseif stringutil.find(DisplayName ,"Thrikreen") > -1 || stringutil.find(RaceName ,"Thrikreen") > -1
			return "Insect"
		elseif stringutil.find(DisplayName ,"Spriggan") > -1 || stringutil.find(RaceName ,"Spriggan") > -1
			return "Spriggan"
		elseif stringutil.find(DisplayName ,"Falmer") > -1 || stringutil.find(RaceName ,"Falmer") > -1
			return "Falmer"
		elseif stringutil.find(DisplayName ,"demogorgon") > -1 || stringutil.find(RaceName ,"demogorgon") > -1
			return "Spriggan"
		elseif stringutil.find(DisplayName ,"Werewolf") > -1 || stringutil.find(RaceName ,"Werewolf") > -1
			return "Lycanthrope"
		elseif stringutil.find(DisplayName ,"Werebear") > -1 || stringutil.find(RaceName ,"Werebear") > -1
			return "Lycanthrope"
		elseif stringutil.find(DisplayName ,"Daedroth") > -1 || stringutil.find(RaceName ,"Daedroth") > -1
			return "Lycanthrope"
		elseif stringutil.find(DisplayName ,"Lycan") > -1 || stringutil.find(RaceName ,"Lycan") > -1
			return "Lycanthrope"
		elseif stringutil.find(DisplayName ,"Troll") > -1 || stringutil.find(RaceName ,"Troll") > -1
			return "Ogre"
		elseif stringutil.find(DisplayName ,"Ogre") > -1 || stringutil.find(RaceName ,"Ogre") > -1
			return "Ogre"
		elseif stringutil.find(DisplayName ,"Ogrim") > -1 || stringutil.find(RaceName ,"Ogrim") > -1
			return "Ogre"
		elseif stringutil.find(DisplayName ,"Giant") > -1 || stringutil.find(RaceName ,"Giant") > -1
			return "Ogre"
		elseif stringutil.find(DisplayName ,"Minotaur") > -1 || stringutil.find(RaceName ,"Minotaur") > -1
			return "Ogre"
		elseif stringutil.find(DisplayName ,"Regenerador") > -1 || stringutil.find(RaceName ,"Regenerador") > -1
			return "Ogre"
		elseif stringutil.find(DisplayName ,"atronach") > -1 || stringutil.find(RaceName ,"atronach") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"ash guardian") > -1 || stringutil.find(RaceName ,"ash guardian") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"dremora") > -1 || stringutil.find(RaceName ,"dremora") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"lurker") > -1 || stringutil.find(RaceName ,"lurker") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"Demon") > -1 || stringutil.find(RaceName ,"Demon") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"Golem") > -1 || stringutil.find(RaceName ,"Golem") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"seeker") > -1 || stringutil.find(RaceName ,"seeker") > -1
			return "Daedra" 
		elseif stringutil.find(DisplayName ,"Cthlhu") > -1 || stringutil.find(RaceName ,"Cthlhu") > -1
			return "Daedra"
        elseif stringutil.find(DisplayName ,"Shoggoth") > -1 || stringutil.find(RaceName ,"Shoggoth") > -1
			return "Daedra"
		elseif stringutil.find(DisplayName ,"Drake") > -1 || stringutil.find(RaceName ,"Drake") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Bear") > -1 || stringutil.find(RaceName ,"Bear") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Guar") > -1 || stringutil.find(RaceName ,"Guar") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Sabrecat") > -1 || stringutil.find(RaceName ,"Sabrecat") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Panther") > -1 || stringutil.find(RaceName ,"Panther") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Lion") > -1 || stringutil.find(RaceName ,"Lion") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Clannfear") > -1 || stringutil.find(RaceName ,"Clannfear") > -1
			return "Predator"
		elseif stringutil.find(DisplayName ,"Skeever") > -1 || stringutil.find(RaceName ,"Skeever") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"rat") > -1 || stringutil.find(RaceName ,"rat") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"deer") > -1 || stringutil.find(RaceName ,"deer") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"Rabbit") > -1 || stringutil.find(RaceName ,"Rabbit") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"Goat") > -1 || stringutil.find(RaceName ,"Goat") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"Chimp") > -1 || stringutil.find(RaceName ,"Chimp") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"Gorilla") > -1 || stringutil.find(RaceName ,"Gorilla") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"Griffin") > -1 || stringutil.find(RaceName ,"Griffin") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"geese") > -1 || stringutil.find(RaceName ,"geese") > -1
			return "Nature"
		elseif stringutil.find(DisplayName ,"wolf") > -1 || stringutil.find(RaceName ,"wolf") > -1
			return "Canine"
		elseif stringutil.find(DisplayName ,"dog") > -1 || stringutil.find(RaceName ,"dog") > -1
			return "Canine"
		elseif stringutil.find(DisplayName ,"husky") > -1 || stringutil.find(RaceName ,"husky") > -1
			return "Canine"
		elseif stringutil.find(DisplayName ,"Horse") > -1 || stringutil.find(RaceName ,"Horse") > -1
			return "Horse"
		elseif stringutil.find(DisplayName ,"Gargoyle") > -1 || stringutil.find(RaceName ,"Gargoyle") > -1
			return "Vampire"
		elseif stringutil.find(DisplayName ,"Death Hound") > -1 || stringutil.find(RaceName ,"Death Hound") > -1
			return "Vampire"
		elseif stringutil.find(DisplayName ,"Baliwog") > -1 || stringutil.find(RaceName ,"Baliwog") > -1
			return "Marine"
		elseif stringutil.find(DisplayName ,"Deep") > -1 || stringutil.find(RaceName ,"Deep") > -1
			return "Marine"
		elseif stringutil.find(DisplayName ,"Horker") > -1 || stringutil.find(RaceName ,"Horker") > -1
			return "Marine"
		elseif stringutil.find(DisplayName ,"Grummite") > -1 || stringutil.find(RaceName ,"Grummite") > -1
			return "Marine"
		elseif stringutil.find(DisplayName ,"fish") > -1 || stringutil.find(RaceName ,"fish") > -1
			return "Marine"
		elseif stringutil.find(DisplayName ,"Dreugh") > -1 || stringutil.find(RaceName ,"Dreugh") > -1
			return "Marine"
		elseif stringutil.find(DisplayName ,"Riekling") > -1 || stringutil.find(RaceName ,"Riekling") > -1
			return "Goblin"
		elseif stringutil.find(DisplayName ,"Skaven") > -1 || stringutil.find(RaceName ,"Skaven") > -1
			return "Goblin"
		elseif stringutil.find(DisplayName ,"Skaven") > -1 || stringutil.find(RaceName ,"Skaven") > -1
			return "Goblin"
		elseif stringutil.find(DisplayName ,"Ork") > -1 || stringutil.find(DisplayName ,"Orc") > -1 || stringutil.find(RaceName ,"Orc") > -1
			return "Goblin"
		elseif stringutil.find(DisplayName ,"Scamp") > -1 || stringutil.find(RaceName ,"Scamp") > -1
			return "Goblin"
		elseif stringutil.find(DisplayName ,"Ghost") > -1 || stringutil.find(RaceName ,"Ghost") > -1
			return "Ethereal"
		elseif stringutil.find(DisplayName ,"Maiden") > -1 || stringutil.find(RaceName ,"Maiden") > -1
			return "Ethereal"
		elseif stringutil.find(DisplayName ,"Wraith") > -1 || stringutil.find(RaceName ,"Wraith") > -1
			return "Ethereal"
		elseif stringutil.find(DisplayName ,"Mother") > -1 || stringutil.find(RaceName ,"Mother") > -1
			return "Ethereal"
		elseif stringutil.find(DisplayName ,"Spectre") > -1 || stringutil.find(RaceName ,"Spectre") > -1
			return "Ethereal"
		else
			MasterScript.Announce("Cannot find " + char.getdisplayname() + "'s keyword! ","Hentairim/Failed.dds" ,playsfx = "Buzzer")
			printdebug("Cannot find " + char.getdisplayname() + "'s keyword!")
			return ""
		endIf
	endif
endFunction


;-------------------Location Change
Bool ReachedHome
Int LastLocationType
;1 = worldspace
;2 = Player House
;3 = NPC House
;4 = Town
;5 = City
;6 = Dungeon
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    ; Skip if nothing changed
    if PlayerRef.GetCurrentLocation() == akOldLoc || utility.randomInt(1,100) <= 40
        return
    endif

    ; ===== Interior location checks =====
    if akNewLoc
        if akNewLoc.HasKeyword(LocTypePlayerHouse) && !ReachedHome
            printdebug("Player entered a PLAYER house: " + akNewLoc)
			OthersPlaySafeRelieve()
			ReachedHome = true
			LastLocationType = 2
        elseif akNewLoc.HasKeyword(LocTypeDwelling)
            printdebug("Player entered an NPC dwelling: " + akNewLoc)
			SocialPlayExcuseMe()
			LastLocationType = 3
        elseif akNewLoc.HasKeyword(LocTypeTown)
            printdebug("Player entered a town location: " + akNewLoc)
			LastLocationType = 4
        elseif akNewLoc.HasKeyword(LocTypeCity)
            printdebug("Player entered a city location: " + akNewLoc)
			LastLocationType = 5
		elseif akNewLoc.HasKeyword(loctypeInn)
			printdebug("Player entered a Inn location: " + akNewLoc)
			LastLocationType = 6
        elseif akNewLoc.HasKeyword(LocTypeDungeon)
            printdebug("Player entered a dungeon: " + akNewLoc)
			LastLocationType = 20
		else 
			LastLocationType = 1
			ReachedHome = false
        endif
    endif
	
	if IsInSafeLocation()
		FollowerDownCount = 0
	endif
EndEvent

Bool Function IsInSafeLocation()
	return LastLocationType >= 2 && LastLocationType <= 6
endfunction

String PickupGachaOutfit

Function SetGachaPickup()
	String[] GachaFolders = miscutil.FoldersInFolder("data/SKSE/Plugins/StorageUtilData/HentairimAdventure/Gacha")
		
	if GachaFolders.Length < 1
		Masterscript.Announce("No Gacha Folders Found!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
		Return
	endif
	
	String GachaTypeFolder

	;Gacha Type Selection
	Int SelectedType
    b612_SelectList GachaTypeMenu = GetSelectList()
	SelectedType = GachaTypeMenu.show(GachaFolders)
	
	if SelectedType >= 0
		GachaTypeFolder = "HentairimAdventure/Gacha/" + GachaFolders[SelectedType] +"/"
	else
		Return
	endif
	PrintDebug("GachaTypeFolder : " + GachaTypeFolder)

	b612_TraitsMenu GachaMenu = GetTraitsMenu()
	string[] GachaNameList = JsonUtil.JsonInFolder(GachaTypeFolder)
	string[] GachaPathArr

	PrintDebug("SetGachaPickup: Called")

	if GachaNameList.length == 0
		PrintDebug("SetGachaPickup: No Gacha JSON File Found, aborting")
		return
	EndIf

	PrintDebug("SetGachaPickup: Found " + GachaNameList.length + " gacha files")

	; Start Processing All Gacha Files Available
	int f
	while f < GachaNameList.length
		String Path = GachaTypeFolder + GachaNameList[f]
		String Name = JsonUtil.GetStringValue(Path,"name","Missing Name")
		string description = JsonUtil.GetStringValue(Path,"description","Missing Description")
		Int ImagePathCount = JsonUtil.StringListCount(Path , "imagepath")
		string imagepath = JsonUtil.StringListGet(Path,"imagepath",Utility.RandomInt(0,ImagePathCount - 1))
		
		PrintDebug("SetGachaPickup: Processing " + Path + " | Name=" + Name)

		; Process Requirements
		int RequirementsCount = JsonUtil.StringListCount(Path , "requirements")
		PrintDebug("SetGachaPickup:   RequirementsCount=" + RequirementsCount)
		int c = 0
		while c < RequirementsCount
			String[] Requirements = StringUtil.Split(JsonUtil.StringListGet(Path , "requirements",c),"|")
			if Requirements && Requirements.length > 1
				String ReqName   = Requirements[0]
				String ReqPlugin = Requirements[1]

				if PO3_SKSEFunctions.IsPluginFound(ReqPlugin)
					description += "\n" + ReqName + " (Installed)"
					PrintDebug("SetGachaPickup:   Requirement OK -> " + ReqName + " (" + ReqPlugin + ")")
				else
					description += "\n" + ReqName + " (Not Installed)"
					PrintDebug("SetGachaPickup:   Requirement MISSING -> " + ReqName + " (" + ReqPlugin + ")")
				endif
			endif
			c += 1
		endwhile		

		GachaMenu.additem(Name , Description , ImagePath)
		GachaPathArr = PapyrusUtil.PushString(GachaPathArr , Path)
		f += 1
	endwhile 

	; User Select What Banner to set as pickup
	String[] result = GachaMenu.show()
	if result.length <= 0
		PrintDebug("SetGachaPickup: No banner selected, exiting")
		return
	endif
	
	String SelectedBannerPath = GachaPathArr[result[0] as int]
	PrintDebug("SetGachaPickup: Selected banner path = " + SelectedBannerPath)

	; Now select which plugin requirement to bind
	b612_SelectList PickupGachaModSelection = GetSelectList()
	String[] AllRequirements = JsonUtil.StringListToArray(SelectedBannerPath ,"requirements")
	String[] InstalledOnly

	PrintDebug("SetGachaPickup: Loaded " + AllRequirements.length + " requirement entries for selection")

	; Filter only installed requirements
	int i = 0
	while i < AllRequirements.length
		String[] Req = StringUtil.Split(AllRequirements[i],"|")
		if Req && Req.length > 1
			String ReqName   = Req[0]
			String ReqPlugin = Req[1]

			if PO3_SKSEFunctions.IsPluginFound(ReqPlugin)
				InstalledOnly = PapyrusUtil.PushString(InstalledOnly , AllRequirements[i])
				PrintDebug("SetGachaPickup: Requirement available for selection -> " + ReqName + " (" + ReqPlugin + ")")
			else
				PrintDebug("SetGachaPickup: Skipping unavailable requirement -> " + ReqName + " (" + ReqPlugin + ")")
			endif
		endif
		i += 1
	endwhile

	if InstalledOnly.length == 0
		PrintDebug("SetGachaPickup: No installed requirements available to pick, aborting")
		MasterScript.Announce("No installed outfit/mod available for Pickup in this banner")
		return
	endif

	MasterScript.Announce("Choose an Outfit/Mod to Serve as Pickup")
	Int Selected = PickupGachaModSelection.show(InstalledOnly)
	if Selected < 0 || Selected >= InstalledOnly.length
		PrintDebug("SetGachaPickup: Invalid requirement selection, exiting")
		return
	endif

	String[] selParts = StringUtil.Split(InstalledOnly[Selected], "|")
	if selParts && selParts.length > 1
		PickupGachaOutfit = selParts[1]
		PrintDebug("SetGachaPickup: PickupGachaOutfit set to = " + selParts[1])
		Masterscript.Announce("Gacha Pickup Set To "+ PickupGachaOutfit)
	else
		Masterscript.Announce("Error Setting Gacha Pickup!")
		printdebug("SetGachaPickup: selParts = " + selParts)
		;PickupGachaOutfit = InstalledOnly[Selected]
		;PrintDebug("SetGachaPickup: PickupGachaOutfit fallback set to raw = " + PickupGachaOutfit)
	endif
EndFunction

Int PityRollCount

Function RollGacha(bool FreeRoll = false)
	String[] GachaFolders = miscutil.FoldersInFolder("data/SKSE/Plugins/StorageUtilData/HentairimAdventure/Gacha")
		printdebug("1 : " + miscutil.FoldersInFolder("data/SKSE/Plugins/StorageUtilData"))
		printdebug("2 : " + miscutil.FoldersInFolder("data/SKSE") )
		printdebug("GachaFolders : " + GachaFolders)
	if GachaFolders.Length < 1
		Masterscript.Announce("No Gacha Folders Found!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
		Return
	endif
	
	String GachaTypeFolder
	String PaddingGachaPool
	
	;---- 0. Gacha Type Selection
	Int SelectedType
    b612_SelectList GachaTypeMenu = GetSelectList()
	SelectedType = GachaTypeMenu.show(GachaFolders)
	
	if SelectedType >= 0
		GachaTypeFolder = "HentairimAdventure/Gacha/" + GachaFolders[SelectedType] +"/"
		PaddingGachaPool = "HentairimAdventure/Gacha/" + GachaFolders[SelectedType] +"/Padding/Padding.json"
	else
		Return
	endif
	PrintDebug("GachaTypeFolder : " + GachaTypeFolder)
	PrintDebug("PaddingGachaPool : " + PaddingGachaPool)
	
	; --- 1. GACHA BANNER SELECTION ---

	string[] GachaPathArr
	b612_TraitsMenu GachaMenu = GetTraitsMenu()
	string[] GachaNameList = JsonUtil.JsonInFolder(GachaTypeFolder)
    int playerLevel = Game.GetPlayer().GetLevel()

	PrintDebug("RollGacha: Found " + GachaNameList.length + " gacha files.")

	if GachaNameList.length == 0
		PrintDebug("RollGacha: No Gacha JSON File Found, aborting")
		return none
	EndIf

	int f = 0
	while f < GachaNameList.length
		String Path = GachaTypeFolder + GachaNameList[f]
		String Name = JsonUtil.GetStringValue(Path,"name","Missing Name")
		string description = jsonutil.getstringvalue(Path,"description","Missing Description")

		Int ImagePathCount = jsonutil.StringListCount(Path , "imagepath")
		string imagepath = jsonutil.StringListGet(Path,"imagepath",utility.randomint(0,ImagePathCount - 1))
		
		; --- ADD LEVEL GATING INFO TO DESCRIPTION ---
		description += "\n\n--- Level Gating ---"
		string availableTiers = ""
		string gatedTiers = ""
		int clevel = JsonUtil.GetIntValue(Path, "clevel", 1)
		int rlevel = JsonUtil.GetIntValue(Path, "rlevel", 1)
		int srlevel = JsonUtil.GetIntValue(Path, "srlevel", 1)
		int ssrlevel = JsonUtil.GetIntValue(Path, "ssrlevel", 1)
		int urlevel = JsonUtil.GetIntValue(Path, "urlevel", 1)
		
		if playerLevel >= urlevel
			availableTiers += "UR, "
		else
			gatedTiers += "UR, "
		endif
		if playerLevel >= ssrlevel
			availableTiers += "SSR, "
		else
			gatedTiers += "SSR, "
		endif
		if playerLevel >= srlevel
			availableTiers += "SR, "
		else
			gatedTiers += "SR, "
		endif
		if playerLevel >= rlevel
			availableTiers += "Rare, "
		else
			gatedTiers += "Rare, "
		endif
		if playerLevel >= clevel
			availableTiers += "Common"
		else
			gatedTiers += "Common"
		endif
		
		if availableTiers != ""
            int commaPos = StringUtil.Find(availableTiers, ", ", StringUtil.GetLength(availableTiers) - 2)
            if commaPos != -1
                availableTiers = StringUtil.SubString(availableTiers, 0, StringUtil.GetLength(availableTiers) - 2)
            endif
			description += "\nAvailable: " + availableTiers
		endif

		if gatedTiers != ""
            int commaPos = StringUtil.Find(gatedTiers, ", ", StringUtil.GetLength(gatedTiers) - 2)
            if commaPos != -1
                gatedTiers = StringUtil.SubString(gatedTiers, 0, StringUtil.GetLength(gatedTiers) - 2)
            endif
			description += "\nGated: " + gatedTiers
		endif
		
		;Print Requirements
		description += "\n ----------------------"
		int RequirementsCount = jsonutil.StringListCount(Path , "requirements")
		int c = 0
		while c < RequirementsCount
			String[] Requirements = StringUtil.Split(jsonutil.StringListGet(Path , "requirements",c),"|")
			String pickupLabel = ""
			if Requirements.Length > 1 && Requirements[1] == PickupGachaOutfit
				pickupLabel = " (Pickup!)"
			endif
			if PO3_SKSEFunctions.IsPluginFound(Requirements[1])
				description += "\n"
				description += Requirements[0] + "(Installed)" + pickupLabel
			else
				description += "\n"
				description += Requirements[0] + "(Not Installed)" + pickupLabel
			endif
			c += 1
		endwhile
		
		
		
		GachaMenu.additem(Name , description ,ImagePath)
		GachaPathArr = PapyrusUtil.PushString(GachaPathArr , Path)
		f += 1
	endwhile
	
	String[] result = GachaMenu.show()
	if result.length <= 0
		return
	EndIf
	
	String GachaPath = GachaPathArr[Result[0] as int]
	PrintDebug("RollGacha: User selected Gacha file = " + GachaPath)
	If CanSaySomething()
		if utility.randomInt(1 , 2 ) == 1
			SocialPlayShortHesitation()
		else
			SocialPlayCouldItBe()
		endif
		AddPausetoVoice(3)
	endif
	Spinicon.show("Rolling...")

	; --- 2. LOAD & PREPARE POOLS ---
	Form[] CommonPool = JsonUtil.FormListToArray(GachaPath, "common")
	Form[] RarePool = JsonUtil.FormListToArray(GachaPath, "rare")
	Form[] SuperRarePool = JsonUtil.FormListToArray(GachaPath, "superrare")
	Form[] SpecialSRPool = JsonUtil.FormListToArray(GachaPath, "speciallysuperrare")
	Form[] UltraRarePool = JsonUtil.FormListToArray(GachaPath, "ultrarare")
	
	CommonPool = TrimPool(CommonPool, "Common")
	RarePool = TrimPool(RarePool, "Rare")
	SuperRarePool = TrimPool(SuperRarePool, "SuperRare")
	SpecialSRPool = TrimPool(SpecialSRPool, "SpeciallySuperRare")
	UltraRarePool = TrimPool(UltraRarePool, "UltraRare")

	; *** FIX START ***
	; We must determine if this banner is a pickup banner without modifying the JSON.
	; We'll do this by checking if any of its listed requirements match the active pickup.
	bool isPickupBanner = false
	if PickupGachaOutfit != ""
		string[] bannerRequirements = JsonUtil.StringListToArray(GachaPath, "requirements")
		int i = 0
		while i < bannerRequirements.Length
			String[] splitReq = StringUtil.Split(bannerRequirements[i], "|")
			if splitReq.Length > 1 && splitReq[1] == PickupGachaOutfit
				isPickupBanner = true
				i += 100
			endif
			i += 1
		endwhile
	endif
	
	if isPickupBanner
		PrintDebug("RollGacha: Applying pickup filter to pools for " + PickupGachaOutfit)
		CommonPool = FilterPoolForPickup(CommonPool, PickupGachaOutfit)
		RarePool = FilterPoolForPickup(RarePool, PickupGachaOutfit)
		SuperRarePool = FilterPoolForPickup(SuperRarePool, PickupGachaOutfit)
		SpecialSRPool = FilterPoolForPickup(SpecialSRPool, PickupGachaOutfit)
		UltraRarePool = FilterPoolForPickup(UltraRarePool, PickupGachaOutfit)
	Else
		PrintDebug("RollGacha: Skipping pickup filter. This banner is not a pickup banner.")
	EndIf
	; *** FIX END ***

	int usepadding = JsonUtil.GetIntValue(GachaPath, "usepadding", 0)
	if usepadding == 1
		Form[] CommonPaddingPool = TrimPool(JsonUtil.FormListToArray(PaddingGachaPool, "common"), "CommonPaddingPool")
		Form[] RarePaddingPool = TrimPool(JsonUtil.FormListToArray(PaddingGachaPool, "rare"), "RarePaddingPool")
		CommonPool = papyrusutil.MergeFormArray(CommonPool , CommonPaddingPool, true)
		RarePool = papyrusutil.MergeFormArray(RarePool , RarePaddingPool, true)
	endif

	; --- 3. APPLY GATING & CALCULATE WEIGHTS ---
	Int clevel = JsonUtil.GetIntValue(GachaPath, "clevel", 1)
	Int rlevel = JsonUtil.GetIntValue(GachaPath, "rlevel", 1)
	Int srlevel = JsonUtil.GetIntValue(GachaPath, "srlevel", 1)
	Int ssrlevel = JsonUtil.GetIntValue(GachaPath, "ssrlevel", 1)
	Int urlevel = JsonUtil.GetIntValue(GachaPath, "urlevel", 1)

	Int CommonWeight = JsonUtil.GetIntValue(GachaPath, "commonweight", 0)
	Int RareWeight = JsonUtil.GetIntValue(GachaPath, "rareweight", 0)
	Int SRWeight = JsonUtil.GetIntValue(GachaPath, "superrareweight", 0)
	Int SSRWeight = JsonUtil.GetIntValue(GachaPath, "speciallysuperrareweight", 0)
	Int URWeight = JsonUtil.GetIntValue(GachaPath, "ultrarareweight", 0)

	if playerLevel < urlevel || (UltraRarePool && UltraRarePool.Length == 0)
		URWeight = 0
	endif
	if playerLevel < ssrlevel || (SpecialSRPool && SpecialSRPool.Length == 0)
		SSRWeight = 0
	endif
	if playerLevel < srlevel || (SuperRarePool && SuperRarePool.Length == 0)
		SRWeight = 0
	endif
	if playerLevel < rlevel || (RarePool && RarePool.Length == 0)
		RareWeight = 0
	endif
	if playerLevel < clevel || (CommonPool && CommonPool.Length == 0)
		CommonWeight = 0
	endif

	Int TotalWeight = CommonWeight + RareWeight + SRWeight + SSRWeight + URWeight
	If TotalWeight <= 0
		Debug.MessageBox("No valid gacha pools found!")
		PrintDebug("RollGacha: ERROR - No valid gacha pools found!")
		Spinicon.Hide()
		return
	EndIf
	
	PrintDebug("RollGacha: Final Pool Weights -> Common=" + CommonWeight + ", Rare=" + RareWeight + ", SR=" + SRWeight + ", SSR=" + SSRWeight + ", UR=" + URWeight)
	PrintDebug("RollGacha: TotalWeight = " + TotalWeight)

	; --- 4. GET ROLL COUNT & CONSUME CURRENCY ---
	If GetPremiumEssence() <= 0 && !FreeRoll
		Masterscript.Announce("Not Enough Premium Essence to Roll!","Hentairim/Failed.dds" ,playsfx = "Buzzer")
		Spinicon.Hide()
		return
	endif

	b612_QuantitySlider QtySlider = GetQuantitySlider()
	int Count
	
	if FreeRoll
		Count = QtySlider.show("How many Rolls?", 1 , 100)
	else
		Count = QtySlider.show("How many Rolls?", 1 , GetPremiumEssence())
	endif
	
	if Count <= 0
		Masterscript.Announce("Please Enter a Valid Number!","Hentairim/Failed.dds" ,playsfx = "Buzzer")
		 Spinicon.Hide()
		return
	elseif Count > GetPremiumEssence() && !FreeRoll
		Masterscript.Announce("Not Enough Premium Essence to Roll!","Hentairim/Failed.dds" ,playsfx = "Buzzer")
		 Spinicon.Hide()
		return
	endif

	if !FreeRoll
		AddPremiumEssence(-Count)
	endif

	; --- 5. EXECUTE ROLLS ---
	Int z = 0
	While z < Count
		Int Roll = Utility.RandomInt(1, TotalWeight)
		Int Current = Roll
		Form[] Pool
		
		If Current <= CommonWeight
			Pool = CommonPool
		ElseIf Current <= CommonWeight + RareWeight
			Pool = RarePool
		ElseIf Current <= CommonWeight + RareWeight + SRWeight
			Pool = SuperRarePool
		ElseIf Current <= CommonWeight + RareWeight + SRWeight + SSRWeight
			Pool = SpecialSRPool
			If CanSaySomething()
				SocialPlayIDidIt()
				AddPausetoVoice(5)
			endif
		Else
			Pool = UltraRarePool
			If CanSaySomething()
				SocialPlayIDidIt()
				AddPausetoVoice(5)
			endif
		EndIf

		If Pool && Pool.Length > 0
			Form reward = Pool[Utility.RandomInt(0, Pool.Length - 1)]
			Playerref.additem(reward, 1, true)
		Else
			PrintDebug("RollGacha: ERROR - Selected pool was empty")
		EndIf
		
		PityRollCount += 1
		z += 1
	EndWhile

	Spinicon.Hide()
	Masterscript.Announce("Rolls complete! Pity count is now: " + PityRollCount)
	PrintDebug("RollGacha: Finished all rolls, exiting")
EndFunction

; Filters a pool, keeping only forms from a specific plugin.
Form[] Function FilterPoolForPickup(Form[] Pool, String PickupPluginName)
    Form[] FilteredPool
    if !Pool || PickupPluginName == ""
        return Pool
    endIf

    int i = 0
    while i < Pool.Length
        Form f = Pool[i]
        ; Use PO3_SKSEFunctions to check if the form is from the pickup plugin
        if PO3_SKSEFunctions.IsFormInMod(f, PickupPluginName)
            FilteredPool = PapyrusUtil.PushForm(FilteredPool, f)
        endIf
        i += 1
    endwhile
    
    ; If the filtered pool is empty, announce it to the user
    if FilteredPool.Length == 0 && Pool.Length > 0
        PrintDebug("FilterPoolForPickup: Filtered pool is now empty for plugin: " + PickupPluginName)
    EndIf
    
    return FilteredPool
EndFunction

;Pity player's lousy luck
; --- Pity System Costs ---


Function RedeemPity()

	String[] GachaFolders = miscutil.FoldersInFolder("data/SKSE/Plugins/StorageUtilData/HentairimAdventure/Gacha")
	String GachaTypeFolder
	
	if GachaFolders.Length < 1
		Masterscript.Announce("No Gacha Folders Found!" ,"Hentairim/Failed.dds" ,playsfx = "Buzzer")
		Return
	endif

	;Gacha Type Selection
	Int SelectedType
    b612_SelectList GachaTypeMenu = GetSelectList()
	SelectedType = GachaTypeMenu.show(GachaFolders)
	
	if SelectedType >= 0
		GachaTypeFolder = "HentairimAdventure/Gacha/" + GachaFolders[SelectedType] +"/"
	else
		Return
	endif

	string GachaConfigfile = "HentairimAdventure/GachaConfig.json"
	Int  SRPityCost = JsonUtil.GetIntValue(GachaConfigfile, "srpitycost", 40)
	Int  SSRPityCost = JsonUtil.GetIntValue(GachaConfigfile, "ssrpitycost", 100)
	Int  URPityCost = JsonUtil.GetIntValue(GachaConfigfile, "urpitycost", 500)
	String GachaFolder = "HentairimAdventure/Gacha/"
	
	; --- Stage 1: Choose Rarity ---
	PrintDebug("RedeemPity: User choosing rarity")
	string[] rarityOptions
	rarityOptions = PapyrusUtil.PushString(rarityOptions, "SR - " + SRPityCost as string)
	rarityOptions = PapyrusUtil.PushString(rarityOptions, "SSR - " + SSRPityCost as string)
	rarityOptions = PapyrusUtil.PushString(rarityOptions, "UR - " + URPityCost as string)
	
	b612_SelectList RarityMenu = GetSelectList()
	MasterScript.Announce("Available Pity : " + PityRollCount)
	Int RarityChoice = RarityMenu.Show(rarityOptions)

	if RarityChoice < 0
		PrintDebug("RedeemPity: Rarity selection cancelled")
		return
	EndIf

	; Check if player can afford the pity
	Int costToRedeem = 0
	String rarityToRedeem
	if RarityChoice == 0
		costToRedeem = SRPityCost
		rarityToRedeem = "superrare"
	elseIf RarityChoice == 1
		costToRedeem = SSRPityCost
		rarityToRedeem = "speciallysuperrare"
	elseIf RarityChoice == 2
		costToRedeem = URPityCost
		rarityToRedeem = "ultrarare"
	endif

	if PityRollCount < costToRedeem
		Masterscript.Announce("Not enough Pity Rolls to redeem this item!","Hentairim/Failed.dds" ,playsfx = "Buzzer")
		PrintDebug("RedeemPity: Not enough pity, aborting")
		return
	EndIf

	; --- Stage 2: Choose Banner ---
	PrintDebug("RedeemPity: User choosing banner")
	b612_TraitsMenu GachaMenu = GetTraitsMenu()
	string[] GachaNameList = JsonUtil.JsonInFolder(GachaFolder)
	string[] GachaPathArr
	
	if GachaNameList.length == 0
		PrintDebug("RedeemPity: No Gacha JSON File Found, aborting")
		Masterscript.Announce("No gacha banners found.")
		return
	EndIf

	int f
	while f < GachaNameList.length
		String Path = GachaFolder + GachaNameList[f]
		String Name = JsonUtil.GetStringValue(Path,"name","Missing Name")
		string description = JsonUtil.GetStringValue(Path,"description","Missing Description")
		Int ImagePathCount = JsonUtil.StringListCount(Path , "imagepath")
		string imagepath = JsonUtil.StringListGet(Path,"imagepath",Utility.RandomInt(0,ImagePathCount - 1))
		
		; TraitsMenu correctly uses AddItem()
		GachaMenu.additem(Name , description , imagepath)
		GachaPathArr = PapyrusUtil.PushString(GachaPathArr , Path)
		f += 1
	endwhile

	String[] result = GachaMenu.show()
	if result.length <= 0
		PrintDebug("RedeemPity: No banner selected, exiting")
		return
	endif
	
	String SelectedBannerPath = GachaPathArr[result[0] as int]
	PrintDebug("RedeemPity: Selected banner path = " + SelectedBannerPath)

	; --- Stage 3: Choose Item to Redeem ---
	Masterscript.Announce("Choose an item to redeem from the " + rarityToRedeem + " pool.")
	b612_SelectList ItemSelectionMenu = GetSelectList()

	Form[] RarityPool = JsonUtil.FormListToArray(SelectedBannerPath, rarityToRedeem)
	if !RarityPool || RarityPool.Length == 0
		PrintDebug("RedeemPity: No items in the " + rarityToRedeem + " pool for this banner, aborting.")
		Masterscript.Announce("This banner has no items in the " + rarityToRedeem + " tier!")
		return
	endif

	; Filter out any items from uninstalled plugins
	Form[] FinalPool = TrimPool(RarityPool, rarityToRedeem)
	
	if !FinalPool || FinalPool.Length == 0
		PrintDebug("RedeemPity: No installable items in the " + rarityToRedeem + " pool, aborting.")
		MasterScript.Announce("No installed items found in this banner's " + rarityToRedeem + " tier!")
		return
	endif

	String[] itemNames
	Form[] formsToRedeem
	int i = 0
	while i < FinalPool.length
		Form item = FinalPool[i]
		itemNames = PapyrusUtil.PushString(itemNames, item.GetName())
		formsToRedeem = PapyrusUtil.PushForm(formsToRedeem, item)
		i += 1
	endwhile

	; SelectList correctly takes a string[] array
	Int selectedItemIndex = ItemSelectionMenu.show(itemNames)
	if selectedItemIndex < 0 || selectedItemIndex >= formsToRedeem.Length
		PrintDebug("RedeemPity: Invalid item selection, exiting.")
		return
	endif

	; --- Final Stage: Reward and Pity Consumption ---
	Form reward = formsToRedeem[selectedItemIndex]
	PlayerRef.AddItem(reward, 1, true)
	PityRollCount -= costToRedeem

	Masterscript.Announce("Redeemed " + reward.GetName() + " for " + costToRedeem + " Pity Rolls!")
	utility.wait(3)
	Masterscript.Announce("New Pity Roll Count: " + PityRollCount)
	PrintDebug("RedeemPity: Successfully redeemed item " + reward.GetName())
EndFunction

;=============================
;trims null entries
;=============================
Form[] Function TrimPool(Form[] InPool, String PoolName)
	if !InPool
		printdebug("[" + PoolName + "] Pool is null")
		return none
	endif

	int i = 0
	while i < InPool.Length
		if !InPool[i]
			printdebug("[" + PoolName + "] Removing invalid form")
			InPool = PapyrusUtil.RemoveForm(InPool, InPool[i])
		else
			i += 1
		endif
	endwhile

	printdebug("[" + PoolName + "] Final count = " + InPool.Length)
	return InPool
EndFunction

Float LastNPCRequestTIme


Function AssignSafeZoneNPCRequests()
    float nowTime = GetCurrentRealTimeSeconds()
    float timeDiff = nowTime - LastNPCRequestTIme
	

	
    printdebug("AssignSafeZoneNPCRequests: Called")
    printdebug("AssignSafeZoneNPCRequests: Time since last request = " + timeDiff)
    printdebug("AssignSafeZoneNPCRequests: Cooldown = " + NPCRequestCD)
    printdebug("AssignSafeZoneNPCRequests: IsNPCRequestPaused = " + IsNPCRequestPaused())
    printdebug("AssignSafeZoneNPCRequests: OccupiedNPC = " + GetOccupiedNPC())
    printdebug("AssignSafeZoneNPCRequests: SafeLocation = " + IsInSafeLocation())
    
	;Fallback
	if timeDiff < 0
		LastNPCRequestTIme = nowTime
	EndIf
	
    int roll = Utility.RandomInt(1,100)
    PrintDebug("AssignSafeZoneNPCRequests: RNG roll = " + roll + " / ChanceForNPCRequest = " + ChanceForNPCRequest)
	printdebug("roll: " + roll)
	printdebug("ChanceForNPCRequest: " + ChanceForNPCRequest)
    if timeDiff > NPCRequestCD && !IsNPCRequestPaused() && !GetOccupiedNPC() && IsInSafeLocation() && roll <= ChanceForNPCRequest
        PrintDebug("AssignSafeZoneNPCRequests: Conditions met → finding target")
        Actor Target = FindRandomActorForNPCRequests(PlayerRef,MaxDistanceForNPCRequest, MinDistanceForNPCRequest )

        if !Target
            PrintDebug("AssignSafeZoneNPCRequests: No valid target found → skipping")
        else
            PrintDebug("AssignSafeZoneNPCRequests: Target found = " + Target)
            Target.AddSpell(HentairimNPCRequestSpell)
            LastNPCRequestTIme = nowTime
            PrintDebug("AssignSafeZoneNPCRequests: Spell added to target. LastNPCRequestTime updated = " + LastNPCRequestTIme)
        endif
    else
        PrintDebug("AssignSafeZoneNPCRequests: Conditions not met → skipping")
    endif
EndFunction

Actor Function FindRandomActorForNPCRequests(ObjectReference arCenter, Float afMaxRadius, Float afMinRadius)
    ; Validate the input to ensure a valid search area
    if afMinRadius >= afMaxRadius
        PrintDebug("FindRandomActorForNPCRequests - ERROR: Min radius (" + afMinRadius + ") >= Max radius (" + afMaxRadius + ")")
        return none
    endif

    Actor resultActor = none
    Int attempts = 0
    Int maxAttempts = 5 ; Limit the number of retries to prevent script from hanging

    PrintDebug("FindRandomActorForNPCRequests - Starting search. MinRadius=" + afMinRadius + ", MaxRadius=" + afMaxRadius)

    ; Loop until a valid actor is found or maximum attempts are reached
    while resultActor == none && attempts < maxAttempts
        PrintDebug("FindRandomActorForNPCRequests - Attempt " + attempts)

        ; Get a random actor within the maximum radius
        Actor randomCandidate = Game.FindRandomActorFromRef(arCenter, afMaxRadius)

        if (randomCandidate) && sexlab.getsex(randomCandidate) <= 2 && !randomCandidate.ishostiletoactor(PlayerRef)
            PrintDebug("FindRandomActorForNPCRequests - Found candidate: " + randomCandidate.GetDisplayName())

            ; Calculate the distance from the candidate to the center
            float distance = arCenter.GetDistance(randomCandidate)
            PrintDebug("FindRandomActorForNPCRequests - Candidate distance: " + distance)

            ; Check distance condition
            if distance >= afMinRadius
                ; Validate candidate can be processed
                if MasterScript.NPCCanBeProcessed(randomCandidate)
                    PrintDebug("FindRandomActorForNPCRequests - Candidate accepted: " + randomCandidate.GetDisplayName())
                    resultActor = randomCandidate
                else
                    PrintDebug("FindRandomActorForNPCRequests - Candidate rejected by NPCCanBeProcessed.")
                endif
            else
                PrintDebug("FindRandomActorForNPCRequests - Candidate rejected (too close).")
            endif
        else
            PrintDebug("FindRandomActorForNPCRequests - No candidate found this attempt.")
        endif

        attempts += 1
    endwhile

    if resultActor
        PrintDebug("FindRandomActorForNPCRequests - Final result: " + resultActor.GetDisplayName())
    else
        PrintDebug("FindRandomActorForNPCRequests - No valid actor found after " + attempts + " attempts.")
    endif

    return resultActor
EndFunction



Actor[] Function AddNearestActorForSex(Actor[] CurrentSexList,int count, Bool IsSeduce ,Int Distance)
	Actor tmpActor
	int z
	int CurrentlyAddedActors = 0
	while z <= 10 && CurrentlyAddedActors < count
		tmpactor = PO3_SKSEFunctions.GetRandomActorFromRef(playerref, Distance, true)
		;basic  validation
		if Sexlab.ValidateActor(tmpactor) > 0 && papyrusutil.CountActor(CurrentSexList , tmpactor) == 0
			actor[] tmpSexlist = CurrentSexList
			tmpSexlist = PapyrusUtil.PushActor(tmpSexlist,tmpactor)
			
			string[] availablesexscenes = sexlabregistry.LookupScenes(tmpSexlist , "" , none , 0 , none)
			
			;Check Seduce Probability && Availability of Sex Scenes
			if availablesexscenes.length > 0 && ((IsSeduce && utility.randomfloat(1,100) <= GetSeduceSuccessChance(playerref,tmpactor,Masterscript.GetActorArousal(tmpactor),seducechancemultiplier , false)) || !IsSeduce)
				CurrentSexList = PapyrusUtil.PushActor(CurrentSexList,tmpactor)
				CurrentlyAddedActors += 1
			endif
		endif
		Distance += 30
		z += 1
	endwhile
	return CurrentSexList
endfunction


Bool Function FuckbyNPC(Actor VictimActor , bool IsVictim = true , Actor Follower = None , Bool IsSeduce = true)
	PrintDebug("FuckByNPC: Function called with VictimActor=" + VictimActor + ", IsVictim=" + IsVictim + ", Follower=" + Follower + ", IsSeduce=" + IsSeduce)

	if sexLab.ValidateActor(VictimActor) <= -1
		PrintDebug("FuckByNPC: Invalid VictimActor -> returning false")
		return false
	endif

	Actor[] TheSexList = new actor[1]
	TheSexList[0] = VictimActor	
	PrintDebug("FuckByNPC: Initialized SexList with VictimActor = " + VictimActor.GetDisplayName())

	int z
	actor tmpactor
	PrintDebug("FuckByNPC: Sex List Before Adding Nearby NPC : " + TheSexList)

	if Follower
		PrintDebug("FuckByNPC: Follower detected (" + Follower.GetDisplayName() + ") → adding to SexList")
		TheSexList = papyrusutil.PushActor(TheSexList , Follower)
		PrintDebug("FuckByNPC: Added Follower, calling AddNearestActorForSex (limit 2, IsSeduce=" + IsSeduce + ")")
		TheSexList = AddNearestActorForSex(TheSexList,2,IsSeduce, 300)
	else
		PrintDebug("FuckByNPC: No Follower → calling AddNearestActorForSex (limit 3, IsSeduce=" + IsSeduce + ")")
		TheSexList = AddNearestActorForSex(TheSexList,3,IsSeduce, 300)
	EndIf

	PrintDebug("FuckByNPC: Sex List After Adding Nearby NPC : " + TheSexList + " (Count=" + TheSexList.Length + ")")

	;return false if no one nearby wants to have sex
	if TheSexList.Length <= 1
		PrintDebug("FuckByNPC: Only VictimActor found (Length=" + TheSexList.Length + ") → returning false")
		return false
	elseif TheSexList.Length <= 2 && Follower
		PrintDebug("FuckByNPC: Only Victim and Follower present (Length=" + TheSexList.Length + ") → returning false")
		return false
	EndIf
	
	PrintDebug("FuckByNPC: Valid scene setup detected, starting SexLab scene... (" + TheSexList.Length + " participants)")

	if !IsVictim
		PrintDebug("FuckByNPC: Scene starting")
		if !Sexlab.StartScene(TheSexList, astags ="")
			PrintDebug("FuckByNPC: Failed to Start Scene with " + TheSexList)
		else
			PrintDebug("FuckByNPC: Scene started successfully")
		EndIf
	else
		PrintDebug("FuckByNPC: Scene starting in Victim mode ")
		if !Sexlab.StartScene(TheSexList, astags ="", akSubmissive = VictimActor)
			PrintDebug("FuckByNPC: Failed to Start Scene with " + TheSexList)
		else
			PrintDebug("FuckByNPC: Scene started successfully")
		endif
	endif

	PrintDebug("FuckByNPC: Function completed → returning true")
	return true	
	
EndFunction


;/
	Idle BaboFaintF_Loop ; fall down on knees and faint
	Idle BaboFaintF ;fall down on face and faint ass up
	Idle BaboDefeatPanting ;FALL ONTO THE Ground like maiden and coughing
	Idle BaboDefeatKnockOutEnd ;falldown knocked out end wake up
	Idle BaboDefeatKnockOutStart ;falldown knocked out
	Idle BaboDefeatSurrender ;Hands up
	Idle Babo_DefeatTraumaStand ;Standing Defeat
/; 
Function PlayBaboIdles(actor char, idle BaboIdle , float timetoplay = 8.0)
	if PO3_SKSEFunctions.IsPluginFound("BakaMotionData.esp")
		SheathWeapon(char)
		char.SetRestrained(true)
		char.PlayIdle(BaboIdle)
		utility.wait(timetoplay)
		char.SetRestrained(false)
		Debug.SendAnimationEvent(char, "IdleForceDefaultState")
	endif
endfunction

Function SheathWeapon(Actor char)
if char.isweapondrawn()
	char.SheatheWeapon()
	utility.wait(2)
endif
Endfunction

Function ShowMiddleFinger(Actor char)
     FaceActor(char, Game.GetPlayer())
     PlayAnim(char, 51)
	 Utility.wait(1.2)
     char.SetRestrained(false)
EndFunction

Float LastUpdatedBodilyeffectsHour


Function ProcessBodilyEffects(actor char)
	
	if !BodyEffectsAndDrugsEnabled()
		Return
	endif
	PrintDebug("ProcessBodilyEffects: called for " + char.GetDisplayName())
	Float HoursElapsed = MasterScript.GetCurrentGameTimeHours() - LastUpdatedBodilyeffectsHour
	PrintDebug("ProcessBodilyEffects: HoursElapsed since last update = " + HoursElapsed + ", LastUpdatedBodilyeffectsHour = " + LastUpdatedBodilyeffectsHour)
	if HoursElapsed < utility.randomfloat(1,3)
		PrintDebug("ProcessBodilyEffects: Skipping update, HoursElapsed too short (" + HoursElapsed + ")")
		return
	endif

	;Process Lactating if any
	Float LactatingHours = GetLactatingRemainingHours(char)
	PrintDebug("ProcessBodilyEffects: LactatingRemainingHours = " + LactatingHours)
	if LactatingHours > 0
		PrintDebug("ProcessBodilyEffects: Processing Lactation for " + char.GetDisplayName() + ", Potency = " + GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
		Masterscript.AddLactatingSpell(char)
		ModBoobsSensitivity(char , GetSensitiveBodyPotencyPerHour())
	else
		Masterscript.RemoveLactatingSpell(char)
		PrintDebug("ProcessBodilyEffects: Lactating Spell Times Up. Remove Lactating Spell for " + char.GetDisplayName())
	Endif
	
	;Process Penis Growth Drug
	Float PenisGrowthHours = GetPenisGrowthRemainingHours(char)
	if PenisGrowthHours > 0
		GrowPenis(Char)
		else
		RestorePenis(Char)
	endif
	
	;Process Body Sensitivity Drug If any
	Float SensitiveBodyHours = GetSensitiveBodyRemainingHours(char)
	PrintDebug("ProcessBodilyEffects: SensitiveBodyRemainingHours = " + SensitiveBodyHours)
	if SensitiveBodyHours > 0
		Int Sex = Sexlab.GetSex(Char)
		PrintDebug("ProcessBodilyEffects: Processing Body Sensitivity Drug, Actor Sex = " + Sex + ", Potency = " + GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
		if Sex == 1 || Sex == 2
			PrintDebug("ProcessBodilyEffects: Applying vaginal/anal/boobs sensitivity mods")
			ModVaginalSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
			ModAnalSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
			ModBoobsSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
		endif
		
		if Sex == 0 || Sex == 2
			PrintDebug("ProcessBodilyEffects: Applying penile sensitivity mod")
			ModPenileSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
		endif
	else
		PrintDebug("ProcessBodilyEffects: No Body Sensitivity Drug active for " + char.GetDisplayName())
	endif
	
	;Process Resistance
	PrintDebug("ProcessBodilyEffects: Checking ResistanceEnabled = " + Masterscript.ResistanceEnabled())
	if Masterscript.ResistanceEnabled()
		PrintDebug("ProcessBodilyEffects: Resistance system active, recovering resistance for " + PlayerRef.GetDisplayName() + ", Math.floor(HoursElapsed) = " + Math.floor(HoursElapsed))
		Masterscript.RecoverResistancebyHour(Playerref, Math.floor(HoursElapsed))
	
		if MasterScript.IsBroken(char)
			PrintDebug("ProcessBodilyEffects: " + char.GetDisplayName() + " is Broken = True, applying extra sensitivity and addiction")
			Int Sex = Sexlab.GetSex(Char)
			PrintDebug("ProcessBodilyEffects: Broken Actor Sex = " + Sex)
			if Sex == 1 || Sex == 2
				PrintDebug("ProcessBodilyEffects: Modifying vaginal and anal sensitivity for broken actor")
				ModVaginalSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
				ModAnalSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed)) 
			endif		
			if Sex != 1
				PrintDebug("ProcessBodilyEffects: Modifying penile sensitivity for broken actor")
				ModPenileSensitivity(char , GetSensitiveBodyPotencyPerHour() * Math.floor(HoursElapsed))
			endif
			PrintDebug("ProcessBodilyEffects: Increasing Sex Addiction for broken actor, Potency = " + GetSexAddictionPotencyPerHour() * Math.floor(HoursElapsed))
			ModSexAddiction(char , GetSexAddictionPotencyPerHour() * Math.floor(HoursElapsed))
		endif
	else
		PrintDebug("ProcessBodilyEffects: Resistance system disabled")
	endif

	Float CumAddictionHours = GetCumAddictionRemainingHours(char)
	PrintDebug("ProcessBodilyEffects: CumAddictionRemainingHours = " + CumAddictionHours)
	if CumAddictionHours > 0
		PrintDebug("ProcessBodilyEffects: Processing Cum Addiction Drug for " + char.GetDisplayName() + ", Potency = " + GetCumAddictionPotencyPerHour() * Math.floor(HoursElapsed))
		ModCumAddiction(char , GetCumAddictionPotencyPerHour() * Math.floor(HoursElapsed))
	endif
	
	Float SexAddictionHours = GetSexAddictionRemainingHours(char)
	PrintDebug("ProcessBodilyEffects: SexAddictionRemainingHours = " + SexAddictionHours)
	if SexAddictionHours > 0
		PrintDebug("ProcessBodilyEffects: Processing Sex Addiction Drug, Potency = " + GetSexAddictionPotencyPerHour() * Math.floor(HoursElapsed))
		ModSexAddiction(char , GetSexAddictionPotencyPerHour())
	endif
	
	Float HugePPHours = GetHugePPAddictionRemainingHours(char)
	PrintDebug("ProcessBodilyEffects: HugePPAddictionRemainingHours = " + HugePPHours)
	if HugePPHours > 0
		PrintDebug("ProcessBodilyEffects: Processing Huge PP Addiction Drug, Potency = " + GetHugePPAddictionPotencyPerHour() * Math.floor(HoursElapsed))
		ModHugePPAddiction(char , GetHugePPAddictionPotencyPerHour() * Math.floor(HoursElapsed))
	endif
	
	Bool PlayPanting = false
	float MagickaDamagePercent = GetCumAddiction(Playerref) as float / 100
	PrintDebug("ProcessBodilyEffects: CumAddiction = " + GetCumAddiction(Playerref) + ", MagickaDamagePercent = " + MagickaDamagePercent)
	if MagickaDamagePercent > 0
		PrintDebug("ProcessBodilyEffects: Applying Magicka damage (" + MagickaDamagePercent + ") to PlayerRef")
		ApplyDamageStats(Playerref, 0.0, MagickaDamagePercent , 0.0)
		
		if MagickaDamagePercent > 0.3 && utility.randomint(1,100) < 40
			PrintDebug("ProcessBodilyEffects: Triggering panting, MagickaDamagePercent > 0.3")
			PlayPanting = true
		EndIf
	EndIf
	
	float SexAddiction = GetSexAddiction(Playerref) as float
	PrintDebug("ProcessBodilyEffects: SexAddiction = " + SexAddiction)
	if SexAddiction > 0
		float ArousaltoAdd = 10 * Math.floor(HoursElapsed) * (SexAddiction / 100 )
		PrintDebug("ProcessBodilyEffects: Adding Arousal (" + ArousaltoAdd + ") | Math.floor(HoursElapsed) = " + Math.floor(HoursElapsed) + ", SexAddiction = " + SexAddiction)
		Masterscript.UpdateArousal(Playerref , math.ceiling(ArousaltoAdd))
		
		if MasterScript.HasOSLAroused()
			float LibidotoAdd = 5 * Math.floor(HoursElapsed) * (SexAddiction / 100)
			PrintDebug("ProcessBodilyEffects: OSLAroused enabled, adding Libido = " + LibidotoAdd)
			OSLArousedNative.ModifyLibido(PlayerRef,LibidotoAdd)
		endif

		Int PlayerArousal = math.floor(Masterscript.GetActorArousal(Playerref))
		PrintDebug("ProcessBodilyEffects: PlayerArousal = " + PlayerArousal)
		if SexAddiction > 70 && PlayerArousal > 80 && utility.randomInt(1,100) <= 30
			PrintDebug("ProcessBodilyEffects: Triggering BegForSex (SexAddiction > 70, Arousal > 80)")
			Masterscript.Announce("Your Sex Addiction and Arousal Overwhelmed Your Sensibilities!")
			BegforSexNearbyNPC()
		endif
	endif
	
	PrintDebug("ProcessBodilyEffects: PlayPanting = " + PlayPanting)
	if PlayPanting
		if Masterscript.IsWearingGag(PlayerRef)
			PrintDebug("ProcessBodilyEffects: Player wearing gag, playing gagged panting sound")
			IVDTPlayGagged(true)
		else	
			PrintDebug("ProcessBodilyEffects: Player not gagged, playing normal panting sound")
			IVDTPlayPanting(true)	
		endif
	else
		PrintDebug("ProcessBodilyEffects: No panting triggered this update")
	endIf
	
	LastUpdatedBodilyeffectsHour = MasterScript.GetCurrentGameTimeHours()
	PrintDebug("ProcessBodilyEffects: finished for " + char.GetDisplayName() + ", LastUpdatedBodilyeffectsHour updated to " + LastUpdatedBodilyeffectsHour)
EndFunction



Function BegforSexNearbyNPC()
	Int SeduceTimerLimit
	if seduceseconds > 0	
		SeduceTimerLimit = SeduceSeconds
		int SeduceExpressionCounter = 1
		HornyPlayBegForPenis()
		PlayRandomSeductionAnims(PlayerRef,none)
		while SeduceTimerLimit > 0
			SeduceExpressionCounter = utility.randomInt(1,5)
			ExpressionsLookUp(PlayerRef , "Seduce" + SeduceExpressionCounter as String)
			Utility.Wait(utility.randomfloat(1,3))
			SeduceTimerLimit -= 1
		endwhile
	endif
	if !FuckbyNPC(Playerref , true , none , false)
		Masterscript.Announce("No One is Around to Take Advantage of you!")
		Debug.SendAnimationEvent(Playerref, "IdleForceDefaultState")
	endif
EndFunction



;future ideas, NPC fucking another NPC
;NPC punch back or cry

;Arousal Control and consequences