Scriptname IVDTVoiceFemaleScript extends ReferenceAlias
{This holds all of the voice categories for a single female voice. Instances of this script are made as quest aliases under the IVDTMainQuest to support multiple voices.
Categories are folder names resolved by AudioUtil.dll (Sound\fx\IVDT\<slot>\<category>) — no sound descriptors involved.}

;Which AudioUtil slot this alias speaks with ("F1", "F2", ...). Resolved per-actor by
;the DLL when empty; only set for fixed-slot aliases.
String Property VoiceSlot = "F1" Auto

;Romantic comments
Sound Property GreetLover Auto
String Property sGreetLover = "GreetLover" Auto
Sound Property GreetFamiliar Auto
String Property sGreetFamiliar = "GreetFamiliar" Auto
Sound Property GreetLoadedFamiliar Auto
String Property sGreetLoadedFamiliar = "GreetLoadedFamiliar" Auto
Sound Property MissMaleLover Auto
String Property sMissMaleLover = "MissMaleLover" Auto
Sound Property WantToBeLover Auto
String Property sWantToBeLover = "WantToBeLover" Auto
Sound Property RomanceMaleThane Auto
String Property sRomanceMaleThane = "RomanceMaleThane" Auto
Sound Property LoveyDovey Auto
String Property sLoveyDovey = "LoveyDovey" Auto
Sound Property AppreciatePartner Auto
String Property sAppreciatePartner = "AppreciatePartner" Auto
Sound Property Satisfied Auto
String Property sSatisfied = "Satisfied" Auto

;Foreplay
Sound Property SensitivePleasure Auto
String Property sSensitivePleasure = "SensitivePleasure" Auto
Sound Property ForeplayIntense Auto
String Property sForeplayIntense = "ForeplayIntense" Auto
Sound Property ForeplaySoft Auto
String Property sForeplaySoft = "ForeplaySoft" Auto
Sound Property ReadyToGetGoing Auto
String Property sReadyToGetGoing = "ReadyToGetGoing" Auto
Sound Property ReadyToResume Auto
String Property sReadyToResume = "ReadyToResume" Auto

;Blowjob
Sound Property BlowjobRemarks Auto
String Property sBlowjobRemarks = "BlowjobRemarks" Auto
Sound Property BlowjobActionIntense Auto
String Property sBlowjobActionIntense = "BlowjobActionIntense" Auto
Sound Property BlowjobActionSoft Auto
String Property sBlowjobActionSoft = "BlowjobActionSoft" Auto
Sound Property AssToMouth Auto
String Property sAssToMouth = "AssToMouth" Auto

;Insertion
Sound Property InsertionGeneric Auto
String Property sInsertionGeneric = "InsertionGeneric" Auto
Sound Property InsertionAnalSlow Auto
String Property sInsertionAnalSlow = "InsertionAnalSlow" Auto
Sound Property InsertionAnalExcited Auto
String Property sInsertionAnalExcited = "InsertionAnalExcited" Auto

;Penetrative sex
Sound Property PenetrativeGrunts Auto
String Property sPenetrativeGrunts = "PenetrativeGrunts" Auto
Sound Property PenetrativeCommentsIntense Auto
String Property sPenetrativeCommentsIntense = "PenetrativeCommentsIntense" Auto
Sound Property PenetrativeCommentsSoft Auto
String Property sPenetrativeCommentsSoft = "PenetrativeCommentsSoft" Auto
Sound Property OnTheAttack Auto
String Property sOnTheAttack = "OnTheAttack" Auto
Sound Property AssFlattering Auto
String Property sAssFlattering = "AssFlattering" Auto
Sound Property IntenseAnal Auto
String Property sIntenseAnal = "IntenseAnal" Auto
Sound Property BeforeGape Auto
String Property sBeforeGape = "BeforeGape" Auto
Sound Property AfterGape Auto
String Property sAfterGape = "AfterGape" Auto
Sound Property AskForPacingBreak Auto
String Property sAskForPacingBreak = "AskForPacingBreak" Auto

