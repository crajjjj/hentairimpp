Scriptname HentairimNPCRequest extends ActiveMagicEffect  

import b612
Import AdventureCall
Import IVDTVoiceCall
Import ExpressionsCall

IVDTControllerScript Property MasterScript Auto
SexLabFramework Property SexLab Auto 
SexLabThread CurrentThread = None
actor Actorref
actor playerref
int sex
int RequestTimer
Idle IdleWave
Idle IdleApplause
Idle IdlePotionDrink
Idle IdleGive
Bool SceneEnded = false
String ActorName
SexlabThread NPCThread

Event OnEffectStart(Actor akTarget, Actor akCaster)	
	InitializeConfig()
	if enableadventure == 0
		PrintDebug("enable adventure = 0. Removing NPC Request Spell")
		RemoveSpell()
	endif
	PrintDebug("[OnEffectStart] Event fired. Target=" + akTarget + " | Caster=" + akCaster)

	ActorRef = akTarget
	PlayerRef = Game.GetPlayer()
	PrintDebug("[OnEffectStart] ActorRef=" + ActorRef + " | PlayerRef=" + PlayerRef)
	SheathWeapon(ActorRef)
	MasterScript.AddDonotDisturbSpell(actorref,1)
	ActorRef.SetRestrained(True)
	PrintDebug("[OnEffectStart] Restrained set to TRUE for " + ActorRef)

	ActorName = ActorRef.GetDisplayName()
	PrintDebug("[OnEffectStart] ActorName=" + ActorName)

	if !ActorRef
		PrintDebug("[OnEffectStart] No target actor! Removing spell.")
		RemoveSpell()
		return
	endif

	IdleWave = Game.GetFormFromFile(0x3EA32, "Skyrim.esm") as Idle
	IdleApplause = Game.GetFormFromFile( 0xD8730, "Skyrim.esm") as Idle
	IdlePotionDrink = Game.GetFormFromFile(0xD33B0, "Skyrim.esm") as Idle
	IdleGive = Game.GetFormFromFile(0xB5E20, "Skyrim.esm") as Idle
	
	PrintDebug("[OnEffectStart] IdleWave loaded from Skyrim.esm, FormID=0x3EA32")

	Sex = SexLab.GetSex(ActorRef)
	PrintDebug("[OnEffectStart] Actor sex detected: " + Sex)
	 
	RegisterForModEvent("HookAnimationStart", "NPCRequestSceneStart")
	RegisterForModEvent("HookAnimationEnd", "NPCRequestSceneEnd")
	PrintDebug("[OnEffectStart] Registered for HookAnimationStart and HookAnimationEnd")
	MasterScript.Announce(Actorref.GetDisplayName() + " Wants Something" , PlaySFX = "Notification")
	RegisterForSingleUpdate(1)
	PrintDebug("[OnEffectStart] Registered for single update after 1 second")

EndEvent

int enableadventure
int printdebug
int	weightforshowrequest
int	weightforsexrequest
int	weightforddrequest
int	weightforalcoholrequest
int	weightfordrugrequest
int chanceforbadrequest
int	weightforgetraped
int	badrequestgiverewards
int enablebodyeffectsanddrugs
Float globalrewardsmultiplier
Float masturbationrewardsmult
Float boobjobrewardsmult
Float footjobrewardsmult
Float handjobrewardsmult
Float oralrewardsmult
Float vaginalrewardsmult
Float analrewardsmult


Function InitializeConfig()
	
	String Config = "HentairimAdventure/config.json"
	String bodyeffectsanddrugsConfig = "HentairimAdventure/BodyEffectsAndDrugs.json"
	enableadventure = JsonUtil.GetIntValue(Config, "enableadventure", 0)
	printdebug = JsonUtil.GetIntValue(Config, "printdebug", 0)
	chanceforbadrequest = JsonUtil.GetIntValue(Config, "chanceforbadrequest", 0)
	badrequestgiverewards = JsonUtil.GetIntValue(Config, "badrequestgiverewards", 0)	
	globalrewardsmultiplier = JsonUtil.GetFloatValue(Config, "globalrewardsmultiplier", 1.0)
	masturbationrewardsmult = JsonUtil.GetFloatValue(Config, "masturbationrewardsmult", 1.0)
	boobjobrewardsmult = JsonUtil.GetFloatValue(Config, "boobjobrewardsmult", 1.0)
	footjobrewardsmult = JsonUtil.GetFloatValue(Config, "footjobrewardsmult", 1.0)
	handjobrewardsmult = JsonUtil.GetFloatValue(Config, "handjobrewardsmult", 1.0)
	oralrewardsmult = JsonUtil.GetFloatValue(Config, "oralrewardsmult", 1.0)
	vaginalrewardsmult = JsonUtil.GetFloatValue(Config, "vaginalrewardsmult", 1.0)
	analrewardsmult = JsonUtil.GetFloatValue(Config, "analrewardsmult", 1.0)	
    enablebodyeffectsanddrugs = JsonUtil.GetIntValue(bodyeffectsanddrugsConfig, "enablebodyeffectsanddrugs", 0)	
