Scriptname HentairimExpressions extends ActiveMagicEffect  

IVDTControllerScript Property MasterScript Auto
SexLabFramework Property SexLab Auto 
SexLabThread CurrentThread = None
actor Actorref
actor[] actorlist
int position
string role = "c"
int Phase = 1
int ExpressionPhase
string LabelGroup

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actorref = akTarget
	PrintDebug("Effect Start for " + Actorref.getdisplayname() )	
		
	PerformInitialization()
	
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;last-resort cleanup: fires whenever the spell is removed, even if the
	;OnUpdate chain died and RemoveExpressions never ran for this instance
	resetexpressions()
	RemoveTongue()
EndEvent

Function PerformInitialization()
PrintDebug("Perform Initialization")	
	
	CurrentThread = Sexlab.GetThreadByActor(Actorref)
	actorlist = CurrentThread.GetPositions()
	
	;establish positions
	position = CurrentThread.GetPositionIdx(actorref)
	
	RegisterForTheEventsWeNeed()
	
	if sexlab == none
		PrintDebug("oh noes sexlab is none!")	
	endif
	
	if CurrentThread == none
		PrintDebug("oh noes Sexlab Thread is none!")	
	endif
	
	if MasterScript == none
		PrintDebug("oh noes Director is none!")	
	endif
	
	PrintDebug("actor list" + actorlist)

	;Base Hentairim Preparation
	InitializeConfigandForms()
	HentairimPrepare()	
	CheckHasMFEE()
	printdebug("initialized complete")
	RegisterForSingleUpdate(0.1)
EndFunction

Function RegisterForTheEventsWeNeed()
	printdebug("Registering Event")
	RegisterForModEvent("AnimationEnd", "ExpressionsSceneEnd")
	RegisterForModEvent("SexLabOrgasmSeparate", "ExpressionsOrgasm")
	RegisterForModEvent("StageStart", "ExpressionsOnStageStart")
	;SexLab Survival drives the player's face during its ahegao - yield to it while it's on
	RegisterForModEvent("_SLS_AhegaoStateChange", "OnSLSAhegaoStateChange")

EndFunction

;-----------------------SLS ahegao yield-----------------------
bool SLSAhegaoActive = false

Event OnSLSAhegaoStateChange(string eventName, string argString, float argNum, form sender)
	;SLS ahegao is a player-only face; ignore for NPC instances
	if !IsPlayer
		return
	endif
	if argNum >= 0.5
		SLSAhegaoActive = true
		printdebug("SLS ahegao started - pausing Hentairim expressions")
		;drop our own tongue so it doesn't clash with the ahegao face SLS applies
		RemoveTongue()
	else
		SLSAhegaoActive = false
		printdebug("SLS ahegao ended - resuming Hentairim expressions")
		CachedLabelGroup = "" ;force a fresh full pass on resume
	endif
EndEvent

bool SceneEnded = false
Event ExpressionsSceneEnd(string eventName, string argString, float argNum, form sender)
	;event-driven cleanup: don't depend on the OnUpdate chain surviving to its
	;next tick - a dropped update used to leave face and tongue stuck forever
	if threadid == argstring
		SceneEnded = true
		RemoveExpressions()
	endif
EndEvent


Event ExpressionsOnStageStart(string eventName, string argString, float argNum, form sender)
	if threadid == argstring
		position = currentthread.getpositionidx(actorref)
	endif
EndEvent

float LastOrgasmtime

Event ExpressionsOrgasm(Form akactor, Int thread)
	If akactor != actorRef
		Return
	EndIf
	IsOrgasming = true
	LastOrgasmtime =  CurrentThread.GetTimeTotal()

EndEvent

;-----------------------Breathing micro-pass + preset cache state-----------------------
int TicksUntilFull = 0
int BreathBase0 = 0
bool BreathingAllowed = false
int enablebreathing = 1
float breathingupdateinseconds = 0.55
float tonguemouthopenthreshold = 0.4

string CachedLabelGroup = ""
float[] CachedPhase1
float[] CachedPhase2
float[] CachedPhase3
float[] CachedPhase4
float[] CachedPhase5
int[] CachedVariance
bool CacheLoadedIntense = false
bool CacheUsedFallback = false
float[] BlowjobOverrideF
float[] BrokenOverrideF
float[] TongueOutOverrideF
float[] KisOverrideF
float[] CunOverrideF

Event OnUpdate()

	if SceneEnded
		RemoveExpressions()
		return
	endif

	if SLSAhegaoActive
		;SLS owns the player's face right now - don't fight it. Keep the loop
		;ticking so we pick straight back up once the ahegao ends.
		float idleinterval = breathingupdateinseconds
		if idleinterval <= 0.0
			idleinterval = 0.5
		endif
		RegisterForSingleUpdate(idleinterval)
		return
	endif

	bool breathingon = enablebreathing == 1 && breathingupdateinseconds > 0.0

	if !breathingon || TicksUntilFull <= 0
		FullExpressionPass()

		if SceneEnded
			;the scene ended while this cycle was mid-application - the event
			;handler's reset already ran, so re-clean the frame we just applied
			RemoveExpressions()
			return
		endif

		float fullinterval = GetExpressionUpdateSeconds()
		int fullticks = 0
		if breathingon
			fullticks = ((fullinterval / breathingupdateinseconds) + 0.5) as int
		endif
		if fullticks <= 1
			TicksUntilFull = 0
			RegisterForSingleUpdate(fullinterval)
		else
			TicksUntilFull = fullticks - 1
			RegisterForSingleUpdate(breathingupdateinseconds)
		endif
	else
		TicksUntilFull -= 1
		BreathePass()

		if SceneEnded
			RemoveExpressions()
			return
		endif
		RegisterForSingleUpdate(breathingupdateinseconds)
	endif

EndEvent

