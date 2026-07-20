Scriptname IVDTControllerScript extends ReferenceAlias  

import b612
sslthreadcontroller threadcontroller
SexLabFramework Property SexLab Auto
IVDTMCMConfigurationScript Property ConfigOptions Auto
IVDTSoundsScript Property Sounds Auto
CreatureFrameworkUtility CFutil
Spell Property SceneTrackerSpell Auto
SoundCategory Property SexLabVoices Auto
SoundCategory Property IVDTVoices Auto
SoundCategory Property IVDTMCMAudio Auto
Race Property WerewolfRace Auto
Race Property VampireLordRace Auto
actor playerref 
Bool PlayerInScene = false
Int ivdtScenesCurrentlyRunning = 0
Int maleOnlyScenesCurrentlyRunning = 0
int enablehentairimstagecontrol
string blockorgasmstring
bool DirectorCanAdvanceStage = true
string currentSceneID
string currentStageID
Actor[] actorList
keyword TNG_Gentlewoman
bool PCisAggressor
Bool AllFemale
bool PCisReceiving
bool PCisVictim
int PCposition
;string PCPositionHentairimTags
;labels and interaction times
String Stimulationlabel
String PenisActionLabel
string OralLabel
string EndingLabel
string PenetrationLabel
float TotalSecondsFucked
Float LastLabelUpdateTime
Float LastPhysicsLabelTime ;mid-stage physics label changes; separate from the stage-change latch above
Bool GotFucked
Idle IdleAttention ;main idle to be used for Seduce to Replace with OAR
Faction AnimType
;Timers
float TimertoAdvance
float LastManualAdvancetime
Bool UpdateNow = false
Sound Buzzer
Sound Chime
Sound BadOutcome
Sound Bell
Sound Fanfare
Sound Notification
int ldi
int sst
int fst
int bst
int kis
int cun
int sbj
int fbj
int sap
int svp
int fap
int fvp
int sdp
int fdp
int scg
int sac
int fcg
int fac
int sdv
int sda
int fdv
int fda
int shj
int fhj
int stf
int ftf
int smf
int fmf
int sfj
int ffj
int eno
int eni
float updaterate = 0.5
;Modules Spells
Spell SFXSPELL
Spell ExpressionsSpell
Spell ResistanceSpell
;others
Faction schlongfaction
faction HentairimBroken
faction HentairimResistanceFaction
Faction AddCombatRape
SexLabThread CurrentThread
bool SceneExtend
int CurrentThreadid
string OriginalSceneID 
bool isPlayingForeplayScene

int[] PCInteractionTypes
Faction slaArousal
int[] PCPartnerInteractionTypes
int linearsceneenjoymentendstagetopup
int linearscenechanceforpctoorgasmasvictim

int enablelinearscenespontaneousorgasmduringnonintense
int enablelinearscenespontaneousorgasmduringintense
int linearscenespontaneousorgasmnpcmalearousalweight
int linearscenespontaneousorgasmnpcfemalearousalweight
int linearscenespontaneousorgasmnpcfutaarousalweight
int linearscenespontaneousorgasmnpccreaturearousalweight
int linearscenespontaneousorgasmpcarousalweight


int CurrentStageNum
Bool isAlmostFinalStage
Bool IsFinalStage

keyword zad_DeviousGag
Bool DoneLinearSceneOrgasm
;Called first time ever the mod is loaded
Spell HentairimNPCRequestSpell
Spell HentairimSeducedSpell 
Spell DoNotDisturbSpell 
Event OnInit()

	PerformInitialization()
	AddCombatRape()
	AddHentairimAdventures()
	HentairimNPCRequestSpell = Game.GetFormFromFile(0x85A, "Hentairim Director.esp") as Spell

EndEvent

;Called on subsequent reloads of the save
Event OnPlayerLoadGame()

	Maintenance()
EndEvent

Function Maintenance()

	PerformInitialization()
	UnmuteSexLabVoices()
	UpdateMasterVolume()
	;Other Parameters
	InitializeDIrectorConfigs()
	InitializeOninusLactis()

Endfunction

Function PerformInitialization()
	; Register globally whenever the script is first initialized
	RegisterForTheEventsWeNeed()
	WarnedSexLabScalingConflict = false ;re-warn about scaling conflict once per game session
	playerref = game.getplayer() ;player
	;lactating spell
	OninusLactisLactatingSpell = Game.GetFormFromFile(0x85C, "Hentairim Director.esp") as Spell
	HentairimResistanceFaction = Game.GetFormFromFile(0x803, "HentairimResistance.esp") as Faction
	;adventure sfx
	 Buzzer =  Game.GetFormFromFile(0x865, "Hentairim Director.esp") as Sound
	 Chime =  Game.GetFormFromFile(0x862, "Hentairim Director.esp") as Sound
	 BadOutcome =  Game.GetFormFromFile(0x863, "Hentairim Director.esp") as Sound
	 Bell =  Game.GetFormFromFile(0x864, "Hentairim Director.esp") as Sound
	 Fanfare =  Game.GetFormFromFile(0x866, "Hentairim Director.esp") as Sound
	 Notification =  Game.GetFormFromFile(0x869, "Hentairim Director.esp") as Sound
	 ;DND Spell
	DoNotDisturbSpell = Game.GetFormFromFile(0x824, "Hentairim Director.esp") as Spell
	
	if Game.GetModbyName("devious devices - assets.esm") != 255
		zad_DeviousGag =  Game.GetFormFromFile(0x7EB8, "devious devices - assets.esm") as Keyword
	endif
	;Hentairim Adventure
	AnimType = Game.GetFormFromFile(0x855, "Hentairim Director.esp") as Faction
	IdleAttention = Game.GetFormFromFile(0x6FF15, "Skyrim.esm") as idle
;Modules
if Game.GetModbyName("HentairimSFX.esp") != 255
	SFXSPELL = Game.GetFormFromFile(0x800, "HentairimSFX.esp") as Spell
endif
if Game.GetModbyName("HentairimExpressions.esp") != 255
	ExpressionsSpell = Game.GetFormFromFile(0x800, "HentairimExpressions.esp") as Spell	
endif

if Game.GetModbyName("HentairimResistance.esp") != 255
	ResistanceSpell = Game.GetFormFromFile(0x800, "HentairimResistance.esp") as Spell
endif	

;Others
if Game.GetModbyName("Schlongs of Skyrim.esp") != 255
	schlongfaction = Game.GetFormFromFile(0xAFF8 , "Schlongs of Skyrim.esp") as Faction
EndIf

if Game.GetModbyName("HentairimResistance.esp") != 255
	HentairimBroken = Game.GetFormFromFile(0x802, "HentairimResistance.esp") as Faction
endif

if !SFXSPELL && Game.GetModbyName("HentairimSFX.esp") != 255
	WritetoErrorlogs("Director", "SFX Spell is Missing! Make Sure the Mod is properly installed and Plugin Enabled")
endif

if !ExpressionsSpell && Game.GetModbyName("HentairimExpressions.esp") != 255
	WritetoErrorlogs("Director", "Expressions Spell is Missing! Make Sure the Mod is properly installed and Plugin Enabled")
endif

if !ResistanceSpell && Game.GetModbyName("HentairimResistance.esp") != 255
	WritetoErrorlogs("Director", "Resistance Spell is Missing! Make Sure the Mod is properly installed and Plugin Enabled")
endif

if isDependencyReady("TheNewGentleman.esp")
	TNG_Gentlewoman = Game.GetFormFromFile(0xFF8, "TheNewGentleman.esp") as Keyword
endif

if isDependencyReady("SexLabAroused.esm")
	slaArousal = Game.GetFormFromFile(0x3FC36, "SexLabAroused.esm") As Faction
Endif
EndFunction

Function RegisterForTheEventsWeNeed()
	miscutil.printconsole("Hentairim Director Registered For Events")

	RegisterForModEvent("AnimationStart", "DirectorSceneStart")
	RegisterForModEvent("SexLabOrgasmSeparate", "DirectorOnOrgasm")
	RegisterForModEvent("StageStart", "DirectorStageStart")
	;RegisterForModEvent("AnimationEnd", "DirectorSceneEnd")	

EndFunction

Event DirectorStageStart(string eventName, string argString, float argNum, form sender)
	printdebug("Director Stage Start Fired")
	if argString as Int == CurrentThread.GetThreadID()
	
		while CurrentThread.GetStatus() == 2
			utility.wait(0.1)
		endwhile
		
		actorlist = currentthread.Getpositions()
		ProcessedSpontaneousOrgasm = false ;enable spontaneous orgasm again
		;trigger update for creatureframework
		if currentSceneID != CurrentThread.GetActiveScene()
			IsStageOffset = false
			DoneLinearSceneOrgasm = false
			TriggerUpdateforCreatures()
			utility.wait(1.5)
		endif
		;scaling tracks its own scene id — OnUpdate may refresh currentSceneID before this event runs
		if enablehentairimscaling == 1 && LastScaledSceneID != CurrentThread.GetActiveScene()
			ResolveScaling()
		endif
	endif
EndEvent

int[] PositionsToAlign
int PositionSchlongtoMove
;Director reacts when a sexlab scene start
Event DirectorSceneStart(string eventName, string argString, float argNum, form sender)
	;Hentairim is for handling player scenes only. 
	
	printdebug("Sexlab Scene Detected")
	
	
	if PlayerInScene && !Sexlab.GetThreadByActor(PlayerRef)
		PlayerInScene = false
	endif
	
	if PlayerInScene || !Sexlab.GetThreadByActor(PlayerRef)
		printdebug("Sexlab Scene Does not Involve Player.Ignored")
		Return
	endIf
	UpdateNow = true
	
	
	;Initialize Configs
	isEnding = false
	PCInSex = true
	CustomScenePositionTags = ""
	CustomStageNum = 0
	CustomSceneTags = new string[1]
	CustomSceneTags = papyrusutil.RemoveString(CustomSceneTags , CustomSceneTags[0])
	TimertoAdvance = 0
	UpdateNow = false
	Timerdebt = 0
	StorageUtil.SetIntValue(None, "DirectorAdvanceStage", 0) ;default no directory signal to have processes be ready
	threadcontroller = sexlab.GetPlayerController()
	CurrentThread = Sexlab.GetThreadByActor(PlayerRef) ;CURRENT THREAD
	CurrentThreadID = CurrentThread.GetThreadID()
	CurrentSceneID = CurrentThread.GetActiveScene()
	CurrentStageID = CurrentThread.GetActiveStage()
	CurrentStageNum = GetLegacyStageNum(CurrentSceneID, CurrentStageID)
	isAlmostFinalStage = isAlmostFinalStage()
	IsFinalStage = IsFinalStage()
	LastLabelUpdateTime = CurrentThread.GetTimeTotal()
	LastPhysicsLabelTime = 0
	actorList = CurrentThread.GetPositions()
	PCPosition =  CurrentThread.GetPositionIdx(Playerref)
	if isLinearScene()
    PrintDebug("EnableOrgasm - Linear scene detected. Calling DisableOrgasmAll().")
    DisableOrgasmAll()
	elseif actorList.length > 1 && !CanActorSatisfyPCHugePPAddiction(actorList[1]) && !isLinearScene()
		PrintDebug("EnableOrgasm - Non-linear scene or HugePP addiction NOT satisfied. Disabling PC orgasm.")
		CurrentThread.DisableOrgasm(PlayerRef, true)
	else
		PrintDebug("EnableOrgasm - No orgasm restrictions applied in this branch.")
	endif
	setLinearSceneIVDTDoneOrgasmHype(false)
	PlayerInScene = true
	SceneExtend = false
	RunCustomScene = CheckifShouldRunCustomScene()
	if !RunCustomScene
		if StorageUtil.GetIntValue(None,"HentairimMustForeplayNext",0) == 1 || (utility.randomint(1,100) <= chancetostartforeplay && PCPosition == 0 && !currentthread.GetSubmissive(playerref) && (currentthread.HasSceneTag("Vaginal") || currentthread.HasSceneTag("Anal")))
			printdebug("Starting Foreplay")
			StartForeplayScene()
		endif
	endif
	UpdateLabelsArr(CurrentSceneID , CurrentStageNum )
	;initialize variables
	IVDTCanAdvance = true ;default IVDT ready to advance
	SFXCanAdvance = true ;default sfx ready to advance
	PCisAggressor = PCisAggressor()
	AllFemale = AllFemale()
	PCisReceiving = playerref == actorList[0]
	PCisVictim = PCisVictim()
	if actorlist.length > 1
		AdjustingSchlongActor = actorlist[1]
	else
		AdjustingSchlongActor = actorlist[0]
	endif

	PositionsToAlign = papyrusutil.pushint(PositionsToAlign,0)
	
	while CurrentThread.GetStatus() == 2
		utility.wait(0.1)
	endwhile
	
	AddtoTimer(GetTimer()) ;calculate starting timer to advance
	AddTrackerToSceneIfApplicable(argString)
	printdebug("Run Custom Scene : " + RunCustomScene)
	printdebug("CurrentThread :" + CurrentThread)
	printdebug("CurrentSceneID :" + CurrentSceneID)
	printdebug("CurrentStageID :" + CurrentStageID)
	printdebug("actorList :" + actorList)
	printdebug("Scene start")
	UpdateNow = false
	RegisterForSingleUpdate(0.1)
EndEvent

Event DirectorOnOrgasm(Form actorRef, Int thread)
	
endevent


Function DirectorEndScene()
	;wait for IVDT to finish cycle
	currentthread.Stopanimation()
	if enablearmorswap == 1
		RestoreArmor(playerref)
	endif
	
	;restore scales whenever we actually changed them, even if the toggle was turned off mid-scene
	if actorlistOriginalScalearr.Length > 0
		ResetScaling()
	endif
	if resetsexassignment == 1
		RevertAllActorsSex()
	endif
	ResetAnimationSpeed()
	isEnding = true
	PCInSex = false
	LastLabelUpdateTime = 0
	LastPhysicsLabelTime = 0
	StorageUtil.SetIntValue(None, "DirectorAdvanceStage", 0)
	
	;unset Hentairim Director Custom Scene Variable
	StorageUtil.SetStringValue(None, "DirectorCustomScene", "")
	CurrentThread = none
	CurrentSceneID = none
	CurrentStageID = none
	LastScaledSceneID = ""
	ProcessedOriginalScale = false
	PlayerInScene = false
	LastManualAdvancetime = 0 
	OriginalSceneID = ""
	Startlinearsceneorgasm = false

	VictimPCCanOrgasm = true
	isPlayingForeplayScene = false
	DoneLinearSceneOrgasm = false
	StorageUtil.unsetIntValue(None,"HentairimMustForeplayNext")
	PositionsToAlign = new int[1]
	PositionsToAlign = papyrusutil.RemoveInt(PositionsToAlign , PositionsToAlign[0])
	PositionSchlongtoMove = 1
	EnableOrgasmAll()
	storageutil.setfloatvalue(none,"HentairimTimerModifier",1.0)
	storageutil.Setintvalue(none,"HentairimNextUseLinearScene",0)
	updaterate = 0.5
	
	if EnableExpressions == 1
		utility.wait(3)
		resetexpressions()
	endif
	
	printdebug("Hentairim Director Scene END")
	
endfunction 

Bool IsEnding

Bool Function AnimationisEnding()
	return isEnding
EndFunction

;Event DirectorSceneEnd(string eventName, string argString, float argNum, form sender)
;	miscutil.printconsole("DirectorSceneEnd START eventName : " + eventName + " argString : " + argString + " argNum : " + argNum)
;	printdebug("eventName :" + eventName + " argString : " + argString + " argNum : " + argNum)
;EndEvent
bool completedResolvingHornyDebt
bool Startlinearsceneorgasm

bool function IsInLinearSceneOrgasm()
	return Startlinearsceneorgasm
endfunction

Float Function TimertoAdvance()
	return TimertoAdvance
endfunction

Event OnUpdate()


	if	!Sexlab.GetThreadByActor(PlayerRef) ;CURRENT THREAD ;threadstatus == 4 || threadstatus == 0
		printdebug("-------------End Scene-------------------.")
		DirectorEndScene()
		return
	endif
	
	printdebug("---Updating---")
	;check whether to advance Stage
	printdebug("TimertoAdvance : " + TimertoAdvance)
	printdebug("Thread Total Time : " + CurrentThread.GetTimeTotal())
	;check for key being held down
	if Input.IsKeyPressed(directortoolskey)
	printdebug("Director Tools key held.")
	OpenDirectorTools()

	elseif Input.IsKeyPressed(adjustsidewayskey)
		while Input.IsKeyPressed(adjustsidewayskey)
			printdebug("Adjust Sideways key pressed.")
			if Input.IsKeyPressed(modifierkey)
				printdebug("Modifier key held. Adjusting sideways Reverse Direction.")
				AdjustAlignment(0 , true)
			else
				printdebug("Modifier key not held. Adjusting sideways normally.")
				AdjustAlignment(0 , false)
			endif
			utility.wait(0.3)
		EndWhile
	elseif Input.IsKeyPressed(adjustupdownkey)
		while Input.IsKeyPressed(adjustupdownkey)
			printdebug("Adjust Up/Down key pressed.")
			if Input.IsKeyPressed(modifierkey)
				printdebug("Modifier key held. Adjusting up/down Reverse Direction.")
				AdjustAlignment(2 , true)
			else
				printdebug("Modifier key not held. Adjusting up/down normally.")
				AdjustAlignment(2 , false)
			endif
			utility.wait(0.3)
		EndWhile
	elseif Input.IsKeyPressed(adjustschlongkey)
		while Input.IsKeyPressed(adjustschlongkey)
			printdebug("Adjust Schlong key pressed.")
			if Input.IsKeyPressed(modifierkey)
				printdebug("Modifier key held. Adjusting Schlong Reverse Direction.")
				AdjustSchlongDirection(true)
			else
				printdebug("Modifier key not held. Adjusting Schlong  normally.")
				AdjustSchlongDirection(false)
			endif
			utility.wait(0.3)
		EndWhile
	elseif Input.IsKeyPressed(adjustforwardkey)
		printdebug("Adjust Forward/Back key pressed.")
		While Input.IsKeyPressed(adjustforwardkey)
			if Input.IsKeyPressed(modifierkey)
				printdebug("Modifier key held. Adjusting forward/back with fine control.")
				AdjustAlignment(1 , true)
			else
				printdebug("Modifier key not held. Adjusting forward/back normally.")
				AdjustAlignment(1 , false)
			endif
			utility.wait(0.3)
		EndWhile
	elseif Input.IsKeyPressed(adjustrotationkey)
		printdebug("Adjust Rotation key pressed.")
		While Input.IsKeyPressed(adjustrotationkey)
			if Input.IsKeyPressed(modifierkey)
				printdebug("Modifier key held. Adjusting rotation with fine control.")
				AdjustAlignment(3 , true)
			else
				printdebug("Modifier key not held. Adjusting rotation normally.")
				AdjustAlignment(3 , false)
			endif
			utility.wait(0.3)
		EndWhile
	elseif Input.IsKeyPressed(advancekey)
		printdebug("Advance key pressed.")
		if CurrentThread.GetTimeTotal() > LastManualAdvancetime + 3
			AdvancetoNextStage()
			AddtoTimer(GetTimer())
			LastManualAdvancetime = CurrentThread.GetTimeTotal()
		else
			printdebug("Advance key pressed too soon. Ignoring.")
		endif
	endif
	
	printdebug("DoneLinearSceneOrgasm : " + DoneLinearSceneOrgasm)
	printdebug("Isfinalstage() : " + Isfinalstage())
	printdebug("isLinearScene() : " + isLinearScene())
	printdebug("isPlayingForeplayScene : " + isPlayingForeplayScene)

	;Handle Spontaneous orgasm
	if !ProcessedSpontaneousOrgasm && isLinearScene() && CurrentThread.GetTimeTotal() - TimertoAdvance <= Utility.randomint(3,10) && CurrentStageNum > 1 && !(isAlmostFinalStage && OrgasmBeforeLastStage())
		ProcessSpontaneousOrgasm()	
	endif

	;handle final or pre final stage orgasm for linear scene
	printdebug("LinearSceneIVDTDoneOrgasmHype : " + LinearSceneIVDTDoneOrgasmHype)
	printdebug("DoneLinearSceneOrgasm : " + DoneLinearSceneOrgasm)
	if LinearSceneStageShouldOrgasm() && !DoneLinearSceneOrgasm
		Startlinearsceneorgasm = true
		if isAlmostFinalStage && OrgasmBeforeLastStage()
			printdebug("PreFinal Orgasm | AlmostFinal=" + isAlmostFinalStage + ", OrgasmBeforeLast=" + OrgasmBeforeLastStage() + ", StageTimesUp=" + StageTimesUp())
			LinearEndStageForceOrgasm()
			DoneLinearSceneOrgasm = true
		elseif !OrgasmBeforeLastStage() && Isfinalstage
			printdebug("Final Orgasm | Final=" + Isfinalstage + ", Linear=" + isLinearScene() + ", OrgasmBeforeLast=" + OrgasmBeforeLastStage())
			LinearEndStageForceOrgasm()
			DoneLinearSceneOrgasm = true
		endif
		Startlinearsceneorgasm = false
	endif

	;======Extended Scene===========
	if storageutil.getintvalue(None,"HentairimExtendScene",0) == 1 && canAdvance()
		printdebug("HentairimExtendScene is active.")

		AdvancetoNextStage()
		
		AddtoTimer(GetTimer())
		printdebug("Timer updated.")
		
		;extend once
		if isFinalStage
			printdebug("end extend scene.")
			storageutil.Setintvalue(None,"HentairimExtendScene",0)
			DirectorEndScene()
			return
		endif
	else ;=========NORMAL SCENE===========
		if CanAdvance()
			printdebug("CanAdvance = true. Advancing stage now.")

			
			;check to see if can extendstage
			bool result
			if isFinalStage
				printdebug("is final stage.")
				if isPlayingForeplayScene
					printdebug("is foreplay scene. reset scene to original penetration scene.")
					DoneLinearSceneOrgasm = false
					isPlayingForeplayScene = false
					currentthread.ResetScene(OriginalSceneID) ;Go back to original intended scene that was skipped
				else ;check if can extend scene
					;check if can counter rape
					printdebug("check if can counter rape")
					result = CounterRape()
					printdebug("counter rape result : " + result)
					;check if can extend scene
					if !result
						printdebug("check if can extend")
						result = ExtendScene()
						printdebug("ExtendScene result : " + ExtendScene())
					endif
					;advance to next stage. usually its end animation
					if !result
						printdebug("Cannot Extend or Counter Rape")
						DirectorEndScene()

						return
						;AdvancetoNextStage()
					endif
				endif
			else
				printdebug("Not Final Stage. Advance")
				AdvancetoNextStage()
			endif
			printdebug("Calling AddtoTimer with value: " + GetTimer())
			AddtoTimer(GetTimer())
			StorageUtil.SetIntValue(None, "DirectorAdvanceStage", 0)
			UpdateNow = true
			printdebug("UpdateNow set to true. Stage advance complete.")

		elseif DirectorCanAdvanceStage && enableautoadvancestage == 1 && StageTimesUp() &&  (!LinearSceneStageShouldOrgasm() || (LinearSceneStageShouldOrgasm() && DoneLinearSceneOrgasm))
			printdebug("Timer passed but waiting on other processes. Checking DirectorAdvanceStage.")

			if StorageUtil.GetIntValue(None, "DirectorAdvanceStage") == 0
				StorageUtil.SetIntValue(None, "DirectorAdvanceStage", 1)
				printdebug("DirectorAdvanceStage was 0. Set to 1.")
			else
				printdebug("DirectorAdvanceStage already set. No change.")
			endif
		endif
	endif	

	;=== Scene or Stage update check ===
	if UpdateNow || currentSceneID != CurrentThread.GetActiveScene() || CurrentStageID != CurrentThread.GetActiveStage()
		printdebug("Updating labels: Scene or Stage changed.")
		currentSceneID = CurrentThread.GetActiveScene()
		CurrentStageID = CurrentThread.GetActiveStage()
		CurrentStageNum = GetLegacyStageNum(CurrentSceneID, CurrentStageID)
		isAlmostFinalStage = isAlmostFinalStage()
		IsFinalStage = IsFinalStage()
		updatelabelsarr(CurrentSceneID, GetLegacyStageNum(CurrentSceneID, CurrentStageID))
		LoadStageSpeed() ;load saved speed
		LoadSchlongAdjustment() ;load saved schlong adjustments
		;scene-change rescaling is handled in DirectorStageStart via LastScaledSceneID

		LastLabelUpdateTime = CurrentThread.GetTimeTotal()
		UpdateNow = false

		if resetsmp == 1
			printdebug("SMP reset triggered.")
			consoleutil.executecommand("SMP Reset")
		endif
	elseif usephysicslabels == 1 && CurrentThread.GetStatus() == 3 && CurrentThread.IsInteractionRegistered()
		;contacts and thrust speed change mid-stage - refresh labels from physics and
		;signal opted-in consumers through the physics-time bump; the stage latch
		;(LastLabelUpdateTime) must only move on real stage changes
		if ApplyPhysicsLabels()
			LastPhysicsLabelTime = CurrentThread.GetTimeTotal()
		endif
	endif

	;=== Continue Scene or End ===
	
	RegisterForSingleUpdate(updaterate)		
	
endEvent

bool function isUpdating()
	return updatenow
endfunction

float function GetDirectorLastLabelTime()
	return LastLabelUpdateTime
endfunction

float function GetDirectorLastPhysicsLabelTime()
	return LastPhysicsLabelTime
