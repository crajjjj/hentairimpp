Scriptname IVDTVoiceCall extends ReferenceAlias hidden

;References
SexLabFramework Property SexLab Auto 

Function IVDTPlayKneeJerk(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0xA4A1, "IntelligentVoicedDirtyTalk.esp") As Sound ;Kneejerk
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall KneeJerk Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayKneeJerkIntense(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0x371C0, "IntelligentVoicedDirtyTalk.esp") As Sound ;Kneejerk Intense
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall KneeJerk Intense Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayPanting(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0x7954, "IntelligentVoicedDirtyTalk.esp") As Sound ;Panting
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall Panting Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayOrgasm(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0x6E65, "IntelligentVoicedDirtyTalk.esp") As Sound ;Orgasm
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall Orgasm Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayGagged(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0x6E5F, "IntelligentVoicedDirtyTalk.esp") As Sound ;Gagged
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall Gagged Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayGaggedIntense(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0x841B, "IntelligentVoicedDirtyTalk.esp") As Sound ;Gagged Intense
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall Gagged Intense Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayAmused(Bool Wait = false) Global

Sound SoundtoPlay = Game.GetFormFromFile(0xB4D9, "IntelligentVoicedDirtyTalk.esp") As Sound ;Amused
	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall Amused Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function IVDTPlayStimulated(Bool Wait = false) Global

Sound SoundtoPlay 

if GetVoiceVariation() == "B"
	SoundtoPlay = Game.GetFormFromFile(0x6E5A, "IntelligentVoicedDirtyTalk.esp") As Sound ;breathing intense
else
	SoundtoPlay = Game.GetFormFromFile(0x6E56, "IntelligentVoicedDirtyTalk.esp") As Sound ;soft breathing
