Scriptname HentairimOninusLactating extends ActiveMagicEffect  

import b612

IVDTControllerScript Property MasterScript Auto
SexLabFramework Property SexLab Auto 
SexLabThread CurrentThread = None
actor Actorref
actor PlayerRef
String OninusLactisFile  = "HentairimAdventure/OninusLactis.json"

Event OnEffectStart(Actor akTarget, Actor akCaster)	
	PrintDebug("[OnEffectStart] Called with target: " + akTarget + " caster: " + akCaster)
	ActorRef = akTarget
	PlayerRef = Game.GetPlayer()

	if !ActorRef
		PrintDebug("[OnEffectStart] No target actor! Removing spell.")
		RemoveSpell()
		return
	endif

	RegisterForModEvent("HookAnimationStart", "HentairimOninusLactisSceneStart")
	RegisterForModEvent("HookAnimationEnd", "HentairimOninusLactisSceneEnd")	
	RegisterForModEvent("SexLabOrgasmSeparate", "HentairimOninusLactisOnOrgasm")
	RegisterForModEvent("HookStageStart", "HentairimOninusLactisStageStart")

	PrintDebug("[OnEffectStart] Finished setup for " + ActorRef.GetDisplayName())
EndEvent

Event OnUpdate()
	PrintDebug("[OnUpdate] Triggered for " + ActorRef)

	if !ActorRef
		RemoveSpell()
		return
	endif 
	
	if InSex 
		PrintDebug("[OnUpdate] Actor is in sex, checking penetration.")
		if IsGettingPenetrated
			PrintDebug("[OnUpdate] Actor is getting penetrated. Rolling for lactation (IsIntense=" + IsIntense + ")")
			if Masterscript.RollforPenetrationLactating(IsIntense)
				PrintDebug("[OnUpdate] Roll succeeded. Triggering lactation.")
				Masterscript.OninusLactislactate(IsIntense)
			else
				PrintDebug("[OnUpdate] Roll failed. No lactation this tick.")
			endif
		endif
		RegisterForSingleUpdate(10)
	else
		PrintDebug("[OnUpdate] Not in sex. Scheduling next check in 300 seconds.")
		RegisterForSingleUpdate(300)
	endif
EndEvent

Event HentairimOninusLactisOnOrgasm(Form akAktor, Int aithread)
	actor char = akAktor as actor
	CurrentThread = Sexlab.GetThread(aithread)
	PrintDebug("[OnOrgasm] Triggered by " + char + " in thread " + aithread)

	if !CurrentThread.HasActor(actorref)
		PrintDebug("[OnOrgasm] CurrentThread does not contain ActorRef. Ignoring.")
		return
	endif
	
	if MasterScript.RollforOrgasmLactating()
		PrintDebug("[OnOrgasm] Roll succeeded. Forcing intense lactation.")
		MasterScript.OninusLactislactate(True)
	else
		PrintDebug("[OnOrgasm] Roll failed. No lactation.")
	endif
EndEvent

Bool InSex
Bool IsGettingPenetrated
Bool IsIntense

Event HentairimOninusLactisStageStart(int aiThreadID, bool abHasPlayer) 
	PrintDebug("[StageStart] Called for Thread=" + aiThreadID)
	
	if !CurrentThread.HasActor(actorref)
		PrintDebug("[StageStart] Actor not in current thread, skipping.")
		return
	endif
	
	if MasterScript.IsgettingPenetrated(Actorref)
		IsGettingPenetrated = true
		IsIntense = stringutil.substring(Masterscript.GetPenetrationLabel(actorref),0,1) == "f"
		PrintDebug("[StageStart] Actor is penetrated. IsIntense=" + IsIntense)
	else
		IsGettingPenetrated = false
		IsIntense = false
		PrintDebug("[StageStart] Actor not penetrated.")
	endif
EndEvent

Event HentairimOninusLactisSceneStart(int aiThreadID, bool abHasPlayer) 
	PrintDebug("[SceneStart] Thread=" + aiThreadID)
	if !CurrentThread.HasActor(actorref)
		PrintDebug("[SceneStart] Actor not in thread, skipping.")
		return
	endif
	
	InSex = true
	RegisterForSingleUpdate(1)
	PrintDebug("[SceneStart] Actor is in sex. Scheduling update.")
EndEvent

Event HentairimOninusLactisSceneEnd(int aiThreadID, bool abHasPlayer) 
	PrintDebug("[SceneEnd] Thread=" + aiThreadID)
	if !CurrentThread.HasActor(actorref)
		PrintDebug("[SceneEnd] Actor not in thread, skipping.")
		return
	endif
	IsGettingPenetrated = false
	IsIntense = false
	InSex = false
	PrintDebug("[SceneEnd] Reset all flags.")
EndEvent 

Function RemoveSpell()
	PrintDebug("[RemoveSpell] Removing spell from " + ActorRef)
	ActorRef.RemoveSpell(po3_sksefunctions.GetActiveEffectSpell(self) as Spell)
EndFunction

function PrintDebug(string contents = "")
	miscutil.printconsole("Hentairim Adventure : " + contents)
endfunction