Function FullExpressionPass()

	;Ends if actor is no longer in scene but magic stuck for some reason
	if MasterScript.AnimationisEnding() || !Sexlab.GetThreadByActor(actorref)
		SceneEnded = true
		RemoveExpressions()
		return
	endif

	int failsafe = 0
	while MasterScript.isupdating() && failsafe < 50 ;wait for director to finish updating
		Utility.wait(0.1)
		failsafe += 1
		printdebug("Waiting for Director to finish Updating")
	endwhile

	HentairimUpdateStageData()

	;if still orgasming, maintain orgasm face
	if GetSecondsSinceLastOrgasm() > 4
		IsOrgasming = false
	endif

	;set Role
	if IsVictim && !isbroken()
		Role = "v"
	else
		Role = "c"
	endif

	;Check if should add tongue or ahegao
	if !IsBroken() && HasMFEE && EnabledMFEEAhegao == 1
		MFEEAddAhegao = false
	endif

	if IsSuckingoffOther() && removetongueonblowjob == 1
		RemoveTongue()
		printdebug("Removing Tongue during  blowjob")
	elseif IsBroken() && HasMFEE && EnabledMFEEAhegao == 1
		RemoveTongue()
		MFEEAddAhegao = true
		printdebug("Starting MFEE Ahegao")
	endif

	;jaw gate: retry a suppressed tongue, or drop an active one whose mouth stayed closed
	UpdateTongueJawGate()

	if IsUnconcious()
		MfgConsoleFunc.SetModifier(actorref, 0, 100) ;left blink
		MfgConsoleFunc.SetModifier(actorref, 1, 100) ;right blink
		MfgConsoleFunc.SetPhoneme(actorref,0,60) ; aah
		BreathingAllowed = false
		AdvancePhase()
		return
	endif

	if !BlowjobOverrideF
		;stale save with an older script version mid-scene - reload config and presets
		InitializeConfigandForms()
	endif

	LabelGroup = Role + GetHentaiExpression() + ExpressionGroup
	string PhaseLookup = LabelGroup + Phase
	printdebug("Expression Looking up : " + PhaseLookup)

	EnsurePhaseCache()

	int varPct = CachedVariance[Phase - 1]
	if varPct < 0
		printdebug(" Expressions : " + PhaseLookup + " missing in " + ExpressionsFile + " even after fallback. Skipping expression this cycle.")
		BreathingAllowed = false
		AdvancePhase()
		return
	endif

	bool mouthblowjob = IsSuckingoffOther() || HasDeviousGag(actorref)
	;enableahegao gates only the hugePP arm; a broken actor always gets the broken face (pre-existing behavior, parens made explicit)
	bool brokenface = (enableahegao == 1 && ishugepp && (IsGettingAnallyPenetrated() || IsGettingVaginallyPenetrated())) || (IsBroken() && (PenisActionlabel != "LDI" || Penetrationlabel != "LDI" || StimulationLabel != "LDI" || OralLabel != "LDI"))

	float[] result = BuildTickPreset(GetCachedPhase(Phase), varPct, mouthblowjob, brokenface)

	;MFEE side effects, hoisted out of the per-cell loops so they run once per cycle
	if MFEEAddAhegao
		if MuFacialExpressionExtended.GetExpressionValueByNumber(actorref,0,1) != 100
			MuFacialExpressionExtended.SetExpressionByNumber(actorref,0,0,100) ;ahegao 1
		endif
		;make sure tongue out and tongue down is not applied as ahegao already has tongue out and down
		if MuFacialExpressionExtended.GetExpressionValueByNumber(actorref,8,0) != 0 || MuFacialExpressionExtended.GetExpressionValueByNumber(actorref,2,0) != 0
			MuFacialExpressionExtended.SetExpressionByNumber(actorref,8,0,0) ;tongueout
			MuFacialExpressionExtended.SetExpressionByNumber(actorref,8,2,0) ;tongue down
		endif
		if MfgConsoleFunc.GetModifier(actorref, 11) != 50
			MfgConsoleFunc.SetModifier(actorref, 11, ahegaolookupmodifier) ;look up 50
		endif
	else
		if !mouthblowjob && MFEEAddTongue
			;apply MFEE tongue out and down
			if MuFacialExpressionExtended.GetExpressionValueByNumber(actorref,8,0) != 100 || MuFacialExpressionExtended.GetExpressionValueByNumber(actorref,2,0) != 100
				MuFacialExpressionExtended.SetExpressionByNumber(actorref,8,0,100) ;tongueout
				MuFacialExpressionExtended.SetExpressionByNumber(actorref,8,2,100) ;tongue down
			endif
		endif
		if brokenface && HasMFEEVanillaRace && MuFacialExpressionExtended.GetExpressionValueByNumber(actorref,0,0) != 100
			MuFacialExpressionExtended.SetExpressionByNumber(actorref,0,0,100) ;ahegao 1
		endif
	endif

	MfgConsoleFuncExt.ApplyExpressionPresetSmooth(actorref, result, false)

	;baseline for the cheap breathing ticks between full passes
	BreathBase0 = (result[0] * 100.0) as int
	BreathingAllowed = !(mouthblowjob || MFEEAddTongue || MFEEAddAhegao || EquippedTongue() || IsKissing() || IsCunnilingus())

	AdvancePhase()

EndFunction

Function AdvancePhase()
	if phase >= 5
		phase = 1
	else
		phase += 1
	endif
EndFunction

Function BreathePass()
	;cheap sub-tick: no MasterScript/SexLab/Json calls, just a mouth nudge around the last applied face
	if !BreathingAllowed
		return
	endif

	int amp = 8
	if Isintense()
		amp = 15
	endif

	int v = BreathBase0 + Utility.RandomInt(0 - amp, amp)
	if v < 0
		v = 0
	elseif v > 100
		v = 100
	endif

	MfgConsoleFuncExt.SetPhoneme(actorref, 0, v, 0.4)
EndFunction