Endfunction

int RequestWindow = 15
Event OnUpdate()
	PrintDebug("[OnUpdate] Event fired for " + ActorRef)

	if !ActorRef || ActorRef.isincombat() || sexlab.validateactor(ActorRef) < 0
		PrintDebug("[OnUpdate] Remove Spell")
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		RemoveSpell()
		return
	endif 
	
	if RequestTimer > RequestWindow
		PrintDebug("[OnUpdate] RequestTimer (" + RequestTimer + ") exceeded RequestWindow (" + RequestWindow + "). Removing spell.")
		RemoveSpell()
		return
	endif
	
	PrintDebug("[OnUpdate] Facing ActorRef towards PlayerRef")
	Masterscript.FaceActor(ActorRef, PlayerRef)

	PrintDebug("[OnUpdate] Playing IdleWave animation for " + ActorRef)
	ActorRef.PlayIdle(IdleWave)
	
	float dist = ActorRef.GetDistance(PlayerRef)
	PrintDebug("[OnUpdate] Distance to " + ActorRef.GetDisplayName() + " = " + dist)

	if !GetOccupiedNPC() && dist <= 100
		PrintDebug("[OnUpdate] Actor is close enough and no occupied NPC. Starting request.")
		StartRequest()
		RemoveSpell()
		return
	endif

	RequestTimer += 1
	PrintDebug("[OnUpdate] RequestTimer incremented to " + RequestTimer)

	RegisterForSingleUpdate(2)
	PrintDebug("[OnUpdate] Registered for next update in 1 second.")
EndEvent


Event NPCRequestSceneStart(int aiThreadID, bool abHasPlayer) 
	;SexlabThread Thread = Sexlab.GetThread(aiThreadID)

EndEvent

Event NPCRequestSceneEnd(int aiThreadID, bool abHasPlayer) 
	PrintDebug("[HentairimAdventureSceneEnd] Event fired. ThreadID=" + aiThreadID + " | HasPlayer=" + abHasPlayer)

	SexLabThread thisThread = SexLab.GetThread(aiThreadID)
	PrintDebug("[HentairimAdventureSceneEnd] Retrieved thread=" + thisThread)

	if thisThread == NPCThread
		SceneEnded = true
		PrintDebug("[HentairimAdventureSceneEnd] Thread matched NPCThread. SceneEnded set to TRUE.")
	else
		PrintDebug("[HentairimAdventureSceneEnd] Thread did not match NPCThread. No change made.")
	endif
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	PrintDebug("[OnHit] Event fired.")

	if akAggressor != None
		PrintDebug("[OnHit] Aggressor=" + akAggressor)
	else
		PrintDebug("[OnHit] Aggressor=None")
	endif

	if akSource != None
		PrintDebug("[OnHit] Source=" + akSource)
	else
		PrintDebug("[OnHit] Source=None")
	endif

	if akProjectile != None
		PrintDebug("[OnHit] Projectile=" + akProjectile)
	else
		PrintDebug("[OnHit] Projectile=None")
	endif

	PrintDebug("[OnHit] Flags: PowerAttack=" + abPowerAttack + ", SneakAttack=" + abSneakAttack + ", BashAttack=" + abBashAttack + ", HitBlocked=" + abHitBlocked)

	if akSource == None || akAggressor == None || akSource as Spell != None 
		if akSource == None
			PrintDebug("[OnHit] Ignored hit. Reason: Source is None.")
		elseif akAggressor == None
			PrintDebug("[OnHit] Ignored hit. Reason: Aggressor is None.")
		elseif akSource as Spell != None
			PrintDebug("[OnHit] Ignored hit. Reason: Source is a Spell.")
		endif
		return
	endif
	
	if ActorRef != None
		PrintDebug("[OnHit] Valid hit detected. Resetting animation for " + ActorRef.GetDisplayName())
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		RemoveSpell()
		PrintDebug("[OnHit] Cleanup complete. Spell removed from " + ActorRef.GetDisplayName())
	else
		PrintDebug("[OnHit] WARNING: ActorRef is None, cannot reset animation or remove spell.")
	endif
EndEvent