endfunction
Function AddTrackerToSceneIfApplicable(string argString)
	
	;Hentairim Director running

	;------------Start Applying Effects to Actors in Thread------------------------		
	RunThreadControl()
	
	;---------------Applying IVDT Spell to Player-------------------
	if playerref.HasSpell(SceneTrackerSpell) ;Scene with female voice actor
		playerref.RemoveSpell(SceneTrackerSpell)
	endif	
	if EnableIVDT == 1
		printdebug("playerref added Hentairim ivdt Spell")
		sslVoiceSlots.DeleteVoice(playerref)
		sslVoiceSlots.StoreVoice(playerref,"")
		threadcontroller.ActorAlias[pcposition].SetActorVoice("",true)
		playerref.AddSpell(SceneTrackerSpell, abVerbose = False) ;Scene with female voice actor
	endif
	;-------------Applying SFX Spell to non position 1 actors----------------
	
	
	if enablesfx == 1
		int z = 0
		while z < actorList.length
			if actorList[z].HasSpell(SFXSPELL) 
				actorList[z].RemoveSpell(SFXSPELL)
			endif
			
			printdebug(actorList[z].getdisplayname() + " added SFX Spell")
			actorList[z].AddSpell(SFXSPELL, abVerbose = False)
		z += 1
		EndWhile
	endif
	
	;---------------Applying Expressions Spell to Actors------------------
	if EnableExpressions == 1

		int z = 0
		while z < actorList.length
			if sexlab.GetGender(actorList[z]) <= 1 ;not creature
				if actorList[z].HasSpell(ExpressionsSpell) 
					actorList[z].RemoveSpell(ExpressionsSpell)
				endif
				if actorList[z] == playerref && enablepcexpression == 1
					printdebug(actorList[z].getdisplayname() + " added Expression Spell")
					actorList[z].AddSpell(ExpressionsSpell, abVerbose = False)
				elseif sexlab.GetGender(actorList[z]) == 0 && enablemalenpcexpression == 1
					printdebug(actorList[z].getdisplayname() + " added Expression Spell")
					actorList[z].AddSpell(ExpressionsSpell, abVerbose = False)
				elseif sexlab.GetGender(actorList[z]) == 1 && enablefemalenpcexpression == 1
					printdebug(actorList[z].getdisplayname() + " added Expression Spell")
					actorList[z].AddSpell(ExpressionsSpell, abVerbose = False)
				endif
			endif
		z += 1
		EndWhile
	EndIf
	
	;---------------Applying Resistance Spell to Actors------------------

	enablepcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablepcresistancedamage" ,0)
	enablemalenpcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablemalenpcresistancedamage" ,0)
	enablefemalenpcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablefemalenpcresistancedamage" ,0)
	enablecreaturenpcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablecreaturenpcresistancedamage" ,0)
	if enableResistance == 1

		int z = 0
		while z < actorList.length
			if sexlab.GetGender(actorList[z]) <= 1 ;not creature
				if actorList[z].HasSpell(ResistanceSpell) 
					actorList[z].RemoveSpell(ResistanceSpell)
				endif
				if actorList[z] == playerref && enablepcresistancedamage == 1
					printdebug(actorList[z].getdisplayname() + " added Resistance Spell")
					actorList[z].AddSpell(ResistanceSpell, abVerbose = False)
				elseif sexlab.GetGender(actorList[z]) == 0 && enablemalenpcresistancedamage == 1
					printdebug(actorList[z].getdisplayname() + " added Resistance Spell")
					actorList[z].AddSpell(ResistanceSpell, abVerbose = False)
				elseif sexlab.GetGender(actorList[z]) == 1 && enablefemalenpcresistancedamage == 1
					printdebug(actorList[z].getdisplayname() + " added Resistance Spell")
					actorList[z].AddSpell(ResistanceSpell, abVerbose = False)
				elseif sexlab.GetGender(actorList[z]) > 1 && enablecreaturenpcresistancedamage == 1
					printdebug(actorList[z].getdisplayname() + " added Resistance Spell")
					actorList[z].AddSpell(ResistanceSpell, abVerbose = False)
				endif
			endif
		z += 1
		EndWhile
		
	endif
EndFunction

Function RegisterThatSceneIsEnding(Bool maleOnlyScene)
	;ivdtScenesCurrentlyRunning -= 1
	
	;If maleOnlyScene
	;	maleOnlyScenesCurrentlyRunning -= 1
	;EndIf
	
	;If ivdtScenesCurrentlyRunning <= 0
	;	SexLabVoices.UnMute()
	;EndIf
EndFunction

Function PlaySound(String theSound, Actor actorMakingSound, Bool waitForCompletion = True, String group = "", String channel = "")
	;theSound is a AudioUtil category name; slot is resolved from the actor by the DLL
	AudioUtil.Play(theSound, actorMakingSound, waitForCompletion, 1.0, group, channel)
EndFunction

bool function IsMale(actor char)
	return sexlab.GetGender((char)) == 0
endfunction

String Function GetNameOfVoiceType(Actor actorWithVoice)
	Race actorRace = actorWithVoice.GetRace()
	
	If actorRace == WerewolfRace ;Transformable creatures must have their voice type hardcoded, otherwise they would use their non-creature voice type
		If IsMale(actorWithVoice)
			Return "MaleWerewolf"
		Else
			Return "FemaleWerewolf"
		EndIf
	
	ElseIf actorRace == VampireLordRace
		If IsMale(actorWithVoice)
			Return "MaleVampireLord"
		Else
			Return "FemaleVampireLord"
		EndIf		
	Else 
		VoiceType voiceTypeToGetNameOf = actorWithVoice.GetLeveledActorBase().GetVoiceType()
		String voiceTypeAsString = voiceTypeToGetNameOf as String 
		Int startingIndex = StringUtil.Find(voiceTypeAsString, "<") + 1
		Int endingIndex = StringUtil.Find(voiceTypeAsString, " (")

		Return StringUtil.Substring(voiceTypeAsString, startingIndex, endingIndex - startingIndex) 
	EndIf
EndFunction



IVDTVoiceFemaleScript Function GetVoiceForActress(Actor actressToVoice)
	IVDTVoiceFemaleScript herVoice = GetOwningQuest().GetAliasByName("Slot" + 1) as IVDTVoiceFemaleScript
	if herVoice
		herVoice.VoiceSlot = "F1"
	endif
	return herVoice
EndFunction

IVDTVoiceMaleScript Function GetVoiceForActor(Actor actorToVoice)
	IVDTVoiceMaleScript hisVoiceSlot = None
	string actorName = actorToVoice.GetLeveledActorBase().GetName()
	string actorVoiceType = GetNameOfVoiceType(actorToVoice)
	
	;Run through all voice slots and check if any have a matching actor or voice type
	;Int currentSlot = 1
	;Int maleVoiceSlots = ConfigOptions.MaleVoiceSlots
	String temp = ""
	int EnableReassigningMaleVoice

	EnableReassigningMaleVoice = JsonUtil.GetIntValue("IVDTHentai/Config.json","enablereassigningmalevoice",0) 
	
	;	printdebug ("Male actorVoiceType  : "+ actorVoiceType )
;Slot M1 = MaleEvenTone
;Slot M2 = MaleArgonian
;Slot M3 = MaleBrute
;Slot M4 = MaleNord
;Slot M5 = MaleCondescending
;Slot M6 = MaleDarkElf
;Slot M7 = MaleKhajitt
;Slot M8 = MaleOrc
	;reassign unused slots

;HENTAIRIM hard assign voice	

if EnableReassigningMaleVoice == 1	
	if  actorVoiceType ==  "malecommander" || actorVoiceType ==  "malesoldier" 
		actorVoiceType = "malebrute"
	elseif actorVoiceType ==  "malecommoner" || actorVoiceType ==  "malecommoneraccented" || actorVoiceType ==  "maleeventonedaccented"|| actorVoiceType ==  "maleyoungeager"
		 actorVoiceType = "maleeventoned"
	elseif actorVoiceType ==  "maleelfhaughty"
		 actorVoiceType = "malecondescending"
	elseif actorVoiceType ==  "maleguard" || actorVoiceType ==  "malenordcommander"
		 actorVoiceType = "malenord"
;	elseif actorVoiceType ==  "maleslycynical"
;		 actorVoiceType = "maledarkelf"
	endif
endif	


;NOTE: playback slot selection now lives in AudioUtil.toml ([voicetype_map] /
;[voicetype_remap] / [npc_overrides]) — the DLL resolves the folder from the actor at
;play time. This alias lookup only remains for script-side state (mainMaleVoice etc.).
int slotNumber = 0
if actorVoiceType == "MaleEvenToned"
	slotNumber = 1
elseif actorVoiceType == "MaleArgonian"
	slotNumber = 2
elseif actorVoiceType == "MaleBrute"
	slotNumber = 3
elseif actorVoiceType == "MaleNord"
	slotNumber = 4
elseif actorVoiceType == "MaleCondescending"
	slotNumber = 5
elseif actorVoiceType == "MaleDarkElf"
	slotNumber = 6
elseif actorVoiceType == "MaleKhajitt"
	slotNumber = 7
elseif actorVoiceType == "MaleOrc"
	slotNumber = 8
endif

if slotNumber > 0
	hisVoiceSlot = GetOwningQuest().GetAliasByName("Slot" + slotNumber) as IVDTVoiceMaleScript
	if hisVoiceSlot
		hisVoiceSlot.VoiceSlot = "M" + slotNumber
	endif
else
	hisVoiceSlot = none
endif

	Return hisVoiceSlot
EndFunction


IVDTVoiceMaleScript Function GetDefaultMaleVoice(Actor actorToVoice)

	Return GetOwningQuest().GetAliasByName("Slot" + 1) as IVDTVoiceMaleScript
EndFunction



IVDTVoiceFemaleScript Function GetFemaleVoiceAtSlot(Int slot)
	Return GetOwningQuest().GetAliasByName("Slot" + slot) as IVDTVoiceFemaleScript
EndFunction

IVDTVoiceMaleScript Function GetMaleVoiceAtSlot(Int slot)
	Return GetOwningQuest().GetAliasByName("Slot" + slot) as IVDTVoiceMaleScript
EndFunction


;SFX Config.json
String SFXConfigFile  = "HentairimSFX/Config.json"
int EnableSFX

;Expressions Config.json
String ExpressionConfigFile  = "HentairimExpressions/Config.json"
int enableExpressions
int enablepcexpression
int enablefemalenpcexpression
int enablemalenpcexpression

;IVDT Config.json
String IVDTConfigFile  = "IVDTHentai/Config.json"
int enableIVDT

;Director Config.json
String ControlConfigFile  = "HentairimDirector/Config.json"
string StageMakerFile = "HentairimDirector/StageMaker.json"
string StageMakerJSONFolder = "HentairimDirector/StageMakerJSON/"

int directortoolskey
int uselinearscene
int linearsceneorgasmbeforelaststage
int givingforeplayinlinearscenedontorgasm
int modifierkey
int adjustforwardkey
int adjustsidewayskey
int adjustupdownkey
int adjustschlongkey
int adjustrotationkey
int advancekey
int enablehentairimscaling
int enablearmorswap
int enableautoadvancestage
int ResetSMP
int resetsexassignment
int chancetostartforeplay
int foreplayhandjobweight
int foreplaytitfuckweight
int foreplayfootjobweight
int foreplayblowjobweight
int enableprintdebug

int enablestagemaker
int chancetousecustomstage
int usephysicslabels
float physicsfastvelocity
float physicsslowfactor
;Hentairim combatrape.json
String CombatRapeConfigFile  = "HentairimDirector/CombatRape.json"

;ArmorSwapping config.json
string ArmorSwappingFile =  "HentairimDirector/ArmorSwapping.json"

;Stage Timers
string TimerConfigFile =  "HentairimDirector/Timers.json"

;Resistance
string ResistanceConfigFile  =  "HentairimResistance/Config.json"
int enableResistance
int enablepcresistancedamage
int enablemalenpcresistancedamage
int enablefemalenpcresistancedamage
int enablecreaturenpcresistancedamage

;Traits
string TraitsFile = "HentairimDirector/HentairimTrait.json"
String[] linearscenefinalstageorgasmfactor
String[] linearsceneextendstagechance
String[] linearscenecounterrapechance

int daystorerolltrait
int extrahornyextendscenechance
int strongnpccounterfuckchance
int cumalotnpcorgasmsecondtimechance
int cumalotnpcorgasmthirdtimechance

Function InitializeDirectorConfigs()

	;Start BY Validation files and post msg box if there are issues
	
	ValidateJsonFile("Hentairim Director config", ControlConfigFile)
	ValidateJsonFile("Hentairim Combat Rape", CombatRapeConfigFile)
	ValidateJsonFIle("Hentairim SFX config" , SFXConfigFile)
	ValidateJsonFIle("Hentairim Expressions config" , ExpressionConfigFile)
	ValidateJsonFIle("Hentairim Armor Swapping config" , ArmorSwappingFile)
	ValidateJsonFIle("Hentairim Timers config" , TimerConfigFile)
	ValidateJsonFIle("Hentairim IVDT config" , IVDTConfigFile)
	ValidateJsonFIle("Hentairim Stage Maker" , StageMakerFile)
	ValidateJsonFIle("Hentairim Resistance config" , ResistanceConfigFile)
	ValidateJsonFIle("Hentairim Resistance RaceBaseResistance" , "HentairimResistance/RaceBaseResistance.json")
	ValidateJsonFIle("Hentairim Resistance RaceFuckingPCEnjoymentModifier" , "HentairimResistance/RaceFuckingPCResistanceModifier.json")
	ValidateJsonFile("Hentairim Adventure Config", "HentairimAdventure/Config.json")
	ValidateJsonFile("Hentairim Adventure Essence Difficulty Config", "HentairimAdventure/EssenceDifficulty.json")
	ValidateJsonFile("Hentairim Adventure Gacha Config", "HentairimAdventure/GachaConfig.json")
	ValidateJsonFile("Hentairim Adventure OninusLactis Config", "HentairimAdventure/OninusLactis.json")
	ValidateJsonFile("Hentairim Adventure Arousal StringAsset", "HentairimAdventure/StringAssets/Arousal.json")
	ValidateJsonFile("Hentairim Adventure BrokenPlayer StringAsset", "HentairimAdventure/StringAssets/BrokenPlayer.json")
	ValidateJsonFile("Hentairim Adventure BrokenPlayerLookingatCock StringAsset", "HentairimAdventure/StringAssets/BrokenPlayerLookingatCock.json")
	ValidateJsonFile("Hentairim Adventure Drug", "HentairimAdventure/BodyEffectsAndDrugs.json")
	ValidateJsonFile("Hentairim Adventure PlayerArousal StringAsset", "HentairimAdventure/StringAssets/PlayerArousal.json")
	;load SFX config
	EnableSFX = JsonUtil.GetIntValue(SFXConfigFile, "enablesfx" ,0)
	
	;load Expressions config
	enableExpressions = JsonUtil.GetIntValue(ExpressionConfigFile, "enableexpressions" ,0)
	enablepcexpression = JsonUtil.GetIntValue(ExpressionConfigFile, "enablepc" ,0)
	enablefemalenpcexpression = JsonUtil.GetIntValue(ExpressionConfigFile, "enablefemalenpc" ,0)
	enablemalenpcexpression = JsonUtil.GetIntValue(ExpressionConfigFile, "enablemalenpc" ,0)
	
	;load resistance config
	enableResistance = JsonUtil.GetIntValue(ResistanceConfigFile, "enableaggressionresistance" ,0)
	enablepcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablepcresistancedamage" ,0)
	enablemalenpcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablemalenpcresistancedamage" ,0)
	enablefemalenpcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablefemalenpcresistancedamage" ,0)
	enablecreaturenpcresistancedamage = JsonUtil.GetIntValue(ResistanceConfigFile, "enablecreaturenpcresistancedamage" ,0)
	
	;Load Timers config
	ldi = JsonUtil.GetIntValue(TimerConfigFile,"ldi",9999)
	sst = JsonUtil.GetIntValue(TimerConfigFile,"sst",9999)
	fst = JsonUtil.GetIntValue(TimerConfigFile,"fst",9999)
	bst = JsonUtil.GetIntValue(TimerConfigFile,"bst",9999)
	kis = JsonUtil.GetIntValue(TimerConfigFile,"kis",9999)
	cun = JsonUtil.GetIntValue(TimerConfigFile,"cun",9999)
	sbj = JsonUtil.GetIntValue(TimerConfigFile,"sbj",9999)
	fbj = JsonUtil.GetIntValue(TimerConfigFile,"fbj",9999)
	sap = JsonUtil.GetIntValue(TimerConfigFile,"sap",9999)
	svp = JsonUtil.GetIntValue(TimerConfigFile,"svp",9999)
	fap = JsonUtil.GetIntValue(TimerConfigFile,"fap",9999)
	fvp = JsonUtil.GetIntValue(TimerConfigFile,"fvp",9999)
	sdp = JsonUtil.GetIntValue(TimerConfigFile,"sdp",9999)
	fdp = JsonUtil.GetIntValue(TimerConfigFile,"fdp",9999)
	scg = JsonUtil.GetIntValue(TimerConfigFile,"scg",9999)
	sac = JsonUtil.GetIntValue(TimerConfigFile,"sac",9999)
	fcg = JsonUtil.GetIntValue(TimerConfigFile,"fcg",9999)
	fac = JsonUtil.GetIntValue(TimerConfigFile,"fac",9999)
	sdv = JsonUtil.GetIntValue(TimerConfigFile,"sdv",9999)
	sda = JsonUtil.GetIntValue(TimerConfigFile,"sda",9999)
	fdv = JsonUtil.GetIntValue(TimerConfigFile,"fdv",9999)
	fda = JsonUtil.GetIntValue(TimerConfigFile,"fda",9999)
	shj = JsonUtil.GetIntValue(TimerConfigFile,"shj",9999)
	fhj = JsonUtil.GetIntValue(TimerConfigFile,"fhj",9999)
	stf = JsonUtil.GetIntValue(TimerConfigFile,"stf",9999)
	ftf = JsonUtil.GetIntValue(TimerConfigFile,"ftf",9999)
	smf = JsonUtil.GetIntValue(TimerConfigFile,"smf",9999)
	fmf = JsonUtil.GetIntValue(TimerConfigFile,"fmf",9999)
	sfj = JsonUtil.GetIntValue(TimerConfigFile,"sfj",9999)
	ffj = JsonUtil.GetIntValue(TimerConfigFile,"ffj",9999)
	eno = JsonUtil.GetIntValue(TimerConfigFile,"eno",9999)
	eni = JsonUtil.GetIntValue(TimerConfigFile,"eni",9999)
	
	;load IVDT config
	EnableIVDT = JsonUtil.GetIntValue(IVDTConfigFile, "enableivdt" ,0)
	;Load Director Configs
	directortoolskey = JsonUtil.GetIntValue(ControlConfigFile, "directortoolskey" ,0)
	uselinearscene = JsonUtil.GetIntValue(ControlConfigFile, "uselinearscene" ,0)
	linearsceneorgasmbeforelaststage = JsonUtil.GetIntValue(ControlConfigFile, "linearsceneorgasmbeforelaststage" ,0)
	givingforeplayinlinearscenedontorgasm = JsonUtil.GetIntValue(ControlConfigFile, "givingforeplayinlinearscenedontorgasm" ,0)
	linearsceneenjoymentendstagetopup = JsonUtil.GetIntValue(ControlConfigFile, "linearsceneenjoymentendstagetopup" ,0)
	linearscenechanceforpctoorgasmasvictim = JsonUtil.GetIntValue(ControlConfigFile, "linearscenechanceforpctoorgasmasvictim" ,0)
	enablelinearscenespontaneousorgasmduringnonintense = JsonUtil.GetIntValue(ControlConfigFile, "enablelinearscenespontaneousorgasmduringnonintense" ,0)
	enablelinearscenespontaneousorgasmduringintense = JsonUtil.GetIntValue(ControlConfigFile, "enablelinearscenespontaneousorgasmduringintense" ,0)
	linearscenespontaneousorgasmnpcmalearousalweight = JsonUtil.GetIntValue(ControlConfigFile, "linearscenespontaneousorgasmnpcmalearousalweight" ,0)
	linearscenespontaneousorgasmnpcfemalearousalweight = JsonUtil.GetIntValue(ControlConfigFile, "linearscenespontaneousorgasmnpcfemalearousalweight" ,0)
	linearscenespontaneousorgasmnpcfutaarousalweight = JsonUtil.GetIntValue(ControlConfigFile, "linearscenespontaneousorgasmnpcfutaarousalweight" ,0)
	linearscenespontaneousorgasmnpccreaturearousalweight = JsonUtil.GetIntValue(ControlConfigFile, "linearscenespontaneousorgasmnpccreaturearousalweight" ,0)
	linearscenespontaneousorgasmpcarousalweight = JsonUtil.GetIntValue(ControlConfigFile, "linearscenespontaneousorgasmpcarousalweight" ,0)
	modifierkey = JsonUtil.GetIntValue(ControlConfigFile, "modifierkey" ,0)
	adjustforwardkey = JsonUtil.GetIntValue(ControlConfigFile, "adjustforwardkey" ,0)
	adjustsidewayskey = JsonUtil.GetIntValue(ControlConfigFile, "adjustsidewayskey" ,0)
	adjustupdownkey = JsonUtil.GetIntValue(ControlConfigFile, "adjustupdownkey" ,0)
	adjustschlongkey = JsonUtil.GetIntValue(ControlConfigFile, "adjustschlongkey" ,0)
	adjustrotationkey = JsonUtil.GetIntValue(ControlConfigFile, "adjustrotationkey" ,0)
	advancekey = JsonUtil.GetIntValue(ControlConfigFile, "advancekey" ,0)
	enablehentairimscaling = JsonUtil.GetIntValue(ControlConfigFile, "enablehentairimscaling" ,0)
	enablearmorswap = JsonUtil.GetIntValue(ControlConfigFile, "enablearmorswap" ,0)
	
	enableautoadvancestage = JsonUtil.GetIntValue(ControlConfigFile, "enableautoadvancestage" ,0)
	resetsmp = JsonUtil.GetIntValue(ControlConfigFile, "resetsmp" ,0)
	resetsexassignment = JsonUtil.GetIntValue(ControlConfigFile, "resetsexassignment" ,0)
	chancetostartforeplay = JsonUtil.GetIntValue(ControlConfigFile, "chancetostartforeplay" ,0)
	foreplayhandjobweight = JsonUtil.GetIntValue(ControlConfigFile, "foreplayhandjobweight" ,0)
	foreplaytitfuckweight = JsonUtil.GetIntValue(ControlConfigFile, "foreplaytitfuckweight" ,0)
	foreplayfootjobweight = JsonUtil.GetIntValue(ControlConfigFile, "foreplayfootjobweight" ,0)
	foreplayblowjobweight = JsonUtil.GetIntValue(ControlConfigFile, "foreplayblowjobweight" ,0)
	enableprintdebug = JsonUtil.GetIntValue(ControlConfigFile, "printdebug" ,0)
	usephysicslabels = JsonUtil.GetIntValue(ControlConfigFile, "usephysicslabels" ,1)
	physicsfastvelocity = JsonUtil.GetFloatValue(ControlConfigFile, "physicsfastvelocity" ,25.0)
	physicsslowfactor = JsonUtil.GetFloatValue(ControlConfigFile, "physicsslowfactor" ,0.65)
	if physicsslowfactor > 1.0
		physicsslowfactor = 1.0
	elseif physicsslowfactor < 0.1
		physicsslowfactor = 0.1
	endif
	linearscenefinalstageorgasmfactor = papyrusutil.stringsplit(JsonUtil.GetstringValue(ControlConfigFile, "linearscenefinalstageorgasmfactor" ,0) ,",")
	linearsceneextendstagechance = papyrusutil.stringsplit(JsonUtil.GetstringValue(ControlConfigFile, "linearsceneextendstagechance" ,0) ,",")
	linearscenecounterrapechance = papyrusutil.stringsplit(JsonUtil.GetstringValue(ControlConfigFile, "linearscenecounterrapechance" ,0) ,",")

	;load Stage Maker Configs

	enablestagemaker = JsonUtil.GetIntValue(StageMakerFile, "enablestagemaker" ,0)
	chancetousecustomstage = JsonUtil.GetIntValue(StageMakerFile, "chancetousecustomstage" ,0)
	
	printdebug(" EnableSFX :" + EnableSFX)
	printdebug(" enableExpressions :" + enableExpressions)
	printdebug("enablepcexpression :" + enablepcexpression)
	printdebug("enablefemalenpcexpression :" + enablefemalenpcexpression)	
	printdebug("enablemalenpcexpression :" + enablemalenpcexpression)
	printdebug("enablehentairimscaling :" + enablehentairimscaling)
	printdebug("enablearmorswap :" + enablearmorswap)

	printdebug(" ldi :" + ldi)
	printdebug(" sst :" + sst)
	printdebug(" fst :" + fst)
	printdebug(" bst :" + bst)
	printdebug(" kis :" + kis)
	printdebug(" cun :" + cun)
	printdebug(" sbj :" + sbj)
	printdebug(" fbj :" + fbj)
	printdebug(" sap :" + sap)
	printdebug(" svp :" + svp)
	printdebug(" fap :" + fap)
	printdebug(" fvp :" + fvp)
	printdebug(" sdp :" + sdp)
	printdebug(" fdp :" + fdp)
	printdebug(" scg :" + scg)
	printdebug(" sac :" + sac)
	printdebug(" fcg :" + fcg)
	printdebug(" fac :" + fac)
	printdebug(" sdv :" + sdv)
	printdebug(" sda :" + sda)
	printdebug(" fdv :" + fdv)
	printdebug(" fda :" + fda)
	printdebug(" shj :" + shj)
	printdebug(" fhj :" + fhj)
	printdebug(" stf :" + stf)
	printdebug(" ftf :" + ftf)
	printdebug(" smf :" + smf)
	printdebug(" fmf :" + fmf)
	printdebug(" sfj :" + sfj)
	printdebug(" ffj :" + ffj)
	printdebug(" eno :" + eno)
	printdebug(" eni :" + eni)
	
	printdebug(" directortoolskey : " + directortoolskey)
	printdebug(" modifierkey : " + modifierkey)
	printdebug(" adjustforwardkey : " + adjustforwardkey)
	printdebug(" adjustsidewayskey : " + adjustsidewayskey)
	printdebug(" adjustupdownkey : " + adjustupdownkey)
	printdebug(" adjustrotationkey : " + adjustrotationkey)
	printdebug(" enablehentairimscaling : " + enablehentairimscaling)
	printdebug(" enablearmorswap : " + enablearmorswap)
	printdebug(" enableautoadvancestage : " + enableautoadvancestage)
	printdebug(" resetsmp : " + resetsmp)
	printdebug(" resetsexassignment : " + resetsexassignment)
	
	printdebug(" Stage maker : " + enablestagemaker)
	printdebug(" chancetousecustomstage : " + chancetousecustomstage)
	printdebug(" linearscenefinalstageorgasmfactor : " + linearscenefinalstageorgasmfactor)
	printdebug(" linearsceneextendstagechance : " + linearsceneextendstagechance)
	printdebug(" linearscenecounterrapechance : " + linearscenecounterrapechance)