Float[] Function BuildTickPreset(float[] base, int varPct, bool mouthblowjob, bool brokenface)
	;build a fresh preset from the cached base - the cached arrays are shared and must never be written to
	float[] result = new float[32]

	bool mouthtongueout = EquippedTongue()
	bool mouthkis = IsKissing()
	bool mouthcun = IsCunnilingus()
	bool cowgirl = IsCowgirl()
	bool doggy = false
	if !MFEEAddAhegao && !brokenface && !cowgirl
		doggy = (CurrentThread.HasSceneTag("Doggy") || CurrentThread.HasSceneTag("Doggystyle") || CurrentThread.HasSceneTag("Doggy Style")) && IsgettingPenetrated()
	endif

	;phonemes 0-15
	int i = 0
	while i <= 15
		if MFEEAddAhegao
			if i == 1
				result[i] = ahegaophonemebigaah / 100.0 ;phoneme 1 big aah
			else
				result[i] = 0.0
			endif
		elseif mouthblowjob
			result[i] = BlowjobOverrideF[i]
		elseif MFEEAddTongue
			if i == 1
				result[i] = tonguephonemebigaah / 100.0
			elseif i == 11
				result[i] = tonguephonemeoh / 100.0
			else
				result[i] = 0.0
			endif
		elseif mouthtongueout
			result[i] = TongueOutOverrideF[i]
		elseif mouthkis
			result[i] = KisOverrideF[i]
		elseif mouthcun
			result[i] = CunOverrideF[i]
		else
			float lo = base[i] * (100 - varPct) / 100.0
			float hi = base[i] * (100 + varPct) / 100.0
			if lo < 0.0
				lo = 0.0
			endif
			if hi > 1.0
				hi = 1.0
			endif
			result[i] = Utility.RandomFloat(lo, hi)
		endif
		i += 1
	endwhile

	;modifiers 16-29 (base values pass through unless an override claims them)
	i = 16
	while i <= 29
		if MFEEAddAhegao
			if i == 27
				result[i] = base[i] ;look up is driven separately via SetModifier
			else
				result[i] = 0.0
			endif
			i += 1
		elseif brokenface
			result[i] = BrokenOverrideF[i]
			i += 1
		elseif cowgirl && i == 24
			result[24] = 1.0 ;look downwards if riding
			result[25] = base[25]
			result[26] = base[26]
			result[27] = base[27]
			i = 28
		elseif doggy && i == 24
			result[24] = base[24]
			result[25] = base[25]
			result[26] = base[26]
			result[27] = base[27]
			result[lookdirection + 16] = 1.0
			i = 28
		else
			result[i] = base[i]
			i += 1
		endif
	endwhile

	result[30] = base[30]
	if !MFEEAddAhegao && IsBroken()
		result[31] = BrokenOverrideF[31]
	else
		result[31] = base[31]
	endif

	return result
EndFunction

Function EnsurePhaseCache()
	if CachedLabelGroup == LabelGroup && CachedVariance
		if !CacheUsedFallback || CacheLoadedIntense == Isintense()
			return
		endif
	endif

	CacheUsedFallback = false
	CacheLoadedIntense = Isintense()
	if !CachedVariance
		CachedVariance = new int[5]
	endif

	string fallbackExpr = "grunt"
	if CacheLoadedIntense
		fallbackExpr = "intensegrunt"
	endif

	int p = 1
	while p <= 5
		string lookupkey = LabelGroup + p
		string[] arr = papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile, lookupkey, ""), ",")
		if arr.length < 33
			printdebug(" Expressions : " + lookupkey + " missing/malformed in " + ExpressionsFile + " (" + arr.length + " items). Falling back to generic " + fallbackExpr + " face.")
			lookupkey = Role + fallbackExpr + ExpressionGroup + p
			arr = papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile, lookupkey, ""), ",")
			CacheUsedFallback = true
		endif
		if arr.length < 33
			printdebug(" Expressions : fallback " + lookupkey + " also missing in " + ExpressionsFile + ".")
			CachedVariance[p - 1] = -1
		else
			CachedVariance[p - 1] = arr[32] as int
			if p == 1
				CachedPhase1 = ConvertPresetToFloats(arr)
			elseif p == 2
				CachedPhase2 = ConvertPresetToFloats(arr)
			elseif p == 3
				CachedPhase3 = ConvertPresetToFloats(arr)
			elseif p == 4
				CachedPhase4 = ConvertPresetToFloats(arr)
			else
				CachedPhase5 = ConvertPresetToFloats(arr)
			endif
		endif
		p += 1
	endwhile

	CachedLabelGroup = LabelGroup
EndFunction

Float[] Function GetCachedPhase(int p)
	;read-only: callers must never write into the returned array
	if p == 1
		return CachedPhase1
	elseif p == 2
		return CachedPhase2
	elseif p == 3
		return CachedPhase3
	elseif p == 4
		return CachedPhase4
	endif
	return CachedPhase5
EndFunction

Float[] Function ConvertPresetToFloats(String[] values)
	float[] result = new float[32]
	int srclen = values.length
	int i = 0
	while i < 32
		if i >= srclen || !values[i]
			result[i] = 0.0
		elseif i == 30
			result[i] = values[i] as float
		else
			result[i] = (values[i] as float) / 100.0
		endif
		i += 1
	endwhile
	return result
EndFunction

Float Function GetMeasuredMouthOpen()
	;max of the mouth-opening phonemes, 0.0-1.0, or -1.0 when unreadable: an
	;all-zero reading is indistinguishable from a failed native read, so 0 is
	;treated as unknown too - callers must fail open on -1.0
	int best = MfgConsoleFunc.GetPhoneme(actorref, 0)
	int p = MfgConsoleFunc.GetPhoneme(actorref, 1)
	if p > best
		best = p
	endif
	p = MfgConsoleFunc.GetPhoneme(actorref, 5)
	if p > best
		best = p
	endif
	p = MfgConsoleFunc.GetPhoneme(actorref, 6)
	if p > best
		best = p
	endif
	p = MfgConsoleFunc.GetPhoneme(actorref, 7)
	if p > best
		best = p
	endif
	p = MfgConsoleFunc.GetPhoneme(actorref, 9)
	if p > best
		best = p
	endif
	if best <= 0
		return -1.0
	endif
	if best > 100
		best = 100
	endif
	return best / 100.0
EndFunction

int TongueClosedTicks = 0
bool TongueGateBlocked = false

Function UpdateTongueJawGate()
	if TongueGateBlocked
		;a tongue roll was suppressed by the jaw gate - the labels (and the
		;winning chance roll) still stand, so retry now that the face moved on
		TongueGateBlocked = false
		printdebug("Tongue jaw gate: retrying suppressed tongue")
		AddTongue()
		return
	endif

	if !(MFEEAddTongue || EquippedTongue())
		TongueClosedTicks = 0
		return
	endif

	float openness = GetMeasuredMouthOpen()
	if openness >= 0.0 && openness < tonguemouthopenthreshold
		;require two consecutive confident readings (~2s apart, past any smooth
		;transition) before stripping the tongue, to avoid churn on a stale read
		TongueClosedTicks += 1
		if TongueClosedTicks >= 2
			printdebug("Tongue jaw gate: mouth measured closed twice (" + openness + "), removing tongue.")
			RemoveTongue()
			TongueClosedTicks = 0
		endif
	else
		TongueClosedTicks = 0
	endif
