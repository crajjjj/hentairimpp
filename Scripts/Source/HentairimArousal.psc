Scriptname HentairimArousal Hidden
; Universal arousal interface — OSLAroused and SexLab Aroused NG.
;
; Detection: Quest.GetQuest("sla_Framework") — both OSL and SLANG ship this editor ID.
; OSL stub returns GetVersion() = 20140124. Real SLANG >= 20200000.
;
; Read : slaframeworkscr.GetActorArousal — works on both forks.
; Write: slaModArousalEffect ModEvent for real SLANG; slaframeworkscr.UpdateActorExposure fallback for OSL stub.

bool Function IsPresent() Global
	return Game.GetModByName("SexLabAroused.esm") != 255
EndFunction

Quest Function GetFramework() Global
	return Quest.GetQuest("sla_Framework")
EndFunction

; True when real SLA NG is installed (not OSL's stub, which returns version 20140124).
bool Function SupportsSLANG() Global
	Quest sla = GetFramework()
	if !sla
		return false
	endif
	return (sla as slaframeworkscr).GetVersion() > 20200000
EndFunction

; Returns current arousal 0-100.
Float Function GetArousal(Actor who) Global
	if !who
		return 0.0
	endif
	Quest sla = GetFramework()
	if !sla
		return 0.0
	endif
	return (sla as slaframeworkscr).GetActorArousal(who) as float
EndFunction

; Adds value to the actor's arousal, clamped to 0-100.
; Real SLANG: fires slaModArousalEffect ModEvent on the "Legacy" effect.
; OSL stub: calls slaframeworkscr.UpdateActorExposure directly.
Function ModifyArousal(Actor who, Float value) Global
	if !who
		return
	endif
	if SupportsSLANG()
		int handle = ModEvent.Create("slaModArousalEffect")
		if handle
			ModEvent.PushForm(handle, who)
			ModEvent.PushString(handle, "Legacy")
			ModEvent.PushFloat(handle, value)
			ModEvent.PushFloat(handle, 100.0)
			ModEvent.Send(handle)
		endif
	else
		Quest sla = GetFramework()
		if sla
			(sla as slaframeworkscr).UpdateActorExposure(who, value as int)
		endif
	endif
EndFunction
