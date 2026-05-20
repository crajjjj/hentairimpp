Scriptname AdventureCall extends ReferenceAlias hidden

SexLabFramework Property SexLab Auto 

;Gives Faint Essence
Bool Function AddFaintEssence(Int value ,String Content = "") Global
	
	if value < 0 && GetFaintEssence() < -Value
		Announce("You Dont Have Enough Faint Essence! You Need "+ (-value) as string,"Hentairim/Failed.dds")
		return false
	endif
	
	StorageUtil.adjustintValue(Game.Getplayer(),"FaintEssence", Value)
	if Content != ""
		Announce(Content)
	EndIf
	return true
EndFunction

;Gives Premium Essence
Bool Function AddPremiumEssence(Int value,String Content = "") Global
	if value < 0 && GetPremiumEssence() < -Value
		Announce("You Dont Have Enough Premium Essence! You Need "+ (-value) as string,"Hentairim/Failed.dds")
		return false
	endif
	
	StorageUtil.adjustintValue(Game.Getplayer(),"PremiumEssence", Value)
	if Content != ""
		Announce(Content)
	EndIf
	return true
Endfunction

int Function GetFaintEssence() Global
	return StorageUtil.GetIntValue(Game.Getplayer(),"FaintEssence", 0)
Endfunction

int Function GetPremiumEssence() Global
	return StorageUtil.GetIntValue(Game.Getplayer(),"PremiumEssence", 0)
Endfunction

; Converts Faint Essence into Premium Essence
; Exchange Rate: defined in config. 50 by default
Function ConverttoPremiumEssence(Int value) Global
	Actor PlayerRef = Game.GetPlayer()
	int Conversionrate = jsonutil.GetIntValue("Hentairimadventure/GachaConfig.json","premiumessenceconversionrate", 50)
	; How much faint the player has
	Int CurrentFaint = GetFaintEssence()
	
	; Total faint required for this conversion
	Int RequiredFaint = value * Conversionrate
	
	; Check if the player has enough faint
	If CurrentFaint >= RequiredFaint
		; Remove faint essence
		StorageUtil.AdjustintValue(PlayerRef, "FaintEssence", -RequiredFaint)
		
		; Add premium essence
		StorageUtil.AdjustintValue(PlayerRef, "PremiumEssence", value)
		
		Announce("Converted " + RequiredFaint + " Faint Essence into " + value + " Premium Essence!")
	Else
		Announce("Not enough Faint Essence. Need " + RequiredFaint + " but only have " + CurrentFaint + ".","Hentairim/Failed.dds")
	EndIf
EndFunction