EndFunction


;-------------------------------Hentairim Expressions Functions START---------------------------------
function RemoveExpressions()
	resetexpressions()
	RemoveTongue()
	Spell ExpressionsSpell = Game.GetFormFromFile(0x800, "HentairimExpressions.esp") as Spell
	actorref.RemoveSpell(ExpressionsSpell)
EndFunction

string ExpressionGroup = "a"
String MasksFile  = "HentairimExpressions/Masks.json"
String ExpressionsFile = ""
string ConfigFile = "HentairimExpressions/Config.json"

String[] Masks
String[] Maskslots
string[] exclude
int lookdirection = 9

bool IsPlayer
bool Gender
actor playerref
int enabletongue
int fhutonguetype
int removetongueonblowjob
int cunusetongue
int enableahegao
int chancetostickouttongueduringintense
int chancetostickouttongueduringattacking
int enableprintdebug
Float pcnonintenseexpressionupdateinseconds
Float pcintenseexpressionupdateinseconds
Float npcnonintenseexpressionupdateinseconds
Float npcintenseexpressionupdateinseconds
	  
Function InitializeConfigandForms()
printdebug("------------------Initialize Hentai Expressions Configs and Forms Start-------------------------")
	playerref = game.getplayer()
	IsPlayer = actorref == playerref
	Gender = sexlab.GetGender(ActorRef)

	;seed the SLS ahegao state in case it's already active when this instance starts
	if IsPlayer
		SLSAhegaoActive = StorageUtil.GetIntValue(None, "_SLS_IsAhegaoing", 0) == 1
	endif
	
	if IsPlayer
		ExpressionsFile = "HentairimExpressions/PCExpressions.json"
	elseif gender == 0	;Male
		ExpressionsFile = "HentairimExpressions/MaleExpressions.json"
	elseif gender == 1	;female
		ExpressionsFile ="HentairimExpressions/FemaleExpressions.json"	
	endif

	BlowjobOverrideF = ConvertPresetToFloats(papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile,"blowjobphonemeoverride","") ,","))
	BrokenOverrideF = ConvertPresetToFloats(papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile,"brokenmodifieroverride","") ,","))
	TongueOutOverrideF = ConvertPresetToFloats(papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile,"tongueoutphonemeoverride","") ,","))
	KisOverrideF = ConvertPresetToFloats(papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile,"kisphonemeoverride","") ,","))
	CunOverrideF = ConvertPresetToFloats(papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile,"cunphonemeoverride","") ,","))
	CachedLabelGroup = "" ;presets may have changed - force a phase cache reload
	Masks = papyrusutil.stringsplit(JsonUtil.GetStringValue(MasksFile,"masks","") ,",")
	Maskslots = papyrusutil.stringsplit(JsonUtil.GetStringValue(MasksFile,"maskslots","") ,",")
	exclude = papyrusutil.stringsplit(JsonUtil.GetStringValue(MasksFile,"exclude","") ,",")
	enabletongue =  JsonUtil.GetIntValue(ConfigFile, "enabletongue" ,0)
	fhutonguetype = JsonUtil.GetIntValue(ConfigFile, "fhutonguetype" ,0)
	removetongueonblowjob = JsonUtil.GetIntValue(ConfigFile, "removetongueonblowjob" ,0)
	cunusetongue = JsonUtil.GetIntValue(ConfigFile, "cunusetongue" ,0)
	enableahegao = JsonUtil.GetIntValue(ConfigFile, "enableahegao" ,0)
	chancetostickouttongueduringintense = JsonUtil.GetIntValue(ConfigFile, "chancetostickouttongueduringintense" ,0)
	chancetostickouttongueduringattacking = JsonUtil.GetIntValue(ConfigFile, "chancetostickouttongueduringattacking" ,0)
	enableprintdebug = JsonUtil.GetIntValue(ConfigFile, "printdebug" ,0)
	
	enablebreathing = JsonUtil.GetIntValue(ConfigFile, "enablebreathing" ,1)
	breathingupdateinseconds = JsonUtil.GetFloatValue(ConfigFile, "breathingupdateinseconds" ,0.55)
	tonguemouthopenthreshold = JsonUtil.GetFloatValue(ConfigFile, "tonguemouthopenthreshold" ,0.4)
	pcnonintenseexpressionupdateinseconds = JsonUtil.GetFloatValue(ConfigFile, "pcnonintenseexpressionupdateinseconds" ,3.0)
	pcintenseexpressionupdateinseconds = JsonUtil.GetFloatValue(ConfigFile, "pcintenseexpressionupdateinseconds" ,3.0)
	npcnonintenseexpressionupdateinseconds = JsonUtil.GetFloatValue(ConfigFile, "npcnonintenseexpressionupdateinseconds" ,3.0)
	npcintenseexpressionupdateinseconds = JsonUtil.GetFloatValue(ConfigFile, "npcintenseexpressionupdateinseconds" ,3.0)
	
	printdebug("enabletongue : " +enabletongue)
	printdebug("fhutonguetype : " +fhutonguetype)
	printdebug("removetongueonblowjob : " +removetongueonblowjob)
	printdebug("cunusetongue : " + cunusetongue)
	printdebug("enableahegao : "+enableahegao)
	printdebug("chancetostickouttongueduringintense : "+chancetostickouttongueduringintense)
	printdebug("chancetostickouttongueduringattacking : "+chancetostickouttongueduringattacking)
	printdebug("enableprintdebug : "+enableprintdebug)
	printdebug("enablebreathing : "+enablebreathing)
	printdebug("breathingupdateinseconds : "+breathingupdateinseconds)
	printdebug("tonguemouthopenthreshold : "+tonguemouthopenthreshold)
	printdebug("pcnonintenseexpressionupdateinseconds : "+pcnonintenseexpressionupdateinseconds)
	printdebug("pcintenseexpressionupdateinseconds : "+pcintenseexpressionupdateinseconds)
	printdebug("npcnonintenseexpressionupdateinseconds : "+npcnonintenseexpressionupdateinseconds)
	printdebug("npcintenseexpressionupdateinseconds : "+npcintenseexpressionupdateinseconds)
	
	InitializeAddNPCTongue()