Function RemoveSpell()
	PrintDebug("[RemoveSpell] Called. Beginning cleanup.")
	unRegisterForModEvent("HookAnimationStart")
	unRegisterForModEvent("HookAnimationEnd")
	UnregisterForUpdate()
	PrintDebug("[RemoveSpell] Updates unregistered.")

	ActorRef.SetRestrained(false)
	Masterscript.RemoveDoNotDisturbSpell(actorref)

	Utility.Wait(3)
	PrintDebug("[RemoveSpell] Waited 3 seconds before cleanup continuation.")

	UnoccupyNPC()
	PrintDebug("[RemoveSpell] NPC unoccupied.")

	if ActorRef != None
		Spell activeSpell = po3_sksefunctions.GetActiveEffectSpell(self) as Spell
		if activeSpell != None
			PrintDebug("[RemoveSpell] Retrieved active spell: " + activeSpell)
			ActorRef.RemoveSpell(activeSpell)
			PrintDebug("[RemoveSpell] Successfully removed spell " + activeSpell + " from " + ActorRef.GetDisplayName())
		else
			PrintDebug("[RemoveSpell] WARNING: No active spell retrieved, nothing to remove from " + ActorRef.GetDisplayName())
		endif
	else
		PrintDebug("[RemoveSpell] WARNING: ActorRef was None, cannot remove spell.")
	endif

	PrintDebug("[RemoveSpell] Cleanup complete.")
EndFunction


function printdebug(string contents = "")
	if printdebug == 1
		miscutil.printconsole("Hentairim Adventure + " + ActorName + "'s + Request : "+ contents)
	endif
endfunction


Int Function FindInt(Int[] arr, Int target)
	if arr == None
		return -1
	endif
	Int i = 0
	While i < arr.Length
		if arr[i] == target
			return i ; Found, return index
		endif
		i += 1
	EndWhile
	return -1 ; Not found
EndFunction

int ShowBoobsScenario = 1 
int DoubleMasturbateScenario = 2 
int BlowjobScenario = 3 
int HandjobScenario = 4 
int FootjobScenario = 5 
int BoobjobScenario = 6 
int VaginalSexScenario = 7 
int AnalSexScenario = 8 
int LesbianScenario = 9
Int AskForMilkScenario = 10
int LactatingDrugScenario = 11
int GetRapedBadScenario = 51
int RevBlowjobScenario = 12
int RevHandjobScenario = 13
int RevFootjobScenario = 14
int RevBoobjobScenario = 15
int RevVaginalSexScenario = 16
int RevAnalSexScenario = 17
int DrugScenario = 18