endfunction

Bool function VictimPCCanOrgasm()
	return VictimPCCanOrgasm
EndFunction

Bool VictimPCCanOrgasm
Bool WarnedSexLabScalingConflict
;Director's Thread Control when Player's Thread just started.
Function RunThreadControl()

	if enablearmorswap == 1
		printdebug("Thread Control running body armor swapping")
		BodySwitchtoLewdArmor(playerref)
	endif
	
	if enablehentairimscaling == 1
		printdebug("Thread Control running Scaling")
		if !WarnedSexLabScalingConflict && !sslSystemConfig.GetSettingBool("bDisableScale")
			WarnedSexLabScalingConflict = true
			Debug.Notification("Hentairim: SexLab scaling is also active! Enable 'Disable Scaling / CTD Fix' in SexLab MCM to avoid size glitches")
		endif
		HentairimScaling()
	EndIf
	
	VictimPCCanOrgasm = utility.randomint(1,100) > linearscenechanceforpctoorgasmasvictim
EndFunction

;--------------------------------HENTAIRIM SCALING FUNCTIONS START--------------------------------;
Float[] actorlistOriginalScalearr
bool ProcessedOriginalScale
String LastScaledSceneID
Function HentairimScaling()
	LastScaledSceneID = CurrentThread.GetActiveScene()
	;always rebuild from scratch — stale entries from an aborted scene would restore wrong scales
	actorlistOriginalScalearr = PapyrusUtil.FloatArray(0)
	int z = 0
	while z < actorlist.Length

		Actor char = actorlist[z]

		;miscutil.PrintConsole(char.GetDisplayName() + " | Original GetScale: " + char.GetScale())
		float display = char.GetScale()
		;miscutil.PrintConsole(char.GetDisplayName() + " | Stored display: " + display)

		char.SetScale(1.0)
		;miscutil.PrintConsole(char.GetDisplayName() + " | SetScale to 1.0")
		;miscutil.PrintConsole(char.GetDisplayName() + " | Scale after setting to 1.0: " + char.GetScale())

		float base = char.GetScale()
		;miscutil.PrintConsole(char.GetDisplayName() + " | Stored base: " + base)

		float ActorScale = display / base
		;miscutil.PrintConsole(char.GetDisplayName() + " | Calculated ActorScale: " + ActorScale)

		float AnimScale = 1.0 / base
		;miscutil.PrintConsole(char.GetDisplayName() + " | AnimScale (1.0/base): " + AnimScale)

		actorlistOriginalScalearr = PapyrusUtil.PushFloat(actorlistOriginalScalearr, ActorScale)
		;miscutil.PrintConsole(char.GetDisplayName() + " | Pushed ActorScale to array: " + ActorScale)

		float finalScale = GetAnimSpecialScaleValue(z)
		finalScale *= AnimScale
		char.SetScale(finalScale)
		;miscutil.PrintConsole(char.GetDisplayName() + " | Final SetScale from GetAnimSpecialScaleValue * AnimScale: " + finalScale)

		z += 1
	endWhile
EndFunction


Function ResetScaling()
	int count = actorlistOriginalScalearr.Length
	if actorlist.Length < count
		count = actorlist.Length
	endif
	int z = 0
	while z < count
		if actorlist[z] != none
			actorlist[z].SetScale(actorlistOriginalScalearr[z])
		endif
		z += 1
	EndWhile

	actorlistOriginalScalearr = PapyrusUtil.FloatArray(0)
EndFunction


float function GetAnimSpecialScaleValue(int position)
;use the live scene id — CurrentSceneID may not be refreshed yet when a stage-start rescale runs
string SceneID = CurrentThread.GetActiveScene()
float ScaleValue = 1.0

if (SexLabRegistry.IsSceneTag(SceneID, "Bigguy") || SexLabRegistry.IsSceneTag(SceneID, "Smallguy")) && position != 0
		scalevalue = 1.15
elseif	SexLabRegistry.IsSceneTag(SceneID, "Shota") && Position > 0 ;there is no shota on 1st position
	int actorcount = CurrentThread.GetPositions().length
	if ActorCount == 2 || (Position == 2 && SexLabRegistry.IsSceneTag(SceneID, "smff")) || (Position > 0 && SexLabRegistry.IsSceneTag(SceneID, "smsmf")) || (Position == 3 && SexLabRegistry.IsSceneTag(SceneID, "smfff")) || (Position == 1 && SexLabRegistry.IsSceneTag(SceneID, "msmf"))
		scalevalue = 0.8
	endif
endif
	return scalevalue
endfunction



;--------------------------------HENTAIRIM SCALING FUNCTIONS END--------------------------------;
;---------------------------ARMOR SWAPPING FUNCTIONS START------------------------
form[] BaseArmorArr 
form[] LewdArmorArr 
form[] ActorArmorArr  

Function BodySwitchtoLewdArmor(actor char)

string[] ArmorSlotsToSwitch = papyrusutil.stringsplit(JsonUtil.GetStringValue(ArmorSwappingFile,"armorslots","") ,",")

int slotlength = ArmorSlotsToSwitch.length
int slotindex = 0
Armor BaseArmor
Armor LewdArmor

printdebug ("wearing lewd armor...")
	while slotindex < slotlength
		BaseArmor = char.GetWornForm(Armor.GetMaskForSlot(ArmorSlotsToSwitch[slotindex] as int)) as armor
	if BaseArmor != none
		LewdArmor = jsonutil.GetFormValue(ArmorSwappingFile, BaseArmor.getname(), none)	as armor

		if LewdArmor != none
			;printdebug (slotindex + " Trying to add  : "+ LewdArmor.getname())
			char.addItem(LewdArmor , abSilent=true)
			
			;printdebug (slotindex + " Trying to unequip  : "+ BaseArmor.getname())
			char.unEquipItem(BaseArmor , abSilent=true)
			
			;printdebug (slotindex + " Trying to equip  : "+ LewdArmor.getname())
			char.EquipItem(LewdArmor , abSilent=true)

			BaseArmorArr = papyrusutil.pushform(BaseArmorArr , BaseArmor)
			LewdArmorArr = papyrusutil.pushform(LewdArmorArr , LewdArmor)
			ActorArmorArr = papyrusutil.pushform(ActorArmorArr , char)
		endif
	endif

	slotindex += 1
	endwhile
endfunction

Function RestoreArmor(actor char)

int slotlength = BaseArmorArr.length
int slotindex = 0
Armor BaseArmor
Armor LewdArmor

printdebug ("restoring armor....")
while slotindex < slotlength 
	BaseArmor = BaseArmorArr[slotindex] as armor
	LewdArmor = LewdArmorArr[slotindex] as armor
	
	;printdebug (slotindex + " Trying to equip  : "+ BaseArmor.getname())
	char.EquipItem(BaseArmor , abSilent=true)
	
	;printdebug (slotindex + " Trying to remove  : "+ LewdArmor.getname())
	char.RemoveItem(LewdArmor , abSilent=true)
	
	slotindex += 1
endwhile

;clear array for reuse next time
BaseArmorarr = new form[1]
LewdArmorarr = new form[1]
BaseArmorarr = papyrusutil.RemoveForm(BaseArmorarr , BaseArmorarr[0])
LewdArmorarr = papyrusutil.RemoveForm(LewdArmorarr , LewdArmorarr[0])
EndFunction
;---------------------------ARMOR SWAPPING FUNCTIONS END------------------------

;---------------------------Stage Control FUNCTIONS Start------------------------
Bool IVDTCanAdvance = True
Bool SFXCanAdvance = True

Bool Function CanAdvance()
	PrintDebug("[CanAdvance] Called")

	Bool LinearSceneOrgasmCheck = true

	if LinearSceneStageShouldOrgasm() && !DoneLinearSceneOrgasm
		PrintDebug("[CanAdvance] LinearSceneStageShouldOrgasm()=TRUE but DoneLinearSceneOrgasm=FALSE → blocking advance")
		LinearSceneOrgasmCheck = false
	else
		PrintDebug("[CanAdvance] LinearSceneOrgasmCheck passed (no pending orgasm requirement)")
	endif

	PrintDebug("[CanAdvance] DirectorCanAdvanceStage=" + DirectorCanAdvanceStage)
	PrintDebug("[CanAdvance] enableautoadvancestage=" + enableautoadvancestage)
	PrintDebug("[CanAdvance] IVDTCanAdvance=" + IVDTCanAdvance)
	PrintDebug("[CanAdvance] SFXCanAdvance=" + SFXCanAdvance)
	PrintDebug("[CanAdvance] StageTimesUp()=" + StageTimesUp())

	Bool result = LinearSceneOrgasmCheck && DirectorCanAdvanceStage && enableautoadvancestage == 1 && IVDTCanAdvance && SFXCanAdvance && StageTimesUp()
	PrintDebug("[CanAdvance] Final result=" + result)

	return result
EndFunction


Bool Function StageTimesUp()
	return TimertoAdvance < CurrentThread.GetTimeTotal()
endFunction

Function IVDTAllowsAdvance(bool allow = true)
	printdebug("IVDT Allows Advance : " + allow)
	IVDTCanAdvance = allow
EndFunction

Function SFXAllowsAdvance(bool allow = true)
	printdebug("SFX Allows Advance : " + allow)
	SFXCanAdvance = allow
EndFunction

bool Function SFXReadytoAdvance()
	return SFXCanAdvance
EndFunction

bool Function IVDTReadytoAdvance()
	return IVDTCanAdvance
EndFunction


String Function GetPrimaryLabel()
	if GetEndingLabel(playerref) != "LDI"
		return GetEndingLabel(playerref)
	elseIF GetOralLabel(Playerref) != "LDI"
		return GetOralLabel(Playerref)
	elseif GetStimulationlabel(Playerref) == "BST"
		return GetStimulationlabel(Playerref)
	elseif GetPenetrationLabel(Playerref) != "LDI"
		return GetPenetrationLabel(Playerref)
	elseif GetPenisActionLabel(Playerref) != "LDI"
		return GetPenisActionLabel(Playerref)
	else
		return GetStimulationlabel(Playerref)
	endif
endfunction

int Function GetTimer()
  
 IF GetPrimaryLabel() == "ldi"
return ldi
elseIF GetPrimaryLabel() == "sst"
return sst
elseIF GetPrimaryLabel() == "fst"
return fst
elseIF GetPrimaryLabel() == "bst"
return bst
elseIF GetPrimaryLabel() == "kis"
return kis
elseIF GetPrimaryLabel() == "cun"
return cun
elseIF GetPrimaryLabel() == "sbj"
return sbj
elseIF GetPrimaryLabel() == "fbj"
return fbj
elseIF GetPrimaryLabel() == "sap"
return sap
elseIF GetPrimaryLabel() == "svp"
return svp
elseIF GetPrimaryLabel() == "fap"
return fap
elseIF GetPrimaryLabel() == "fvp"
return fvp
elseIF GetPrimaryLabel() == "sdp"
return sdp
elseIF GetPrimaryLabel() == "fdp"
return fdp
elseIF GetPrimaryLabel() == "scg"
return scg
elseIF GetPrimaryLabel() == "sac"
return sac
elseIF GetPrimaryLabel() == "fcg"
return fcg
elseIF GetPrimaryLabel() == "fac"
return fac
elseIF GetPrimaryLabel() == "sdv"
return sdv
elseIF GetPrimaryLabel() == "sda"
return sda
elseIF GetPrimaryLabel() == "fdv"
return fdv
elseIF GetPrimaryLabel() == "fda"
return fda
elseIF GetPrimaryLabel() == "shj"
return shj
elseIF GetPrimaryLabel() == "fhj"
return fhj
elseIF GetPrimaryLabel() == "stf"
return stf
elseIF GetPrimaryLabel() == "ftf"
return ftf
elseIF GetPrimaryLabel() == "smf"
return smf
elseIF GetPrimaryLabel() == "fmf"
return fmf
elseIF GetPrimaryLabel() == "sfj"
return sfj
elseIF GetPrimaryLabel() == "ffj"
return ffj
elseIF GetPrimaryLabel() == "eno"
return eno
elseIF GetPrimaryLabel() == "eni"
return eni
else
printdebug("Label for TImer is not found. Defaulting to 15")
return 15

endif
endfunction

Function AddtoTimer(float value)
	value = value * storageutil.Getfloatvalue(none,"HentairimTimerModifier",1.0) ;global storageutil that lets mods to modify timer for this scene
	
	TimertoAdvance = CurrentThread.GetTimeTotal()
	TimertoAdvance += value
	if IsGettingAnallyPenetrated(actorlist[0]) || IsGettingVaginallyPenetrated(actorlist[0]) || IsSuckingoffOther(actorlist[0])
		if timerdebt > 0
			if timerdebt < 15
				TimertoAdvance += timerdebt
				timerdebt = 0
			else
				TimertoAdvance += 15
				timerdebt -= 15
			endif
		elseif timerdebt < 0
			if timerdebt > -10
				TimertoAdvance += timerdebt ; negative debt fully paid off
				timerdebt = 0
			else
				TimertoAdvance -= 10
				timerdebt += 10
			endif
		endif
	endif

endFunction


bool IsStageOffset 
Function AdjustAlignment(int Movement , Bool Modifier = false)
	float offsetmod = 1
	if Modifier
		offsetmod = -1
	endif
	
	;smaller values for rotation
	if Movement == 3	
		offsetmod = offsetmod/10
	endif
	
	string stageid = ""
	if IsStageOffset
		stageid = currentStageID
	endif
	
	int z = 0
	while z < PositionsToAlign.length
		float[] OffSet = sexlabregistry.GetStageOffset(CurrentSceneID, stageid, PositionsToAlign[z])
		 OffSet[Movement] = OffSet[Movement] + offsetmod
		sexlabregistry.SetStageOffsetA(currentsceneid ,stageid, PositionsToAlign[z] , OffSet) 
		z += 1
	EndWhile
	currentthread.skipto(currentstageid)
endfunction

string[] Function FindValidCustomScene(bool ReturnAllValidScenes = false) ;if enabled, it will return all valid custom scenes. the entire line item string will be stuffed into array in place of custom stage. used for custom scene searching only
printdebug("Finding Valid Custom Scenes.")

string actorrace 
string StringKey
string[] ValidCustomScenesarr
;add actor count to string key
StringKey += actorlist.length as string

; identify non PC race
int z 
while z < actorlist.length 
	if actorlist[z] != playerref
		if sexlab.GetGender(actorlist[z]) <= 1
			StringKey += "human"
			z += 100
		else
			StringKey += "creature"
			z += 100
		endif
	endif
	z+= 1
endwhile
;identify string keysd

if isVictim(actorlist[1])
	StringKey += "femdom"
elseif isVictim(actorlist[0])
	StringKey += "aggressive"
else
	StringKey += "consensual"
endif
printdebug("finding line items with Custom Scene String Key : " + StringKey)

;start looping through all the JSON files in StageMakerJSONFolder
string[] StageMakerFileNameList = JsonUtil.JsonInFolder(StageMakerJSONFolder)
printdebug("all stage make file names" + StageMakerFileNameList)

if StageMakerFileNameList.length == 0
	printdebug("No Stage Maker JSON File Found")
	return none
EndIf
;we want to find a custom scenes if its available from various files
int f
while f < StageMakerFileNameList.length
	String Path = StageMakerJSONFolder + StageMakerFileNameList[f]
	printdebug("Searching for Stage Maker Line items in : " + Path)
	
	int CustomSceneCount
	CustomSceneCount = JsonUtil.StringListCount(Path,StringKey)
	printdebug("total line items in " + CustomSceneCount)

	;line items found . start to search for suitable custom scenes.
	if CustomSceneCount > 0
		z = 0
		while z < CustomSceneCount
			
			string Lineitem = JsonUtil.StringListGet(Path,StringKey,z)
			printdebug("Line Item found :" + Lineitem)
			
			;breakdown and validate line item
			string[] LineItemArr = papyrusutil.stringsplit(Lineitem , "|")
			printdebug("LineItemArr : " + LineItemArr)
			
			;first array value is always the position tags to validate against.
			;PositionTagsArr is the lookup criteria
			string[] PositionTagsArr = papyrusutil.stringsplit(LineItemArr[0] , ",")
			printdebug("PositionTagsArr : " + PositionTagsArr)
			
			;start to check if the PositionTagsArr's tags are matching with the current playing animation
			int y = 0
			Bool ValidLineItem = true
			Bool Containstilde = false
			Bool TildeSatisfied = false
			while y < PositionTagsArr.length && ValidLineItem
				string specialchar = StringUtil.Substring(PositionTagsArr[y],0,1)
				printdebug("specialchar : " + specialchar)

				if specialchar == "@" ;match animation name
					String SceneNametoCheck = StringUtil.Substring(PositionTagsArr[y],1)
					printdebug("Scene Name Look up : " + SceneNametoCheck)
					if SexlabRegistry.GetSceneName(CurrentSceneID) != SceneNametoCheck
						ValidLineItem = false
						y += 100
					endif
				elseif specialchar == "-" ;minus means it should not contain this tag
					string tagtocheck = StringUtil.Substring(PositionTagsArr[y],1)
					printdebug("tag to Look up : " + tagtocheck)
					if CurrentThread.HasSceneTag(tagtocheck)
						printdebug("Current Scene Contains excluded" + tagtocheck +" tag. skip this Line Item")
						ValidLineItem = false
						y += 100
					endif
				elseif specialchar == "~" ;minus means it should not contain this tag
					Containstilde = true
					string tagtocheck = StringUtil.Substring(PositionTagsArr[y],1)
					printdebug("tagtocheck : " + tagtocheck)
					if CurrentThread.HasSceneTag(tagtocheck)
						printdebug("Current Scene Contains tilde " +tagtocheck + " tag. tilde condition satisfied")
						TildeSatisfied = true
					endif
				else
					string tagtocheck = PositionTagsArr[y]
					printdebug("tagtocheck : " + tagtocheck)
					if !CurrentThread.HasSceneTag(tagtocheck)
						printdebug("Current Scene does not  " +tagtocheck + " tag. Skip this Line Item")
						ValidLineItem = false
						y += 100
					endif
				endif
				y += 1
			endwhile
			;make lineitem valid only after at least one tag fits tilde
			if Containstilde && !TildeSatisfied
				ValidLineItem = false
			endif
			
			;this is a valid line item. add it to the valid item group
			if ValidLineItem
				printdebug("Line Item is Valid and added to the List of valid Custom scenes")
				ValidCustomScenesarr = papyrusutil.pushstring(ValidCustomScenesarr, Lineitem)
			endif
			
			z += 1

		endwhile
	else
	printdebug("no line items found in " + Path +". String Key : "+ StringKey + " Skipping")	
	endif
	f += 1
endwhile
	
	;we are done looking for the list of valid line items from various files. return none if none is found or pick a random line item for the scene if more than 1
	if ValidCustomScenesarr.length <= 0
		printdebug("no valid Line Item Found for Scene")
		Return none
	ElseIf ReturnAllValidScenes
		return ValidCustomScenesarr
	Else
		string[] Result = papyrusutil.stringsplit(ValidCustomScenesarr[utility.randomint(0,ValidCustomScenesarr.length - 1)] , "|")	
		printdebug("Custom Scene selected : " + Result)
		return Result
	endif
EndFunction

Bool RunCustomScene = false
string CustomScenePositionTags
string[] CustomSceneTags
string StorageUtilCustomScene
int CustomStageNum = 0
Bool Function CheckifShouldRunCustomScene()

if enablestagemaker != 1
	return false
endif
;look for custom scene string from storageutil
String SUCustomSceneString = StorageUtil.GetStringValue(None, "DirectorCustomScene", "")

if Utility.RandomInt(1,100) > chancetousecustomstage && StorageUtilCustomScene == ""
	printdebug("Failed Chance to use Stage Maker's custom Scenes ")
	return false
endif

if currentthread.HasSceneTag("Furniture")
	printdebug("Cannot use CUstom Scene in FUrniture")
	return false
endif

;has storageutil custom scene string
if StorageUtilCustomScene != ""
	CustomSceneTags = papyrusutil.stringsplit(SUCustomSceneString,"|")
else
	CustomSceneTags = FindValidCustomScene()
endIf

if CustomSceneTags.length <= 0 || CustomSceneTags == none
	printdebug("no Valid Custom Scene Found. Using Default Scene ")
	return false
else	
	printdebug("CustomSceneTags : " + CustomSceneTags)
	

	MovetoNextCustomStage()

	return true
endif
endfunction

Function MovetoNextCustomStage()
	;string CustomScenePositionTags - The position tags that all stages to adhere, unless there are more than one stage tags in the stage number
	;string[] CustomSceneTags - Current Scene tags. or usually hentairim tags
	;CustomStageNum - te current stage number in the custom scene
	if CustomStageNum >= CustomSceneTags.length
		printdebug("Reached the End of Custom Scene. Stopping animation")
		DirectorEndScene()
		return
	endif
	
	string TagsToApply
	int DestinationStage
	String CustomStageTags = CustomSceneTags[CustomStageNum + 1] ;the hentairim tag to go for . +1 tp skip first lookup criteria
	printdebug("CustomStageTags : " + CustomStageTags)

	if StringUtil.find(CustomStageTags , "@") > -1 
		int commaIndex = StringUtil.Find(CustomStageTags, ",")
		string LineItemSceneName = StringUtil.Substring(CustomStageTags, 1, commaIndex - 1)
		int LineItemStagenum = StringUtil.Substring(CustomStageTags, commaIndex + 1) as int
		TeleportToSceneWithName(LineItemSceneName,LineItemStagenum)
		CustomStageNum += 1
		return ;no need to run subsequent code
	elseif StringUtil.find(CustomStageTags , ",") > -1 
		;more tags other than hentairim tag or no hentairim tag . ignore CustomScenePositionTags
		TagsToApply = CustomStageTags
	else
		;if there is only one tag which is hentairim tag
		
		TagsToApply = CustomSceneTags[0] + "," + CustomStageTags
	endif
	;if current scene already has this customstagetags
	if currentthread.HasSceneTag(CustomStageTags)
		DestinationStage = StringUtil.Substring(CustomStageTags, 0, 1) as int
		if DestinationStage > 0
			string[] StagesIDList = SexlabRegistry.GetAllStages(CurrentSceneID)
			CurrentThread.SkipTo(StagesIDList[DestinationStage - 1])
			CustomStageNum += 1
			return ;no need to run subsequent code
		endif
	endif
	;identify destination stage to move to. only look at first character for potential stage number as per rules
		DestinationStage = StringUtil.Substring(CustomStageTags,0,1) as int
	
	;if no destination Stage Identified
	if DestinationStage <= 0
		if IsEnding(actorlist[0])
			DestinationStage = 5
		elseif IsgettingPenetrated(actorlist[0]) || IsCowgirl(actorlist[0]	)
			DestinationStage = Utility.Randomint(3,5)
		else
			DestinationStage = Utility.Randomint(1,2)
		endif
	endif

	printdebug("Custom Stage TagsToApply : " + TagsToApply)
	printdebug("Custom DestinationStage : " + DestinationStage)

	
	bool result = TeleportToRandomStageWithTags(TagsToApply , DestinationStage)
	
	if !result ;no scene found
		WritetoErrorlogs("StageMaker" ,"Custom Scene : " + CustomSceneTags + " | no Stage Found with Tags" + TagsToApply +" and Destination Stage" + DestinationStage + " Verify if the Combination of Actor's Gender & Scene tags availability Exists")
	endIf
	CustomStageNum += 1

EndFunction


Function RevertAllActorsSex()
	int z
	while z < actorlist.length
		sexlab.ClearForcedSex(actorlist[z])
		z += 1
	endwhile

endfunction

Int Timerdebt = 0
Function AddTimerDebt(int value)

	Timerdebt += Value

EndFunction

Function ModResistance(Actor char, int value)
if enableResistance == 1
	int currentRank = char.GetFactionRank(HentairimResistanceFaction)
	int newRank = currentRank + value

	if newRank > 100
		newRank = 100
	elseif newRank < 0
		newRank = 0
	endif

	char.SetFactionRank(HentairimResistanceFaction, newRank)