printdebug("------------------Initialize Hentai Expressions Configs and Forms END-------------------------")
endfunction

Function ResetHentaiExpressionGroup()
int type
	Type = Utility.Randomint(1,3)	
	if type == 1
		ExpressionGroup = "a"
	elseif type == 2
		ExpressionGroup = "b"
	elseif type == 3
		ExpressionGroup = "c"
	endif

	lookdirection = utility.Randomint(8,10)
	CachedLabelGroup = "" ;group letter is part of the cache key - force reload
endfunction

string Function GetExpressionLabel()

if PenetrationLabel != "LDI"
	return PenetrationLabel
elseif PenisActionLabel != "LDI"
	return PenisActionLabel
elseif StimulationLabel != "LDI"
	return StimulationLabel
elseif EndingLabel != "LDI"
	return EndingLabel
else 
	return "LDI"
endif

endfunction

Bool Function EquippedTongue()
	if !FHUTongueTypeArmor
		return false
	endif
	return actorref.IsEquipped(FHUTongueTypeArmor)
EndFunction

Function AddTongue()

	printdebug("AddTongue: Starting. MFEEAddAhegao=" + MFEEAddAhegao + " WearingMask=" + (WearingMask(actorref) != none) + " IsSuckingoffOther=" + IsSuckingoffOther() + " EnableTongue=" + EnableTongue + " HasDeviousGag=" + HasDeviousGag(actorref) + " IsUnconcious=" + IsUnconcious() + " EquippedTongue=" + EquippedTongue())

	if MFEEAddAhegao || WearingMask(actorref) != none || IsSuckingoffOther() || EnableTongue != 1 || HasDeviousGag(actorref) || IsUnconcious() || EquippedTongue()
		printdebug("AddTongue: Conditions blocked tongue, exiting early.")
		return
	endif

	;jaw gate: don't show a tongue through closed lips. Only a confidently-low
	;nonzero reading blocks (unreadable/zero fails open); a blocked roll is
	;retried by UpdateTongueJawGate on the next full pass
	float openness = GetMeasuredMouthOpen()
	if openness >= 0.0 && openness < tonguemouthopenthreshold
		printdebug("AddTongue: mouth not open enough (" + openness + "), deferring tongue.")
		TongueGateBlocked = true
		return
	endif

	if HasMFEE && EnabledMFEETongue == 1
		printdebug("AddTongue: Using MFEE tongue expression.")
		MFEEAddTongue = true
	else
		if Game.GetModByName("sr_fillherup.esp") != 255
			printdebug("AddTongue: sr_fillherup.esp detected, equipping FHUTongueTypeArmor if available.")
			armor temptongue 
			
			if FHUTongueTypeArmor
				printdebug("AddTongue: Equipping FHUTongueTypeArmor=" + FHUTongueTypeArmor)
				actorref.AddItem(FHUTongueTypeArmor, abSilent = true)
				actorref.EquipItem(FHUTongueTypeArmor, abSilent = true)
			else
				printdebug("AddTongue: FHUTongueTypeArmor not defined, skipping equip.")
			endif
		else
			printdebug("AddTongue: sr_fillherup.esp not detected, skipping FHU tongue.")
		endif
	endif
EndFunction

Function RemoveTongue()

if HasMFEE && MFEEAddTongue
	MFEEAddTongue = false
else
	if EquippedTongue()
	
		actorref.unEquipItem(FHUTongueTypeArmor, abSilent=true)
		actorref.removeItem(FHUTongueTypeArmor , abSilent=true)
	
	endif
endif
endfunction

Function unequipmask(actor char)
Armor Mask = wearingmask(char)
if Mask
	actorref.unEquipItem(Mask, abSilent=true)
endif

endfunction

Armor Function WearingMask(actor char)
if Maskslots.length == 0
	return none
endif

int slotlength = Maskslots.length
int slotindex = 0
int masklength = Masks.length
int maskindex = 0
int excludelength = exclude.length
int excludeindex = 0
Armor Mask
Armor WearingMask = none
string Maskname

	while slotindex < slotlength
		Mask = char.GetWornForm(Armor.GetMaskForSlot(Maskslots[slotindex] as int)) as armor
		if Mask
			Maskname = Mask.getname()
		else
			Maskname = ""
		endif
		excludeindex = 0
		maskindex = 0
		
		;check to see if its excluded opened Mask
		while excludeindex < excludelength
			if stringutil.find(Maskname ,Masks[excludeindex]) > -1
				maskindex = 100
				excludeindex = 100
			endif
			excludeindex += 1
		endwhile
		
		;check to see if its wearing mask
		while maskindex < masklength
			if stringutil.find(Maskname ,Masks[maskindex]) > -1
				WearingMask = Mask
				maskindex = 100
				slotindex = 100
			endif
			maskindex += 1
		endwhile

	slotindex += 1
	endwhile
	printdebug("Wearing Mask :" + WearingMask)
return WearingMask 
endfunction

Bool Function HasDeviousGag(Actor char)
	if has_MagicEffect(char, 0x2b077, "Devious Devices - Integration.esm")
		return true
	endif
	return false
EndFunction

bool function has_MagicEffect(actor a, int id, string filename)
	MagicEffect ME = get_form(id, filename) as MagicEffect
	if !ME
		return false
	endif
	return a.HasMagicEffect(ME)
endfunction


Bool Function IsUnconcious()
	if (CurrentThread.HasSceneTag("faint") || CurrentThread.HasSceneTag("sleep") || CurrentThread.HasSceneTag("necro")) && position == 0
		Return true
	else
		return false
	endif
endfunction


String Function GetPrimaryLabel()
	IF OralLabel != "LDI"
		return OralLabel
	elseif Stimulationlabel == "BST"
		return Stimulationlabel
	elseif PenetrationLabel != "LDI"
		return PenetrationLabel
	elseif PenisActionLabel != "LDI"
		return PenisActionLabel
	else
		return Stimulationlabel
	endif
endfunction

int function  GetFullEnjoyment()
	int enjoyment = CurrentThread.GetEnjoyment(actorref) as int
	printdebug("Enjoyment : " + enjoyment)
	return enjoyment
endfunction

bool IsOrgasming