Function StartRequest()
    PrintDebug("[StartRequest] Called.")

    OccupyNPC(ActorRef)
    if ActorRef != None
        PrintDebug("[StartRequest] NPC occupied: " + ActorRef.GetDisplayName())
    else
        PrintDebug("[StartRequest] WARNING: ActorRef is None when trying to occupy.")
    endif
		SocialPlayWhatDoYouWant(true)

    PrintDebug("[StartRequest] Triggered SocialPlayWhatDoYouWant.")

    if ActorRef != None
        Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
        PrintDebug("[StartRequest] Reset animation for " + ActorRef.GetDisplayName())
    else
        PrintDebug("[StartRequest] WARNING: ActorRef is None, cannot reset animation.")
    endif

    int PlayerSex = SexLab.GetSex(PlayerRef)
	

    ;================== female/futa Player x male NPC or Female PC x Futa NPC=========
    if (PlayerSex == 1 && (Sex == 0 || Sex == 2)) || (PlayerSex == 2 && Sex == 0)
        PrintDebug("[StartRequest] Player is female/futa, NPC is male/futa. Proceeding with random scenario.")
		
		int[] scenarioCodes = new int[8]

		scenarioCodes[0] = ShowBoobsScenario
		scenarioCodes[1] = DoubleMasturbateScenario
		scenarioCodes[2] = BlowjobScenario
		scenarioCodes[3] = HandjobScenario
		scenarioCodes[4] = FootjobScenario
		scenarioCodes[5] = BoobjobScenario
		scenarioCodes[6] = VaginalSexScenario
		scenarioCodes[7] = AnalSexScenario	
		
		if enablebodyeffectsanddrugs == 1
			scenarioCodes = papyrusutil.pushint(scenarioCodes, DrugScenario)
		endif

		;push in lactating scenario if player is lactating
		if Masterscript.HasLactatingSpell(Playerref)
			scenarioCodes = papyrusutil.pushint(scenarioCodes, AskForMilkScenario)
		endif
	
		int[] badscenarioCodes = new int[1]
		badscenarioCodes[0] = GetRapedBadScenario
		
		if Utility.RandomInt(1,100) < chanceforbadrequest ;bad request
			HandleScenarios(badscenarioCodes, PlayerSex == 2)			
		else
			HandleScenarios(scenarioCodes, PlayerSex == 2)			
		endif
		
    ;================== Female Player x Female NPC==================
    elseif PlayerSex == 1 && Sex == 1 
        PrintDebug("[StartRequest] Player is female, NPC female. Proceeding with random scenario.")
        ; Map scenario codes for this specific combination
        int[] scenarioCodes = new int[3]
        scenarioCodes[0] = ShowBoobsScenario
        scenarioCodes[1] = DoubleMasturbateScenario
        scenarioCodes[2] = LesbianScenario
        
		;push in lactating scenario if player is lactating
		if Masterscript.HasLactatingSpell(Playerref)
			scenarioCodes = papyrusutil.pushint(scenarioCodes, AskForMilkScenario)
		endif
		
		if enablebodyeffectsanddrugs == 1
			scenarioCodes = papyrusutil.pushint(scenarioCodes, DrugScenario)
		endif
		
        HandleScenarios(scenarioCodes, false)

    ;========================= Futa/Male Player x Female NPC======================
    elseif (PlayerSex == 2 && Sex == 1) || (PlayerSex == 0 && Sex == 1)
        PrintDebug("[StartRequest] Player is Futa/Male, NPC is Female. Proceeding with random scenario.")
        ; Map scenario codes for this specific combination
        int[] scenarioCodes
        if PlayerSex == 0 ;Male Player
            scenarioCodes = new int[8]
            scenarioCodes[0] = ShowBoobsScenario
            scenarioCodes[1] = DoubleMasturbateScenario
            scenarioCodes[2] = RevBlowjobScenario
            scenarioCodes[3] = RevHandjobScenario
            scenarioCodes[4] = RevFootjobScenario
            scenarioCodes[5] = RevBoobjobScenario
            scenarioCodes[6] = RevVaginalSexScenario
            scenarioCodes[7] = RevAnalSexScenario
        else ; Futa player
            scenarioCodes = new int[8]
            scenarioCodes[0] = DoubleMasturbateScenario
            scenarioCodes[1] = RevBlowjobScenario
            scenarioCodes[2] = RevHandjobScenario
            scenarioCodes[3] = RevFootjobScenario
            scenarioCodes[4] = RevBoobjobScenario
            scenarioCodes[5] = RevVaginalSexScenario
            scenarioCodes[6] = RevAnalSexScenario
			scenariocodes[7] = DrugScenario
        endif
		
		;push in lactating scenario if player is lactating
		if Masterscript.HasLactatingSpell(Playerref)
			scenarioCodes = papyrusutil.pushint(scenarioCodes, AskForMilkScenario)
		endif
		
		if enablebodyeffectsanddrugs == 1
			scenarioCodes = papyrusutil.pushint(scenarioCodes, DrugScenario)
		endif
		
        HandleScenarios(scenarioCodes, false)
    endif
EndFunction