endif
EndFunction

Function RecoverResistancebyHour(Actor Char , int HoursPassed = 1)
int pcrecoverresistancepercentageperhour = JsonUtil.GetIntValue(ResistanceConfigFile, "pcrecoverresistancepercentageperhour", 5)

if IsBroken(Char)
	 SetBrokenpoints(char,GetBrokenpoints(char) - HoursPassed)
	
	if !IsBroken(Char)
		;recover resistance
		announce("You Recovered your Sanity")
		ModResistance(Playerref,100)
		return
	endif
else
	ModResistance(Playerref,pcrecoverresistancepercentageperhour * HoursPassed)
endif

endfunction

function SetBrokenPoints(actor char,int value)
if !char.isinfaction(HentairimBroken)
	char.addtofaction(HentairimBroken)
endif

int NewBrokenValue  = Value
if NewBrokenValue <= 0
	NewBrokenValue = 0
elseif NewBrokenValue > 127
	NewBrokenValue = 127
endif

char.SetFactionRank(HentairimBroken , NewBrokenValue)

endFunction

int function GetResistance()
	if Playerref.Isinfaction(HentairimResistanceFaction)
		return Playerref.GetFactionRank(HentairimResistanceFaction)
	else 
		Return 100
	Endif
endFunction

int function GetBrokenPoints(actor char)

	return char.GetFactionRank(HentairimBroken)

endFunction

Bool Function TryToFindaPositions(String HentairimTagwithoutStage ,string additionaltags, bool SearchFromtheFront = false)
	PrintDebug("TryToFindaPositions: Started with Tag = " + HentairimTagwithoutStage)

	string tags
	int TargetStage

	if StringUtil.Substring(HentairimTagwithoutStage, 0, 1) == "s"
		TargetStage = Utility.RandomInt(2, 3)
		PrintDebug("Tag starts with S, setting TargetStage between 2 and 3: " + TargetStage)
	else
		TargetStage = Utility.RandomInt(3, 6)
		PrintDebug("Tag not starting with S, setting TargetStage between 3 and 6: " + TargetStage)
	endif

	tags = TargetStage as string + HentairimTagwithoutStage
	PrintDebug("Constructed initial tags: " + tags)

	bool found = TeleportToRandomStageWithTags(tags, TargetStage)
	PrintDebug("Initial teleport result with TargetStage " + TargetStage + ": " + found)
	bool found2
	if !found
		if SearchFromtheFront
			int y = 1
			
			PrintDebug("Initial search failed, attempting fallback search from stage 7 down to 1")

			while y <= 7 && !found2
				tags = y as string + HentairimTagwithoutStage + "," + additionaltags
				PrintDebug("Trying fallback tag: " + tags + " at stage " + y)
				found2 = TeleportToRandomStageWithTags(tags, y)
				PrintDebug("Fallback attempt at stage " + y + " result: " + found2)
				y += 1
			endwhile
		else
			int y = 7
			PrintDebug("Initial search failed, attempting fallback search from stage 7 down to 1")

			while y >= 1 && !found2
				tags = y as string + HentairimTagwithoutStage + "," + additionaltags
				PrintDebug("Trying fallback tag: " + tags + " at stage " + y)
				found2 = TeleportToRandomStageWithTags(tags, y)
				PrintDebug("Fallback attempt at stage " + y + " result: " + found2)
				y -= 1
			endwhile
		endif
		
		if found2
			PrintDebug("Fallback found a position successfully.")
			return true
		else
			PrintDebug("Fallback failed. No valid position found. Ending Scene")
			DirectorEndScene()
			return false
		endif
	else
		PrintDebug("Initial teleport succeeded.")
		return true
	endif
EndFunction

Bool Function NextStageHasPenetration()
	bool result
	bool ContinueInSameScene
	int currentstage = CurrentStageNum
	string NextStage = (Currentstage + 1) as string

	if isFinalStage
		result = false
	else
		result = CurrentThread.HasSceneTag(NextStage + "ASVP") || CurrentThread.HasSceneTag(NextStage + "AFVP") || CurrentThread.HasSceneTag(NextStage + "ASDP") || CurrentThread.HasSceneTag(NextStage + "AFDP") || CurrentThread.HasSceneTag(NextStage + "ASAP") || CurrentThread.HasSceneTag(NextStage + "FSAP")
	endif
	return result
endfunction

Function AdvancetoNextStage()
	if RunCustomScene
		MovetoNextCustomStage()
	else
		CurrentThread.skipto(GetNextStageID(CurrentSceneID, CurrentStageID))
	endIf
endFunction

Function DisableOrgasm(Actor char)

    CurrentThread.DisableOrgasm(char, true)

    if char
        PrintDebug("DisableOrgasm - Orgasm disabled for: " + char.GetDisplayName())
    else
        PrintDebug("DisableOrgasm - Orgasm disabled for NONE actor")
    endif
EndFunction

Function EnableOrgasm(Actor char)

    if isLinearScene()
        PrintDebug("EnableOrgasm - Linear scene detected," + char.GetDisplayName() +" orgasm DISABLED instead.")
        CurrentThread.DisableOrgasm(char, true)
    else
        PrintDebug("EnableOrgasm - Non-linear scene, " +char.GetDisplayName()+ " orgasm ENABLED.")
        CurrentThread.DisableOrgasm(char, false)
    endif
EndFunction

Function EnableOrgasmAll()
	int z 
	while z < actorlist.length
		EnableOrgasm(actorlist[z])
		z += 1
	endwhile	
EndFunction

Function DisableOrgasmAll()
	int z 
	while z < actorlist.length
		DisableOrgasm(actorlist[z])
		z += 1
	endwhile	
EndFunction
;---------------------------Stage Control FUNCTIONS END------------------------

;---------------------------Director's Utility START------------------------

Bool function ValidateJsonFile(String Title , string Path)
	printdebug("validating " + Path)
	;check if exists
	if !jsonutil.JsonExists(Path)
		Debug.MessageBox(Title + " : "+Path + " File Is Missing")
		WritetoErrorlogs("Director", Title + " : "+Path + " Format Is Missing : ")
		return false
	EndIf
	
	string errors = jsonutil.GetErrors(Path)
	
	if errors != ""
		Debug.MessageBox(Title + " : "+Path + " Format has Errors : ")
		WritetoErrorlogs("Director", Title + " : "+Path + " Format has Errors : ")
		return false
	EndIf
	return true
EndFunction

Bool Function AllFemale()

	int[] sexarr = sexlab.GetSexAll(actorlist)
	if sexlab.CountFemale(actorlist) == actorlist.length	
		return true
	else
		return false
	endIf
endfunction

function printdebug(string contents = "")
	if enableprintdebug == 1
		miscutil.PrintConsole ("Hentairim Director : "+ contents)
	endif
endfunction

function WritetoErrorlogs(string Header = "Not Specified" ,String contents = "")
	JsonUtil.StringListAdd("ErrorLog.json", Header, " : " + contents, TRUE)
endfunction

bool function ResistanceEnabled()
	return enableResistance == 1
EndFunction

Function UpdateMasterVolume()
	Float Volume = 100
	IVDTVoices.SetVolume(Volume)
	IVDTMCMAudio.SetVolume(Volume)
EndFunction

Function UnmuteSexLabVoices()
	SexLabVoices.UnMute()
EndFunction
string[] Stimulationlabelarr
string[] PenisActionLabelarr
string[] OralLabelarr
string[] PenetrationLabelarr
string[] EndingLabelarr
string Labelsconcat
Function UpdateLabelsArr(string anim , int stage)

	Stimulationlabelarr = HentairimTags.GetStimulationlabelarr(anim , stage , actorlist)
	PenisActionLabelarr  = HentairimTags.GetPenisActionLabelarr(anim , stage , actorlist)
	OralLabelarr  = HentairimTags.GetOralLabelarr(anim , stage , actorlist)
	PenetrationLabelarr = HentairimTags.GetPenetrationLabelarr(anim , stage , actorlist)
	EndingLabelarr  =HentairimTags.GetEndingLabelarr(anim , stage , actorlist)

	ApplyClimaxAnnotations(anim)

	;snapshot the tag-derived labels so the physics overlay can revert when contact ends
	BaseStimulationlabelarr = CopyStringArray(Stimulationlabelarr)
	BasePenisActionLabelarr = CopyStringArray(PenisActionLabelarr)
	BaseOralLabelarr = CopyStringArray(OralLabelarr)
	BasePenetrationLabelarr = CopyStringArray(PenetrationLabelarr)

	ApplyPhysicsLabels()

	Labelsconcat = "1" +Stimulationlabelarr[0] + "1" + PenisActionLabelarr[0] + "1" + OralLabelarr[0] + "1" + PenetrationLabelarr[0] + "1" + EndingLabelarr[0]

	printdebug("Stimulationlabelarr : " + Stimulationlabelarr)
	printdebug("PenisActionLabelarr : " + PenisActionLabelarr)
	printdebug("OralLabelarr : " + OralLabelarr)
	printdebug("PenetrationLabelarr : " + PenetrationLabelarr)
	printdebug("EndingLabelarr : " + EndingLabelarr)
endfunction

Function ApplyClimaxAnnotations(string anim)
	;SLSB climax annotations fill EN labels for stages the Hentairim tags don't cover
	if CurrentStageID == ""
		return
	endif
	int[] climaxers = SexlabRegistry.GetClimaxingActors(anim, CurrentStageID)
	if !climaxers || climaxers.Length == 0
		return
	endif
	int z = 0
	while z < EndingLabelarr.Length
		if EndingLabelarr[z] == "LDI" && climaxers.Find(z) > -1
			EndingLabelarr[z] = "ENI" ;registry doesn't distinguish inside/outside; ENI is the common case
		endif
		z += 1
	endwhile
endfunction

;--------------------------------PHYSICS LABEL BRIDGE START--------------------------------;
;When SLPP node-collision detection is registered for the thread, overlay the tag-derived
;labels with what is physically happening. Tags stay as fallback for anything physics
;cannot see (titfuck, posture nuance like cowgirl, ending inside/outside) and for scenes
;where detection is unavailable. The F/S prefix comes from live contact velocity, so
;intensity tracks the real animation speed including user AnimSpeed overrides.
float[] PhysVelEnvelope
bool[] PhysVelFast
;tag-derived baselines, snapshotted per stage in UpdateLabelsArr; the overlay always
;derives from these so labels revert when contact ends and posture info survives
string[] BaseStimulationlabelarr
string[] BasePenisActionLabelarr
string[] BaseOralLabelarr
string[] BasePenetrationLabelarr

string[] Function CopyStringArray(string[] src)
	string[] dst = PapyrusUtil.StringArray(src.Length)
	int i = 0
	while i < src.Length
		dst[i] = src[i]
		i += 1
	endwhile
	return dst
EndFunction

Bool Function ApplyPhysicsLabels()
	if usephysicslabels != 1 || CurrentThread == none || !CurrentThread.IsInteractionRegistered()
		return false
	endif
	if BasePenetrationLabelarr.Length != actorlist.Length || PenetrationLabelarr.Length != actorlist.Length
		return false
	endif
	if PhysVelEnvelope.Length != actorlist.Length || PhysVelFast.Length != actorlist.Length
		PhysVelEnvelope = PapyrusUtil.FloatArray(actorlist.Length)
		PhysVelFast = PapyrusUtil.BoolArray(actorlist.Length)
	endif

	bool changed = false
	int z = 0
	while z < actorlist.Length
		actor pos = actorlist[z]
		if pos != none
			bool recvVag = false
			bool recvAnal = false
			bool recvGrind = false
			bool givesVag = false
			bool givesAnal = false
			bool penisSucked = false
			bool penisDeep = false
			bool penisHJ = false
			bool penisFJ = false
			bool mouthKis = false
			bool mouthDeep = false
			bool mouthOral = false
			bool mouthShaft = false
			actor oralTarget = none
			float maxVel = 0.0

			;one flags call per position replaces the pairwise GetInteractionTypes sweep;
			;partner lookups and velocity reads only for the types the flags say are active
			bool[] f = CurrentThread.GetCurrentInteractionFlags(pos)
			if f.Length >= 28
				recvVag = f[15] ;pVaginal
				recvAnal = f[16] ;pAnal
				recvGrind = f[4] ;pGrinding
				mouthOral = f[12] ;aOral
				mouthDeep = f[14] ;aDeepthroat
				mouthShaft = f[13] ;aLickingShaft
				mouthKis = f[9] ;bKissing
				givesVag = f[26] ;aVaginal
				givesAnal = f[27] ;aAnal
				penisSucked = f[23] ;pOral
				penisDeep = f[24] ;pDeepthroat
				penisHJ = f[19] ;pHandJob
				penisFJ = f[20] ;pFootJob

				actor prt
				if recvVag
					prt = CurrentThread.GetPartnerByTypeRev(pos, 1) ;whoever penetrates pos
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(pos, prt, 1))
					endif
				endif
				if recvAnal
					prt = CurrentThread.GetPartnerByTypeRev(pos, 2)
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(pos, prt, 2))
					endif
				endif
				if recvGrind
					prt = CurrentThread.GetPartnerByTypeRev(pos, 4)
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(pos, prt, 4))
					endif
				endif
				if mouthOral
					oralTarget = CurrentThread.GetPartnerByTypeRev(pos, 3) ;whom pos licks/sucks
					if oralTarget != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(pos, oralTarget, 3))
					endif
				endif
				if givesVag
					prt = CurrentThread.GetPartnerByType(pos, 1) ;receiver pos penetrates
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(prt, pos, 1))
					endif
				endif
				if givesAnal
					prt = CurrentThread.GetPartnerByType(pos, 2)
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(prt, pos, 2))
					endif
				endif
				if penisSucked
					prt = CurrentThread.GetPartnerByType(pos, 3) ;whoever sucks pos off
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(prt, pos, 3))
					endif
				endif
				if penisHJ
					prt = CurrentThread.GetPartnerByType(pos, 9)
					if prt != none
						maxVel = MaxAbsVelocity(maxVel, CurrentThread.GetVelocity(prt, pos, 9))
					endif
				endif
			endif

			;velocity envelope: a single sample can land on a thrust reversal (~0),
			;so decay the previous peak instead of trusting the instantaneous value
			float env = PhysVelEnvelope[z] * 0.7
			if maxVel > env
				env = maxVel
			endif
			PhysVelEnvelope[z] = env
			;hysteresis: rise to F at the threshold, fall back to S only well below it,
			;so a sub-second thrust cycle sampled at 0.5s does not flap the prefix
			if !PhysVelFast[z] && env >= physicsfastvelocity
				PhysVelFast[z] = true
			elseif PhysVelFast[z] && env < physicsfastvelocity * physicsslowfactor
				PhysVelFast[z] = false
			endif
			string sp = "S"
			if PhysVelFast[z]
				sp = "F"
			endif

			;each label derives from the immutable tag baseline: overlays apply on top,
			;and when contact ends newlbl falls back to the baseline, reverting the array

			;Penetration label (receiver view)
			string base = BasePenetrationLabelarr[z]
			string newlbl = base
			if recvVag && recvAnal
				newlbl = sp + "DP"
			elseif recvVag
				if base == "SCG" || base == "FCG"
					newlbl = sp + "CG" ;keep cowgirl posture from tags
				else
					newlbl = sp + "VP"
				endif
			elseif recvAnal
				if base == "SAC" || base == "FAC"
					newlbl = sp + "AC"
				else
					newlbl = sp + "AP"
				endif
			endif
			if newlbl != PenetrationLabelarr[z]
				PenetrationLabelarr[z] = newlbl
				changed = true
			endif

			;Penis action label (giver view)
			base = BasePenisActionLabelarr[z]
			newlbl = base
			if givesVag
				newlbl = sp + "DV"
			elseif givesAnal
				newlbl = sp + "DA"
			elseif penisDeep
				newlbl = "FMF"
			elseif penisSucked
				newlbl = sp + "MF"
			elseif penisHJ
				newlbl = sp + "HJ"
			elseif penisFJ
				newlbl = sp + "FJ"
			endif
			if newlbl != PenisActionLabelarr[z]
				PenisActionLabelarr[z] = newlbl
				changed = true
			endif

			;Oral label (mouth view) - same priority order as the tag version
			base = BaseOralLabelarr[z]
			newlbl = base
			if mouthKis
				newlbl = "KIS"
			elseif mouthDeep
				newlbl = "FBJ"
			elseif mouthOral
				if oralTarget != none && Sexlab.GetGender(oralTarget) % 2 == 1
					newlbl = "CUN"
				elseif sp == "F"
					newlbl = "FBJ"
				else
					newlbl = "SBJ"
				endif
			elseif mouthShaft
				newlbl = "SBJ"
			endif
			if newlbl != OralLabelarr[z]
				OralLabelarr[z] = newlbl
				changed = true
			endif

			;Stimulation label - grinding is the only physical signal for it
			base = BaseStimulationlabelarr[z]
			newlbl = base
			if recvGrind && base != "BST"
				newlbl = sp + "ST"
			endif
			if newlbl != Stimulationlabelarr[z]
				Stimulationlabelarr[z] = newlbl
				changed = true
			endif
		endif
		z += 1
	endwhile

	if changed
		Labelsconcat = "1" +Stimulationlabelarr[0] + "1" + PenisActionLabelarr[0] + "1" + OralLabelarr[0] + "1" + PenetrationLabelarr[0] + "1" + EndingLabelarr[0]
		printdebug("Physics labels applied - Stim: " + Stimulationlabelarr + " PenisAction: " + PenisActionLabelarr + " Oral: " + OralLabelarr + " Penetration: " + PenetrationLabelarr)
	endif
	return changed
EndFunction

float Function MaxAbsVelocity(float current, float candidate)
	float a = Math.abs(candidate)
	if a > current
		return a
	endif
	return current
EndFunction
;--------------------------------PHYSICS LABEL BRIDGE END--------------------------------;

bool Function SceneisIntense()
	return stringutil.find(Labelsconcat ,"1F") > -1
endfunction

;string labelsconcat

;Function UpdateLabels(string anim , int stage , int actorpos = 0 )
; Stimulationlabel = HentairimTags.StimulationLabel(anim , stage , actorpos)
; PenisActionLabel  = HentairimTags.PenisActionLabel(anim , stage , actorpos)
; OralLabel  = HentairimTags.OralLabel(anim , stage , actorpos)
; PenetrationLabel = HentairimTags.PenetrationLabel(anim , stage , actorpos)
; EndingLabel  = HentairimTags.EndingLabel(anim , stage , actorpos)
;Labelsconcat = "1" +Stimulationlabel + "1" + PenisActionLabel + "1" + OralLabel + "1" + PenetrationLabel + "1" + EndingLabel

;endfunction

Bool Function LinearSceneCanOrgasm(actor char)
;check the past stages tags to see if actor has been stimulated before for orgasm
if givingforeplayinlinearscenedontorgasm != 1
	return true
endif
	if !VictimPCCanOrgasm() && IsVictim(Playerref) && char == Playerref
		return false
	else
		int stagecount = SexlabRegistry.GetAllStages(currentsceneid).length - 1
		int pos = CurrentThread.GetPositionIdx(char)
		while stagecount > -1
			string tmpPenisActionLabel = HentairimTags.PenisActionLabel(currentsceneid , stagecount , pos)
			string tmpStimulationLabel = HentairimTags.StimulationLabel(currentsceneid , stagecount , pos)
			string tmpPenetrationLabel = HentairimTags.PenetrationLabel(currentsceneid , stagecount , pos)
			if tmpPenisActionLabel == "SFJ" || tmpPenisActionLabel == "FFJ" || tmpPenisActionLabel == "STF" || tmpPenisActionLabel == "FTF" || tmpPenisActionLabel == "SDV" || tmpPenisActionLabel == "FDV" || tmpPenisActionLabel == "SDA" || tmpPenisActionLabel == "FDA" || tmpPenisActionLabel == "SMF" || tmpPenisActionLabel == "FMF" || tmpPenisActionLabel == "SHJ" || tmpPenisActionLabel == "FHJ"
				printdebug(char.getdisplayname() + " had Penis Action Label. Can Orgasm")
				return TRUE
			elseif tmpPenetrationLabel == "SVP" || tmpPenetrationLabel == "FVP" || tmpPenetrationLabel == "SAP" || tmpPenetrationLabel == "FAP" || tmpPenetrationLabel == "SDP" || tmpPenetrationLabel == "FDP"
				printdebug(char.getdisplayname() + " had Penetrated before. Can Orgasm")
				return TRUE
			elseif tmpStimulationLabel == "SST" || tmpStimulationLabel == "FST" || tmpStimulationLabel == "BST"
				printdebug(char.getdisplayname() + " had Stimulation before. Can Orgasm")
				return TRUE
			endif
			Stagecount -= 1
		endwhile
		printdebug(char.getdisplayname() + " didnt had any sort of stimulation. cannot orgasm")
	endif
	return false
	
	
endFunction


string function GetNextStageID(String asScene, String asStage)
	string[] all_stages = SexlabRegistry.GetAllStages(asScene)
	if SexlabRegistry.StageExists(asScene, asStage)
		int idx = all_stages.find(asStage)
		if idx >= 0 && idx < all_stages.length - 1
			return all_stages[idx + 1]
		endif
	endif
	return ""
endfunction

string function GetLastStageID(String asScene)
	string[] all_stages = SexlabRegistry.GetAllStages(asScene)
	return all_stages[all_stages.length - 1]
endfunction

string function GetPrevStageID(String asScene, String asStage)
	string[] all_stages = SexlabRegistry.GetAllStages(asScene)
	if SexlabRegistry.StageExists(asScene, asStage)
		int idx = all_stages.find(asStage)
		if idx > 0
			return all_stages[idx - 1]
		endif
	endif
	return ""
endfunction

;----------------HENTAIRIM LABEL FUNCTIONs===============
string function GetStimulationlabel(actor char)
	if !CurrentThread
		return ""
	endif
	return Stimulationlabelarr[CurrentThread.GetPositionIdx(char)]
endfunction

string function GetPenisActionLabel(actor char)
	if !CurrentThread
		return ""
	endif
	return PenisActionLabelarr[CurrentThread.GetPositionIdx(char)]
endfunction

string function GetOralLabel(actor char)
	if !CurrentThread
		return ""
	endif
	return OralLabelarr[CurrentThread.GetPositionIdx(char)]
endfunction

string function GetPenetrationLabel(actor char)
	if !CurrentThread
		return ""
	endif
	return PenetrationLabelarr[CurrentThread.GetPositionIdx(char)]
endfunction

string function GetEndingLabel(actor char)
	if !CurrentThread
		return ""
	endif
	return EndingLabelarr[CurrentThread.GetPositionIdx(char)]
endfunction

Bool Function ActorIsgettingTitfucked(actor char)
	return  Getpenisactionlabel(char) == "STF" || Getpenisactionlabel(char) == "FTF"
endfunction

Bool Function ActorIsgivingtitfuck(actor char)
	return  actorlist[0] == char && (Getpenisactionlabel(actorlist[1]) == "STF" ||  Getpenisactionlabel(actorlist[1]) == "FTF" ||  Getpenisactionlabel(actorlist[2]) == "FTF" ||  Getpenisactionlabel(actorlist[2]) == "FTF")
endfunction

Bool Function ActorIsgettingHandjobbed(actor char)
	return  Getpenisactionlabel(char) == "SHJ" || Getpenisactionlabel(char) == "FHJ"
endfunction

Bool Function ActorIsgettingFootjobbed(actor char)
	return  Getpenisactionlabel(char) == "SFJ" || Getpenisactionlabel(char) == "FFJ"
endfunction

Bool Function ActorIsgettingSuckedOff(actor char)
	return  Getpenisactionlabel(char) == "SMF" || Getpenisactionlabel(char) == "FMF"
endfunction

Bool Function IsgettingPenetrated(actor char)
	return IsGettingAnallyPenetrated(char) || IsGettingVaginallyPenetrated(char)
endfunction

Bool Function IsgettingDoublePenetrated(actor char)
	return GetPenetrationLabel(char) == "SDP" || GetPenetrationLabel(char) == "FDP"
endfunction

Bool Function IsLeadIN(actor char)
	return GetStimulationlabel(char) == "LDI" && GetPenisActionlabel(char) == "LDI" && GetPenetrationlabel(char) == "LDI" && GetOralLabel(char) == "LDI" && GetEndingLabel(char) == "LDI" 
endfunction 

Bool Function IsSuckingoffOther(actor char)
	return GetOralLabel(char) == "SBJ" ||  GetOralLabel(char) == "FBJ"
endfunction

Bool Function IsCowgirl(actor char)
	return GetPenetrationLabel(char) == "SCG" ||  GetPenetrationLabel(char) == "FCG" ||  GetPenetrationLabel(char) == "SAC" ||  GetPenetrationLabel(char) == "FAC"			
endfunction

Bool Function IsEnding(actor char)
	return GetEndingLabel( char) == "ENI" || GetEndingLabel( char) == "ENO"
endfunction

Bool Function IsGettingVaginallyPenetrated(actor char)
	return GetPenetrationLabel(char) == "SVP" || GetPenetrationLabel(char) == "FVP" || GetPenetrationLabel(char) == "SCG" || GetPenetrationLabel(char) == "FCG" || GetPenetrationLabel(char) == "SDP" || GetPenetrationLabel(char) == "FDP"
endfunction

Bool Function IsGettingAnallyPenetrated(actor char)
	return GetPenetrationLabel(char) == "SAP" || GetPenetrationLabel(char) == "FAP"  || GetPenetrationLabel(char) == "SAC" || GetPenetrationLabel(char) == "FAC" || GetPenetrationLabel(char) == "SDP" || GetPenetrationLabel(char) == "FDP"