String Function GetHentaiExpression()

string 	HentaiScenario = StorageUtil.GetStringValue(None, "HentaiScenario", "")
if !isplayer || (isplayer && HentaiScenario == "")
	if IsOrgasming
		HentaiScenario = "orgasm"
	elseif (IsGivingAnalPenetration() || IsGivingVaginalPenetration()  || IsGettingSuckedoff()) && !Isintense()
		HentaiScenario = "grunt"
	elseif (IsGivingAnalPenetration() || IsGivingVaginalPenetration() || IsGettingSuckedoff()) && Isintense()
		HentaiScenario = "intensegrunt"
	elseif GetFullEnjoyment() > 70 && !Isintense() && gender == 0
		HentaiScenario = "closetoorgasm"
	elseif GetFullEnjoyment() > 70 && Isintense() && gender == 0
		HentaiScenario = "closetoorgasmintense"
	elseif (IsCowgirl() || IsGivingAnalPenetration() || IsGivingVaginalPenetration() ) && !IsVictim
		HentaiScenario = "attacking"
	elseif IsGettingStimulated()
		if Isintense()
			HentaiScenario = "grunt"
		else
			HentaiScenario = "Leadin"
		endif
	elseif IsEnding()
		if IsVictim
			HentaiScenario = "unamusedending"
		else
			HentaiScenario = "Panting"
		endif
	else
		if Isintense()
			HentaiScenario = "intensegrunt"
		else
			HentaiScenario = "grunt"
		endif
	Endif
endif

return HentaiScenario

EndFunction

function resetexpressions()

;SLS owns the player's face during its ahegao and wants it to persist past the
;scene end - don't wipe it. SLS clears its own face when its ahegao finishes.
if SLSAhegaoActive
	return
endif

;0.1 = near-instant: the default 0.75 makes the reset itself a slow smooth
;transition that a concurrently-interpolating apply can win against
MfgConsoleFuncExt.resetmfg(actorref, 0.1)
if hasmfee || HasMFEEVanillaRace
	MuFacialExpressionExtended.RevertExpression(actorref)
endif

endfunction


Bool HasMFEE = false
Bool HasMFEEVanillaRace = false
int  EnabledMFEETongue = 0
int EnabledMFEEAhegao = 0
bool MFEEAddTongue = false
bool MFEEAddAhegao = false
int ahegaophonemebigaah
int tonguephonemebigaah
int tonguephonemeoh
int ahegaolookupmodifier
String EnableErinMFEE  = "HentairimExpressions/ErinMFEEConfig.json"

Function CheckHasMFEE()
	;check if has MFEE
	if MuFacialExpressionExtended.GetVersion() > 0   &&  (actorref.GetRace().getname() =="Erin" || actorref.GetRace().getname() =="Elin" )
		HasMFEE = true
		EnabledMFEETongue = JsonUtil.GetIntValue(EnableErinMFEE,"enablemfeetongue",0)  
		EnabledMFEEAhegao = JsonUtil.GetIntValue(EnableErinMFEE,"enablemfeeahegao",0)
		ahegaophonemebigaah = JsonUtil.GetIntValue(EnableErinMFEE,"ahegaophonemebigaah",0)
		tonguephonemebigaah = JsonUtil.GetIntValue(EnableErinMFEE,"tonguephonemebigaah",0)
		tonguephonemeoh	 = JsonUtil.GetIntValue(EnableErinMFEE,"tonguephonemeoh",0)	
		ahegaolookupmodifier = JsonUtil.GetIntValue(EnableErinMFEE,"ahegaolookupmodifier",0)
    elseif MuFacialExpressionExtended.GetVersion() > 0
		HasMFEEVanillaRace = true
	endif
endfunction


Float function GetSecondsSinceLastOrgasm()

return CurrentThread.Gettimetotal() - LastOrgasmtime 

endfunction

float function GetExpressionUpdateSeconds()
if IsPlayer
	if Isintense()
		return pcintenseexpressionupdateinseconds
	else
		return pcnonintenseexpressionupdateinseconds
	endif
else
	if Isintense()
		return npcintenseexpressionupdateinseconds
	else
		return npcnonintenseexpressionupdateinseconds
	endif	
endif

EndFunction

Bool function isDependencyReady(String modname)
  int index = Game.GetModByName(modname)
  if index == 255 || index == -1
    return false
  else
    return true
  endif
endfunction

string NPCTongueFile  = "HentairimExpressions/NPCTongue.json"
int enablenpctongue = 0

Function InitializeAddNPCTongue()
printdebug("enablenpctongue : " + enablenpctongue)
enablenpctongue = JsonUtil.GetIntValue(NPCTongueFile, "enablenpctongue", 0)

FHUTongueTypeArmor =  GetTongueType()
endfunction 

armor FHUTongueTypeArmor

Armor function GetTongueType()

	if FHUTongueType == 0
		FHUTongueType = Utility.RandomInt(1, 10)
	endif	
	string name = actorref.getdisplayname()
	int TongueType
	armor Tongue
	if isplayer
		TongueType = FHUTongueType
	elseif enablenpctongue == 1
		TongueType = JsonUtil.GetIntValue(NPCTongueFile, name, 99)
	endif
	
	if TongueType == 1
	Tongue = Game.GetFormFromFile(0x263B2, "sr_fillherup.esp") as Armor
elseif  TongueType == 2
	Tongue = Game.GetFormFromFile(0x263B3, "sr_fillherup.esp") as Armor
elseif  TongueType == 3
	Tongue = Game.GetFormFromFile(0x263B4, "sr_fillherup.esp") as Armor
elseif  TongueType == 4
	Tongue = Game.GetFormFromFile(0x263B5, "sr_fillherup.esp") as Armor
elseif  TongueType == 5
	Tongue = Game.GetFormFromFile(0x263B6, "sr_fillherup.esp") as Armor	
elseif  TongueType == 6
	Tongue = Game.GetFormFromFile(0x263B7, "sr_fillherup.esp") as Armor	
elseif  TongueType == 7
	Tongue = Game.GetFormFromFile(0x263B8, "sr_fillherup.esp") as Armor	
elseif  TongueType == 8
	Tongue = Game.GetFormFromFile(0x263B9, "sr_fillherup.esp") as Armor	
elseif  TongueType == 9
	Tongue = Game.GetFormFromFile(0x263BA, "sr_fillherup.esp") as Armor	