endif

	if !SoundtoPlay
		miscutil.printconsole("IVDTVoiceCall Stimulated Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction


Function SocialPlayWhyDoThis(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D9, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Why Do This Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayWhatever(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D8, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Whatever Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayWhatIsThis(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D7, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play What Is This Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayWhatIsThat(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D6, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play What Is That Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayWhatDoYouWant(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D5, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play What Do You Want Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayWakeUpConfused(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D4, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Wake Up Confused Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayWaitAMinute(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D3, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Wait A Minute Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayThisCantBe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D2, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play This Can't Be Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayYes(Bool Wait = false) Global
    if GetVoiceVariation() != "B"
        return
    endif

    Sound SoundtoPlay = Game.GetFormFromFile(0x3C1DA, "IntelligentVoicedDirtyTalk.esp") as Sound
    if !SoundtoPlay
        miscutil.printconsole("Social Play Yes Sound is None")
    else
        PlaySound(SoundtoPlay, Wait)
    endif
EndFunction


Function SocialPlayThanks(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D1, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Thanks Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlaySigh(Bool Wait = false) Global
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1D0, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Sigh Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayShortHesitation(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1CF, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Short Hesitation Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayShock(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1CE, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Shock Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayReprimand(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1CD, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Reprimand Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayRelief(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1CC, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Relief Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayReject(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1CB, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Reject Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayRegret(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1CA, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Regret Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayPleaseTakeCareOfMe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C9, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Please Take Care Of Me Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayOhNo(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C8, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Oh No Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayNo(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C7, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play No Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayIWontForgiveYou(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C6, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play I Won't Forgive You Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayIUnderstand(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C5, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play I Understand Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayISee(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C4, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play I See Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayIObeyYou(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C3, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play I Obey You Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayIDidIt(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C2, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play I Did It Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayHmm(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C1, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Hmm Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayGrunt(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1C0, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Grunt Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayGreet(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1BF, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Greet Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayExcuseMe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1BE, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Excuse Me Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayCuteAngryNoises(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1BD, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Cute Angry Noises Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayErm(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1BC, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Erm Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayCouldItBe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1BB, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Could It Be Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayCough(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1BA, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Cough Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayApologise(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B9, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Apologise Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function SocialPlayLaugh(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1DC, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Social Play Laugh Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function OthersPlayWorkOnSomething(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B8, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Others Play Work On Something Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayStruggle(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B7, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Struggle Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function OthersPlayStartBartering(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B6, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Others Play Start Bartering Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function OthersPlaySleepWait(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B5, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Others Play Sleep Wait Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function OthersPlaySafeRelieve(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B4, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Others Play Safe Relieve Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function OthersPlayOutIntoWorldSpace(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B3, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Others Play Out Into World Space Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function OthersPlayLevelUp(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B2, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Others Play Level Up Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayShowBoobs(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B1, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Show Boobs Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlaySeduce(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif

	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1B0, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Seduce Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif

endfunction

Function HornyPlayRejectSex(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1AF, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Reject Sex Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayNakedInPublicComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1AE, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Naked In Public Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayMasturbateCommentsNearOrgasm(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1AD, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Masturbate Comments Near Orgasm Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayMasturbateComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1AC, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Masturbate Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayLetGoOfMe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1AB, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Let Go Of Me Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayLeakingCumComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1AA, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Leaking Cum Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayLactatingComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A9, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Lactating Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A8, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayBoobsFondled(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A7, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Boobs Fondled Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayBlush(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A6, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Blush Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayBegForPenis(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A5, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Beg For Penis Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayAcceptSexBroken(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A4, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Accept Sex Broken Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function HornyPlayAcceptSex(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A3, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Horny Play Accept Sex Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayPowerAttack(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A2, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Power Attack Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayHit(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A1, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Hit Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayFollowerDown(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C1A0, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Follower Down Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayExhaustion(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C19F, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Exhaustion Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayStateWithStrongEnemy(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C19E, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play State With Strong Enemy Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayStateWithEnemy(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C19D, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play State With Enemy Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayDungeonEnemyEncounter(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C19C, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Dungeon Enemy Encounter Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayDifficultEnd(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C19B, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Difficult End Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayDifficult(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C19A, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Difficult Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayEndComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C199, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play End Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C198, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Comments Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayBleedOut(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C197, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Bleed Out Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CombatPlayAttack(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	Sound SoundtoPlay = Game.GetFormFromFile(0x3C196, "IntelligentVoicedDirtyTalk.esp") as Sound
	if !SoundtoPlay
		miscutil.printconsole("Combat Play Attack Sound is None")
	else
		PlaySound(SoundtoPlay,Wait)
	endif
endfunction

Function CheckAllSounds() Global
	int soundsChecked = 0
	int soundsMissing = 0
	miscutil.printconsole("--- Starting Sound Check ---")

	Sound Sound_3C1D9 = Game.GetFormFromFile(0x3C1D9, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D9
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Why Do This' (0x3C1D9) is missing.")
	endif

	Sound Sound_3C1D8 = Game.GetFormFromFile(0x3C1D8, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D8
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Whatever' (0x3C1D8) is missing.")
	endif

	Sound Sound_3C1D7 = Game.GetFormFromFile(0x3C1D7, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D7
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play What Is This' (0x3C1D7) is missing.")
	endif

	Sound Sound_3C1D6 = Game.GetFormFromFile(0x3C1D6, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D6
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play What Is That' (0x3C1D6) is missing.")
	endif

	Sound Sound_3C1D5 = Game.GetFormFromFile(0x3C1D5, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D5
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play What Do You Want' (0x3C1D5) is missing.")
	endif

	Sound Sound_3C1D4 = Game.GetFormFromFile(0x3C1D4, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D4
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Wake Up Confused' (0x3C1D4) is missing.")
	endif

	Sound Sound_3C1D3 = Game.GetFormFromFile(0x3C1D3, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D3
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Wait A Minute' (0x3C1D3) is missing.")
	endif

	Sound Sound_3C1D2 = Game.GetFormFromFile(0x3C1D2, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D2
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play This Cant Be' (0x3C1D2) is missing.")
	endif

	Sound Sound_3C1D1 = Game.GetFormFromFile(0x3C1D1, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D1
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Thanks' (0x3C1D1) is missing.")
	endif

	Sound Sound_3C1D0 = Game.GetFormFromFile(0x3C1D0, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1D0
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Sigh' (0x3C1D0) is missing.")
	endif

	Sound Sound_3C1CF = Game.GetFormFromFile(0x3C1CF, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1CF
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Short Hesitation' (0x3C1CF) is missing.")
	endif

	Sound Sound_3C1CE = Game.GetFormFromFile(0x3C1CE, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1CE
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Shock' (0x3C1CE) is missing.")
	endif

	Sound Sound_3C1CD = Game.GetFormFromFile(0x3C1CD, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1CD
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Reprimand' (0x3C1CD) is missing.")
	endif

	Sound Sound_3C1CC = Game.GetFormFromFile(0x3C1CC, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1CC
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Relief' (0x3C1CC) is missing.")
	endif

	Sound Sound_3C1CB = Game.GetFormFromFile(0x3C1CB, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1CB
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Reject' (0x3C1CB) is missing.")
	endif

	Sound Sound_3C1CA = Game.GetFormFromFile(0x3C1CA, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1CA
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Regret' (0x3C1CA) is missing.")
	endif

	Sound Sound_3C1C9 = Game.GetFormFromFile(0x3C1C9, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C9
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Please Take Care Of Me' (0x3C1C9) is missing.")
	endif

	Sound Sound_3C1C8 = Game.GetFormFromFile(0x3C1C8, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C8
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Oh No' (0x3C1C8) is missing.")
	endif

	Sound Sound_3C1C7 = Game.GetFormFromFile(0x3C1C7, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C7
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play No' (0x3C1C7) is missing.")
	endif

	Sound Sound_3C1C6 = Game.GetFormFromFile(0x3C1C6, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C6
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play I Wont Forgive You' (0x3C1C6) is missing.")
	endif

	Sound Sound_3C1C5 = Game.GetFormFromFile(0x3C1C5, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C5
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play I Understand' (0x3C1C5) is missing.")
	endif

	Sound Sound_3C1C4 = Game.GetFormFromFile(0x3C1C4, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C4
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play I See' (0x3C1C4) is missing.")
	endif

	Sound Sound_3C1C3 = Game.GetFormFromFile(0x3C1C3, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C3
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play I Obey You' (0x3C1C3) is missing.")
	endif

	Sound Sound_3C1C2 = Game.GetFormFromFile(0x3C1C2, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C2
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play I Did It' (0x3C1C2) is missing.")
	endif

	Sound Sound_3C1C1 = Game.GetFormFromFile(0x3C1C1, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C1
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Hmm' (0x3C1C1) is missing.")
	endif

	Sound Sound_3C1C0 = Game.GetFormFromFile(0x3C1C0, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1C0
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Grunt' (0x3C1C0) is missing.")
	endif

	Sound Sound_3C1BF = Game.GetFormFromFile(0x3C1BF, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1BF
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Greet' (0x3C1BF) is missing.")
	endif

	Sound Sound_3C1BE = Game.GetFormFromFile(0x3C1BE, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1BE
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Excuse Me' (0x3C1BE) is missing.")
	endif

	Sound Sound_3C1BD = Game.GetFormFromFile(0x3C1BD, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1BD
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Cute Angry Noises' (0x3C1BD) is missing.")
	endif

	Sound Sound_3C1BC = Game.GetFormFromFile(0x3C1BC, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1BC
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Erm' (0x3C1BC) is missing.")
	endif

	Sound Sound_3C1BB = Game.GetFormFromFile(0x3C1BB, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1BB
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Could It Be' (0x3C1BB) is missing.")
	endif

	Sound Sound_3C1BA = Game.GetFormFromFile(0x3C1BA, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1BA
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Cough' (0x3C1BA) is missing.")
	endif

	Sound Sound_3C1B9 = Game.GetFormFromFile(0x3C1B9, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B9
		soundsMissing += 1
		miscutil.printconsole("Sound 'Social Play Apologise' (0x3C1B9) is missing.")
	endif

	Sound Sound_3C1B8 = Game.GetFormFromFile(0x3C1B8, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B8
		soundsMissing += 1
		miscutil.printconsole("Sound 'Others Play Work On Something' (0x3C1B8) is missing.")
	endif

	Sound Sound_3C1B7 = Game.GetFormFromFile(0x3C1B7, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B7
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Struggle' (0x3C1B7) is missing.")
	endif

	Sound Sound_3C1B6 = Game.GetFormFromFile(0x3C1B6, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B6
		soundsMissing += 1
		miscutil.printconsole("Sound 'Others Play Start Bartering' (0x3C1B6) is missing.")
	endif

	Sound Sound_3C1B5 = Game.GetFormFromFile(0x3C1B5, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B5
		soundsMissing += 1
		miscutil.printconsole("Sound 'Others Play Sleep Wait' (0x3C1B5) is missing.")
	endif

	Sound Sound_3C1B4 = Game.GetFormFromFile(0x3C1B4, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B4
		soundsMissing += 1
		miscutil.printconsole("Sound 'Others Play Safe Relieve' (0x3C1B4) is missing.")
	endif

	Sound Sound_3C1B3 = Game.GetFormFromFile(0x3C1B3, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B3
		soundsMissing += 1
		miscutil.printconsole("Sound 'Others Play Out Into World Space' (0x3C1B3) is missing.")
	endif

	Sound Sound_3C1B2 = Game.GetFormFromFile(0x3C1B2, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B2
		soundsMissing += 1
		miscutil.printconsole("Sound 'Others Play Level Up' (0x3C1B2) is missing.")
	endif

	Sound Sound_3C1B1 = Game.GetFormFromFile(0x3C1B1, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B1
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Show Boobs' (0x3C1B1) is missing.")
	endif

	Sound Sound_3C1B0 = Game.GetFormFromFile(0x3C1B0, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1B0
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Seduce' (0x3C1B0) is missing.")
	endif

	Sound Sound_3C1AF = Game.GetFormFromFile(0x3C1AF, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1AF
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Reject Sex' (0x3C1AF) is missing.")
	endif

	Sound Sound_3C1AE = Game.GetFormFromFile(0x3C1AE, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1AE
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Naked In Public Comments' (0x3C1AE) is missing.")
	endif

	Sound Sound_3C1AD = Game.GetFormFromFile(0x3C1AD, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1AD
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Masturbate Comments Near Orgasm' (0x3C1AD) is missing.")
	endif

	Sound Sound_3C1AC = Game.GetFormFromFile(0x3C1AC, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1AC
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Masturbate Comments' (0x3C1AC) is missing.")
	endif

	Sound Sound_3C1AB = Game.GetFormFromFile(0x3C1AB, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1AB
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Let Go Of Me' (0x3C1AB) is missing.")
	endif

	Sound Sound_3C1AA = Game.GetFormFromFile(0x3C1AA, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1AA
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Leaking Cum Comments' (0x3C1AA) is missing.")
	endif

	Sound Sound_3C1A9 = Game.GetFormFromFile(0x3C1A9, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A9
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Lactating Comments' (0x3C1A9) is missing.")
	endif

	Sound Sound_3C1A8 = Game.GetFormFromFile(0x3C1A8, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A8
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Comments' (0x3C1A8) is missing.")
	endif

	Sound Sound_3C1A7 = Game.GetFormFromFile(0x3C1A7, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A7
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Boobs Fondled' (0x3C1A7) is missing.")
	endif

	Sound Sound_3C1A6 = Game.GetFormFromFile(0x3C1A6, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A6
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Blush' (0x3C1A6) is missing.")
	endif

	Sound Sound_3C1A5 = Game.GetFormFromFile(0x3C1A5, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A5
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Beg For Penis' (0x3C1A5) is missing.")
	endif

	Sound Sound_3C1A4 = Game.GetFormFromFile(0x3C1A4, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A4
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Accept Sex Broken' (0x3C1A4) is missing.")
	endif

	Sound Sound_3C1A3 = Game.GetFormFromFile(0x3C1A3, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A3
		soundsMissing += 1
		miscutil.printconsole("Sound 'Horny Play Accept Sex' (0x3C1A3) is missing.")
	endif

	Sound Sound_3C1A2 = Game.GetFormFromFile(0x3C1A2, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A2
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Power Attack' (0x3C1A2) is missing.")
	endif

	Sound Sound_3C1A1 = Game.GetFormFromFile(0x3C1A1, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A1
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Hit' (0x3C1A1) is missing.")
	endif

	Sound Sound_3C1A0 = Game.GetFormFromFile(0x3C1A0, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C1A0
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Follower Down' (0x3C1A0) is missing.")
	endif

	Sound Sound_3C19F = Game.GetFormFromFile(0x3C19F, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C19F
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Exhaustion' (0x3C19F) is missing.")
	endif

	Sound Sound_3C19E = Game.GetFormFromFile(0x3C19E, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C19E
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play State With Strong Enemy' (0x3C19E) is missing.")
	endif

	Sound Sound_3C19D = Game.GetFormFromFile(0x3C19D, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C19D
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play State With Enemy' (0x3C19D) is missing.")
	endif

	Sound Sound_3C19C = Game.GetFormFromFile(0x3C19C, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C19C
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Dungeon Enemy Encounter' (0x3C19C) is missing.")
	endif

	Sound Sound_3C19B = Game.GetFormFromFile(0x3C19B, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C19B
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Difficult End' (0x3C19B) is missing.")
	endif

	Sound Sound_3C19A = Game.GetFormFromFile(0x3C19A, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C19A
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Difficult' (0x3C19A) is missing.")
	endif

	Sound Sound_3C199 = Game.GetFormFromFile(0x3C199, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C199
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play End Comments' (0x3C199) is missing.")
	endif

	Sound Sound_3C198 = Game.GetFormFromFile(0x3C198, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C198
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Comments' (0x3C198) is missing.")
	endif

	Sound Sound_3C197 = Game.GetFormFromFile(0x3C197, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C197
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Bleed Out' (0x3C197) is missing.")
	endif

	Sound Sound_3C196 = Game.GetFormFromFile(0x3C196, "IntelligentVoicedDirtyTalk.esp") as Sound
	soundsChecked += 1
	if !Sound_3C196
		soundsMissing += 1
		miscutil.printconsole("Sound 'Combat Play Attack' (0x3C196) is missing.")
	endif

	miscutil.printconsole("--- Sound Check Complete ---")
	miscutil.printconsole("Total Sounds Checked: " + soundsChecked)
	miscutil.printconsole("Missing Sounds: " + soundsMissing)
	miscutil.printconsole("Total Sounds Found: " + (soundsChecked - soundsMissing))
endfunction

Function PlaySound(Sound SoundToPlay ,Bool Wait = false) Global
	Actor Playerref = Game.GetPlayer()
	if !SoundToPlay || StorageUtil.Getintvalue(Playerref,"HentairimSoundWait",0)
		return
	endif
	int InstanceID
	int LatestRunningSoundInstance = StorageUtil.Getintvalue(Playerref,"HentairimLatestSoundInstance",0)
	;Stop Currently Playing Sound if any
	if  LatestRunningSoundInstance > 0
		Sound.StopInstance(LatestRunningSoundInstance)
	endif
	
	if wait
		StorageUtil.Setintvalue(Playerref,"HentairimSoundWait",1)
		SoundtoPlay.Playandwait(Playerref)
		StorageUtil.Setintvalue(Playerref,"HentairimSoundWait",0)
	else
		InstanceID = SoundtoPlay.Play(Playerref)
		StorageUtil.Setintvalue(Playerref,"HentairimLatestSoundInstance",InstanceID)
	endif
	
endfunction

Bool Function IsMoanonly() Global
	return JsonUtil.GetIntValue("IVDTHentai/Config.json","moanonly",0) == 1
endfunction

String Function GetVoiceVariation() Global
	String VoiceVariationFile  = "IVDTHentai/VoiceVariation.json"
	string VoiceVariation = JsonUtil.GetStringValue(VoiceVariationFile,"voicevariation","NA") 
	
	return VoiceVariation
EndFunction