Int Function GetPowerLevelDifference(Actor Char, Actor EnemyRef) Global
    If !Char || !EnemyRef
        return 0
    EndIf

    ; =======================
    ; HEALTH COMPARISON (RAW VALUES)
    ; =======================
    Float playerHealth = Char.GetActorValue("Health")
    Float enemyHealth  = EnemyRef.GetActorValue("Health")
    Float healthFactor = (playerHealth - enemyHealth) * 0.5

    ; =======================
    ; STAMINA COMPARISON (RAW VALUES, weaker influence)
    ; =======================
    Float playerStamina = Char.GetActorValue("Stamina")
    Float enemyStamina  = EnemyRef.GetActorValue("Stamina")
    Float stamFactor = (playerStamina - enemyStamina) * 0.15

    ; =======================
    ; MAGICKA COMPARISON (RAW VALUES, balanced influence)
    ; =======================
    Float playerMagicka = Char.GetActorValue("Magicka")
    Float enemyMagicka  = EnemyRef.GetActorValue("Magicka")
    Float magickaFactor = (playerMagicka - enemyMagicka) * 0.25

    ; =======================
    ; LEVEL DIFFERENCE (progressive)
    ; =======================
    Float playerLevel = Char.GetLevel()
    Float enemyLevel  = EnemyRef.GetLevel()
    Float levelRatio  = 0.0
    If (playerLevel + enemyLevel) != 0.0
        levelRatio = (playerLevel - enemyLevel) / (playerLevel + enemyLevel)
    EndIf
    Float levelFactor = levelRatio * 30.0

    ; =======================
    ; SKILL DIFFERENCE
    ; =======================
    ; Physical skills
    Float pSkillMain = (Char.GetActorValue("OneHanded") + Char.GetActorValue("TwoHanded")) / 2.0
    Float eSkillMain = (EnemyRef.GetActorValue("OneHanded") + EnemyRef.GetActorValue("TwoHanded")) / 2.0
    Float mainSkillRatio = 0.0
    If (pSkillMain + eSkillMain) != 0.0
        mainSkillRatio = (pSkillMain - eSkillMain) / (pSkillMain + eSkillMain)
    EndIf
    Float pSkillDef = (Char.GetActorValue("LightArmor") + Char.GetActorValue("HeavyArmor")) / 2.0
    Float eSkillDef = (EnemyRef.GetActorValue("LightArmor") + EnemyRef.GetActorValue("HeavyArmor")) / 2.0
    Float defSkillRatio = 0.0
    If (pSkillDef + eSkillDef) != 0.0
        defSkillRatio = (pSkillDef - eSkillDef) / (pSkillDef + eSkillDef)
    EndIf

    ; Magic skills
    Float pSkillMagic = (Char.GetActorValue("Alteration") + Char.GetActorValue("Conjuration") + Char.GetActorValue("Destruction") + Char.GetActorValue("Illusion") + Char.GetActorValue("Restoration")) / 5.0
    Float eSkillMagic = (EnemyRef.GetActorValue("Alteration") + EnemyRef.GetActorValue("Conjuration") + EnemyRef.GetActorValue("Destruction") + EnemyRef.GetActorValue("Illusion") + EnemyRef.GetActorValue("Restoration")) / 5.0
    Float magicSkillRatio = 0.0
    If (pSkillMagic + eSkillMagic) != 0.0
        magicSkillRatio = (pSkillMagic - eSkillMagic) / (pSkillMagic + eSkillMagic)
    EndIf
    
    Float skillFactor = (mainSkillRatio * 20.0) + (defSkillRatio * 10.0) + (magicSkillRatio * 20.0)

    ; =======================
    ; COMBINE FACTORS
    ; =======================
    Float powerDifferenceScore = healthFactor + stamFactor + magickaFactor + levelFactor + skillFactor

    ; =======================
    ; Special PLAYER POWER BOOST (MULTIPLIER)
    ; =======================
    ; Multiply the entire final power score by 1.5 for the player's boost
	if Char == Game.Getplayer()
		If powerDifferenceScore > 0.0
			powerDifferenceScore = powerDifferenceScore * 1.5
		Else
			powerDifferenceScore = powerDifferenceScore / 1.5
		EndIf
	Endif
    ; =======================
    ; SCALE RESULT TO -3 to 3 RANGE
    ; =======================
    Int finalResult = 0

    If powerDifferenceScore > 25.0
        ; Char is much stronger
        finalResult = 3
    ElseIf powerDifferenceScore > 10.0
        ; Char is stronger
        finalResult = 2
    ElseIf powerDifferenceScore > 5.0
        ; Char is slightly stronger
        finalResult = 1
    ElseIf powerDifferenceScore < -25.0
        ; EnemyRef is much stronger
        finalResult = -3
    ElseIf powerDifferenceScore < -10.0
        ; EnemyRef is stronger
        finalResult = -2
    ElseIf powerDifferenceScore < -5.0
        ; EnemyRef is slightly stronger
        finalResult = -1
    EndIf

    return finalResult
EndFunction