elseif  TongueType == 10
	Tongue = Game.GetFormFromFile(0x263BB, "sr_fillherup.esp") as Armor	
endif

FHUTongueTypeArmor = Tongue
return Tongue
endfunction


;-------------------------------Hentairim Expressions Functions END---------------------------------

;-----------------------BASE HENTAIRIM Update Functions-----------------------------

Bool IsHugePP
string CurrentSceneID = ""
string currentStageID = ""
Int currentStage = -1
Int ThreadID = -1
Faction HentairimBroken
bool IsVictim
float DirectorLastLabelTime
float DirectorLastPhysicsLabelTime

Function HentairimPrepare()
	printdebug("--------------------Hentairim Prepare Initial Data START-----------------")
	HentairimBroken = Game.GetFormFromFile(0x802, "HentairimResistance.esp") as Faction
	ThreadID = CurrentThread.GetThreadID()
	IsHugePP = IsHugePP()
	HentairimUpdateStageData()
	IsVictim = IsVictim(Actorref)
	
	printdebug("ThreadID : " + ThreadID)
	printdebug("Partner IsHugePP : " + IsHugePP)

	printdebug("--------------------Hentairim Prepare Initial Data END-----------------")
endfunction



Function HentairimUpdateStageData()
	printdebug("Updating Labels")

	printdebug("DirectorLastLabelTimeCheck: local=" + DirectorLastLabelTime + " master=" + MasterScript.GetDirectorLastLabelTime())
	if DirectorLastLabelTime != MasterScript.GetDirectorLastLabelTime() || DirectorLastPhysicsLabelTime != MasterScript.GetDirectorLastPhysicsLabelTime()
		printdebug("Animation, Stage or Physics Labels Different. Updating Stage Data")
		TongueGateBlocked = false ;stale gate-deferred rolls don't survive a label change
		CurrentSceneID = CurrentThread.GetActiveScene()
		currentStageID = CurrentThread.GetActiveStage()
		currentstage = GetLegacyStageNum(CurrentSceneID, currentStageID)
		
		UpdateLabels(actorref)	

		printdebug("PC Thread Position : " + CurrentThread.GetPositionIdx(Actorref))
		printdebug("current Animation : " + CurrentSceneID)
		printdebug("current StageID : " + currentStageID)
		printdebug("current stage number: " + currentstage)
		

		int rand = Utility.RandomInt(1,100)
		float chancemultiplier = 1
		if IsBroken()
			chancemultiplier = chancemultiplier * 2
		EndIf
		
		if EquippedTongue()
			if Utility.RandomInt(1,2) == 1
				RemoveTongue()
			EndIf
		else
			if EnableTongue == 1
				;if !EquippedTongue() && (IsCunnilingus() && cunusetongue == 1) || ((IsIntense() || isbroken()) && IsGettingPenetrated() && rand <= chancetostickouttongueduringintense * chancemultiplier) || ((IsCowgirl() || IsGivingAnalPenetration() || IsGivingVaginalPenetration()) && !IsVictim && rand <= chancetostickouttongueduringattacking * chancemultiplier)
				if !EquippedTongue() && ( (IsCunnilingus() && cunusetongue == 1) || ((IsIntense() || isbroken()) && IsGettingPenetrated() && rand <= chancetostickouttongueduringintense * chancemultiplier) || ((IsCowgirl() || IsGivingAnalPenetration() || IsGivingVaginalPenetration()) && !IsVictim && rand <= chancetostickouttongueduringattacking * chancemultiplier) )
					printdebug("Adding Tongue")
					AddTongue()
				endif
			EndIf
		endif
		
		;remove mask if giving BJ
		if IsSuckingoffOther()
			unequipmask(actorref)
		endif
		DirectorLastLabelTime = MasterScript.GetDirectorLastLabelTime()
		DirectorLastPhysicsLabelTime = MasterScript.GetDirectorLastPhysicsLabelTime()
	endif

endfunction

String Stimulationlabel
String PenisActionLabel
string OralLabel
string EndingLabel
string PenetrationLabel
string Labelsconcat
;sexLabThreadController.ActorAlias(actorInQuestion).GetFullEnjoyment()

Function UpdateLabels(actor char)
 	printdebug("--------------------Hentairim Updating Labels START-----------------")
	
 Stimulationlabel = MasterScript.GetStimulationlabel(char)
 PenisActionLabel  = MasterScript.GetPenisActionLabel(char)
 OralLabel  = MasterScript.GetOralLabel(char)
 EndingLabel  = MasterScript.GetEndingLabel(char)
 PenetrationLabel = MasterScript.GetPenetrationLabel(char)
 
 Labelsconcat = "1" +Stimulationlabel + "1" + PenisActionLabel + "1" + OralLabel + "1" + PenetrationLabel + "1" + EndingLabel
 PrintDebug("Stimulationlabel :" + Stimulationlabel + ", PenisActionLabel :" +  PenisActionLabel  + ", OralLabel :" +  OralLabel  + ", PenetrationLabel :" +  PenetrationLabel  + ", EndingLabel :" +  EndingLabel)

printdebug("--------------------Hentairim Updating Labels END-----------------")
endfunction
;-----------------------BASE HENTAIRIM Update Functions END-----------------------------


;-----------------------Hentairim Common Utilities START--------------------------------------

Bool Function Isintense()
	return stringutil.find(Labelsconcat ,"1F") > -1 || stringutil.find(Labelsconcat ,"BST") > -1
endfunction

Bool Function IsGettingStimulated()
	return Stimulationlabel == "SST" ||  Stimulationlabel == "FST"
endfunction

Bool Function IsSuckingoffOther()
	return OralLabel == "SBJ" ||  OralLabel == "FBJ" 
endfunction

Bool Function IsGettingDoublePenetrated()

return PenetrationLabel == "SDP" || PenetrationLabel == "FDP" 
endfunction

Bool Function IsgettingPenetrated()
	return IsGettingAnallyPenetrated() || IsGettingVaginallyPenetrated()
endfunction

Bool Function IsGettingVaginallyPenetrated()
	return PenetrationLabel == "SVP" || PenetrationLabel == "FVP" || PenetrationLabel == "SCG" || PenetrationLabel == "FCG" || PenetrationLabel == "SDP" || PenetrationLabel == "FDP"