endfunction

Bool Function IsGivingAnalPenetration(actor char)
	return GetPenisActionLabel(char) == "FDA" || GetPenisActionLabel(char) == "SDA"
endfunction

Bool Function IsGivingVaginalPenetration(actor char)
	return GetPenisActionLabel(char) =="FDV" || GetPenisActionLabel(char) == "SDV"
endfunction


int[] Function GetActorInteractiontypes(actor char)
	;SLPP function to find all interaction types from actor Point of view.
	;clear array
	int[] ActorInteractiontypes
	if !CurrentThread
		return ActorInteractiontypes
	endif
	int z = 0
	while z < actorlist.Length
		if actorlist[z] != char
			printdebug("actor list : " + actorlist)
			printdebug("Interaction Types to merge : " + currentthread.GetInteractionTypes(char , actorlist[z]))
			ActorInteractiontypes = papyrusutil.MergeIntArray(ActorInteractiontypes ,currentthread.GetInteractionTypes(char , actorlist[z]) , true)
		endif
	z += 1
	EndWhile
	printdebug( char.getdisplayname() + "Interaction types from Partner : " + ActorInteractiontypes)
	return ActorInteractiontypes
endfunction 

int[] Function GetActorPartnerInteractiontypes(actor char)
	;SLPP function to find all interaction types from actor's partner Point of view.
	;clear array
	int[] PartnerInteractiontypes
	if !CurrentThread
		return PartnerInteractiontypes
	endif
	int z = 0
	while z < actorlist.Length
		if actorlist[z] != char
			PartnerInteractiontypes = papyrusutil.MergeIntArray(PartnerInteractiontypes , currentthread.GetInteractionTypes(actorlist[z], char ) , true)
		endif
	z += 1
	EndWhile
	printdebug(char.getdisplayname() + " Interaction types to Partner : " + PartnerInteractiontypes)
	return PartnerInteractiontypes
endfunction

function resetexpressions()

int z
while z < actorlist.length
	MfgConsoleFuncExt.resetmfg(actorlist[z]) 
	if MuFacialExpressionExtended.GetVersion() > 0
		MuFacialExpressionExtended.RevertExpression(actorlist[z])
	endif
z += 1
endwhile

endfunction


Int Function FindInt(Int[] arr, Int target)
    Int i = 0
    While i < arr.Length
        If arr[i] == target
            Return i ; Found, return index
        EndIf
        i += 1
    EndWhile
    Return -1 ; Not found
EndFunction

int Function GetLegacyStageNum(String asScene, String asStage)


	string[] all_stages = SexlabRegistry.GetAllStages(asScene)

	if SexlabRegistry.StageExists(asScene, asStage)
		int stage_num = all_stages.find(asStage) + 1
		return stage_num
	else
		
		return 0
	endif
EndFunction

int Function GetLegacyStagesCount(String asScene)
	int stages_count = SexlabRegistry.GetAllStages(asScene).Length
	return stages_count
EndFunction

bool Function isFinalStage()

		return CurrentStageNum >= GetFinalStageNum()
EndFunction

int Function GetFinalStageNum()

	if RunCustomScene
		return CustomSceneTags.length
	else
		string[] AllStages = SexlabRegistry.GetAllStages(currentsceneid)
		
		;look for ending
		
		Bool Foundending
		int FinalStageNum = AllStages.length
		int z = AllStages.length
		while z > 0 && !Foundending
			string tmpendinglabel = HentairimTags.EndingLabel(CurrentSceneid , z , 0)
			if tmpendinglabel == "ENO" || tmpendinglabel == "ENI"
				Foundending = true
				FinalStageNum = z
			endif
			z -= 1
		endwhile

		if !Foundending
			;no EN tags - fall back to SLSB climax annotations from the registry
			string[] climaxstages = SexlabRegistry.GetClimaxStages(currentsceneid, -1)
			if climaxstages && climaxstages.Length > 0
				int maxidx = -1
				int c = 0
				while c < climaxstages.Length
					int idx = AllStages.Find(climaxstages[c])
					if idx > maxidx
						maxidx = idx
					endif
					c += 1
				endwhile
				if maxidx > -1
					FinalStageNum = maxidx + 1
				endif
			endif
		endif

		return FinalStageNum
	endIf
EndFunction

bool Function isAlmostFinalStage()

	return CurrentStageNum >= GetFinalStageNum() - 1
EndFunction

;---------------------------Director's Utility END------------------------

;------------------------------Director's Tools START------------------------
Function ResolveScaling()
	ResetScaling()
	HentairimScaling()
endfunction

String ActionLogsFile  = "ActionLogs/ActionLogs.json"

Function OpenDirectorTools()
	if !CurrentThread 
		return none
	endif
	Int result
    b612_SelectList DirectorTools = GetSelectList()
    String[] Directortoolsarr = StringUtil.Split("Change Stage;Change Animation;Resolve Hentairim Scaling;Actor Position Alignments;Actor Schlong Alignments;Toggle Stage Advance;Save Stage Speed;Debug Tools",";")
	
	result = DirectorTools.Show(Directortoolsarr)
	
	if result == 0 ;Change Stage
		if RunCustomScene 
			ShowCustomStageList()
		else
			ShowStageList()
		endif
    elseif result == 1 ;Change Animation
		;ShowChangePosition()
		OpenChangeAnimationMenu()
	elseif result == 2 ; Resolve Scaling
		ResolveScaling()
		;int z = 0
		;while z < actorList.length
		;	actorList[z].SetScale(GetAnimSpecialScaleValue(z))
		;	z += 1
		;endwhile
	elseif result == 3 ;Actor Alignments
        ShowAlignmentActorList()		
	elseif result == 4 ;Actor Schlong Alignments
		ShowSchlongAlignmentActorList()
	elseif result == 5
		if DirectorCanAdvanceStage
			DirectorCanAdvanceStage = false
			Announce("Advance Stage Paused")
		else
			DirectorCanAdvanceStage = true
			Announce("Advance Stage Resumed")
		endif
	elseif result == 6
		SaveStageSpeed()
	elseif result == 7 ;Open Debug tools
		OpenDebugTools()
	endif
EndFunction

function OpenDebugTools()
	Int result
	b612_SelectList DiagnosticToolsMenu = GetSelectList()
	String[] Menulist = StringUtil.Split("Show Scene Tags;Disable Scene;Stop Animation;Find Animation Without Hentairim Tags;Diagnose Hentairim Tags;Diagnose Director; Toggle SFX Debug",";")
	result = DiagnosticToolsMenu.Show(Menulist)	

	if result == 0 ;Show Scene Tags
		debug.Messagebox( SexLabRegistry.GetSceneName(CurrentSceneID) + " : " + SexLabRegistry.GetSceneTags(CurrentSceneID))
	elseif result == 1 ; Disable scene
		DisableScene(CurrentSceneID)
	elseif result == 2 ;stop animation
		DirectorEndScene()
	elseif result == 3 ;find animation without hentairim tags
		FindAnimationWithoutHentairimTags()
	ElseIf result == 4 ;diagnose hentairim tags
		DiagnoseHentairimTags()
	ElseIf result == 5 ;diagnose Director
		DiagnoseDirector()
	ElseIf result == 6 ; Switch on SFX Debug
		ToggleSFXDebug()
	endif
endfunction

Bool SFXDebug = false

function ToggleSFXDebug()
	if SFXDebug
		SFXDebug = false
	else
		SFXDebug = true
	endif
	
endFunction

Bool Function isSFXDebugTurnedOnByDirector()
	return SFXDebug
EndFunction

Function DiagnoseHentairimTags()

	string Tags = "-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1BFST,-2BFST,-3BFST,-4BFST,-5BFST,-5AFST,-4AFST,-3AFST,-2AFST,-1AFST,-5BSST,-4BSST,-3BSST,-2BSST,-1BSST,-1ASST,-2ASST,-3ASST,-4ASST,-5ASST,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-1BFHJ,-2BFHJ,-3BFHJ,-4BFHJ,-5BFHJ,-1BSHJ,-2BSHJ,-3BSHJ,-4BSHJ,-5BSHJ,-1BSFJ,-2BSFJ,-3BSFJ,-4BSFJ,-5BSFJ,-1BFTF,-2BFTF,-3BFTF,-4BFTF,-5BFTF,-1BSTF,-2BSTF,-3BSTF,-4BSTF,-5BSTF,-1AFBJ,-2AFBJ,-3AFBJ,-4AFBJ,-5AFBJ,-1ASBJ,-2ASBJ,-3ASBJ,-4ASBJ,-5ASBJ,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP"
	;lookup with playing actors
	string[] SceneIDarrWithoutTags = SexLabRegistry.LookupScenesA( currentthread.GetPositions()  ,Tags,  currentthread.GetSubmissives(), 0, none )
	string[] SceneIDarr = SexLabRegistry.LookupScenesA( currentthread.GetPositions()  ,"",  currentthread.GetSubmissives(), 0, none )
	
	int Countwithouttags = SceneIDarrWithoutTags.length
	int TotalCount = SceneIDarr.length
	String Messagestr = "=====Hentairim Tags Diagnostics====="
	int z
	while z < actorList.length
		string sexname
		int sex = Sexlab.GetSex(actorlist[z])
		if sex == 0
			sexname = Actorlist[z].GetDisplayName() + " (Male)"
		elseif sex == 1
			sexname = Actorlist[z].GetDisplayName() +" (Female)"
		elseif sex == 2
			Sexname = Actorlist[z].GetDisplayName() + " (Futa)"
		elseif Sex > 2
			sexname = Actorlist[z].GetDisplayName() + " (" +actorlist[z].GetRace().GetName()+")"
		endif		
		Messagestr += "\n Position " + z + " : " + sexname 
		z += 1
	EndWhile
	 float Incompletepc = Countwithouttags as float / TotalCount as float
	  Messagestr += "\n \n =====Results===== "
	 Messagestr += "\n Total Animations For this Position  : " + TotalCount
	 Messagestr += "\n Total Animations For this Position Without Tags: " + Countwithouttags
	 Messagestr += "\n Percentage of Animations without Hentairim Tags : " + (Incompletepc * 100) as string + "%"
	 debug.MessageBox(Messagestr)
	 Messagestr = ""
	 Messagestr += "=====Director's Message===== "
	 
	 if Incompletepc > 0.9
		Messagestr += "\n a Very high Percentage of your scenes are missing its Hentairim Tags. Hentairim will still function, but You will lose out a lot , A LOT of the intended experience by Hentairim as scenes not without HentairimTags will be treated as lead in"
		Messagestr += "\n its very likely that although you installed SLSB correctly, the Scenes Do not Contain Hentairim Tags, which is likely that you Generated your own SLSB or Downloaded Someone's SLSB release without HentairimTags and did not use the Pre Converted SLSB from the Release Page which already contain the Hentairim Tags."
		Messagestr += "\n Few things you can do :"
		Messagestr += "\n If you Didnt Generate the SLSB Yourself, You can pester the Guy who released the SLSB to include Hentairim Tags in SLSB."
		Messagestr += "\n OR"
		Messagestr += "\n Follow the Step by Step Guide from SLPP Release Page on how to use the Convert.py to Generate SLSB WITH HENTAIRIM TAGS IN SLATE ACTION FILES. You can get the Hentairim Tags SLATE Action log along with the Hentairim Release Page. FOLLOW THE CONVERT.py GUIDE WORD FOR WORD. if you not sure what you are doing, Ask for Help in the SLPP discord." 
	 elseif Incompletepc > 0.30
		Messagestr += "\n a High Percentage of your scenes are missing its Hentairim Tags. you will have mixed experience depending on the scene played which wouldnt be very pleasant."
		Messagestr += "\n If You Generated the SLSB, Add the Hentairim Action Logs which can be retrieved from Hentairim Release Page, and include it into your SLSB Generation. Follow the Convert.py Guide on how to include SLATE Action logs."
		Messagestr += "\n If you didnt Generate the SLSB, you can pester the SLSB Release Guy to include updated Hentairim Tags."
		Messagestr += "\n Download the PreConverted SLSB from SLPP Release Page and use the Matching Animation Packs Version against the Fomod."
	elseif Incompletepc > 0.10
		Messagestr += "\n Most of your Animations have Hentairim Installed, but there is a significant amount to notice"
		Messagestr += "\n Make sure You have Generated/Downloaded the SLSB with the latest Hentairim SLATE Action logs."
	elseif  Incompletepc > 0.05
		Messagestr += "\n Great! a most of Your Scenes Contain Hentairim Tags."
		Messagestr += "\n You can choose to Fine tune by adding in the tags and include in the SLSB Generation."
		Messagestr += "\n if you do add in your tags in missing animation, please do share your SLATE Action log to the Hentairim Board in SLPP Discord or Loverslab Release Page."
	 endIf
	 
		Messagestr += "\n \n \n Note : Hentairim Tags SLATE is missing some tags for some animation as it does not cover Guro animations, explicitly gay animations , and some obscure animation packs."
		Messagestr += "\n You can always Assign the Hentairim Tags yourself by adding them into the action log. Read the Hentairim Guide for its assignment."
		debug.MessageBox(Messagestr)
endfunction

Function DiagnoseDirector()
	String Messagestr = "===== Director Config Diagnostics ====="

	; ===== Expressions =====
	if enableExpressions == 1
		Messagestr += "\nExpressions: Enabled"
	else
		Messagestr += "\nExpressions: Disabled"
	endif

	if enablepcexpression == 1
		Messagestr += "\n - PC Expressions: Enabled"
	else
		Messagestr += "\n - PC Expressions: Disabled"
	endif

	if enablefemalenpcexpression == 1
		Messagestr += "\n - Female NPC Expressions: Enabled"
	else
		Messagestr += "\n - Female NPC Expressions: Disabled"
	endif

	if enablemalenpcexpression == 1
		Messagestr += "\n - Male NPC Expressions: Enabled"
	else
		Messagestr += "\n - Male NPC Expressions: Disabled"
	endif

	; ===== SFX =====
	if EnableSFX == 1
		Messagestr += "\nSFX: Enabled"
	else
		Messagestr += "\nSFX: Disabled"
	endif

	; ===== Resistance =====
	if enableResistance == 1
		Messagestr += "\nAggression Resistance: Enabled"
	else
		Messagestr += "\nAggression Resistance: Disabled"
	endif

	if enablepcresistancedamage == 1
		Messagestr += "\n - PC Damage: Enabled"
	else
		Messagestr += "\n - PC Damage: Disabled"
	endif

	if enablemalenpcresistancedamage == 1
		Messagestr += "\n - Male NPC Damage: Enabled"
	else
		Messagestr += "\n - Male NPC Damage: Disabled"
	endif

	if enablefemalenpcresistancedamage == 1
		Messagestr += "\n - Female NPC Damage: Enabled"
	else
		Messagestr += "\n - Female NPC Damage: Disabled"
	endif

	if enablecreaturenpcresistancedamage == 1
		Messagestr += "\n - Creature NPC Damage: Enabled"
	else
		Messagestr += "\n - Creature NPC Damage: Disabled"
	endif

	; ===== Director Controls =====
	if enableautoadvancestage == 1
		Messagestr += "\nAuto-Advance Stage: Enabled"
	else
		Messagestr += "\nAuto-Advance Stage: Disabled"
	endif

	if enablearmorswap == 1
		Messagestr += "\nArmor Swap: Enabled"
	else
		Messagestr += "\nArmor Swap: Disabled"
	endif

	if enablehentairimscaling == 1
		Messagestr += "\nHentairim Scaling: Enabled"
	else
		Messagestr += "\nHentairim Scaling: Disabled"
	endif

	if resetsmp == 1
		Messagestr += "\nReset SMP: Enabled"
	else
		Messagestr += "\nReset SMP: Disabled"
	endif

	if resetsexassignment == 1
		Messagestr += "\nReset Sex Assignment: Enabled"
	else
		Messagestr += "\nReset Sex Assignment: Disabled"
	endif

	; ===== Stage Maker =====
	if enablestagemaker == 1
		Messagestr += "\nStage Maker: Enabled"
	else
		Messagestr += "\nStage Maker: Disabled"
	endif

	Messagestr += "\n - Chance to Use Custom Stage: " + chancetousecustomstage + "%"
	debug.messagebox(Messagestr)
	messagestr = ""
	; ===== Timers =====
	Messagestr += "\n\n===== Timers (seconds) ====="
	Messagestr += "\nLDI: " + ldi
	Messagestr += "\nSST: " + sst
	Messagestr += "\nFST: " + fst
	Messagestr += "\nBST: " + bst
	Messagestr += "\nKIS: " + kis
	Messagestr += "\nCUN: " + cun
	Messagestr += "\nSBJ: " + sbj
	Messagestr += "\nFBJ: " + fbj
	Messagestr += "\nSAP: " + sap
	Messagestr += "\nSVP: " + svp
	Messagestr += "\nFAP: " + fap
	Messagestr += "\nFVP: " + fvp
	Messagestr += "\nSDP: " + sdp
	Messagestr += "\nFDP: " + fdp
	Messagestr += "\nSCG: " + scg
	Messagestr += "\nSAC: " + sac
	Messagestr += "\nFCG: " + fcg
	Messagestr += "\nFAC: " + fac
	Messagestr += "\nSDV: " + sdv
	Messagestr += "\nSDA: " + sda
	Messagestr += "\nFDV: " + fdv
	Messagestr += "\nFDA: " + fda
	Messagestr += "\nSHJ: " + shj
	Messagestr += "\nFHJ: " + fhj
	Messagestr += "\nSTF: " + stf
	Messagestr += "\nFTF: " + ftf
	Messagestr += "\nSMF: " + smf
	Messagestr += "\nFMF: " + fmf
	Messagestr += "\nSFJ: " + sfj
	Messagestr += "\nFFJ: " + ffj
	Messagestr += "\nENO: " + eno
	Messagestr += "\nENI: " + eni
	debug.messagebox(Messagestr)
	messagestr = ""
	; ===== Foreplay Weights =====
	Messagestr += "\n\n===== Foreplay Weights ====="
	Messagestr += "\nHandjob: " + foreplayhandjobweight
	Messagestr += "\nTitfuck: " + foreplaytitfuckweight
	Messagestr += "\nFootjob: " + foreplayfootjobweight
	Messagestr += "\nBlowjob: " + foreplayblowjobweight

	; ===== Linear Scene Settings =====
	Messagestr += "\n\n===== Linear Scene Factors ====="
	Messagestr += "\nFinal Stage Orgasm Factor: " + linearscenefinalstageorgasmfactor
	;Print Orgasm Factor of each Actor
	
	int z
	while z < Actorlist.length
		Float ActorOrgasmFactor = GetOrgasmFactor(actorList[z])
		Messagestr += "\n--" + actorList[z].getdisplayname()
		Messagestr += "\n----Linear Stage Orgasm Factor : " + ActorOrgasmFactor
		Messagestr += "\n----Current Enjoyment : " + currentthread.GetEnjoyment(actorList[z])
		Messagestr += "\n----Enjoyment After Orgasm Factor : " + currentthread.GetEnjoyment(actorList[z]) * ActorOrgasmFactor
		z += 1
	EndWhile
	
	; ===== Stage Extension ===== ExtendStageChance
	Messagestr += "\n\n===== Stage Extensions ====="
	Messagestr += "\nExtend Stage Chance: " + linearsceneextendstagechance + "%"
	z = 0
	while z < Actorlist.length
		Messagestr += "\n--" + actorList[z].getdisplayname() 
		int ActorExtendStageChance = (ExtendStageChance(actorList[z]) * 100 ) as int
		if actorList[z] == playerref
			Messagestr += "\n----Player Cannot Extend Stage."
		else
			Messagestr += "\n---Extend Stage Chance : " + ActorExtendStageChance
			if  GetControllingActor() && ActorExtendStageChance > 0
				Messagestr += "\n----"+ actorList[z].getdisplayname() +" is Controlling & Extend Stage chance is "+ ActorExtendStageChance+"%. Extend Scene Might Happen"
			else
				Messagestr += "\n----"+ actorList[z].getdisplayname() +" is Not Controlling or Extend Stage chance is 0%. Extend Scene Wont Happen"
			endif
		endIf
		z += 1
	EndWhile
	
	Messagestr += "\nCounter Rape Chance: " + linearscenecounterrapechance + "%"
	z = 0
	while z < Actorlist.length
		Messagestr += "\n--" + actorList[z].getdisplayname() 
		int ActorCounterrapechance = (CounterRapeChance(actorList[z]) * 100) as int
		if actorList[z] == playerref
			Messagestr += "\n----Player Cannot Counter Rape Others."
		else
			Messagestr += "\n----Counter Rape Chance : " + ActorCounterrapechance
			if currentthread.GetSubmissive(playerref)
				Messagestr += "\n----Player is Victim. Counter Rape Wont Happen"
			elseif currentthread.GetSubmissive(actorList[z]) && ActorCounterrapechance > 0
				Messagestr += "\n----"+ actorList[z].getdisplayname() +" is Victim & Counter Rape Chance is " +ActorCounterrapechance +". Counter Rape Might Happen"
			else
				Messagestr += "\n----"+ actorList[z].getdisplayname() +" is Not Victim or Counter Rape Chance is 0. Counter Rape Wont Happen"
			endif
		endIf
		z += 1
	EndWhile
	debug.messagebox(Messagestr)
	messagestr = ""
EndFunction


Function OpenChangeAnimationMenu()
	Int result
	b612_SelectList ChangeAnimationMenu = GetSelectList()
	String[] Menulist = StringUtil.Split("Find Animation by Positions;Find Animation by Name Or Tags;Find Custom Scenes",";")
		
	result = ChangeAnimationMenu.Show(Menulist)
	
	if result == 0
		ShowChangePosition()
	elseif result == 1
		FindAnimationbyNameorTags()
	elseif result == 2
		FindCustomScene()
	endif
endfunction	

Function FindAnimationbyNameorTags()
	UITextEntryMenu InputBox = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
	Inputbox.OpenMenu()
	string lookup = Inputbox.GetResultString() 
	 String ResultScene = SexlabRegistry.GetSceneByName(lookup) ; first try finding the animation by name
	 if ResultScene != "" ;found a scene with input name
		 currentthread.ResetScene(ResultScene)
		 RunCustomScene = false
	 elseif ResultScene == "" ;if no scene found with name input, search by tags instead.
		LookupAnimation(lookup)
	 EndIf
endfunction


Function FindCustomScene()
	string[] CustomSceneList = FindValidCustomScene(true)
	if CustomSceneList.length > 0
		UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
		int z
		while z < CustomSceneList.length
			ListMenu.AddEntryItem(CustomSceneList[z])
		z += 1
		EndWhile

		;open menu
		ListMenu.OpenMenu()	
		
		Int Selected = ListMenu.GetResultInt()
		if Selected >= 0
			CustomSceneTags = papyrusutil.stringsplit(CustomSceneList[Selected] , "|")	
			CustomStageNum = 0
			RunCustomScene = true
			MovetoNextCustomStage()	
		endif	
	else
		announce("No Valid Custom Scenes Found")
	endif
endfunction

Function Announce(String Content , string icon = "icon.dds" ,float delay = 2.0 ,String PlaySFX = "")

	GetAnnouncement().Show(Content,icon, delay)
	
	if PlaySFX == "Buzzer"
		Buzzer.Play(Playerref)
	elseif PlaySFX == "Chime"
		Chime.Play(Playerref)
	elseif PlaySFX == "BadOutcome"
		Badoutcome.Play(Playerref)
	elseif PlaySFX == "Bell"
		Bell.Play(Playerref)
	elseif PlaySFX == "Fanfare"
		Fanfare.Play(Playerref)
	elseif PlaySFX == "Notification"
		Notification.Play(Playerref)
	elseif PlaySFX != ""
		printdebug("Invalid PlaySFX : " + PlaySFX) 
	endif

endfunction


;/
target: target refr to set for
scale: time scale of animation speed, 1.0 is normal and 0.5 is 50% speed, negative is now allowed to play animation in reverse
transition: time in seconds until this speed is reached
absolute: time in seconds is fixed or not, if nonzero then it takes exactly this
          many seconds to reach target speed, if zero then it takes
		  speedDiff * transition seconds. Just set 0 if you don't understand :P
 /;

Function SaveStageSpeed()
	jsonutil.SetFloatValue("HentairimDirector/StageSpeed.json",SexlabRegistry.GetSceneName(CurrentSceneID) +"|"+CurrentStageNum,HentairimAnimSpeed.GetSpeed(PlayerRef, false))	
	Announce("Stage Speed Saved")
endfunction

Function LoadStageSpeed()
	float speed	= jsonutil.GetFloatValue("HentairimDirector/StageSpeed.json",SexlabRegistry.GetSceneName(CurrentSceneID) +"|"+CurrentStageNum, 0.0)
	printdebug("Saved Stage Speed :" + Speed)
if Speed > 0
	printdebug("Applying Stage Speed to all Actors")
	int z = 0
	while z < actorList.length
		HentairimAnimSpeed.SetSpeed(actorList[z], speed, 0.5, 0)
		z += 1
	endwhile
else
	printdebug("No Saved Speed. Resetting Speed to default")
	ResetAnimationSpeed()
endIf

endfunction

Function ResetAnimationSpeed()
	int z = 0
	while z < actorList.length
		HentairimAnimSpeed.SetSpeed(actorList[z], 1.0, 0.5, 0)
		z += 1
	endwhile
	
endfunction