Float Function GetSeduceSuccessChance(Actor Char, Actor Target, Float TargetArousal, Float ChanceModifier = 1.0, Bool HasFollower = false) Global
	If !Char || !Target
		return 0.0
	EndIf

	; =======================
	; BASE VALUE
	; =======================
	Float baseChance = 30.0 ; Seduction is generally harder than physical domination

	; =======================
	; SKILL FACTOR
	; =======================
	Float speech = Char.GetActorValue("Speechcraft")
	Float illusion = Char.GetActorValue("Illusion")
	Float alteration = Char.GetActorValue("Alteration")

	; main focus = speech, illusion; alteration minor
	Float skillFactor = (speech * 0.5) + (illusion * 0.4) + (alteration * 0.1)
	skillFactor = (skillFactor / 100.0) * 40.0 - 20.0 ; roughly -20 to +20 range

	; =======================
	; AROUSAL INFLUENCE
	; =======================
	Float a = TargetArousal / 100.0  ; normalize

	; Smooth progression: gentle at start, faster midrange, flattens near 100
	Float arousalFactor = (a * a * (3 - 2 * a)) * 100.0

	; Clamp
	if arousalFactor > 100.0
		arousalFactor = 100.0
	endif


	; =======================
	; SOCIAL BOOSTS
	; =======================
	if HasFollower
		baseChance += 10.0 ; having a companion may boost social confidence
	endif

	baseChance = baseChance + (arousalFactor * 0.3) + (skillFactor * 0.4)

	baseChance = baseChance * ChanceModifier

	; =======================
	; RACE / CREATURE MODIFIER
	; =======================
	String targetRace = Target.GetRace().GetName()

	; Horny / Lustful
	if stringutil.find(targetRace, "Troll") > -1 || stringutil.find(targetRace, "Lurker") > -1 || stringutil.find(targetRace, "Chaurus") > -1 || stringutil.find(targetRace, "Ogre") > -1 || targetRace == "Ogrim"
		baseChance *= 1.2
	elseif stringutil.find(targetRace, "Rabbit") > -1 || stringutil.find(targetRace, "Dog") > -1 || stringutil.find(targetRace, "Werewolf") > -1 || stringutil.find(targetRace, "Werebear") > -1 || stringutil.find(targetRace, "Horse") > -1
		baseChance *= 1.15
	elseif stringutil.find(targetRace, "Goblin") > -1 || stringutil.find(targetRace, "Riekling") > -1 || stringutil.find(targetRace, "Falmer") > -1 || stringutil.find(targetRace, "Giant") > -1 || stringutil.find(targetRace, "Orc") > -1
		baseChance *= 1.10
	; Cold / Non-horny
	elseif stringutil.find(targetRace, "Vampire") > -1
		baseChance *= 0.5
	elseif stringutil.find(targetRace, "Dwarven") > -1 || stringutil.find(targetRace, "Dragon") > -1
		baseChance *= 0.1
	endif

	; =======================
	; CLAMP
	; =======================
	if baseChance < 5.0
		baseChance = 5.0
	elseif baseChance > 95.0
		baseChance = 95.0
	endif

	return baseChance
EndFunction


;Calculate Chance for Char to Rape Enemyref based on various factors
Float Function GetRapeSuccessChance(Actor Char, Actor EnemyRef ,Float ChanceModifier = 1.0 , Bool HasFollower = false) Global
    If !Char || !EnemyRef
        return 0.0
    EndIf
	actor[] EnemiesInCombat = PO3_SKSEFunctions.GetCombatTargets(Char)
    ; =======================
    ; HEALTH COMPARISON
    ; =======================
    Float playerHealthPerc = (Char.GetActorValue("Health") / Char.GetBaseActorValue("Health"))
    Float enemyHealthPerc  = (EnemyRef.GetActorValue("Health") / EnemyRef.GetBaseActorValue("Health"))
    Float healthFactor = (1.0 - enemyHealthPerc) - (1.0 - playerHealthPerc) ; how much weaker enemy is vs player
    healthFactor = healthFactor * 50.0 ; health weight → up to ±50%

    ; =======================
    ; STAMINA COMPARISON (weaker influence)
    ; =======================
    Float playerStamPerc = (Char.GetActorValue("Stamina") / Char.GetBaseActorValue("Stamina"))
    Float enemyStamPerc  = (EnemyRef.GetActorValue("Stamina") / EnemyRef.GetBaseActorValue("Stamina"))
    Float stamFactor = ((1.0 - enemyStamPerc) - (1.0 - playerStamPerc)) * 15.0 ; stamina = ~1/3 health weight

    ; =======================
    ; LEVEL DIFFERENCE (progressive)
    ; =======================
    Float playerLevel = Char.GetLevel()
    Float enemyLevel  = EnemyRef.GetLevel()
    Float levelRatio  = (playerLevel - enemyLevel) / (playerLevel + enemyLevel)
    Float levelFactor = levelRatio * 30.0 ; max ±30% influence

    ; =======================
    ; SKILL DIFFERENCE
    ; =======================
    Float pSkillMain = (Char.GetActorValue("OneHanded") + Char.GetActorValue("TwoHanded")) / 2.0
    Float eSkillMain = (EnemyRef.GetActorValue("OneHanded") + EnemyRef.GetActorValue("TwoHanded")) / 2.0
    Float mainSkillRatio = (pSkillMain - eSkillMain) / (pSkillMain + eSkillMain)

    Float pSkillDef = (Char.GetActorValue("LightArmor") + Char.GetActorValue("HeavyArmor") + Char.GetActorValue("Smithing")) / 3.0
    Float eSkillDef = (EnemyRef.GetActorValue("LightArmor") + EnemyRef.GetActorValue("HeavyArmor") + EnemyRef.GetActorValue("Smithing")) / 3.0
    Float defSkillRatio = (pSkillDef - eSkillDef) / (pSkillDef + eSkillDef)

    Float skillFactor = (mainSkillRatio * 20.0) + (defSkillRatio * 10.0) ; weighted 2:1

    ; =======================
    ; COMBINE FACTORS
    ; =======================
    Float baseChance = 50.0 + healthFactor + stamFactor + levelFactor + skillFactor

    ; Apply modifier
    baseChance = baseChance * ChanceModifier
	
	;Add Chance Based on Victim's Arousal
	Float Arousal
	float ArousalAdditionalChance = 0.0

	if PO3_SKSEFunctions.IsPluginFound("TheNewGentleman.esp")
		Arousal = HentairimArousal.GetArousal(EnemyRef)

		; Below 30, interpolate from -15 at 0 → 0 at 30
		if Arousal < 30
			ArousalAdditionalChance = (Arousal/ 30.0) * 15.0 - 15.0

		; At or above 30, interpolate from 0 at 30 → +15 at 100
		else
			ArousalAdditionalChance = ((Arousal - 30.0) / 70.0) * 15.0
		endif
	endif
	
	basechance = basechance + ArousalAdditionalChance 
	if HasFollower
		basechance += 25.0
	Endif
	
	;Reduce base Chance By Enemies Around
	Int EnemiesNearby 
	int v
	while v < EnemiesInCombat.length
		if !EnemiesInCombat[v].isdead()
			EnemiesNearby += 1
		endif
		v += 1
	endwhile
	BaseChance = baseChance - ((EnemiesNearby * 10) as float)
	
	;drastically reduce chance if its huge race
	String charraceName = char.GetRace().GetName()
	if stringutil.find(charraceName, "Lurker") > -1 || stringutil.find(charraceName, "Giant") > -1 || stringutil.find(charraceName, "Mammoth") > -1 || stringutil.find(charraceName, "Centurion") > -1
		baseChance = baseChance / 5
	Endif
	
    ; Clamp to 5–95% range
    if baseChance < 5.0
        baseChance = 5.0
    elseif baseChance > 95.0
        baseChance = 95.0
    endif
	
	
	
    return baseChance
