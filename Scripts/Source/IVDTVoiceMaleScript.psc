Scriptname IVDTVoiceMaleScript extends ReferenceAlias
{This holds all of the voice categories for a single male voice. Instances of this script are made as quest aliases under the IVDTMainQuest to support multiple voices.
Categories are folder names resolved by AudioUtil.dll (Sound\fx\IVDT\<slot>\<category>) — no sound descriptors involved.}

;Which AudioUtil slot this alias speaks with ("M1".."M8"). Set per alias in Maintenance
;(Slot1 -> "M1" etc.); used for MCM previews and male-only scenes.
String Property VoiceSlot = "M1" Auto

;Arousal
Sound Property Aroused Auto
String Property sAroused = "Aroused" Auto

;Pre nut
Sound Property StrugglingEarly Auto
String Property sStrugglingEarly = "StrugglingEarly" Auto
Sound Property StrugglingOvert Auto
String Property sStrugglingOvert = "StrugglingOvert" Auto
Sound Property StrugglingSubtle Auto
String Property sStrugglingSubtle = "StrugglingSubtle" Auto
Sound Property AboutToCum Auto
String Property sAboutToCum = "AboutToCum" Auto

;Male orgasm
Sound Property Orgasm Auto
String Property sOrgasm = "Orgasm" Auto

;Post nut
Sound Property PostNutRemark Auto
String Property sPostNutRemark = "PostNutRemark" Auto

;Humor
Sound Property JokeAroused Auto
String Property sJokeAroused = "JokeAroused" Auto
Sound Property JokeAfterOrgasm Auto
String Property sJokeAfterOrgasm = "JokeAfterOrgasm" Auto

;Miscellaneous
Sound Property TeaseFemaleOrgasm Auto
String Property sTeaseFemaleOrgasm = "TeaseFemaleOrgasm" Auto
Sound Property AfterFemaleOrgasm Auto
String Property sAfterFemaleOrgasm = "AfterFemaleOrgasm" Auto
Sound Property LoveyDovey Auto
String Property sLoveyDovey = "LoveyDovey" Auto
Sound Property Aggressive Auto
String Property sAggressive = "Aggressive" Auto
Sound Property TeaseAggressivePartner Auto
String Property sTeaseAggressivePartner = "TeaseAggressivePartner" Auto

;Special sound topic used to sample the voice slot from the MCM menu to help the user pair the voices
Sound Property MCMSampleSounds Auto
String Property sMCMSampleSounds = "MCMSampleSounds" Auto
