Scriptname HentairimAnimSpeed Hidden
; Guard wrapper for AnimSpeedSE (SKSE plugin). All functions are no-ops / safe
; defaults when the plugin is not loaded, detected via GetVersion() == 0.

bool Function IsPresent() Global
	return PO3_SKSEFunctions.IsPluginFound("AnimSpeedSE")
EndFunction

; Returns current animation speed, or 1.0 (normal) if plugin absent.
Float Function GetSpeed(ObjectReference target, bool absolute) Global
	if !IsPresent()
		return 1.0
	endif
	return AnimSpeedHelper.GetAnimationSpeed(target, absolute)
EndFunction

; Sets animation speed. No-op if plugin absent.
Function SetSpeed(ObjectReference target, float scale, float transition, bool absolute) Global
	if !IsPresent()
		return
	endif
	AnimSpeedHelper.SetAnimationSpeed(target, scale, transition, absolute)
EndFunction