Function AddCombatRape()

	Spell CombatRapeTrackerSpell =  Game.GetFormFromFile(0x801, "Hentairim Director.esp") as Spell

	if !Playerref.hasspell(CombatRapeTrackerSpell)
		Playerref.addspell(CombatRapeTrackerSpell)
	EndIf
endfunction

Function AddHentairimAdventures()

	Spell hentairimAdventureSpell =  Game.GetFormFromFile(0x828, "Hentairim Director.esp") as Spell
	
	if !Playerref.hasspell(hentairimAdventureSpell)
		Playerref.addspell(hentairimAdventureSpell)
	EndIf
endfunction

Bool Function AdventureEnabled()
	String AdventureConfig = "HentairimAdventure/config.json"
	
	return JsonUtil.GetIntValue(AdventureConfig, "enableadventure", 0) == 1
endFunction

Function LogActionToFile(String actionLine) ;Store SLATE Action Tags for Hentairim
	   
	   If (JsonUtil.StringListAdd("HentairimDirector/ActionLogs.json", "SLATE.ActionLog", actionLine, TRUE) < 0)
            announce("Error: failed to add " + actionLine + " to action-log file ")
        EndIf
EndFunction

Function LookupAnimation(string Tags = "")
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	string CurrentSceneName = SexlabRegistry.GetSceneName(CurrentSceneID)
	
	;lookup with playing actors
	string[] SceneIDarr = SexLabRegistry.LookupScenesA( currentthread.GetPositions()  ,Tags,  currentthread.GetSubmissives(), 0, none )
	
	if SceneIDarr.length > 0
		int z
		while z < SceneIDarr.length
			
			if currentsceneid == SceneIDarr[z]
				ListMenu.AddEntryItem(">>>" +SexlabRegistry.GetSceneName(SceneIDarr[z])+"<<<")
			else
				ListMenu.AddEntryItem(SexlabRegistry.GetSceneName(SceneIDarr[z]))
			EndIf
		z += 1
		endwhile

		ListMenu.OpenMenu()
		Int Selected = ListMenu.GetResultInt()
		if Selected >= 0
			currentthread.ResetScene(SceneIDarr[Selected])
			RunCustomScene = false
		endif
	endif
EndFunction


Function FindAnimationWithoutHentairimTags()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	string CurrentSceneName = SexlabRegistry.GetSceneName(CurrentSceneID)
	
	string Tags = "-4AKIS,-3AKIS,-2AKIS,-1AKIS,-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1BFST,-2BFST,-3BFST,-4BFST,-5BFST,-5AFST,-4AFST,-3AFST,-2AFST,-1AFST,-5BSST,-4BSST,-3BSST,-2BSST,-1BSST,-1ASST,-2ASST,-3ASST,-4ASST,-5ASST,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-1BFHJ,-2BFHJ,-3BFHJ,-4BFHJ,-5BFHJ,-1BSHJ,-2BSHJ,-3BSHJ,-4BSHJ,-5BSHJ,-1BSFJ,-2BSFJ,-3BSFJ,-4BSFJ,-5BSFJ,-1BFTF,-2BFTF,-3BFTF,-4BFTF,-5BFTF,-1BSTF,-2BSTF,-3BSTF,-4BSTF,-5BSTF,-1AFBJ,-2AFBJ,-3AFBJ,-4AFBJ,-5AFBJ,-1ASBJ,-2ASBJ,-3ASBJ,-4ASBJ,-5ASBJ,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP"
	;lookup with playing actors
	string[] SceneIDarr = SexLabRegistry.LookupScenesA( currentthread.GetPositions()  ,Tags,  currentthread.GetSubmissives(), 0, none )
	
	if SceneIDarr.length > 0
		int z
		while z < SceneIDarr.length
			ListMenu.AddEntryItem(SexlabRegistry.GetSceneName(SceneIDarr[z]))
		z += 1
		endwhile

		ListMenu.OpenMenu()
		Int Selected = ListMenu.GetResultInt()
		if Selected >= 0
			currentthread.ResetScene(SceneIDarr[Selected])
			RunCustomScene = false
		endif
	endif
EndFunction

Actor AdjustingSchlongActor
Function AdjustSchlongDirection(Bool Reverse = false)
	int AdjustmentValue = GetSchlongAdjustment(AdjustingSchlongActor)
	
;Add or minus 1 for every call
	if Reverse
		AdjustmentValue -= 1
	else
		AdjustmentValue += 1
	endif 
	;clamp to 9
	if AdjustmentValue > 9
		AdjustmentValue = 9
	elseif AdjustmentValue < -9
		AdjustmentValue = -9
	endif

	if AdjustmentValue <= 9 && AdjustmentValue >= -9
		printdebug("ActortoAdjust Schlong AdjustmentValue: " + AdjustmentValue)
		Debug.SendAnimationEvent(AdjustingSchlongActor, "SOSBend" + AdjustmentValue as string)
		SaveSchlongAdjustment(currentthread.GetPositionIdx(AdjustingSchlongActor) , AdjustmentValue)
		printdebug("Applied Schlong Adjustments")
	else
		printdebug("Bad Schlong Adjustment Value Input. Value must be between -9 and 9")
		Announce("Bad Schlong Adjustment Value Input. Value must be between -9 and 9")
	endIf
EndFunction

Function ShowSchlongAlignmentActorList()
	b612_SelectList Actorlistmenu = GetSelectList()
	b612_QuantitySlider AdjustmentValueSlider = GetQuantitySlider()
	String[] ActorlistNames
	
	int z = 0
	while z < actorlist.Length
			if actorlist[z] == AdjustingSchlongActor
				ActorlistNames = papyrusutil.pushstring(ActorlistNames , actorlist[z].getdisplayname() + " (Selected)")
			else
				ActorlistNames = papyrusutil.pushstring(ActorlistNames , actorlist[z].getdisplayname())
			endif
		z += 1
	endWhile
	
	;Show Actor List
	actor ActortoAdjust
	int position = Actorlistmenu.Show(ActorlistNames)
	if position <= -1
		return
	else
		AdjustingSchlongActor = actorlist[position]
	EndIf
		Announce("Actor to Adjust Schlong Changed To " + AdjustingSchlongActor.getdisplayname())

endFunction
;/
Function ShowSchlongAlignmentActorList()
	b612_SelectList Actorlistmenu = GetSelectList()
	b612_QuantitySlider AdjustmentValueSlider = GetQuantitySlider()
	String[] ActorlistNames
	
	int z = 0
	while z < actorlist.Length
			ActorlistNames = papyrusutil.pushstring(ActorlistNames , actorlist[z].getdisplayname())
		z += 1
	endWhile
	
	;Show Actor List
	actor ActortoAdjust
	int position = Actorlistmenu.Show(ActorlistNames)
	if position <= -1
		return
	else
		ActortoAdjust = actorlist[position]
	EndIf
		printdebug("ActortoAdjust Schlong : " + ActortoAdjust.getdisplayname())

		;Actor has Schlong or Strap on. Open UI for value input
		UITextEntryMenu InputBox = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
		Inputbox.OpenMenu()
		int AdjustmentValue = Inputbox.GetResultString() as int
		;int AdjustmentValue = AdjustmentValueSlider.show("Adjust Schlong Position",-9,9)
		if AdjustmentValue > 9
			AdjustmentValue = 9
		elseif AdjustmentValue < -9
			AdjustmentValue = -9
		endif
		
		if AdjustmentValue <= 9 ||  AdjustmentValue >= -9
			printdebug("ActortoAdjust Schlong AdjustmentValue: " + AdjustmentValue)
			Debug.SendAnimationEvent(ActortoAdjust, "SOSBend" + AdjustmentValue as string)
			SaveSchlongAdjustment(currentthread.GetPositionIdx(ActortoAdjust) , AdjustmentValue)
			printdebug("Applied Schlong Adjustments")
		else
			printdebug("Bad Schlong Adjustment Value Input. Value must be between -9 and 9")
			Announce("Bad Schlong Adjustment Value Input. Value must be between -9 and 9")
		endIf

endFunction
/;

Function SaveSchlongAdjustment(int position, int value)
	string sceneName = SexlabRegistry.GetSceneName(CurrentSceneID)
	int stageNum = CurrentStageNum
	string strkey = sceneName + "|" + stageNum + "|" + position

	printdebug("======================= [SaveSchlongAdjustment] Saving Schlong Adjustment =======================")
	printdebug("[SaveSchlongAdjustment] Scene Name : " + sceneName)
	printdebug("[SaveSchlongAdjustment] Stage Num  : " + stageNum)
	printdebug("[SaveSchlongAdjustment] Position   : " + position)
	printdebug("[SaveSchlongAdjustment] Value      : " + value)
	printdebug("[SaveSchlongAdjustment] JSON Key   : " + strkey)
	printdebug("-------------------------------------------------------------------")

	jsonutil.SetIntValue("HentairimDirector/SchlongAdjustment.json", strkey, value)

	printdebug("[SaveSchlongAdjustment] Successfully saved Schlong Adjustment to JSON file")
	printdebug("======================= [SaveSchlongAdjustment] Save Process Complete =======================")
endFunction


int Function GetSchlongAdjustment(Actor char)
	int pos = Currentthread.GetPositionIdx(char)
	
	return jsonutil.GetIntValue("HentairimDirector/SchlongAdjustment.json",SexlabRegistry.GetSceneName(CurrentSceneID) +"|"+CurrentStageNum+"|"+pos, 0)

endfunction

Function LoadSchlongAdjustment()
	int z
	string sceneName = SexlabRegistry.GetSceneName(CurrentSceneID)
	int stageNum = CurrentStageNum

	printdebug("======================= [LoadSchlongAdjustment] Starting Load Process =======================")
	printdebug("Scene: " + sceneName + " | Stage: " + stageNum)
	printdebug("Actor count: " + actorList.Length)
	printdebug("-------------------------------------------------------------------")

	while z < actorList.Length
		actor ActorToAdjust = actorList[z]
		string strkey = sceneName + "|" + stageNum + "|" + z

		Int Adjustment = jsonutil.GetIntValue("HentairimDirector/SchlongAdjustment.json", strkey, 0)
		
		printdebug("[LoadSchlongAdjustment] Checking position index: " + z)
		printdebug("[LoadSchlongAdjustment] Actor: " + ActorToAdjust)
		printdebug("[LoadSchlongAdjustment] Key used: " + strkey)
		printdebug("[LoadSchlongAdjustment] Retrieved Adjustment Value: " + Adjustment)

		if Adjustment != 0
			string animEvent = "SOSBend" + Adjustment as string
			Debug.SendAnimationEvent(ActorToAdjust, animEvent)
			printdebug("[LoadSchlongAdjustment] >>> Applied Animation Event: " + animEvent)
		else
			printdebug("[LoadSchlongAdjustment] --- No saved Schlong Adjustment found for position " + z)
		endIf

		printdebug("-------------------------------------------------------------------")
		z += 1
	endWhile		

	printdebug("======================= [LoadSchlongAdjustment] Load Process Complete =======================")
endFunction


Function ShowAlignmentActorList()
	b612_SelectList Actorlistmenu = GetSelectList()
	;prepare Actorlist Names
	String[] ActorlistNames = new string[1]
	if IsStageOffset
		ActorlistNames[0] = "Stage Alignment"
	else
		ActorlistNames[0] = "Scene Alignment"
	endif
	
	int z = 0
	while z < actorlist.Length
		if PositionsToAlign.find(z) >= 0 ; in the arr to align
			ActorlistNames = papyrusutil.pushstring(ActorlistNames , actorlist[z].getdisplayname()+"(Selected)")
		else
			ActorlistNames = papyrusutil.pushstring(ActorlistNames , actorlist[z].getdisplayname()+"(Not Selected)")
		endif
		z += 1
	endWhile
	
	;Show Actor List
	int position = Actorlistmenu.Show(ActorlistNames)
	if position <= -1
		return
	EndIf
	
	;Toggle Scene or stage offset
	if position == 0
		if IsStageOffset
			IsStageOffset = false
			Announce("Actor Alignment by Scene")
		else
			IsStageOffset = true
			Announce("Actor Alignment by Stage")
		endif
		return
	endif
	
	;remove or add positions to be aligned
	position -= 1
	if PositionsToAlign.find(position) >= 0 ;remove from actors to Align if existing
		PositionsToAlign = papyrusutil.removeint(PositionsToAlign,position)
		debug.notification("Position " + position + " Removed For Alignment Function")
	else
		PositionsToAlign = papyrusutil.pushint(PositionsToAlign,position)
		debug.notification("Position " + position + " Added For Alignment Function")
	endif	
endfunction

Function ShowCustomStageList()
	b612_SelectList CustomStagesMenuList = GetSelectList()
	
	;prepare Custom Stages
	
	String[] CustomStagesList
	string[] StagesNumList
	int x = 1 ;skip first item with lookup criteria
	while x < customscenetags.length
		if CustomStageNum == x
			CustomStagesList = papyrusutil.pushstring(CustomStagesList,">>>"+"Custom Stage"+ x + " = " +customscenetags[x]+"<<<")
		else
			CustomStagesList = papyrusutil.pushstring(CustomStagesList,"Custom Stage"+ x + " = " +customscenetags[x])
		endif
		x += 1
	EndWhile

	;position of the selected item
	int selected = CustomStagesMenuList.Show(CustomStagesList)
	if selected >= 0
		CustomStageNum = selected + 1
		MovetoNextCustomStage()
	endif
endfunction

Function ShowStageList()
	b612_SelectList StagesMenuList = GetSelectList()
	;prepare Stages
	String[] StagesIDList = SexlabRegistry.GetAllStages(CurrentSceneID)
	string[] StagesNumList
	int z = 0
	
	while z < StagesIDList.Length
		if currentstageid == StagesIDList[z]
			StagesNumList = papyrusutil.pushstring(StagesNumList, ">>>Stage " + (z + 1)+"<<<" as string)
		else
			StagesNumList = papyrusutil.pushstring(StagesNumList, "Stage " + (z + 1) as string)
		endif
		z += 1
	endWhile
	
	;position of the selected stage
	int StagePosition = StagesMenuList.Show(StagesNumList)
	if StagePosition >= 0
		CurrentThread.SkipTo(StagesIDList[StagePosition]) ;unintended behavior to reset the stage when no stage is selected
	endif
endfunction

Function TeleportToRandomStageWithSimilarPositions() 

	int DestinationStage
	string tags 
	
	;whether if its standing or kneeling or laying
	if currentthread.HasSceneTag("Standing")
		tags += "Standing,"
	elseif currentthread.HasSceneTag("laying")
		tags += "Laying,"
	elseif currentthread.HasSceneTag("kneeling")
		tags += "Kneeling,"
	EndIf
	;whether if its aggressive
	if currentthread.HasSceneTag("Aggressive") && !currentthread.HasSceneTag("femdom")
		tags += "Aggressive,"
	EndIf
	;Whether if its Doggystyle or spooning
	if  currentthread.HasSceneTag("femdom")
		tags += "femdom,"
	elseif currentthread.HasSceneTag("Doggystyle") || currentthread.HasSceneTag("Doggy")
		tags += "~Doggystyle,~Doggy,~Doggystyle,"
	elseif currentthread.HasSceneTag("Spooning")
		tags += "Spooning,"
	endif
	
	;Finally Add the current Hentairim tags
	String HentairimLabeltoLookFor 
	
	;goes back to the same stage number with same intensity
	HentairimLabeltoLookFor = CurrentStageNum + "A" + PenetrationLabel
	
	tags +=  HentairimLabeltoLookFor
	TeleportToRandomStageWithTags(tags , CurrentStageNum)
	
endfunction

; Tags example : Doggy, Standing,-laying,3BSVP
bool Function TeleportToRandomStageWithTags(String Tags , int StartFromStage = 1) 
	printdebug("Tags to Teleport :" + Tags)
	printdebug("Stage Num to teleport to :" + StartFromStage)
	string[] SceneIDarr =  SexLabRegistry.LookupScenesA( currentthread.GetPositions()  ,Tags,  currentthread.GetSubmissives(), 0, none )
	
	if SceneIDarr.length > 0
		String SelectedSceneID = SceneIDarr[Utility.Randomint(0, SceneIDarr.length - 1)]
		String[] StagesIDarr = SexlabRegistry.GetAllStages(SelectedSceneID)
		currentthread.ResetScene(SelectedSceneID) ;resets to stage 1 by default
		CurrentThread.SkipTo(StagesIDarr[StartFromStage - 1])
		RunCustomScene = false ;stop running custom stage
		isPlayingForeplayScene = false ;stop identifying as foreplay
		DoneLinearSceneOrgasm = false; Reset Linear Scene Orgasm
		return true
	else
		printdebug("No Scene Found with Tags : " + Tags)
		WritetoErrorlogs("Director", "No Scene Found with Tags : " + Tags)
		return false
	endIf
	
endfunction

bool Function TeleportToSceneWithName(String SceneName , int StartFromStage = 1) 

	String ResultSceneID = SexlabRegistry.GetSceneByName(SceneName)

	if ResultSceneID != ""
		printdebug("Teleporting to SceneName : " + SceneName + ", Stage : " + StartFromStage)
		String[] StagesIDarr = SexlabRegistry.GetAllStages(ResultSceneID)
		currentthread.ResetScene(ResultSceneID) ;resets to stage 1 by default
		CurrentThread.SkipTo(StagesIDarr[StartFromStage - 1])
		return true
	else
		printdebug("No Scene Found with " + SceneName)
		return false
	endIf
	
endfunction

bool Function PCisVictim()
	return CurrentThread.GetSubmissive(playerref)
EndFunction

bool Function isVictim(actor char)
	return CurrentThread.GetSubmissive(char)
EndFunction

bool Function PCisAggressor()
	 actor[] victimlist = CurrentThread.GetSubmissives()
	 int z = 0
	 while z < victimlist.length
		if victimlist[z] == playerref
			return false
		endif
		z += 1
	 endwhile
	 
	if victimlist.length > 0
		return true
	else
		return  false
	endif
EndFunction

; TriggerUpdate for CF to work around penis reverting from SL PP
function CFTriggerUpdate(actor char)
	; Get the framework script
	CreatureFramework CF = Game.GetFormFromFile(0xD62, "CreatureFramework.esm") as CreatureFramework
	if CF
		CF.TriggerUpdateForActor(char)
	else
		WritetoErrorlogs("Director" , "Missing Creature Framework Make sure the Plugin is Enabled or Reinstall.")
	endif
endFunction

Function TriggerUpdateforCreatures()
	int z
	while z < actorlist.length
		if sexlab.GetSex(actorList[z]) > 2
			CFTriggerUpdate(actorList[z])
		endif
	z += 1
	endwhile
	
endfunction

Bool Function IsBroken(actor char)
	return char.GetFactionRank(HentairimBroken) > 0
endfunction

Function CheckStatus()

int ResistancePoints = playerref.GetFactionRank(HentairimResistanceFaction)
int BrokenPoints = playerref.GetFactionRank(HentairimBroken)
string msg 
if PCisVictim
	msg += "You are a Victim! \n"
elseif PCisAggressor 
	msg += "You are an Aggressor! \n"
else
	msg += "You are in Consensual! \n"
endif
msg += "Resistance Points: " + ResistancePoints + "\n"
if BrokenPoints > 0
	msg += "Broken Status : You Are Broken ! Hours Without Sex to Recover : " + BrokenPoints + "\n"
else
	msg += "Broken Status : You are Sane \n"
endIf
Debug.MessageBox(msg)
endFunction


String Function ShowChangePosition()
	if !CurrentThread 
		return none
	endif
	Int TypearrID
	int PositionarrID
    b612_SelectList PositionList = GetSelectList()
	String[] Typearr
	String[] Positionarr
	Typearr = StringUtil.Split("Vaginal;Anal;Oral;Boobjob;Handjob;Lesbian;Futa;Any",";")
	Positionarr = StringUtil.Split("Standing;Kneeling;Laying;Sitting;Doggystyle;Cowgirl;Missionary;Any",";")
	TypearrID = PositionList.Show(Typearr) 
	PositionarrID = PositionList.Show(Positionarr)
	string randomstage = Utility.randomint(2,3) as string
	String HentairimTag
	
	if Typearr[TypearrID] == "any"
		Typearr[TypearrID] = "-a"
	endIf
	
	if Positionarr[PositionarrID] == "any"
		Positionarr[PositionarrID] = "-b"
	endIf
	
	string tags = Positionarr[PositionarrID] + "," + Typearr[TypearrID]
	
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	string[] SceneIDarr =  SexLabRegistry.LookupScenesA( currentthread.GetPositions()  ,Tags,  currentthread.GetSubmissives(), 0, none )
	if SceneIDarr.length > 0
		int z
		while z < SceneIDarr.length
			
			if currentsceneid == SceneIDarr[z]
				ListMenu.AddEntryItem(">>>" +SexlabRegistry.GetSceneName(SceneIDarr[z])+"<<<")
			else
				ListMenu.AddEntryItem(SexlabRegistry.GetSceneName(SceneIDarr[z]))
			EndIf
		z += 1
		endwhile
		
		;open menu
		ListMenu.OpenMenu()
		Int Selected = ListMenu.GetResultInt()
		if Selected >= 0
			currentthread.ResetScene(SceneIDarr[Selected])
			RunCustomScene = false
		endif
	endif
endfunction

Bool function HasSexlabArousal()
	return Game.GetModbyName("SexlabAroused.esm") != 255
endfunction

function UpdateArousal(Actor char, int value)
if !HasSexlabArousal()
	return
endif
	
	Quest OSLArousalQuest = Game.GetFormFromFile(0x4290F, "SexlabAroused.esm") as Quest
    slaFrameworkScr SLAFramework = OSLArousalQuest as slaFrameworkScr
	
	if SLAFramework != none
		SLAFramework.UpdateActorExposure(char, value)
	else
		miscutil.printconsole("Something is Wrong! SLAFramework Script is none! looks like its not installed")
	endif
	
endfunction


bool Function PCIsInControl()
	return ActorInControl() == playerref
endfunction

int Function PositionInControl()
	if (CurrentThread.HasSceneTag("Cowgirl") || CurrentThread.HasSceneTag("femdom") || CurrentThread.HasSceneTag("Amazon")) || (IsSuckingoffOther(actorlist[0]) && !CurrentThread.HasSceneTag("Forced"))
		return 0
	else
		return 1
	endif
endfunction

Actor Function ActorInControl()
	if (CurrentThread.HasSceneTag("Cowgirl") || CurrentThread.HasSceneTag("femdom") || CurrentThread.HasSceneTag("Amazon")) || (IsSuckingoffOther(actorlist[0]) && !CurrentThread.HasSceneTag("Forced"))
		return actorlist[0]
	else
		return actorlist[1]
	endif
endfunction

Function ForceOrgasm(actor char)
	int pos
	pos = CurrentThread.getpositionidx(char)
	if pos >= 0
		threadcontroller.ActorAlias[pos].DoOrgasm(true)
	endif

endfunction