Function HandleScenarios(int[] scenarioCodes, bool treatPlayerAsFemale)
    int RandIndex = Utility.RandomInt(0, scenarioCodes.Length - 1)
    int chosenScenario = scenarioCodes[RandIndex]

    if treatPlayerAsFemale
        SexLab.TreatasFemale(PlayerRef)
    endif

    string strmessage = ""
    bool Reversed = false

    if chosenScenario == ShowBoobsScenario
        strmessage = ActorName + " Wants to See Your Boobs!"
    elseif chosenScenario == DoubleMasturbateScenario
        strmessage = ActorName + " Wants to Masturbate Together!"
    elseif chosenScenario == BlowjobScenario
        strmessage = ActorName + " Wants you to give a blowjob!"
        Reversed = true
    elseif chosenScenario == HandjobScenario
        strmessage = ActorName + " Wants You Give a Handjob!"
        Reversed = true
    elseif chosenScenario == FootjobScenario
        strmessage = ActorName + " Wants You Give a Footjob!"
        Reversed = true
    elseif chosenScenario == BoobjobScenario
        strmessage = ActorName + " Wants You Give a Boobjob!"
        Reversed = true
    elseif chosenScenario == VaginalSexScenario
		Masterscript.PlayAnim(Actorref,31)
        strmessage = ActorName + " Wants to Fuck Your Pussy!"
    elseif chosenScenario == AnalSexScenario
		Masterscript.PlayAnim(Actorref,31)
        strmessage = ActorName + " Wants to Fuck Your Ass!"
    elseif chosenScenario == LesbianScenario
        strmessage = ActorName + " Wants to Feel Good Together!"
	elseif chosenScenario == GetRapedBadScenario
		Masterscript.PlayAnim(Actorref,31)
		strmessage = ActorName + " Wants to Rape You!"
	elseif ChosenScenario == AskForMilkScenario
		strmessage = ActorName + " Wants Your Milk!"
	elseif ChosenScenario == DrugScenario
		strmessage = ActorName + " Wants You To Drink Something!"
	elseif ChosenScenario == RevHandjobScenario
		strmessage = ActorName + " Wants To Give You a Handjob!"
	elseif ChosenScenario == RevFootjobScenario
		strmessage = ActorName + " Wants To Give You a Footjob!"
	elseif ChosenScenario == RevBoobjobScenario
		strmessage = ActorName + " Wants To Give You a Boobjob!"
	elseif ChosenScenario == RevVaginalSexScenario
		strmessage = ActorName + " Wants You to Fuck Her Pussy!"
	elseif ChosenScenario == RevAnalSexScenario
		strmessage = ActorName + " Wants You to Fuck Her Ass!"
    endif
	if chosenScenario > 50
		Announce(strmessage, "Hentairim/QuestionExclamationMark.dds")
	else
		Announce(strmessage, "Hentairim/QuestionMark.dds")
	Endif
	
    Utility.Wait(1)

    if chosenScenario > 50 ;50 scenario codes are all bad
		if chosenScenario == GetRapedBadScenario
			StartGetRapedBadScenario()
		endif
	elseif YesOrNo()
        PrintDebug("[HandleScenarios] Player accepted. Starting scenario: " + strmessage)
        if chosenScenario == ShowBoobsScenario
			SocialPlayYes(True)
            StartShowBoobsScenario()
        elseif chosenScenario == DoubleMasturbateScenario
			SocialPlayYes(True)
            StartDoubleMasturbateScenario()
        elseif chosenScenario == BlowjobScenario
			 SocialPlayYes(True)
             StartBlowJobScenario()
        elseif chosenScenario == HandjobScenario
			SocialPlayYes(True)
            StartHandjobScenario()
        elseif chosenScenario == FootjobScenario
			SocialPlayYes(True)
            StartFootjobScenario()
        elseif chosenScenario == BoobjobScenario
			SocialPlayYes(True)
            StartBoobjobScenario()
        elseif chosenScenario == VaginalSexScenario
			If MasterScript.IsBroken(Playerref)
				HornyPlayAcceptSexBroken(True)
			else
				HornyPlayAcceptSex(True)
			endif	
            StartVaginalSexScenario()
        elseif chosenScenario == AnalSexScenario
			If MasterScript.IsBroken(Playerref)
				HornyPlayAcceptSexBroken(True)
			else
				HornyPlayAcceptSex(True)
			endif	
            StartAnalSexScenario()
        elseif chosenScenario == LesbianScenario
			SocialPlayYes(True)
            StartLesbianScenario()
		elseif chosenScenario == AskForMilkScenario
			SocialPlayYes(True)
			StartAskForMilkScenario()
		elseif ChosenScenario == DrugScenario
			SocialPlayYes(True)
			StartDrugScenario()
		elseif ChosenScenario == RevHandjobScenario
			SocialPlayYes(True)
			StartHandjobScenario(true)
		elseif ChosenScenario == RevFootjobScenario
			SocialPlayYes(True)
			StartFootjobScenario(true)
		elseif ChosenScenario == RevBoobjobScenario
			SocialPlayYes(True)
			StartBoobjobScenario(true)
		elseif ChosenScenario == RevVaginalSexScenario
			SocialPlayYes(True)
			StartVaginalSexScenario(true)
		elseif ChosenScenario == RevAnalSexScenario
			SocialPlayYes(True)
			StartAnalSexScenario(true)
        endif
    else
		HornyPlayRejectSex(true)
        PrintDebug("[HandleScenarios] Player declined scenario: " + strmessage)
    endif
EndFunction

Bool Function YesorNo()
	PrintDebug("[YesorNo] Called. Preparing Yes/No selection menu.")

	Int Selected = -1
	b612_SelectList YesNoSelect = GetSelectList()
	String[] YesNoarr = StringUtil.Split("Yes;No", ";")
	PrintDebug("[YesorNo] Selection options prepared: Yes / No")

	Selected = YesNoSelect.Show(YesNoarr)
	PrintDebug("[YesorNo] Player made a choice. Selected index = " + Selected)

	if Selected >= 0 && Selected < YesNoarr.Length
		PrintDebug("[YesorNo] Choice string = " + YesNoarr[Selected])
	else
		PrintDebug("[YesorNo] WARNING: Invalid selection index = " + Selected + ". Defaulting to No.")
		Selected = 1
	endif

	if YesNoarr[Selected] == "Yes"
		PrintDebug("[YesorNo] Player chose YES. Returning True.")
		return True
	else
		PrintDebug("[YesorNo] Player chose NO. Playing refusal animation.")
		MasterScript.PlayAnim(PlayerRef, 8)
		Utility.Wait(3)
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		PrintDebug("[YesorNo] Refusal animation finished. Returning False.")
		return False
	endif