EndFunction

;Damage stats On Rape Failure
Function ApplyDamageStats(Actor char, Float healthPercent, Float magickaPercent, Float staminaPercent) Global
    If !Char
        return
    EndIf

    ; Clamp percents between 0.0 and 1.0
    If healthPercent < 0.0
        healthPercent = 0.0
    ElseIf healthPercent > 1.0
        healthPercent = 1.0
    EndIf

    If magickaPercent < 0.0
        magickaPercent = 0.0
    ElseIf magickaPercent > 1.0
        magickaPercent = 1.0
    EndIf

    If staminaPercent < 0.0
        staminaPercent = 0.0
    ElseIf staminaPercent > 1.0
        staminaPercent = 1.0
    EndIf

    ; Apply penalties
    Float curHealth  = char.GetActorValue("Health")
    Float curMagicka = char.GetActorValue("Magicka")
    Float curStamina = char.GetActorValue("Stamina")

    char.DamageActorValue("Health", curHealth * healthPercent)
    char.DamageActorValue("Magicka", curMagicka * magickaPercent)
    char.DamageActorValue("Stamina", curStamina * staminaPercent)
EndFunction


Function PauseNewRequest() Global
	StorageUtil.SetIntValue(None,"HentairimPauseNewRequest",1)
Endfunction

Function UnPauseNewRequest() Global
	StorageUtil.SetIntValue(None,"HentairimPauseNewRequest",0)
Endfunction

Bool Function IsNPCRequestPaused() Global
	return StorageUtil.SetIntValue(None,"HentairimPauseNewRequest",0) == 1
Endfunction

Function OccupyNPC(Actor Char) Global
	PauseNewRequest()
	StorageUtil.SetFormValue(None,"HentairimOccupiedNPC",Char)
Endfunction

Function UnOccupyNPC() Global
	UnPauseNewRequest()
	StorageUtil.UnSetFormValue(None,"HentairimOccupiedNPC")
Endfunction

Actor Function GetOccupiedNPC() Global
	return StorageUtil.SetFormValue(None,"HentairimOccupiedNPC",none) as Actor
EndFunction

Function Announce(String Content , string icon = "icon.dds" ,float delay = 2.0) GLOBAL

	b612.GetAnnouncement().Show(Content,icon, delay)
endfunction