endfunction

Bool Function IsGettingAnallyPenetrated() 
	return PenetrationLabel == "SAP" || PenetrationLabel == "FAP"  || PenetrationLabel == "SAC" || PenetrationLabel == "FAC" || PenetrationLabel == "SDP" || PenetrationLabel == "FDP"
endfunction

Bool Function IsKissing()
	return OralLabel == "KIS"
endfunction

Bool Function IsCunnilingus()
	return OralLabel == "CUN"
endfunction

Bool Function IsGivingAnalPenetration()
	return PenisActionLabel == "FDA" || PenisActionLabel == "SDA"
endfunction

Bool Function IsGivingVaginalPenetration()
	return PenisActionLabel =="FDV" || PenisActionLabel == "SDV"
endfunction

Bool Function IsLeadIN()
	return Stimulationlabel == "LDI" && PenisActionlabel == "LDI" && Penetrationlabel == "LDI" && OralLabel == "LDI" && EndingLabel == "LDI" 
endfunction 

Bool Function IsGettingSuckedoff()
	return PenisActionLabel == "SMF" ||  PenisActionLabel == "FMF"	 
endfunction

Bool Function IsCowgirl()
	return PenetrationLabel == "SCG" ||  PenetrationLabel == "FCG" ||  PenetrationLabel == "SAC" ||  PenetrationLabel == "FAC"			
endfunction

Bool Function IsEnding()
	return EndingLabel == "ENI" || EndingLabel == "ENO"
endfunction


Bool function IshugePP()
	if position != 0
		return false
	endif
	return masterscript.ishugepp(actorref)
;/
	;no Huge PP effects if not receiving in position 0
	if position != 0
		return false
	endif
	;SOS
	faction SchlongFaction = Game.GetFormFromFile(0xAFF8 , "Schlongs of Skyrim.esp") as Faction
	;TNG
	keyword TNG_XL
	keyword TNG_L
	keyword TNG_Gentlewoman
	String ControlConfigFile  = "HentairimDirector/Config.json"
	 int HugePPSchlongSize = JsonUtil.GetIntValue(ControlConfigFile, "soshugeppsize" ,6)
    if !TNG_Gentlewoman && isDependencyReady("TheNewGentleman.esp")
      TNG_XL = Game.GetFormFromFile(0xFE5, "TheNewGentleman.esp") as Keyword
      TNG_L = Game.GetFormFromFile(0xFE4, "TheNewGentleman.esp") as Keyword
      TNG_Gentlewoman = Game.GetFormFromFile(0xFF8, "TheNewGentleman.esp") as Keyword
    endif

  String MaleRaceName = actorList[1].GetRace().getName()
  if stringutil.find(MaleRaceName, "Brute") > -1 || stringutil.find(MaleRaceName, "Spider") > -1 || stringutil.find(MaleRaceName, "Lurker") > -1 || stringutil.find(MaleRaceName, "Daedroth") > -1 || stringutil.find(MaleRaceName, "Horse") > -1 || stringutil.find(MaleRaceName, "Bear") > -1 || stringutil.find(MaleRaceName, "Chaurus") > -1 || stringutil.find(MaleRaceName, "Dragon") > -1 || MaleRaceName == "Frost Atronach" || stringutil.find(MaleRaceName, "Giant") > -1 || MaleRaceName == "Mammoth" || MaleRaceName == "Sabre Cat" || stringutil.find(MaleRaceName, "Troll") > -1 || MaleRaceName == "Werewolf" || stringutil.find(MaleRaceName, "Gargoyle") > -1 || MaleRaceName == "Dwarven Centurion" || stringutil.find(MaleRaceName, "Ogre") > -1 || MaleRaceName == "Ogrim" || MaleRaceName == "Nest Ant Flier" || stringutil.find(MaleRaceName, "OGrim") > -1
    return True
  else
    ;if Schlong is big
    if (SchlongFaction)
      return actorList[1].GetFactionRank(SchlongFaction) >= HugePPSchlongSize
    elseif (TNG_XL)
      ;keywords can explicitly overwrite value
      int TNG_Size = TNG_PapyrusUtil.GetActorSize(actorList[1])
      bool tngxl = actorList[1].HasKeyword(TNG_XL)
      bool tngl = actorList[1].HasKeyword(TNG_L)
      bool isBig = tngxl || TNG_Size >= HugePPSchlongSize || tngl

      return isBig
    endif
    return false
  endif
  /;
EndFunction


int Function GetLegacyStageNum(String asScene, String asStage)
	string[] all_stages = SexlabRegistry.GetAllStages(asScene)
	if SexlabRegistry.StageExists(asScene, asStage)
		int stage_num = all_stages.find(asStage)+1
		return stage_num
	endif
	return 0
EndFunction

int Function GetLegacyStagesCount(String asScene)
	int stages_count = SexlabRegistry.GetAllStages(asScene).Length
	return stages_count
EndFunction

float Function GetAnimationSpeed()
	return HentairimAnimSpeed.GetSpeed(game.getplayer(), true)
EndFunction

Function PlaySound(Sound theSound, Actor actorMakingSound, Bool waitForCompletion = True)

	If waitForCompletion
		theSound.PlayAndWait(actorMakingSound)
	Else
		theSound.Play(actorMakingSound)
	EndIf
EndFunction

Bool Function IsVictim(actor char)
  return CurrentThread.GetSubmissive(char)
endFunction

Bool Function IsBroken()
	return actorref.GetFactionRank(HentairimBroken) > 0
endfunction

bool function has_spell(actor a, int id, string filename)
	spell sp = get_form(id, filename) as spell
	if !sp
		return false
	endif
	return a.HasSpell(sp)
endfunction

form function get_form(int id, string filename)
	if Game.GetModbyName(filename) == 255 
		return None
	endif
	return Game.GetFormFromFile(id, filename)
endfunction


Function PrintDebug(string Contents = "")
if enableprintdebug == 1
	miscutil.printconsole(actorref.getdisplayname() + " HentaiRim Expressions " + Contents)
endif
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
;-----------------------Hentairim Common Utilities END--------------------------------------
function WritetoErrorlogs(string Header = "Not Specified" ,String contents = "")
	JsonUtil.StringListAdd("ErrorLog.json", Header, " : " + contents, TRUE)
endfunction