EndFunction


Function StartShowBoobsScenario()
	PrintDebug("[StartShowBoobsScenario] Starting scenario.")

	MasterScript.DisablePlayerControl()
	PrintDebug("[StartShowBoobsScenario] Player control disabled.")

	MasterScript.FaceActor(PlayerRef, ActorRef)
	MasterScript.FaceActor(ActorRef, PlayerRef)
	PrintDebug("[StartShowBoobsScenario] Both actors are now facing each other.")

	; Player Start Massaging Own Boobs
	MasterScript.PlayAnim(PlayerRef, 3)
	PrintDebug("[StartShowBoobsScenario] Player animation started (boob massage).")

	; NPC Start Fapping
	NPCThread = SexLab.StartSceneQuick(ActorRef)
	PrintDebug("[StartShowBoobsScenario] NPC Scene started. NPCThread = " + NPCThread)

	Float Counter = 0
	Bool MadeShowBoobSpeech = False
	int ExpressionCounter = 1
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		PrintDebug("[StartShowBoobsScenario] Loop iteration " + Counter + " running.")
		ExpressionsLookUp(PlayerRef , "Showboobs" + ExpressionCounter as String)
		ExpressionCounter += 1
		if ExpressionCounter > 5
			ExpressionCounter = 1
		endif
		MasterScript.PlayAnim(PlayerRef, 3)
		PrintDebug("[StartShowBoobsScenario] Player boob massage animation looped.")

		if !MadeShowBoobSpeech && GetVoiceVariation() == "B" && !IsMoanOnly() && Utility.RandomInt(1,100) <= 15
			PrintDebug("[StartShowBoobsScenario] Conditions met. Triggering ShowBoobs speech.")
			PlayShowBoobsSpeech()
			MadeShowBoobSpeech = True
		else
			PrintDebug("[StartShowBoobsScenario] Conditions not met. Triggering stimulated moan.")
			PlayStimulatedMoan()
		endif

		Counter = NPCThread.GetTimeTotal()
		Utility.Wait(1)
	endwhile

	PrintDebug("[StartShowBoobsScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * globalrewardsmultiplier)
		AddFaintEssence(FinalReward, " You Received " + FinalReward + " Faint Essence For letting " + ActorName + " Fap to your Boobs!")
		PrintDebug("[StartShowBoobsScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartShowBoobsScenario] Scenario ended prematurely. No rewards given.")
	endif

	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	PrintDebug("[StartShowBoobsScenario] Player reset to idle state.")

	MasterScript.RestorePlayerControl()
	PrintDebug("[StartShowBoobsScenario] Player control restored. Scenario complete.")
EndFunction

Function StartDoubleMasturbateScenario()
	PrintDebug("[StartDoubleMasturbateScenario] Starting scenario.")

	MasterScript.FaceActor(PlayerRef, ActorRef)
	MasterScript.FaceActor(ActorRef, PlayerRef)
	PrintDebug("[StartDoubleMasturbateScenario] Actors are now facing each other.")

	SexLab.StartSceneQuick(PlayerRef)
	PrintDebug("[StartDoubleMasturbateScenario] Player scene started.")

	NPCThread = SexLab.StartSceneQuick(ActorRef)
	PrintDebug("[StartDoubleMasturbateScenario] NPC scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartDoubleMasturbateScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	endwhile

	PrintDebug("[StartDoubleMasturbateScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * masturbationrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Fapping with " + ActorName + "!")
		PrintDebug("[StartDoubleMasturbateScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartDoubleMasturbateScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction


Function StartBlowJobScenario(Bool Reversed = false)
	PrintDebug("[StartBlowJobScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, asTags = Masterscript.GetTagsForSpecificPlay("blowjob"))
	else
		NPCThread = SexLab.StartSceneQuick(ActorRef, PlayerRef, asTags = Masterscript.GetTagsForSpecificPlay("blowjob"))
	endif
	
	PrintDebug("[StartBlowJobScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartBlowJobScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	endwhile
	PrintDebug("[StartBlowJobScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * oralrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Sucking Off " + ActorName + "!")
		PrintDebug("[StartBlowJobScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartBlowJobScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction


Function StartHandjobScenario(Bool Reversed = false)
	PrintDebug("[StartHandjobScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(ActorRef, PlayerRef, asTags = Masterscript.GetTagsForSpecificPlay("Handjob"))
	else
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, asTags = Masterscript.GetTagsForSpecificPlay("Handjob"))
	endif
	PrintDebug("[StartHandjobScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartHandjobScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	endwhile

	PrintDebug("[StartHandjobScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * handjobrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Giving " + ActorName + " HandJob!")
		PrintDebug("[StartHandjobScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartHandjobScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction


Function StartFootJobScenario(Bool Reversed = false)
	PrintDebug("[StartFootJobScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(ActorRef, PlayerRef, asTags = Masterscript.GetTagsForSpecificPlay("Footjob"))
	else
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, asTags = Masterscript.GetTagsForSpecificPlay("Footjob"))
	endif
	PrintDebug("[StartFootJobScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartFootJobScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	Endwhile

	PrintDebug("[StartFootJobScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * footjobrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Giving " + ActorName + " FootJob!")
		PrintDebug("[StartFootJobScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartFootJobScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction


Function StartBoobJobScenario(Bool Reversed = false)
	PrintDebug("[StartBoobJobScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(ActorRef,PlayerRef , asTags = Masterscript.GetTagsForSpecificPlay("Boobjob"))
	else
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, asTags = Masterscript.GetTagsForSpecificPlay("Boobjob"))
	endif
	PrintDebug("[StartBoobJobScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded
		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartBoobJobScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	Endwhile

	PrintDebug("[StartBoobJobScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * boobjobrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Giving " + ActorName + " BoobJob!")
		PrintDebug("[StartBoobJobScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartBoobJobScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction


Function StartVaginalSexScenario(Bool Reversed = false)
	PrintDebug("[StartVaginalSexScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(ActorRef,PlayerRef , asTags = Masterscript.GetTagsForSpecificPlay("Vaginal"))
	else
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, asTags = Masterscript.GetTagsForSpecificPlay("Vaginal"))
	endif
	
	PrintDebug("[StartVaginalSexScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded
		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartVaginalSexScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	Endwhile

	PrintDebug("[StartVaginalSexScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * vaginalrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Letting " + ActorName + " Fuck Your Pussy!")
		PrintDebug("[StartVaginalSexScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartVaginalSexScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction


Function StartAnalSexScenario(Bool Reversed = false)
	PrintDebug("[StartAnalSexScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(ActorRef, PlayerRef, asTags = Masterscript.GetTagsForSpecificPlay("Anal"))
	else
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, asTags = Masterscript.GetTagsForSpecificPlay("Anal"))
	endif
	PrintDebug("[StartAnalSexScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartAnalSexScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	Endwhile
	PrintDebug("[StartAnalSexScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * analrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Letting " + ActorName + " Fuck Your Ass!")
		PrintDebug("[StartAnalSexScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartAnalSexScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction

Function StartLesbianScenario(Bool Reversed = false)
	PrintDebug("[StartLesbianScenario] Starting scenario.")
	if Reversed
		NPCThread = SexLab.StartSceneQuick(ActorRef, PlayerRef)
	else
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef)
	endif
	PrintDebug("[StartLesbianScenario] Scene started. NPCThread = " + NPCThread)

	Float Counter = 0 
	while NPCThread.HasActor(ActorRef) && !SceneEnded

		Counter = NPCThread.GetTimeTotal()
		PrintDebug("[StartLesbianScenario] Loop iteration. Counter = " + Counter)
		Utility.Wait(1)
	Endwhile

	PrintDebug("[StartLesbianScenario] Loop ended. Final Counter = " + Counter)

	if Counter > 0
		int FinalReward = Math.Ceiling(Counter * masturbationrewardsmult * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Letting " + ActorName + " Fuck Your Ass!")
		PrintDebug("[StartLesbianScenario] Player rewarded with " + FinalReward + " Faint Essence.")
	else
		MasterScript.Announce("Scenario Stopped Prematurely, No Rewards")
		PrintDebug("[StartLesbianScenario] Scenario ended prematurely. No rewards given.")
	Endif
EndFunction

Function StartGetRapedBadScenario()
	PrintDebug("[StartGetRapedBadScenario] Starting scenario.")
	if !MasterScript.SLHHActivate(Playerref, actorref)
		NPCThread = SexLab.StartSceneQuick(PlayerRef, ActorRef, akSubmissive = Playerref, asTags = "Aggressive")
	else
		utility.wait(8)
		HornyPlayLetGoOfMe(true)
	Endif
endfunction

Function StartDrugScenario()
		MasterScript.FaceActor(PlayerRef, ActorRef)
		MasterScript.FaceActor(ActorRef, PlayerRef)	
		Actorref.playidle(IdleGive)
		utility.wait(2)
		MasterScript.DisablePlayerControl()
		PlayerRef.playidle(IdlePotionDrink)
		utility.wait(4)
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		
		bool PlayerisFemale = sexlab.getsex(playerref) == 1
		AddRandomDrug(Playerref , !PlayerisFemale)

		MasterScript.RestorePlayerControl()
		utility.wait(3)
		int FinalReward = Math.Ceiling(80 * globalrewardsmultiplier)
		AddFaintEssence(FinalReward , " You Received " + FinalReward + " Faint Essence For Becoming " + ActorName + "'s Guinea Pig!")
endfunction

Function StartAskForMilkScenario()
	PrintDebug("[StartAskForMilkScenario] Starting scenario.")
	Masterscript.unequipBoobCover(Playerref)
	MasterScript.DisablePlayerControl()
	PrintDebug("[StartAskForMilkScenario] Player control disabled.")

	MasterScript.FaceActor(PlayerRef, ActorRef)
	MasterScript.FaceActor(ActorRef, PlayerRef)
	PrintDebug("[StartAskForMilkScenario] Both actors are now facing each other.")

	; Player Start Massaging Own Boobs
	MasterScript.PlayAnim(PlayerRef, 3)
	PrintDebug("[StartAskForMilkScenario] Player animation started (Milking).")

	; NPC Start Applause
	Actorref.playidle(IdleApplause)
	PrintDebug("[StartAskForMilkScenario] NPC Applause")

	Bool MadeLactatingComments = False


	MasterScript.PlayAnim(PlayerRef, 3)

	PlayStimulatedMoan()
	Utility.Wait(1)
	Masterscript.OninusLactislactate(true)
	if !MadeLactatingComments && GetVoiceVariation() == "B" && !IsMoanOnly() && Utility.RandomInt(1,100) <= 15
		PrintDebug("[StartAskForMilkScenario] Conditions met. Triggering ShowBoobs speech.")
		PlayLactatingComments()
		MadeLactatingComments = True
	else
		PlayStimulatedMoan()
	endif
	Utility.Wait(1)
	PlayStimulatedMoan()

	int FinalReward = Math.Ceiling(50 * globalrewardsmultiplier)
	AddFaintEssence(FinalReward, " You Received " + FinalReward + " Faint Essence For letting " + ActorName + " Fap to your Boobs!")
	PrintDebug("[StartAskForMilkScenario] Player rewarded with " + FinalReward + " Faint Essence.")

	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	PrintDebug("[StartAskForMilkScenario] Player reset to idle state.")

	MasterScript.RestorePlayerControl()
	PrintDebug("[StartAskForMilkScenario] Player control restored. Scenario complete.")
EndFunction

Function PlayStimulatedMoan()
	PrintDebug("[PlayStimulatedMoan] Called.")

	if MasterScript.IsWearingGag(PlayerRef)
		PrintDebug("[PlayStimulatedMoan] Player is gagged. Playing gagged sound.")
		IVDTPlayGagged(True)
	else
		PrintDebug("[PlayStimulatedMoan] Player not gagged. Playing stimulated moan.")
		IVDTPlayStimulated(True)
	endif
EndFunction


Function PlayLactatingComments()
	PrintDebug("[PlayShowBoobsSpeech] Called.")
	
	if MasterScript.IsWearingGag(PlayerRef)
		PrintDebug("[PlayShowBoobsSpeech] Player is gagged. Playing gagged sound.")
		IVDTPlayGagged(True)
	else
		PrintDebug("[PlayShowBoobsSpeech] Player not gagged. Playing horny speech.")
		HornyPlayLactatingComments(True)
	endif
EndFunction

Function PlayShowBoobsSpeech()
	PrintDebug("[PlayShowBoobsSpeech] Called.")
	
	if MasterScript.IsWearingGag(PlayerRef)
		PrintDebug("[PlayShowBoobsSpeech] Player is gagged. Playing gagged sound.")
		IVDTPlayGagged(True)
	else
		PrintDebug("[PlayShowBoobsSpeech] Player not gagged. Playing horny speech.")
		HornyPlayShowBoobs(True)
	endif
EndFunction


Function SheathWeapon(Actor char)
if char.isweapondrawn()
	char.SheatheWeapon()
	utility.wait(2)
endif
Endfunction