;Female orgasm hype
Sound Property NearOrgasmNoises Auto
String Property sNearOrgasmNoises = "NearOrgasmNoises" Auto
Sound Property NearOrgasmExclamations Auto
String Property sNearOrgasmExclamations = "NearOrgasmExclamations" Auto
Sound Property CumTogetherTease Auto
String Property sCumTogetherTease = "CumTogetherTease" Auto
Sound Property MyTurnToCum Auto
String Property sMyTurnToCum = "MyTurnToCum" Auto

;Female orgasm
Sound Property Orgasm Auto
String Property sOrgasm = "Orgasm" Auto

;Female orgasm post-nut
Sound Property AfterOrgasmArouse Auto
String Property sAfterOrgasmArouse = "AfterOrgasmArouse" Auto
Sound Property AfterOrgasmExclamations Auto
String Property sAfterOrgasmExclamations = "AfterOrgasmExclamations" Auto
Sound Property AfterOrgasmRemarks Auto
String Property sAfterOrgasmRemarks = "AfterOrgasmRemarks" Auto
Sound Property MadeMeCumSoMuch Auto
String Property sMadeMeCumSoMuch = "MadeMeCumSoMuch" Auto

;Male orgasm hype
Sound Property MaleHalfwayIntense Auto
String Property sMaleHalfwayIntense = "MaleHalfwayIntense" Auto
Sound Property MaleCloseAlready Auto
String Property sMaleCloseAlready = "MaleCloseAlready" Auto
Sound Property MaleCloseNotice Auto
String Property sMaleCloseNotice = "MaleCloseNotice" Auto
Sound Property TeaseMaleCloseToOrgasmIntense Auto
String Property sTeaseMaleCloseToOrgasmIntense = "TeaseMaleCloseToOrgasmIntense" Auto
Sound Property TeaseMaleCloseToOrgasmSoft Auto
String Property sTeaseMaleCloseToOrgasmSoft = "TeaseMaleCloseToOrgasmSoft" Auto
Sound Property AskForVaginalCum Auto
String Property sAskForVaginalCum = "AskForVaginalCum" Auto
Sound Property AskForAnalCum Auto
String Property sAskForAnalCum = "AskForAnalCum" Auto
Sound Property AskForOralCum Auto
String Property sAskForOralCum = "AskForOralCum" Auto
Sound Property PullOut Auto
String Property sPullOut = "PullOut" Auto

;Male orgasm
Sound Property MaleOrgasmOral Auto
String Property sMaleOrgasmOral = "MaleOrgasmOral" Auto
Sound Property MaleOrgasmNonOral Auto
String Property sMaleOrgasmNonOral = "MaleOrgasmNonOral" Auto

;Male orgasm post-nut
Sound Property SurprisedByMaleOrgasm Auto
String Property sSurprisedByMaleOrgasm = "SurprisedByMaleOrgasm" Auto
Sound Property MaleOrgasmReactionIntense Auto
String Property sMaleOrgasmReactionIntense = "MaleOrgasmReactionIntense" Auto
Sound Property MaleOrgasmReactionSoft Auto
String Property sMaleOrgasmReactionSoft = "MaleOrgasmReactionSoft" Auto
Sound Property MaleOrgasmReactionLover Auto
String Property sMaleOrgasmReactionLover = "MaleOrgasmReactionLover" Auto
Sound Property CameInAss Auto
String Property sCameInAss = "CameInAss" Auto
Sound Property CameInMouth Auto
String Property sCameInMouth = "CameInMouth" Auto
Sound Property CameInPussy Auto
String Property sCameInPussy = "CameInPussy" Auto
Sound Property WantMore Auto
String Property sWantMore = "WantMore" Auto
Sound Property RefractoryPeriod Auto
String Property sRefractoryPeriod = "RefractoryPeriod" Auto
Sound Property NoticeMaleWantsMore Auto
String Property sNoticeMaleWantsMore = "NoticeMaleWantsMore" Auto