Function LinearEndStageForceOrgasm()
    actor[] tmpCummingActorlist = actorList
    int[] orgasmCount
    int[] maleIndexes
    int[] femaleIndexes

    PrintDebug("=== Starting LinearEndStageForceOrgasm ===")

    ;------------------------------------------------
    ; Build orgasmCount and split actors by gender
    ;------------------------------------------------
    int i = 0
    while i < tmpCummingActorlist.Length
        float enjoy = CurrentThread.GetEnjoyment(tmpCummingActorlist[i]) as float 
        PrintDebug("Actor " + i + " initial enjoyment: " + enjoy)
			;huge pp addiction
		if	!CanActorSatisfyPCHugePPAddiction(actorlist[1])
			enjoy = 0
		elseif enjoy < 100 && linearsceneenjoymentendstagetopup == 1
			enjoy = 100
		elseif tmpCummingActorlist[i] == PlayerRef
			enjoy = 100
		elseif enjoy > 500
			enjoy = 500
		endif
		;Add Enjoyment Factor
		if tmpCummingActorlist[i] != PlayerRef
			Enjoy = Enjoy * GetOrgasmFactor(tmpCummingActorlist[i])
		endif
		bool CanOrgasm = true
		
		CanOrgasm = LinearSceneCanOrgasm(tmpCummingActorlist[i])
		
        if SexLab.GetSex(tmpCummingActorlist[i]) == 1 ; Female
            if CanOrgasm
				femaleIndexes = PapyrusUtil.PushInt(femaleIndexes, i)
			endif
        else ; Male
			if CanOrgasm
				maleIndexes = PapyrusUtil.PushInt(maleIndexes, i)
			endif
        endif

        int orgasms = math.ceiling(enjoy) / 100
        orgasmCount = PapyrusUtil.PushInt(orgasmCount, orgasms)
        PrintDebug("Actor " + i + " initial orgasm count: " + orgasms)
        i += 1
    endwhile

    ;------------------------------------------------
    ; Compute total male orgasms and choose insertion point
    ;  insertionPoint is somewhere in the middle third of total male orgasms.
    ;------------------------------------------------
    int totalMaleOrgasms = 0
    i = 0
    while i < maleIndexes.Length
        totalMaleOrgasms += orgasmCount[maleIndexes[i]]
        i += 1
    endwhile

    ; Ensure we have a sensible insertion range
    int minInsert = Max(1, Math.Ceiling(totalMaleOrgasms / 3.0)) ; at least 1
    int maxInsert = Max(minInsert, Math.Floor((2 * totalMaleOrgasms) / 3.0))
    int insertionPoint = 0
    if totalMaleOrgasms <= 0
        insertionPoint = 0 ; no male orgasms — females get added in fallback below
    else
        insertionPoint = Utility.RandomInt(minInsert, maxInsert)
    endif

    PrintDebug("Total male orgasms: " + totalMaleOrgasms + " | female insertion point: " + insertionPoint)

    ;------------------------------------------------
    ; Start with only males allowed
    ;------------------------------------------------
    int[] allowedIndexes = maleIndexes
    int maleOrgasmsSoFar = 0
    bool keepGoing = True

    while keepGoing
        ; Remove anyone with 0 left from allowedIndexes
        int j = 0
        while j < allowedIndexes.Length
            int idx = allowedIndexes[j]
            if orgasmCount[idx] <= 0
                PrintDebug("Removing actor " + idx + " from pool (no orgasms left)")
                allowedIndexes = PapyrusUtil.RemoveInt(allowedIndexes, idx)
            else
                j += 1
            endif
        endwhile

        int[] available = GetAvailableFromList(orgasmCount, allowedIndexes)
        if available.Length <= 0
            ; If males are done but females still waiting, inject remaining females (fallback)
            if femaleIndexes.Length > 0
                PrintDebug("Male pool exhausted — adding remaining females to allowed pool as fallback")
                int f = 0
                while f < femaleIndexes.Length
                    int fidx = femaleIndexes[f]
                    allowedIndexes = PapyrusUtil.PushInt(allowedIndexes, fidx)
                    f += 1
                endwhile
                ; clear femaleIndexes entirely (they are now in allowed pool)
                int g = 0
                while g < femaleIndexes.Length
                    femaleIndexes = PapyrusUtil.RemoveInt(femaleIndexes, femaleIndexes[g])
                    ; don't increment g because RemoveInt shifts elements
                endwhile
                ; recompute available after adding females
                available = GetAvailableFromList(orgasmCount, allowedIndexes)
                if available.Length <= 0
                    keepGoing = False
                endif
            else
                keepGoing = False
            endif
        else
            ; Choose random starter from current allowed pool
            int starter = available[Utility.RandomInt(0, available.Length - 1)]
            PrintDebug("Starting orgasm chain with actor " + starter)
            maleOrgasmsSoFar += TriggerOrgasmChain(starter, tmpCummingActorlist, orgasmCount, allowedIndexes, maleOrgasmsSoFar)

            ;------------------------------------------------
            ; Female insertion logic:
            ; - Add a female once maleOrgasmsSoFar hits insertionPoint
            ; - If insertionPoint == 0 (no males), fallback handled above
            ;------------------------------------------------
            if insertionPoint > 0 && maleOrgasmsSoFar >= insertionPoint && femaleIndexes.Length > 0
                int addIdx = femaleIndexes[Utility.RandomInt(0, femaleIndexes.Length - 1)]
                allowedIndexes = PapyrusUtil.PushInt(allowedIndexes, addIdx)
                femaleIndexes = PapyrusUtil.RemoveInt(femaleIndexes, addIdx)
                PrintDebug("Inserted female actor " + addIdx + " into allowed pool at male count " + maleOrgasmsSoFar)
            endif
        endif
    endwhile

    PrintDebug("All orgasms done. Final orgasmCount array:")
    i = 0
    while i < orgasmCount.Length
        PrintDebug(" actor " + i + " left: " + orgasmCount[i])
        i += 1
    endwhile
EndFunction


;====================================================
; TriggerOrgasmChain
; - causes actor to orgasm, attempts to start another during wait time,
;   then resumes actor's own next orgasm if any.
; - returns updated maleSoFar count
;====================================================
Int Function TriggerOrgasmChain(int index, Actor[] actors, int[] orgasmCount, Int[] allowedIndexes, int maleSoFar)
    if orgasmCount[index] <= 0
        PrintDebug("Actor " + index + " skipped — no orgasms left")
        return maleSoFar
    endif
	int remaining

	ForceOrgasm(actors[index])
	 ; decrement properly
	remaining = orgasmCount[index] - 1
	orgasmCount[index] = remaining
	PrintDebug("Actor " + index + " orgasmed. Remaining = " + remaining)

	
    ; if needed, remove from allowed pool
    if remaining <= 0
        allowedIndexes = PapyrusUtil.RemoveInt(allowedIndexes, index)
    endif

    ; If male, increment male counter used for insertion timing
    if SexLab.GetSex(actors[index]) != 1
        maleSoFar += 1
        PrintDebug("maleOrgasmsSoFar -> " + maleSoFar)
    endif

    ; Scale wait time based on remaining orgasms
	float baseWait = Utility.RandomFloat(1.0, 3.0)
	int orgasmDivisor = orgasmCount[index]
	if orgasmDivisor < 1
		orgasmDivisor = 1
	endif
	float waitTime = baseWait / (orgasmDivisor as float)

	; Clamp to minimum so it never gets too tiny
	if waitTime < 0.2
		waitTime = 0.2
	endif

    ; During this actor's wait, try to start another random actor (exclude current)
    int[] available = GetAvailableFromList(orgasmCount, allowedIndexes, index)
    if available.Length > 0
        int nextIndex = available[Utility.RandomInt(0, available.Length - 1)]
        PrintDebug("Actor " + nextIndex + " will orgasm during wait of " + waitTime + "s for actor " + index)
        Utility.Wait(Utility.RandomFloat(0.3, waitTime))
        maleSoFar = TriggerOrgasmChain(nextIndex, actors, orgasmCount, allowedIndexes, maleSoFar)
    endif

    ; After wait, resume this actor if they have more orgasms left
    if orgasmCount[index] > 0
        Utility.Wait(waitTime)
        PrintDebug("Actor " + index + " preparing next orgasm after " + waitTime + "s")
        maleSoFar = TriggerOrgasmChain(index, actors, orgasmCount, allowedIndexes, maleSoFar)
    endif

    return maleSoFar
EndFunction


;====================================================
; Helper: returns indexes from groupList that still have orgasms left
; excludeIndex optional: skip one index (e.g., the current orgasmer)
;====================================================
Int[] Function GetAvailableFromList(Int[] orgasmCount, Int[] groupList, Int excludeIndex = -1)
    int[] result
    int i = 0
    while i < groupList.Length
        int idx = groupList[i]
        if orgasmCount[idx] > 0 && idx != excludeIndex
            result = PapyrusUtil.PushInt(result, idx)
        endif
        i += 1
    endwhile
    return result
EndFunction

float function GetCurrentRealTimeSeconds()
	return utility.GetCurrentRealTime()
endFunction

float function GetCurrentGameTimeHours()
	return Utility.GetCurrentGameTime() * 24.0
endFunction

Bool function isDependencyReady(String modname)
  return PO3_SKSEFunctions.IsPluginFound(modname)
  ;int index = Game.GetModByName(modname)
 ;if index == 255 || index == -1
  ;  return false
  ;else
  ;  return true
  ;endif
endfunction

Bool Function CanActorSatisfyPCHugePPAddiction(Actor char)
    PrintDebug("CanActorSatisfyPCHugePPAddiction - Checking actor: " + (char.GetDisplayName()))

    if !Adventurecall.BodyEffectsAndDrugsEnabled()
        PrintDebug("CanActorSatisfyPCHugePPAddiction - Body effects & drugs disabled. Returning TRUE.")
        return TRUE
    endif

    int HugePPAddictionPotency = Adventurecall.GetHugePPAddiction(PlayerRef)
    PrintDebug("CanActorSatisfyPCHugePPAddiction - PC HugePPAddictionPotency = " + HugePPAddictionPotency)
	
    if HugePPAddictionPotency <= 0
        PrintDebug("CanActorSatisfyPCHugePPAddiction - No HugePP addiction. Returning TRUE.")
        return TRUE
    endif

    int RequiredSizetosatisfy = Math.Floor((HugePPAddictionPotency * 4.0) / 100.0) + 1
    if RequiredSizetosatisfy > 4
        RequiredSizetosatisfy = 4
    endif
    PrintDebug("CanActorSatisfyPCHugePPAddiction - Required penis size to satisfy = " + RequiredSizetosatisfy)

    int ActorPenisSize = GetNormalizedPenisSize(char)
    PrintDebug("CanActorSatisfyPCHugePPAddiction - ActorPenisSize = " + ActorPenisSize)

    ; ignore invalid / female
    if ActorPenisSize < 0
        PrintDebug("CanActorSatisfyPCHugePPAddiction - Invalid size (probably female). Returning FALSE.")
        return FALSE
    endif

    if ActorPenisSize >= RequiredSizetosatisfy
        PrintDebug("CanActorSatisfyPCHugePPAddiction - Actor satisfies requirement. Returning TRUE.")
        return TRUE
    else
        PrintDebug("CanActorSatisfyPCHugePPAddiction - Actor too small. Returning FALSE.")
    endif

    return FALSE
EndFunction



Int Function GetNormalizedPenisSize(Actor char)
    PrintDebug("GetNormalizedPenisSize - Checking actor: " + char.GetDisplayName())

    int ModPenisSize = -1
    int HugePPSchlongSize = JsonUtil.GetIntValue(ControlConfigFile, "soshugeppsize", 6)
    PrintDebug("GetNormalizedPenisSize - HugePPSchlongSize threshold = " + HugePPSchlongSize)

    Int Sex = Sexlab.GetSex(char)
    PrintDebug("GetNormalizedPenisSize - Actor sex = " + Sex)

    if Sex == 1
        PrintDebug("GetNormalizedPenisSize - Female detected. Returning -1.")
        return -1
    endif

    if Sex >= 3 ; creature
        PrintDebug("GetNormalizedPenisSize - Creature detected.")
        if IshugePP(char)
            PrintDebug("GetNormalizedPenisSize - Creature has HugePP. Returning 4.")
            return 4
        elseif IsSmallPP(Char)
            PrintDebug("GetNormalizedPenisSize - Creature normal size. Returning 2.")
            return 0
		else 
			return 2
        endif
    else
        if SchlongFaction
            int SchlongSize = char.GetFactionRank(SchlongFaction) ; 1 - 16
            PrintDebug("GetNormalizedPenisSize - Raw SchlongSize = " + SchlongSize)

            if SchlongSize < 1
                SchlongSize = 1
                PrintDebug("GetNormalizedPenisSize - Adjusted SchlongSize to minimum = 1")
            elseif SchlongSize > 16
                SchlongSize = 16
                PrintDebug("GetNormalizedPenisSize - Adjusted SchlongSize to maximum = 16")
            endif

            if SchlongSize >= HugePPSchlongSize
                ModPenisSize = 4
                PrintDebug("GetNormalizedPenisSize - SchlongSize >= HugePP threshold. Returning 4.")
            else
                ; Scale 0 → 3 for ranks below threshold
                ModPenisSize = Math.Floor((SchlongSize * 3.0) / HugePPSchlongSize)
                PrintDebug("GetNormalizedPenisSize - Normalized size scaled to " + ModPenisSize)
            endif

        elseif PO3_SKSEFunctions.IsPluginFound("TheNewGentleman.esp")
            ModPenisSize = TNG_PapyrusUtil.GetActorSize(char)
            PrintDebug("GetNormalizedPenisSize - Size from TheNewGentleman = " + ModPenisSize)
        else
            PrintDebug("GetNormalizedPenisSize - No valid method found. Returning default -1.")
        endif
    endif

    PrintDebug("GetNormalizedPenisSize - Final normalized size = " + ModPenisSize)
    return ModPenisSize
EndFunction

Bool Function IsSmallPP(Actor Char)
  Int Sex = Sexlab.GetSex(char)
  if Sex <= 2
	return GetNormalizedPenisSize(Char) <= 0
  else
	 String charraceName =  char.GetRace().GetName()
	 if stringutil.find(charraceName, "rabbit") > -1 ||	stringutil.find(charraceName, "fox") > -1 || stringutil.find(charraceName, "rabbit") > -1 || stringutil.find(charraceName, "Skeever") > -1
		return TRUE
	 else
		return false
	 endIf
 endif
 
EndFunction

Bool function IshugePP(actor char)
  int HugePPSchlongSize
	HugePPSchlongSize = JsonUtil.GetIntValue(ControlConfigFile, "soshugeppsize" ,6)
  Race charRace = char.GetRace()
  String charraceName = charRace.GetName()
  if stringutil.find(charraceName, "Brute") > -1 || stringutil.find(charraceName, "Spider") > -1 || stringutil.find(charraceName, "Lurker") > -1 || stringutil.find(charraceName, "Daedroth") > -1 || stringutil.find(charraceName, "Horse") > -1 || stringutil.find(charraceName, "Bear") > -1 || stringutil.find(charraceName, "Chaurus") > -1 || stringutil.find(charraceName, "Dragon") > -1 || charraceName == "Frost Atronach" || stringutil.find(charraceName, "Giant") > -1 || charraceName == "Mammoth" || charraceName == "Sabre Cat" || stringutil.find(charraceName, "Troll") > -1 || charraceName == "Werewolf" || stringutil.find(charraceName, "Gargoyle") > -1 || charraceName == "Dwarven Centurion" || stringutil.find(charraceName, "Ogre") > -1 || charraceName == "Ogrim" || charraceName == "Nest Ant Flier" 
    return True
  else
    ;if Schlong is big
    if (SchlongFaction)
      return char.GetFactionRank(SchlongFaction) >= HugePPSchlongSize
	elseif TNG_Gentlewoman
		if char.GetActorBase().GetSex() == 1 && char.HasKeyword(TNG_Gentlewoman) && TNG_PapyrusUtil.GetActorSize(char) == 4
			return true
		else
			return false
		endif
    elseif PO3_SKSEFunctions.IsPluginFound("TheNewGentleman.esp") && TNG_PapyrusUtil.GetActorSize(char) == 4
      return true
    endif
    return false
  endif
EndFunction

String function PPSize(actor char)
	if (SchlongFaction)
      return char.GetFactionRank(SchlongFaction) as string
	elseif isDependencyReady("TheNewGentleman.esp")
		return TNG_PapyrusUtil.GetActorSize(char)
	else
		return "N/A"
	endif
	
EndFunction

Bool Function ScenehasCreatures()
	return sexlab.CountCreatures(actorList) > 0
endfunction

Bool Function isLinearScene()
	return uselinearscene == 1 || storageutil.Getintvalue(none,"HentairimNextUseLinearScene",0) == 1
endfunction

Bool Function OrgasmBeforeLastStage()
	Return uselinearscene == 1 && linearsceneorgasmbeforelaststage == 1
Endfunction

Bool Function DoneLinearSceneOrgasm()
	return DoneLinearSceneOrgasm
Endfunction

Float Function GetOrgasmFactor(actor char)
	
	string charname = char.getdisplayname()
	int Sex = Sexlab.GetSex(char)
	int position = CurrentThread.getpositionidx(char)
	float StorageutilOrgasmFactor = storageutil.GetFloatvalue(char,"HentairimOrgasmFactor",1)

	int z 
	while z < linearscenefinalstageorgasmfactor.length
		string[] item = stringutil.split(linearscenefinalstageorgasmfactor[z],"|")
		;check if display name contains the keyword
		if stringutil.find( charname, item[0]) > -1
			;display name match keyword. Get Orgasm Factor
			Float Factor = item[1] as float
			return Factor * StorageutilOrgasmFactor
		endif
		z += 1
	endWhile
	
	;add orgasm factor based on arousal
	StorageutilOrgasmFactor += GetActorArousal(char) / 100

	;add orgasm factor based on sensitivity
	if Sex != 1 && position > 0 && (CurrentThread.HasSceneTag("Vaginal") || CurrentThread.HasSceneTag("Oral") || CurrentThread.HasSceneTag("Anal") )
		StorageutilOrgasmFactor += Adventurecall.GetPenileSensitivity(char)
	endif
	
	if (Sex == 1 || Sex == 2) && position == 0
		if CurrentThread.HasSceneTag("Vaginal")
			StorageutilOrgasmFactor += Adventurecall.GetVaginalSensitivity(char)
		endif
		
		if CurrentThread.HasSceneTag("Anal")
			StorageutilOrgasmFactor += Adventurecall.GetAnalSensitivity(char)
		endif
	endif
	
	return StorageutilOrgasmFactor
endFunction

actor function FindFirstActorwithPenisPosition()
	int z
	while z < actorlist.length
		if sexlab.getsex(actorList[z]) != 1 ;not female
			return actorList[z]
		endif
	z += 1
	endwhile
	
	return none
EndFunction

Actor function GetControllingActor()
	if currentthread.HasSceneTag("cowgirl") || currentthread.HasSceneTag("amazon") || currentthread.HasSceneTag("femdom")
		return actorlist[0]
	elseif currentthread.HasSceneTag("lesbian")
		return actorlist[1]
	else
		return FindFirstActorwithPenisPosition()
	endif
EndFunction

bool Function ExtendScene()
	;check if can Extend Scene
	string tags
	Actor ActorWhoisControlling 
	if currentthread.HasSceneTag("cowgirl") || currentthread.HasSceneTag("amazon") || currentthread.HasSceneTag("femdom")
		ActorWhoisControlling = actorlist[0]
		;femdom scene extend to femdom scene
		tags = "~1ASCG,~2ASCG,~3ASCG,~4ASCG,~5ASCG,~6ASCG,~1AFCG,~2AFCG,~3AFCG,~4AFCG,~5AFCG"
	elseif currentthread.HasSceneTag("lesbian")
		ActorWhoisControlling = actorlist[1]
		tags = "lesbian"
	else
		ActorWhoiscontrolling = FindFirstActorwithPenisPosition()
		
		if currentthread.HasSceneTag("aggressive")
			; non femdom scene extend to non femdom scene
			tags = "aggressive,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-6ASCG,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG"
		else
			tags = "-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-6ASCG,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG"
		endif
	endIf
	if ActorWhoisControlling == None
		return false
	endif
	bool result
	if utility.randomfloat(0,1) < ExtendStageChance(ActorWhoiscontrolling)
		
		result = TeleportToRandomStageWithTags(tags, StartFromStage = 2)
		if result
			StorageUtil.SetIntValue(None, "HentairimExtendScene", 1)
		endif
	
	endif
	return result
endfunction

Float Function ExtendStageChance(actor char)

	if char == PlayerRef || char.isplayerteammate()
		return 0
	EndIf
	string charname = char.getdisplayname()
	int z 
	while z < linearsceneextendstagechance.length
		string[] item = stringutil.split(linearsceneextendstagechance[z],"|")
		;check if display name contains the keyword
		printdebug(" Extend Stage Chance items : " + item)
		if stringutil.find( charname, item[0]) > -1
			;display name match keyword. Get Extend Stage Chance
			Float Chance = item[1] as float / 100
			printdebug("Extend Stage Chance :" + Chance)
			return Chance
		endif
		z += 1
	endWhile
	return 0
endFunction

bool Function CounterRape()		
	
	string tags
	string hentairimtagwithoutstage
	actor[] Submissives = CurrentThread.GetSubmissives()
	int SubmissivePos = CurrentThread.getpositionidx(Submissives[0])
	int SubmissiveSex = sexlab.getsex(Submissives[0])
	if utility.randomfloat(0,1) < CounterRapeChance(Submissives[0])
		if SubmissivePos == 0 && SubmissiveSex == 1;pos 0 female submissive
			tags = "~femdom,~cowgirl,~amazon"
		elseif SubmissivePos > 0 && SubmissiveSex != 1  ;victim has penis
			if SubmissiveSex > 2 ;creature
				tags = "-2ASCG,-3ASCG,-4ASCG,-5ASCG,-6ASCG,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG"
			else
				tags = "aggressive,~vaginal,~anal"
			endIf
		endif
	;flip all actor submissive Status
	int z
		while z < actorList.length
			if CurrentThread.GetSubmissive(actorList[z]) ;is submissive
				CurrentThread.SetIsSubmissive(actorList[z], false)
				printdebug("Counter Rape! :" + actorList[z].getdisplayname() + " Flipped to Aggressor")
			else
				CurrentThread.SetIsSubmissive(actorList[z], true)
				printdebug("Counter Rape! :" + actorList[z].getdisplayname() + " Flipped to Victim")
			endif
			z += 1
		endwhile
		
		bool result = TeleportToRandomStageWithTags(tags , StartFromStage = 2) 
		storageutil.Setintvalue(None,"HentairimExtendScene",1)
		if result
			return true
		else
			return false
		endif
	else
		return false
	endif
endfunction

Float Function CounterRapeChance(actor char)
	if char == PlayerRef || char.isplayerteammate()
		return 0
	EndIf
	string charname = char.getdisplayname()
	int z 
	while z < linearscenecounterrapechance.length
		string[] item = stringutil.split(linearscenecounterrapechance[z],"|")
		;check if display name contains the keyword
		printdebug(" Counter Rape Chance items : " + item)
		if stringutil.find( charname, item[0]) > -1
			;display name match keyword. Get Counter Rape Chance
			Float Chance = item[1] as float / 100
			printdebug("Counter Rape Chance :" + Chance)
			return Chance
		endif
		z += 1
	endWhile
	return 0
endFunction

Function DisableScene(string Sceneid)
	;for disabling the scene in library
		SexlabRegistry.SetSceneEnabled(Sceneid,false)
		Announce("Scene Disabled")

endfunction

Int Function Max(Int a, Int b)
    If a > b
        return a
    Else
        return b
    EndIf
EndFunction

String Function GetTagsForSpecificPlay(String Type)

	if Type == "Handjob"
		return "~1CSHJ,~2CSHJ,~3CSHJ,~4CSHJ,~1CFHJ,~2CFHJ,~3CFHJ,~4CFHJ,~1BSHJ,~2BSHJ,~3BSHJ,~4BSHJ,~1BFHJ,~2BFHJ,~3BFHJ,~4BFHJ,-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP"
	elseif Type == "Boobjob"
		return "~1CSTF,~2CSTF,~3CSTF,~4CSTF,~1CFTF,~2CFTF,~3CFTF,~4CFTF,~1BSTF,~2BSTF,~3BSTF,~4BSTF,~1BFTF,~2BFTF,~3BFTF,~4BFTF,-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP"
	elseif Type == "FootJob"
		return  "~1CSFJ,~2CSFJ,~3CSFJ,~4CSFJ,~1CFFJ,~2CFFJ,~3CFFJ,~4CFFJ,~1BSFJ,~2BSFJ,~3BSFJ,~4BSFJ,~1BFFJ,~2BFFJ,~3BFFJ,~4BFFJ,-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP"
	elseif Type == "BlowJob"
		return"~1BSBJ,~2BSBJ,~3BSBJ,~4BSBJ,~1BFBJ,~2BFBJ,~3BFBJ,~4BFBJ,~1ASBJ,~2ASBJ,~3ASBJ,~4ASBJ,~1AFBJ,~2AFBJ,~3AFBJ,~4AFBJ,-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP"
	elseif type == "Vaginal"
		return "~1asvp,~2asvp,~3asvp,~4asvp,~5asvp,~1afvp,~2afvp,~3afvp,~4afvp,~5afvp,~6afvp,~7afvp"
	elseif Type == "Anal"
		return "~1asap,~2asap,~3asap,~4asap,~5asap,~1afap,~2afap,~3afap,~4afap,~5afap,~6afap,~7afap"
	endif
	return ""
EndFunction

bool Function StartForeplayScene()

	int totalWeight = foreplayhandjobweight + foreplaytitfuckweight + foreplayfootjobweight + foreplayblowjobweight
	if totalWeight <= 0 && !currentthread.HasSceneTag("Vaginal") && !currentthread.HasSceneTag("anal") && !currentthread.HasSceneTag("fisting")
		return false
	endif
	;Tags = "-5AFAC,-4AFAC,-3AFAC,-2AFAC,-1AFAC,-5ASAC,-4ASAC,-3ASAC,-2ASAC,-1ASAC,-1AFAP,-2AFAP,-3AFAP,-4AFAP,-5AFAP,-1ASAP,-2ASAP,-3ASAP,-4ASAP,-5ASAP,-1AFCG,-2AFCG,-3AFCG,-4AFCG,-5AFCG,-6AFCG,-7AFCG,-1ASCG,-2ASCG,-3ASCG,-4ASCG,-5ASCG,-2ASVP,-3ASVP,-4ASVP,-5ASVP,-6ASVP,-7ASVP,-8ASVP,-2AFVP,-3AFVP,-4AFVP,-5AFVP,-6AFVP,-7AFVP,-8AFVP,-1ASDP,-2ASDP,-3ASDP,-4ASDP,-5ASDP,-2AFDP,-3AFDP,-4AFDP,-5AFDP,-6AFDP,-7AFDP,"
	int roll = Utility.RandomInt(0, totalWeight - 1)

	string HandjobTags = GetTagsForSpecificPlay("HandJob")
	string TitFuckTags = GetTagsForSpecificPlay("BoobJob")
	string FootJobTags = GetTagsForSpecificPlay("FootJob")
	string BlowjobTags = GetTagsForSpecificPlay("BlowJob")

	string SelectedTags
	if roll < foreplayhandjobweight
		SelectedTags = HandjobTags
	elseif roll < (foreplayhandjobweight + foreplaytitfuckweight)
		SelectedTags = TitFuckTags
	elseif roll < (foreplayhandjobweight + foreplaytitfuckweight + foreplayfootjobweight)
		SelectedTags = FootJobTags
	elseif IsWearingGag(Playerref)
		int rand = utility.randomint(1,3)
		if rand == 1 
			SelectedTags = FootJobTags
		elseif rand == 2
			SelectedTags = TitFuckTags
		else
			SelectedTags = HandjobTags
		endif
	else
		SelectedTags = BlowjobTags
	endif
	
	if PCisAggressor()
		SelectedTags += ",-Forced"
	elseif PCisVictim()
	    SelectedTags += ",Forced"
	endif 
	
	
	bool result
	OriginalSceneID = CurrentSceneID
	printdebug("foreplay SelectedTags : " + SelectedTags)
	result = TeleportToRandomStageWithTags(SelectedTags, 1)
	printdebug("foreplay teleport : " + result)
	if result
		isPlayingForeplayScene = true
	else
		isPlayingForeplayScene = false
		OriginalSceneID = ""
	endif

	return result