Int Function GetVaginalSensitivity(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimVaginalSensitivity",0)
endfunction

Int Function GetPenileSensitivity(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimPenileSensitivity",0)
endfunction

Int Function GetBoobsSensitivity(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimBoobsSensitivity",0)
endfunction

Int Function GetAnalSensitivity(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimAnalSensitivity",0)
endfunction

Int Function ClampDrugPotency(Actor Char, String itemkey) Global
	int current = StorageUtil.GetIntValue(Char, itemkey, 0)
	if current > 100
		StorageUtil.SetIntValue(Char, itemkey, 100)
		return 100
	elseif current < 0
		StorageUtil.SetIntValue(Char, itemkey, 0)
		return 0
	endif
	return current
EndFunction


Function ModBodySensitivity(Actor Char, Int value ) Global
	; Vaginal
	StorageUtil.AdjustIntValue(Char, "HentairimVaginalSensitivity", value)
	ClampDrugPotency(Char, "HentairimVaginalSensitivity")

	; Boobs
	StorageUtil.AdjustIntValue(Char, "HentairimBoobsSensitivity", value)
	ClampDrugPotency(Char, "HentairimBoobsSensitivity")

	; Anal
	StorageUtil.AdjustIntValue(Char, "HentairimAnalSensitivity", value)
	ClampDrugPotency(Char, "HentairimAnalSensitivity")
	
	; Penile
	StorageUtil.AdjustIntValue(Char, "HentairimPenileSensitivity", value)
	ClampDrugPotency(Char, "HentairimPenileSensitivity")
EndFunction

Function ModCumAddiction(Actor Char, Int value) Global
	StorageUtil.AdjustIntValue(Char, "HentairimCumAddiction", value)
	ClampDrugPotency(Char, "HentairimCumAddiction")
EndFunction

Function ModSexAddiction(Actor Char, Int value) Global
	StorageUtil.AdjustIntValue(Char, "HentairimSexAddiction", value)
	ClampDrugPotency(Char, "HentairimSexAddiction")
EndFunction

Function ModHugePPAddiction(Actor Char, Int value) Global
	StorageUtil.AdjustIntValue(Char, "HentairimHugePPAddiction", value)
	ClampDrugPotency(Char, "HentairimHugePPAddiction")
EndFunction

Int Function GetHugePPAddictionSatiatePerStage() Global
    return JsonUtil.GetIntValue(DrugsConfigPath(), "hugeppaddictionsatiateperstage", 0)
EndFunction

Int Function GetCumAddictionSatiatePerOrgasm() Global
    return JsonUtil.GetIntValue(DrugsConfigPath(), "cumaddictionsatiateperorgasm", 0)
EndFunction

Int Function GetSexAddictionSatiatePerOrgasm() Global
    return JsonUtil.GetIntValue(DrugsConfigPath(), "sexaddictionsatiateperorgasm", 0)
EndFunction

Int Function GetSensitiveBodySatiatePerStage() Global
    return JsonUtil.GetIntValue(DrugsConfigPath(), "sensitivebodysatiateperstage", 0)
EndFunction

Int Function GetSensitiveBodySatiatePerIntenseStage() Global
    return JsonUtil.GetIntValue(DrugsConfigPath(), "sensitivebodysatiateperintensestage", 0)
EndFunction

Int Function GetCumAddiction(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimCumAddiction",0)
endfunction

Int Function GetSexAddiction(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimSexAddiction",0)
endfunction

Int Function GetHugePPAddiction(Actor Char) GLOBAL
	return StorageUtil.GetintValue(Char,"HentairimHugePPAddiction",0)
endfunction

Int Function GetSensitiveBodyPotencyPerHour() GLOBAL
	return JsonUtil.GetIntValue(DrugsConfigPath(), "sensitivebodypotencyperhour", 0)
endfunction

Int Function GetCumAddictionPotencyPerHour() GLOBAL
	return JsonUtil.GetIntValue(DrugsConfigPath(), "cumaddictionpotencyperhour", 0)
endfunction

Int Function GetSexAddictionPotencyPerHour() GLOBAL
	return JsonUtil.GetIntValue(DrugsConfigPath(), "sexaddictionpotencyperhour", 0)
endfunction

Int Function GetHugePPAddictionPotencyPerHour() GLOBAL
	return JsonUtil.GetIntValue(DrugsConfigPath(), "hugeppaddictionpotencyperhour", 0)
endfunction

Function ModVaginalSensitivity(Actor Char , Int Value) GLOBAL
	int NewValue = GetVaginalSensitivity(Char) + Value
	If NewValue > 100
		NewValue = 100
	elseif NewValue < 0
		NewValue = 0
	endif
	StorageUtil.SetintValue(Char,"HentairimVaginalSensitivity",NewValue)
endfunction

Function ModPenileSensitivity(Actor Char , Int Value) GLOBAL
	int NewValue = GetPenileSensitivity(Char) + Value
	If NewValue > 100
		NewValue = 100
	elseif NewValue < 0
		NewValue = 0
	endif
	StorageUtil.SetintValue(Char,"HentairimPenileSensitivity",NewValue)
endfunction

Function ModAnalSensitivity(Actor Char , Int Value) Global
	int NewValue = GetAnalSensitivity(Char) + Value
	If NewValue > 100
		NewValue = 100
	elseif NewValue < 0
		NewValue = 0
	endif
	StorageUtil.SetintValue(Char,"HentairimAnalSensitivity",NewValue)
endfunction
Function ModBoobsSensitivity(Actor Char , Int Value) Global
    int NewValue = GetBoobsSensitivity(Char) + Value
	If NewValue > 100
		NewValue = 100
	elseif NewValue < 0
		NewValue = 0
	endif
	StorageUtil.SetintValue(Char,"HentairimBoobsSensitivity",NewValue)
endfunction


Bool Function BodyEffectsAndDrugsEnabled() Global
	return jsonutil.GetintValue(DrugsConfigPath(),"enablebodyeffectsanddrugs",0) > 0
Endfunction

String Function DrugsConfigPath() Global
	return "HentairimAdventure/BodyEffectsAndDrugs.json"
endfunction

Float Function GetLactatingRemainingHours(Actor Char) Global
	float endHour = StorageUtil.GetFloatValue(Char, "HentairimLactatingEndHour")
	if endHour <= 0
		return 0.0
	endif

	float remaining = endHour - GetCurrentGameTimeHours()
	if remaining <= 0
		StorageUtil.UnsetFloatValue(Char, "HentairimLactatingEndHour")
		return 0.0
	endif
	return remaining
EndFunction

Float Function GetSensitiveBodyRemainingHours(Actor Char) Global
	float endHour = StorageUtil.GetFloatValue(Char, "HentairimSensitiveBodyEndHour")
	if endHour <= 0
		return 0.0
	endif

	float remaining = endHour - GetCurrentGameTimeHours()
	if remaining <= 0
		StorageUtil.UnsetFloatValue(Char, "HentairimSensitiveBodyEndHour")
		return 0.0
	endif
	return remaining
EndFunction

Float Function GetCumAddictionRemainingHours(Actor Char) Global
	float endHour = StorageUtil.GetFloatValue(Char, "HentairimCumAddictionEndHour")
	if endHour <= 0
		return 0.0
	endif

	float remaining = endHour - GetCurrentGameTimeHours()
	if remaining <= 0
		StorageUtil.UnsetFloatValue(Char, "HentairimCumAddictionEndHour")
		return 0.0
	endif
	return remaining
EndFunction

Float Function GetHugePPAddictionRemainingHours(Actor Char) Global
	float endHour = StorageUtil.GetFloatValue(Char, "HentairimHugePPEndHour")
	if endHour <= 0
		return 0.0
	endif

	float remaining = endHour - GetCurrentGameTimeHours()
	if remaining <= 0
		StorageUtil.UnsetFloatValue(Char, "HentairimHugePPEndHour")
		return 0.0
	endif
	return remaining
EndFunction

Float Function GetSexAddictionRemainingHours(Actor Char) Global
	float endHour = StorageUtil.GetFloatValue(Char, "HentairimSexAddictionEndHour")
	if endHour <= 0
		return 0.0
	endif

	float remaining = endHour - GetCurrentGameTimeHours()
	if remaining <= 0
		StorageUtil.UnsetFloatValue(Char, "HentairimSexAddictionEndHour")
		return 0.0
	endif
	return remaining
EndFunction

Float Function GetPenisGrowthRemainingHours(Actor Char) Global
	float endHour = StorageUtil.GetFloatValue(Char, "HentairimPenisGrowthEndHour")
	if endHour <= 0
		return 0.0
	endif

	float remaining = endHour - GetCurrentGameTimeHours()
	if remaining <= 0
		StorageUtil.UnsetFloatValue(Char, "HentairimPenisGrowthEndHour")
		return 0.0
	endif
	return remaining
EndFunction

Function GrowPenis(actor char) Global
	;TNG_Papyrusutil.GetAllPossibleAddons(true)
	TNG_Papyrusutil.SetActorAddon(char , 0)
Endfunction

Function RestorePenis(actor char) Global
	TNG_Papyrusutil.SetActorAddon(char , -2) ;male go back to default , female go back to not having penis
	ModPenileSensitivity(char , -100) 
Endfunction

Function AddRandomDrug(Actor char , Bool ExcludePenisGrowth = false) Global
	int num 
	
	AddDrug(char, utility.randomint(1,5))
endfunction

Function AddDrug(Actor char, Int DrugType) Global
	;/ Types of Drug Effects
	; 1 = Lactating
	; 2 = Body Sensitive Drug
	; 3 = Cum Addiction Drug
	; 4 = Large PP Addiction Drug
	; 5 = Sex Addiction Drug
	; 6 = Penis Growth Drug
	/;

	int lactatingdrugeffectminhours       = JsonUtil.GetIntValue(DrugsConfigPath(), "lactatingdrugeffectminhours", 100)
	int lactatingdrugeffectmaxhours       = JsonUtil.GetIntValue(DrugsConfigPath(), "lactatingdrugeffectmaxhours", 300)
	int sensitivebodydrugeffectminhours   = JsonUtil.GetIntValue(DrugsConfigPath(), "sensitivebodydrugeffectminhours", 100)
	int sensitivebodydrugeffectmaxhours   = JsonUtil.GetIntValue(DrugsConfigPath(), "sensitivebodydrugeffectmaxhours", 300)
	int sexaddictiondrugeffectminhours    = JsonUtil.GetIntValue(DrugsConfigPath(), "sexaddictiondrugeffectminhours", 100)
	int sexaddictiondrugeffectmaxhours    = JsonUtil.GetIntValue(DrugsConfigPath(), "sexaddictiondrugeffectmaxhours", 300)
	int cumaddictiondrugeffectminhours    = JsonUtil.GetIntValue(DrugsConfigPath(), "cumaddictiondrugeffectminhours", 100)
	int cumaddictiondrugeffectmaxhours    = JsonUtil.GetIntValue(DrugsConfigPath(), "cumaddictiondrugeffectmaxhours", 300)
	int hugeppaddictiondrugeffectminhours = JsonUtil.GetIntValue(DrugsConfigPath(), "hugeppaddictiondrugeffectminhours", 100)
	int hugeppaddictiondrugeffectmaxhours = JsonUtil.GetIntValue(DrugsConfigPath(), "hugeppaddictiondrugeffectmaxhours", 300)
	int maxnumberofdrugeffects        = JsonUtil.GetIntValue(DrugsConfigPath(), "maxnumberofdrugeffects", 1)
	int penisgrowthdrugeffectminhours = 100
	int penisgrowthdrugeffectmaxhours = 300
	; === Count active effects ===
	Int activeEffects = 0
	if GetLactatingRemainingHours(char) > 0
		activeEffects += 1
	endif
	if GetSensitiveBodyRemainingHours(char) > 0
		activeEffects += 1
	endif
	if GetCumAddictionRemainingHours(char) > 0
		activeEffects += 1
	endif
	if GetHugePPAddictionRemainingHours(char) > 0
		activeEffects += 1
	endif
	if GetSexAddictionRemainingHours(char) > 0
		activeEffects += 1
	endif
	if GetPenisGrowthRemainingHours(char) > 0
		activeEffects += 1
	endif


	float now = GetCurrentGameTimeHours()

	; check if this effect is already active
	Bool alreadyActive = false
	if DrugType == 1 && GetLactatingRemainingHours(char) > 0
		alreadyActive = true
	elseif DrugType == 2 && GetSensitiveBodyRemainingHours(char) > 0
		alreadyActive = true
	elseif DrugType == 3 && GetCumAddictionRemainingHours(char) > 0
		alreadyActive = true
	elseif DrugType == 4 && GetHugePPAddictionRemainingHours(char) > 0
		alreadyActive = true
	elseif DrugType == 5 && GetSexAddictionRemainingHours(char) > 0
		alreadyActive = true
	elseif DrugType == 6 && GetPenisGrowthRemainingHours(char) > 0
		alreadyActive = true
	endif

	; === Stop only if at cap AND effect is not already active ===
	if activeEffects >= maxnumberofdrugeffects && !alreadyActive
		return
	endif

	; === Apply / Top Up ===
	if DrugType == 1
		if lactatingdrugeffectminhours == 0 && lactatingdrugeffectmaxhours == 0
			return
		endif
		float duration = Utility.RandomFloat(lactatingdrugeffectminhours, lactatingdrugeffectmaxhours)
		float currentEnd = StorageUtil.GetFloatValue(char, "HentairimLactatingEndHour")
		if currentEnd > now
			StorageUtil.SetFloatValue(char, "HentairimLactatingEndHour", currentEnd + duration)
		else
			StorageUtil.SetFloatValue(char, "HentairimLactatingEndHour", now + duration)
		endif

	elseif DrugType == 2
		if sensitivebodydrugeffectminhours == 0 && sensitivebodydrugeffectmaxhours == 0
			return
		endif
		float duration = Utility.RandomFloat(sensitivebodydrugeffectminhours, sensitivebodydrugeffectmaxhours)
		float currentEnd = StorageUtil.GetFloatValue(char, "HentairimSensitiveBodyEndHour")
		if currentEnd > now
			StorageUtil.SetFloatValue(char, "HentairimSensitiveBodyEndHour", currentEnd + duration)
		else
			StorageUtil.SetFloatValue(char, "HentairimSensitiveBodyEndHour", now + duration)
		endif

	elseif DrugType == 3
		if cumaddictiondrugeffectminhours == 0 && cumaddictiondrugeffectmaxhours == 0
			return
		endif
		float duration = Utility.RandomFloat(cumaddictiondrugeffectminhours, cumaddictiondrugeffectmaxhours)
		float currentEnd = StorageUtil.GetFloatValue(char, "HentairimCumAddictionEndHour")
		if currentEnd > now
			StorageUtil.SetFloatValue(char, "HentairimCumAddictionEndHour", currentEnd + duration)
		else
			StorageUtil.SetFloatValue(char, "HentairimCumAddictionEndHour", now + duration)
		endif

	elseif DrugType == 4
		if hugeppaddictiondrugeffectminhours == 0 && hugeppaddictiondrugeffectmaxhours == 0
			return
		endif
		float duration = Utility.RandomFloat(hugeppaddictiondrugeffectminhours, hugeppaddictiondrugeffectmaxhours)
		float currentEnd = StorageUtil.GetFloatValue(char, "HentairimHugePPEndHour")
		if currentEnd > now
			StorageUtil.SetFloatValue(char, "HentairimHugePPEndHour", currentEnd + duration)
		else
			StorageUtil.SetFloatValue(char, "HentairimHugePPEndHour", now + duration)
		endif

	elseif DrugType == 5
		if sexaddictiondrugeffectminhours == 0 && sexaddictiondrugeffectmaxhours == 0
			return
		endif
		float duration = Utility.RandomFloat(sexaddictiondrugeffectminhours, sexaddictiondrugeffectmaxhours)
		float currentEnd = StorageUtil.GetFloatValue(char, "HentairimSexAddictionEndHour")
		if currentEnd > now
			StorageUtil.SetFloatValue(char, "HentairimSexAddictionEndHour", currentEnd + duration)
		else
			StorageUtil.SetFloatValue(char, "HentairimSexAddictionEndHour", now + duration)
		endif
	elseif DrugType == 6
		if penisgrowthdrugeffectminhours == 0 && penisgrowthdrugeffectmaxhours == 0
			return
		endif
		float duration = Utility.RandomFloat(penisgrowthdrugeffectminhours, penisgrowthdrugeffectmaxhours)
		float currentEnd = StorageUtil.GetFloatValue(char, "HentairimPenisGrowthEndHour")
		if currentEnd > now
			StorageUtil.SetFloatValue(char, "HentairimPenisGrowthEndHour", currentEnd + duration)
		else
			StorageUtil.SetFloatValue(char, "HentairimPenisGrowthEndHour", now + duration)
		endif
		GrowPenis(char)
	endif
EndFunction


float function GetCurrentGameTimeHours() global
	return Utility.GetCurrentGameTime() * 24.0
endFunction

Function ClearDrugEffects(Actor Char, Int DrugType) Global
	;/ Types of Drug Effects
	; 0 = Clear All
	; 1 = Lactating
	; 2 = Body Sensitive Drug
	; 3 = Cum Addiction Drug
	; 4 = Large PP Addiction Drug
	; 5 = Sex Addiction Drug
	; 6 = Penis Growth Drug
	/;

	if DrugType == 0 || DrugType == 1
		StorageUtil.UnsetFloatValue(Char, "HentairimLactatingEndHour")
	endif

	if DrugType == 0 || DrugType == 2
		StorageUtil.UnsetFloatValue(Char, "HentairimSensitiveBodyEndHour")
	endif

	if DrugType == 0 || DrugType == 3
		StorageUtil.UnsetFloatValue(Char, "HentairimCumAddictionEndHour")
	endif

	if DrugType == 0 || DrugType == 4
		StorageUtil.UnsetFloatValue(Char, "HentairimHugePPEndHour")
	endif

	if DrugType == 0 || DrugType == 5
		StorageUtil.UnsetFloatValue(Char, "HentairimSexAddictionEndHour")
	endif
	
	if DrugType == 0 || DrugType == 6
		StorageUtil.UnsetFloatValue(Char, "HentairimPenisGrowthEndHour")
	endif
EndFunction