;Miscellaneous or generic/multi-purpose
Sound Property BreathyIntense Auto
String Property sBreathyIntense = "BreathyIntense" Auto
Sound Property BreathySoft Auto
String Property sBreathySoft = "BreathySoft" Auto
Sound Property Amused Auto
String Property sAmused = "Amused" Auto
Sound Property Unamused Auto
String Property sUnamused = "Unamused" Auto
Sound Property UnamusedEnd Auto
String Property sUnamusedEnd = "UnamusedEnd" Auto
Sound Property InAwe Auto
String Property sInAwe = "InAwe" Auto
Sound Property Oh Auto
String Property sOh = "Oh" Auto
Sound Property TeaseAggressivePartner Auto
String Property sTeaseAggressivePartner = "TeaseAggressivePartner" Auto
Sound Property TeaseAnal Auto
String Property sTeaseAnal = "TeaseAnal" Auto
Sound Property AskForAnal Auto
String Property sAskForAnal = "AskForAnal" Auto

;Special sound topic used to sample the voice slot from the MCM menu to help the user pair the voices
Sound Property MCMSampleSounds Auto
String Property sMCMSampleSounds = "MCMSampleSounds" Auto


;The presence of this function will probably confuse people. I should explain...
;IVDT was originally made with the assumption that there will always be a "main" female voice in the scene. Everything was built around that.
;Fast forward to post-release, I decide to add support for male-only scenes. At this point, its impossible to roll back the assumptions previously made.
;My workaround is to pretend like the female voice is the male voice. All my old code works fine interfacing with the female voice...
;...I just in this one place configure the female voice to secretely be a male voice. One of my most genius innovations (until it breaks something).
Function SetUpVoiceFromMaleVoice(IVDTVoiceMaleScript maleVoice)
	VoiceSlot = maleVoice.VoiceSlot

	sLoveyDovey = maleVoice.sLoveyDovey

	sSensitivePleasure = maleVoice.sStrugglingSubtle

	sInsertionGeneric = maleVoice.sStrugglingSubtle
	sInsertionAnalExcited = maleVoice.sStrugglingSubtle
	sInsertionAnalSlow = maleVoice.sStrugglingSubtle

	sPenetrativeCommentsIntense = maleVoice.sAggressive
	sPenetrativeCommentsSoft = maleVoice.sTeaseAggressivePartner

	sNearOrgasmNoises = maleVoice.sStrugglingSubtle
	sNearOrgasmExclamations = maleVoice.sStrugglingOvert
	sCumTogetherTease = maleVoice.sAboutToCum
	sMyTurnToCum = maleVoice.sStrugglingOvert

	sOrgasm = maleVoice.sOrgasm

	sAfterOrgasmRemarks = maleVoice.sPostNutRemark
	sAfterOrgasmArouse = maleVoice.sPostNutRemark

	sMaleHalfwayIntense = maleVoice.sAggressive
	sTeaseMaleCloseToOrgasmIntense = maleVoice.sAggressive
	sTeaseMaleCloseToOrgasmSoft = maleVoice.sAggressive

	sMaleOrgasmReactionIntense = maleVoice.sAfterFemaleOrgasm
	sMaleOrgasmReactionSoft = maleVoice.sAfterFemaleOrgasm
	sMaleOrgasmReactionLover = maleVoice.sAfterFemaleOrgasm
	sCameInAss = maleVoice.sAroused
	sCameInMouth = maleVoice.sAroused
	sCameInPussy = maleVoice.sAroused
	sWantMore = maleVoice.sAggressive

	sAmused = maleVoice.sJokeAroused
	sInAwe = maleVoice.sAroused
	sTeaseAggressivePartner = maleVoice.sTeaseAggressivePartner
EndFunction