endFunction

Actor[] Function GetPlayerSceneActorlist()
	return actorlist
Endfunction

bool function isPlayingForeplayScene()
	return isPlayingForeplayScene
endfunction

Bool Function IsWearingGag(Actor char)
	return char.WornHasKeyword(zad_DeviousGag)
endfunction

;------------------------------ONINUS LACTIS NG------------------
;Oninus Lactis File
Quest OninusLactisQuest
int enableoninuslactislactate
int oninuslactischancetolactateduringorgasm
int oninuslactischancetolactateduringnonintense
int oninuslactischancetolactateduringintense
int mintimetolactate
int maxtimetolactate
int levelduringnonintense
int levelduringintense
Spell OninusLactisLactatingSpell

String OninusLactisFile  = "IVDTHentai/OninusLactis.json"
Function InitializeOninusLactis()
	 OninusLactisQuest = Game.GetFormFromFile(0xD61, "OninusLactis.esp") as Quest
	 enableoninuslactislactate = JsonUtil.GetIntValue(OninusLactisFile,"enableoninuslactislactate",0)
	 oninuslactischancetolactateduringorgasm = JsonUtil.GetIntValue(OninusLactisFile,"chancetolactateduringorgasm",0)
	 oninuslactischancetolactateduringnonintense = JsonUtil.GetIntValue(OninusLactisFile,"chancetolactateduringnonintense",0)
	 oninuslactischancetolactateduringintense = JsonUtil.GetIntValue(OninusLactisFile,"chancetolactateduringintense",0)
	 mintimetolactate = JsonUtil.GetIntValue(OninusLactisFile,"mintimetolactate",0)
	 maxtimetolactate  = JsonUtil.GetIntValue(OninusLactisFile,"maxtimetolactate",0)
	 levelduringnonintense = JsonUtil.GetIntValue(OninusLactisFile,"levelduringnonintense",0)
	 levelduringintense  = JsonUtil.GetIntValue(OninusLactisFile,"levelduringintense",0)

	if !HasOninusLactis() || OninusLactisQuest == none || enableoninuslactislactate == 0
		PrintDebug("Hentairim Director : Oninus Lactis not enabled or installed")
		enableoninuslactislactate = 0
	else 
		MiscUtil.printconsole("Hentairim Director : Oninus Lactis Enabled")
	endif
endfunction

Bool Function RollforOrgasmLactating()
	bool result = Utility.randomint(1,100) < oninuslactischancetolactateduringorgasm
	return Result
Endfunction

Bool Function RollforPenetrationLactating(Bool IsIntense)
	bool result 
	if IsIntense
		result = Utility.randomint(1,100) < oninuslactischancetolactateduringintense + Adventurecall.GetBoobsSensitivity(Playerref)
	else
		result = Utility.randomint(1,100) < oninuslactischancetolactateduringnonintense + Adventurecall.GetBoobsSensitivity(Playerref)
	endif
	
	return Result
Endfunction

Bool function HasOninusLactis()
	if enableoninuslactislactate == 1 && Game.GetModbyName("OninusLactis.esp") != 255
		return true
	else		
		return false
	endif
endfunction

Bool function HasMME()
	return Game.GetModbyName("MilkModNEW.esp") != 255
endfunction

Bool Function HasLactatingSpell(actor char)
	return char.hasspell(OninusLactisLactatingSpell)
EndFunction

Function AddLactatingSpell(actor char)
	if !HasLactatingSpell(char)
		char.AddSpell(OninusLactisLactatingSpell)
	endif
EndFunction

Function RemoveLactatingSpell(actor char)
	if HasLactatingSpell(char)
		char.RemoveSpell(OninusLactisLactatingSpell)
	endif
EndFunction

Bool Function CanLactate()
	return HasOninusLactis() && enableoninuslactislactate == 1 && !WearingBoobCover(Playerref)
endfunction

function OninusLactislactate(Bool IsIntense)
if !CanLactate()
	return
endif
	int lactatetime = utility.randomint(mintimetolactate , maxtimetolactate)
	int lactatelevel
	
	if IsIntense
		lactatelevel = levelduringintense
	else
		lactatelevel = levelduringnonintense
	endif
	
	;----- Milk Mod Economy (MME) integration -----
	;When MME is installed, the nipple squirt is driven by the milkmaid's milk reserve:
	;only squirt when she is at least 20% full, and drain her reserve when she squirts.
	bool isMME = HasMME()
	if isMME
		float milkMax = MME_Storage.getMilkMaximum(Playerref)
		int MMEFullness = 0
		if milkMax > 0.0
			MMEFullness = Math.Ceiling(MME_Storage.getMilkCurrent(Playerref) / milkMax * 100)
		endif
		if MMEFullness <= 20
			PrintDebug("Hentairim Director : MME milk too low (" + MMEFullness + "%). Skipping nipple squirt.")
			return
		endif
	endif

	;if HasOninusLactisNG()
    OninusLactis squirtScript = OninusLactisQuest as OninusLactis
	
	
	if squirtScript != none
		squirtScript.PlayNippleSquirt(playerref, lactatetime ,lactatelevel)
		
		;reduce boobs sensitivity if milking
		if adventurecall.BodyEffectsAndDrugsEnabled()
			Adventurecall.ModBoobsSensitivity(Playerref, Adventurecall.GetSensitiveBodySatiatePerStage())
		endif

		;drain the MME milk reserve proportionally to this squirt
		if isMME
			DrainMMEMilkForSquirt(lactatetime, lactatelevel)
		endif
	else
		printdebug("Something is Wrong! OninusLactis Script is none! ReInstall Oninus Lactis NG!")
	endif
	
endfunction

Function DrainMMEMilkForSquirt(int lactatetime, int lactatelevel)
	Float curMilk = MME_Storage.getMilkCurrent(Playerref)

	; percent-of-current drain, scaled by intensity and squirt duration
	Float basePct = Utility.RandomFloat(0.20, 0.50)

	; intensityScale in [0..1] : non-intense squirts drain less than intense ones
	Float intensityScale = 1.0
	if levelduringintense > 0
		intensityScale = (lactatelevel as Float) / (levelduringintense as Float)
		if intensityScale < 0.0
			intensityScale = 0.0
		elseif intensityScale > 1.0
			intensityScale = 1.0
		endif
	endif

	; timeScale in [0.25..1.0] : longer squirts drain more
	Float timeScale = 1.0
	if maxtimetolactate > 0
		timeScale = (lactatetime as Float) / (maxtimetolactate as Float)
		if timeScale < 0.25
			timeScale = 0.25
		elseif timeScale > 1.0
			timeScale = 1.0
		endif
	endif

	Float drain = curMilk * basePct * intensityScale * timeScale
	if drain > curMilk
		drain = curMilk
	elseif drain < 0.0
		drain = 0.0
	endif

	if drain > 0.0
		MME_Storage.changeMilkCurrent(Playerref, 0.0 - drain, false)
		PrintDebug("Hentairim Director : MME drained " + drain + " milk (was " + curMilk + ").")
	endif
EndFunction

Function SetAnimType(actor char, Int Value)
; combining with OAR , set various animations by replacing GetAttention01.hkx

;0 = none
;1 = Seduce
;2 = Seduce Animals
;3 = Squeeze Boobs
;4 = Flaunt Ass
;5 = Beg for Sex
;6 = Blush
;7 = Female Masturbate 
;8 = Reject
;31 = Male Pelvis Thrust Anim
;51 - middle finger
if !char.isinfaction(AnimType)
	char.addtofaction(AnimType)
endif

Char.SetFactionRank(AnimType , Value)

EndFunction

Function PlayAnim(Actor Char , Int Value)
	

	SheathWeapon(char)
	
	PrintDebug("PlayAnim: Setting anim type " + Value + " for " + Char.GetDisplayName())
	SetAnimType(Char, Value)

	Char.PlayIdle(IdleAttention)
EndFunction

Function SheathWeapon(Actor char)
if char.isweapondrawn()
	char.SheatheWeapon()
	utility.wait(2)
endif
Endfunction

Bool Function HasAnyArousalMod()
	Bool found = HentairimArousal.IsPresent()
	PrintDebug("HasAnyArousalMod: " + found)
	return found
EndFunction


Function FaceActor(Actor akActorToTurn, Actor akTargetActor, bool abShowBack = false)
    if akActorToTurn == None || akTargetActor == None
        return
    endif

    ; 1. Get positions
    float actorX = akActorToTurn.GetPositionX()
    float actorY = akActorToTurn.GetPositionY()
    float targetX = akTargetActor.GetPositionX()
    float targetY = akTargetActor.GetPositionY()

    ; 2. Determine direction and set angle using eight quadrants
    float dx = targetX - actorX
    float dy = targetY - actorY
    float newAngleZ = akActorToTurn.GetAngleZ()

    ; Define a small threshold to avoid division-by-zero or floating point errors
    float threshold = 0.01

    if (dx > threshold && dy >= dx) ; North-East
        newAngleZ = 45.0
    elseIf (dx >= 0 && dy > threshold && dy < dx) ; East-North
        newAngleZ = 90.0
    elseIf (dy >= 0 && dx < -threshold && dy >= -dx) ; North-West
        newAngleZ = 315.0
    elseIf (dx <= 0 && dy > threshold && dy < -dx) ; West-North
        newAngleZ = 270.0
    elseIf (dx < -threshold && dy <= dx) ; South-West
        newAngleZ = 225.0
    elseIf (dx < 0 && dy < -threshold && dy > dx) ; West-South
        newAngleZ = 270.0
    elseIf (dx > threshold && dy <= -dx) ; South-East
        newAngleZ = 135.0
    elseIf (dx > 0 && dy < -threshold && dy > -dx) ; East-South
        newAngleZ = 90.0
    endif

    ; 3. Apply 180-degree rotation if abShowBack is true
    if abShowBack
        newAngleZ = newAngleZ + 180.0
        ; Normalize the angle to keep it within 0-360 degrees
        if newAngleZ >= 360.0
            newAngleZ = newAngleZ - 360.0
        endif
    endif

    ; 4. Apply final rotation
    float currentAngleX = akActorToTurn.GetAngleX()
    float currentAngleY = akActorToTurn.GetAngleY()
    akActorToTurn.SetAngle(currentAngleX, currentAngleY, newAngleZ)
EndFunction

Function FaceActorPair(Actor ActorOne, Actor ActorTwo, Actor TargetRef, bool abShowBack = false)
    if ActorOne == None || TargetRef == None
        return
    endif

    ; Make ActorOne face the target
    FaceActor(ActorOne, TargetRef, abShowBack)

    ; Make ActorTwo face the target and move next to ActorOne
    if ActorTwo != None
        FaceActor(ActorTwo, TargetRef, abShowBack)

        float offset = 100.0
        float angleZ = ActorOne.GetAngleZ()

        float newX = ActorOne.GetPositionX()
        float newY = ActorOne.GetPositionY()
        float newZ = ActorOne.GetPositionZ()

        ; Decide offset based on ActorOne’s facing quadrant
        if angleZ >= 315.0 || angleZ < 45.0      ; Facing North
            newX += offset
        elseIf angleZ >= 45.0 && angleZ < 135.0  ; Facing East
            newY -= offset
        elseIf angleZ >= 135.0 && angleZ < 225.0 ; Facing South
            newX -= offset
        elseIf angleZ >= 225.0 && angleZ < 315.0 ; Facing West
            newY += offset
        endif

        ; Move ActorTwo beside ActorOne
        ActorTwo.SetPosition(newX, newY, newZ)
    endif
EndFunction



Function RestorePlayerControl()
	PrintDebug("[RestorePlayerControl] Called. Restoring player control...")

	;PlayerRef.SetVehicle(None)
	;PrintDebug("[RestorePlayerControl] Vehicle cleared.")

	Game.EnablePlayerControls()
	PrintDebug("[RestorePlayerControl] Player controls enabled.")

	;Game.SetPlayerAIDriven(false)
	;PrintDebug("[RestorePlayerControl] AI driven disabled.")

	Game.ForceThirdPerson()
	PrintDebug("[RestorePlayerControl] Forced third-person camera.")

	;PlayerRef.SetRestrained(False)
	;PrintDebug("[Re storePlayerControl] Restraint removed.")

	;PlayerRef.SetDontMove(False)
	;PrintDebug("[RestorePlayerControl] DontMove flag cleared.")

	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	PrintDebug("[RestorePlayerControl] Animation state reset to IdleForceDefaultState.")

	PrintDebug("[RestorePlayerControl] Completed.")
EndFunction


Function DisablePlayerControl()
	PrintDebug("[DisablePlayerControl] Called. Disabling player control...")

	;PlayerRef.SetRestrained(True)
	;PrintDebug("[DisablePlayerControl] Player restrained.")

	;PlayerRef.SetDontMove(True)
	;PrintDebug("[DisablePlayerControl] DontMove flag set.")
	Game.DisablePlayerControls()
	;Game.DisablePlayerControls(true, true, true, false, true, true, false, false)
	;PrintDebug("[DisablePlayerControl] Player controls disabled with restrictions applied.")

	;Game.SetPlayerAIDriven()
	;PrintDebug("[DisablePlayerControl] Player AI driven enabled.")

	if Game.GetCameraState() == 0
		Game.ForceThirdPerson()
		PrintDebug("[DisablePlayerControl] Camera was first-person. Forced to third-person.")
	else
		PrintDebug("[DisablePlayerControl] Camera already not first-person. No force applied.")
	endif

	PrintDebug("[DisablePlayerControl] Completed.")
EndFunction

Bool Function SLHHActivate(Actor pTarget, Actor pTargetFriend = None)
    bool result
	Keyword SLHHScriptEventKeyword = Game.GetFormFromFile(0x0000C510, "SexLabHorribleHarassment.esp") as Keyword
	if SLHHScriptEventKeyword
		result = true
		SLHHScriptEventKeyword.SendStoryEvent(None, pTarget, pTargetFriend)
	endif
	return result
endFunction

Bool Function NPCCanBeProcessed(Actor char)
    ; null safety
    if !char
        PrintDebug("OnUpdate: NPC is Interrupted, removing spell.")
        return false
    endif

    if SexLab.ValidateActor(char) < 0
        printdebug("[NPCCanBeProcessed] FAIL: ValidateActor < 0 for " + char)
        return false
    endif

    if char.GetDialogueTarget()
        printdebug("[NPCCanBeProcessed] FAIL: " + char + " is in dialogue")
        return false
    endif

    ; dead or disabled NPCs should not be processed
    if char.IsDead() || !char.Is3DLoaded()
        printdebug("[NPCCanBeProcessed] FAIL: " + char + " dead or not 3D loaded")
        return false
    endif

    ; in combat → skip
    if char.IsInCombat()
        printdebug("[NPCCanBeProcessed] FAIL: " + char + " is in combat")
        return false
    endif

    ; skip if char is in a player-owned horse / carriage / mount
    if char.IsOnMount()
        printdebug("[NPCCanBeProcessed] FAIL: " + char + " is on mount")
        return false
    endif
	
	iF char.hasspell(HentairimNPCRequestSpell)
		printdebug("[NPCCanBeProcessed] FAIL: " + char + " has HentairimNPCRequestSpell")
		return false
	endif
	
	iF char.hasspell(HentairimSeducedSpell)
		printdebug("[NPCCanBeProcessed] FAIL: " + char + " has HentairimSeducedSpell")
		return false
	endif

    ; if all checks pass → safe to process
    printdebug("[NPCCanBeProcessed] PASS: " + char + " can be processed")
    return true
EndFunction

Float Function GetActorArousal(Actor char)
	return HentairimArousal.GetArousal(char)
Endfunction
String Function GetStringAsset(String ContentType , String StringListKey)
	PrintDebug("[GetStringAsset] Called with ContentType=" + ContentType + " | Key=" + StringListKey)
	
	String Folder = "HentairimAdventure/StringAssets/"
	String Path = Folder + ContentType +".json"
	;Content Type Must Match json file name in Folder

	if ContentType != ""
		PrintDebug("[GetStringAsset] Using Path=" + Path)
		int Count  = jsonutil.StringListCount(Path , StringListKey)
		PrintDebug("[GetStringAsset] List count for key=" + StringListKey + " = " + Count)
		if Count > 0
			int RandIndex = Utility.RandomInt(0 , Count - 1)
			PrintDebug("[GetStringAsset] Selected random index=" + RandIndex)

			String Context
			Context = JsonUtil.StringListGet(Path, StringListKey, RandIndex)
			PrintDebug("[GetStringAsset] Raw Context=" + Context)
			return Context
		else
			PrintDebug("[GetStringAsset] FAIL: No entries for key=" + StringListKey)
			return ""
		endif
	else
		PrintDebug("[GetStringAsset] FAIL: No path resolved for ContentType=" + ContentType)
		return ""
	endif
EndFunction


String Function StringReplace(String original, String substring, String replacement)
    String result = ""
    int lastPos = 0
    int currentPos = StringUtil.Find(original, substring, 0)

    while currentPos >= 0
        ; Append the part of the original string before the found substring
        result += StringUtil.Substring(original, lastPos, currentPos - lastPos)
        
        ; Append the replacement string
        result += replacement
        
        ; Update the last position to continue searching from after the replaced substring
        lastPos = currentPos + StringUtil.GetLength(substring)
        
        ; Find the next occurrence of the substring
        currentPos = StringUtil.Find(original, substring, lastPos)
    endwhile

    ;Append any remaining part of the original string
    result += StringUtil.Substring(original, lastPos, StringUtil.GetLength(original) - lastPos)
    
    return result
EndFunction


;---------DO NOT DISTURB SPELL-------------

;When Spell is applied, Aggressors Will be Redirected to Other Combatants, and sheath if there are no one else. resume combat when spell is removed.
;Persist means Do Not Disturb Do Not Go Away After Sex, but persists for another 1000 Seconds(fallback). should be removed manually by another process instead of waiting for it to remove by itself. if persists if maintained.
Function AddDoNotDisturbSpell(Actor Char , Int Persist = 0)
	if DoNotDisturbSpell
		if Persist == 1
			Storageutil.SetIntValue(Char,"DoNotDisturbPersist",Persist)
		else
			Storageutil.unsetIntValue(Char,"DoNotDisturbPersist")
		endif
		
		if !Char.hasspell(DoNotDisturbSpell)
			Char.addspell(DoNotDisturbSpell)	
		EndIf
	endif
endfunction

Function RemoveDoNotDisturbSpell(Actor Char)
	if DoNotDisturbSpell
		if Char.hasspell(DoNotDisturbSpell)
			Char.Removespell(DoNotDisturbSpell)
		EndIf
	endif
endfunction



Function unequipBoobCover(actor char)
Armor BoobCover = WearingBoobCover(char)
if BoobCover
	char.unEquipItem(BoobCover, abSilent=true)
endif

endfunction

Armor Function WearingBoobCover(actor char)
	string BoobCoverFile = "HentairimAdventure/BoobCovers.json"
	string[] Slots = papyrusutil.stringsplit(JsonUtil.GetStringValue(BoobCoverFile,"slots","") ,",")
	string[] Covers = papyrusutil.stringsplit(JsonUtil.GetStringValue(BoobCoverFile,"covers","") ,",")
	string[] exclude = papyrusutil.stringsplit(JsonUtil.GetStringValue(BoobCoverFile,"exclude","") ,",")
	
	PrintDebug("WearingBoobCover called for: " + char.GetDisplayName())
	PrintDebug("Slots length = " + Slots.length)
	PrintDebug("Covers length = " + Covers.length)

	if Slots.length == 0
		PrintDebug("No slots found, returning None")
		return None
	endif

	int slotlength = Slots.length
	int slotindex = 0
	int Coverslength = Covers.length
	int Coversindex = 0
	int excludelength = exclude.length
	int excludeindex = 0
	Armor BoobCover
	Armor WearingBoobCover = None
	string BoobCovername

	while slotindex < slotlength
		Coversindex = 0
		excludeindex = 0
		BoobCover = char.GetWornForm(Armor.GetMaskForSlot(Slots[slotindex] as int)) as Armor
		if BoobCover
			BoobCovername = BoobCover.GetName()
			PrintDebug("SlotIndex " + slotindex + " has armor: " + BoobCovername)
		else
			PrintDebug("SlotIndex " + slotindex + " has no armor equipped")
		endif
		
		;check if its excluded item (already exposed lewd armor)
		while excludeindex < excludelength
			PrintDebug("Checking Boob Cover Exclusion keyword: " + exclude[excludeindex])

			if BoobCover && StringUtil.Find(BoobCovername , exclude[excludeindex]) > -1 
				PrintDebug("Found excluded boob cover armor: " + BoobCovername)
				Excludeindex = 100
				Coversindex = 100
			endif
			excludeindex += 1
		endwhile
		
		; check if its a cover
		while Coversindex < Coverslength
			PrintDebug("Checking Cover keyword: " + Covers[Coversindex])

			if BoobCover && StringUtil.Find(BoobCovername , Covers[Coversindex]) > -1
				PrintDebug("Found valid BoobCover: " + BoobCovername)
				WearingBoobCover = BoobCover
				Coversindex = 100
				slotindex = 100
			endif

			Coversindex += 1
		endwhile

		slotindex += 1
	endwhile

	if WearingBoobCover
		PrintDebug("WearingBoobCover returning: " + WearingBoobCover.GetName())
	else
		PrintDebug("WearingBoobCover returning None")
	endif

	return WearingBoobCover
EndFunction

Float Function GetSpontaneousOrgasmchance(actor char)

	PrintDebug("[GetSpontaneousOrgasmchance] Called for " + char)

	if GetPenisActionLabel(char) == "LDI" && GetPenetrationLabel(char) == "LDI" && GetStimulationLabel(char) == "LDI"
		PrintDebug("[GetSpontaneousOrgasmchance] is LDI → returning 0.0")
		return 0.0
	endIf
	
	if SceneisIntense() && enablelinearscenespontaneousorgasmduringintense != 1
		PrintDebug("[GetSpontaneousOrgasmchance] Scene intense but disabled → returning 0.0")
		return 0.0
	endIf
	
	if !SceneisIntense() && enablelinearscenespontaneousorgasmduringnonintense != 1
		PrintDebug("[GetSpontaneousOrgasmchance] Scene not intense but disabled → returning 0.0")
		return 0.0
	endIf
	
	int sex = sexlab.getsex(char)
	float weight
	if char == playerref
		weight = linearscenespontaneousorgasmpcarousalweight as float
		PrintDebug("[GetSpontaneousOrgasmchance] Actor is player → weight=" + weight)
	elseif sex == 0
		weight = linearscenespontaneousorgasmnpcmalearousalweight as float
		PrintDebug("[GetSpontaneousOrgasmchance] Actor is male → weight=" + weight)
	elseif sex == 1
		weight = linearscenespontaneousorgasmnpcfemalearousalweight as float
		PrintDebug("[GetSpontaneousOrgasmchance] Actor is female → weight=" + weight)
	elseif sex == 2
		weight = linearscenespontaneousorgasmnpcfutaarousalweight as float
		PrintDebug("[GetSpontaneousOrgasmchance] Actor is futa → weight=" + weight)
	else
		weight = linearscenespontaneousorgasmnpccreaturearousalweight as float
		PrintDebug("[GetSpontaneousOrgasmchance] Actor is creature/other → weight=" + weight)
	endif
	
	float chance = GetActorArousal(char) * (weight / 100.0)
	PrintDebug("[GetSpontaneousOrgasmchance] Arousal=" + GetActorArousal(char) + " Factor=" + GetOrgasmFactor(char) + " → chance=" + chance)

	return chance
EndFunction


Bool ProcessedSpontaneousOrgasm	

Function ProcessSpontaneousOrgasm()
	PrintDebug("[ProcessSpontaneousOrgasm] Called")

	if !isLinearScene() || Isfinalstage || ProcessedSpontaneousOrgasm
		PrintDebug("[ProcessSpontaneousOrgasm] Aborting → isLinear=" + isLinearScene() + " final=" + Isfinalstage + " processed=" + ProcessedSpontaneousOrgasm)
		Return
	endIf

	int z
	while z < actorList.length
		float roll = Utility.RandomFloat(0,100)
		float chance = GetSpontaneousOrgasmchance(actorList[z])
		PrintDebug("[ProcessSpontaneousOrgasm] Checking actor index " + z + " roll=" + roll + " chance=" + chance)

		if roll <= chance
			PrintDebug("[ProcessSpontaneousOrgasm] Triggering ForceOrgasm on actor index " + z)
			ForceOrgasm(actorList[z])
			Utility.wait(Utility.RandomFloat(1,2))
		endif
		z += 1
	endwhile

	ProcessedSpontaneousOrgasm = true
	PrintDebug("[ProcessSpontaneousOrgasm] Finished, ProcessedSpontaneousOrgasm set to true")
EndFunction

Bool LinearSceneIVDTDoneOrgasmHype

Function setLinearSceneIVDTDoneOrgasmHype(Bool Value)
	LinearSceneIVDTDoneOrgasmHype = value
endFunction

Bool PCInSex

Bool Function PCInSex()
	return PCInSex
EndFunction

Bool Function LinearSceneStageShouldOrgasm()
	return (isAlmostFinalStage && OrgasmBeforeLastStage() && StageTimesUp()) || (!OrgasmBeforeLastStage() && Isfinalstage && isLinearScene() )
Endfunction

;------------------------------Director's Tools END------------------------


