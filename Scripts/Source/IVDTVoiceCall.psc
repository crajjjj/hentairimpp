Scriptname IVDTVoiceCall extends ReferenceAlias hidden

;References
SexLabFramework Property SexLab Auto 

Function IVDTPlayKneeJerk(Bool Wait = false) Global

PlaySound("Oh", Wait)
endfunction

Function IVDTPlayKneeJerkIntense(Bool Wait = false) Global

PlaySound("AfterGape", Wait)
endfunction

Function IVDTPlayPanting(Bool Wait = false) Global

PlaySound("AfterOrgasmExclamations", Wait)
endfunction

Function IVDTPlayOrgasm(Bool Wait = false) Global

PlaySound("Orgasm", Wait)
endfunction

Function IVDTPlayGagged(Bool Wait = false) Global

PlaySound("AssToMouth", Wait)
endfunction

Function IVDTPlayGaggedIntense(Bool Wait = false) Global

PlaySound("AssFlattering", Wait)
endfunction

Function IVDTPlayAmused(Bool Wait = false) Global

PlaySound("Amused", Wait)
endfunction

Function IVDTPlayStimulated(Bool Wait = false) Global

String SoundtoPlay = "BreathySoft"
if GetVoiceVariation() == "B"
	SoundtoPlay = "BreathyIntense"
endif
PlaySound(SoundtoPlay, Wait)
endfunction


Function SocialPlayWhyDoThis(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	PlaySound("Social Why Do This", Wait)
endfunction

Function SocialPlayWhatever(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Whatever", Wait)
endfunction

Function SocialPlayWhatIsThis(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	PlaySound("Social What Is This", Wait)
endfunction

Function SocialPlayWhatIsThat(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social What Is That", Wait)
endfunction

Function SocialPlayWhatDoYouWant(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social What Do You Want", Wait)
endfunction

Function SocialPlayWakeUpConfused(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Wake Up Confused", Wait)
endfunction

Function SocialPlayWaitAMinute(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Wait A Minute", Wait)
endfunction

Function SocialPlayThisCantBe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social This Cant Be", Wait)
endfunction

Function SocialPlayYes(Bool Wait = false) Global
    if GetVoiceVariation() != "B"
        return
    endif

    PlaySound("Social Yes", Wait)
EndFunction


Function SocialPlayThanks(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Thanks", Wait)
endfunction

Function SocialPlaySigh(Bool Wait = false) Global
	PlaySound("Social Sigh", Wait)
endfunction

Function SocialPlayShortHesitation(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Short Hesitation", Wait)
endfunction

Function SocialPlayShock(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Shock", Wait)
endfunction

Function SocialPlayReprimand(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Reprimand", Wait)
endfunction

Function SocialPlayRelief(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Relief", Wait)
endfunction

Function SocialPlayReject(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Reject", Wait)
endfunction

Function SocialPlayRegret(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Regret", Wait)
endfunction

Function SocialPlayPleaseTakeCareOfMe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Please Take Care Of Me", Wait)
endfunction

Function SocialPlayOhNo(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Oh No", Wait)
endfunction

Function SocialPlayNo(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social No", Wait)
endfunction

Function SocialPlayIWontForgiveYou(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social I Wont Forgive You", Wait)
endfunction

Function SocialPlayIUnderstand(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social I Understand", Wait)
endfunction

Function SocialPlayISee(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social I See", Wait)
endfunction

Function SocialPlayIObeyYou(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social I Obey You", Wait)
endfunction

Function SocialPlayIDidIt(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social I Did It", Wait)
endfunction

Function SocialPlayHmm(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Hmm", Wait)
endfunction

Function SocialPlayGrunt(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Grunt", Wait)
endfunction

Function SocialPlayGreet(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Greet", Wait)
endfunction

Function SocialPlayExcuseMe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Excuse Me", Wait)
endfunction

Function SocialPlayCuteAngryNoises(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Cute Angry Noises", Wait)
endfunction

Function SocialPlayErm(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Erm", Wait)
endfunction

Function SocialPlayCouldItBe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Could It Be", Wait)
endfunction

Function SocialPlayCough(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Cough", Wait)
endfunction

Function SocialPlayApologise(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Apologise", Wait)
endfunction

Function SocialPlayLaugh(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Social Laugh", Wait)
endfunction

Function OthersPlayWorkOnSomething(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Others Work On Something", Wait)
endfunction

Function HornyPlayStruggle(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Struggle", Wait)
endfunction

Function OthersPlayStartBartering(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Others Start Bartering", Wait)
endfunction

Function OthersPlaySleepWait(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Others Sleep Wait", Wait)
endfunction

Function OthersPlaySafeRelieve(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Others Safe Relieve", Wait)
endfunction

Function OthersPlayOutIntoWorldSpace(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Others Out Into World Space", Wait)
endfunction

Function OthersPlayLevelUp(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Others Level Up", Wait)
endfunction

Function HornyPlayShowBoobs(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Show Boobs", Wait)
endfunction

Function HornyPlaySeduce(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif

	PlaySound("Horny Seduce", Wait)

endfunction

Function HornyPlayRejectSex(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Reject Sex", Wait)
endfunction

Function HornyPlayNakedInPublicComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Naked In Public Comments", Wait)
endfunction

Function HornyPlayMasturbateCommentsNearOrgasm(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Masturbate Comments Near Orgasm", Wait)
endfunction

Function HornyPlayMasturbateComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Masturbate Comments", Wait)
endfunction

Function HornyPlayLetGoOfMe(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Let Go Of Me", Wait)
endfunction

Function HornyPlayLeakingCumComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Leaking Cum Comments", Wait)
endfunction

Function HornyPlayLactatingComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Lactating Comments", Wait)
endfunction

Function HornyPlayComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Comments", Wait)
endfunction

Function HornyPlayBoobsFondled(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Boobs Fondled", Wait)
endfunction

Function HornyPlayBlush(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Blush", Wait)
endfunction

Function HornyPlayBegForPenis(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Beg For Penis", Wait)
endfunction

Function HornyPlayAcceptSexBroken(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Accept Sex Broken", Wait)
endfunction

Function HornyPlayAcceptSex(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Horny Accept Sex", Wait)
endfunction

Function CombatPlayPowerAttack(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Power Attack", Wait)
endfunction

Function CombatPlayHit(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Hit", Wait)
endfunction

Function CombatPlayFollowerDown(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Follower Down", Wait)
endfunction

Function CombatPlayExhaustion(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Exhaustion", Wait)
endfunction

Function CombatPlayStateWithStrongEnemy(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat State With Strong Enemy", Wait)
endfunction

Function CombatPlayStateWithEnemy(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat State With Enemy", Wait)
endfunction

Function CombatPlayDungeonEnemyEncounter(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Dungeon Enemy Encounter", Wait)
endfunction

Function CombatPlayDifficultEnd(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Difficult End", Wait)
endfunction

Function CombatPlayDifficult(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Difficult", Wait)
endfunction

Function CombatPlayEndComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat End Comments", Wait)
endfunction

Function CombatPlayComments(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Comments", Wait)
endfunction

Function CombatPlayBleedOut(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Bleed Out", Wait)
endfunction

Function CombatPlayAttack(Bool Wait = false) Global
	if  GetVoiceVariation() != "B"
		return
	endif
	
	PlaySound("Combat Attack", Wait)
endfunction

Function CheckAllSounds() Global
	int soundsChecked = 0
	int soundsMissing = 0
	miscutil.printconsole("--- Starting Sound Check (AudioUtil categories, slot F1) ---")
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Attack") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Attack' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Bleed Out") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Bleed Out' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Difficult") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Difficult' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Difficult End") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Difficult End' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Dungeon Enemy Encounter") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Dungeon Enemy Encounter' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat End Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat End Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Exhaustion") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Exhaustion' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Follower Down") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Follower Down' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Hit") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Hit' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat Power Attack") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat Power Attack' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat State With Enemy") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat State With Enemy' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Combat State With Strong Enemy") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Combat State With Strong Enemy' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Accept Sex") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Accept Sex' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Accept Sex Broken") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Accept Sex Broken' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Beg For Penis") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Beg For Penis' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Blush") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Blush' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Boobs Fondled") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Boobs Fondled' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Lactating Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Lactating Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Leaking Cum Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Leaking Cum Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Let Go Of Me") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Let Go Of Me' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Masturbate Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Masturbate Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Masturbate Comments Near Orgasm") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Masturbate Comments Near Orgasm' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Naked In Public Comments") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Naked In Public Comments' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Reject Sex") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Reject Sex' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Seduce") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Seduce' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Show Boobs") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Show Boobs' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Horny Struggle") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Horny Struggle' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Others Level Up") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Others Level Up' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Others Out Into World Space") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Others Out Into World Space' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Others Safe Relieve") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Others Safe Relieve' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Others Sleep Wait") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Others Sleep Wait' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Others Start Bartering") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Others Start Bartering' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Others Work On Something") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Others Work On Something' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Apologise") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Apologise' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Cough") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Cough' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Could It Be") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Could It Be' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Cute Angry Noises") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Cute Angry Noises' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Erm") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Erm' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Excuse Me") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Excuse Me' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Greet") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Greet' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Grunt") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Grunt' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Hmm") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Hmm' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social I Did It") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social I Did It' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social I Obey You") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social I Obey You' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social I See") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social I See' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social I Understand") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social I Understand' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social I Wont Forgive You") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social I Wont Forgive You' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social No") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social No' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Oh No") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Oh No' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Please Take Care Of Me") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Please Take Care Of Me' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Regret") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Regret' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Reject") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Reject' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Relief") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Relief' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Reprimand") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Reprimand' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Shock") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Shock' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Short Hesitation") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Short Hesitation' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Sigh") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Sigh' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Thanks") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Thanks' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social This Cant Be") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social This Cant Be' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Wait A Minute") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Wait A Minute' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Wake Up Confused") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Wake Up Confused' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social What Do You Want") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social What Do You Want' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social What Is That") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social What Is That' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social What Is This") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social What Is This' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Whatever") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Whatever' has no audio files.")
	endif
	soundsChecked += 1
	if AudioUtil.GetCategoryFileCount("F1", "Social Why Do This") == 0
		soundsMissing += 1
		miscutil.printconsole("Category 'Social Why Do This' has no audio files.")
	endif
	miscutil.printconsole("--- Sound Check Complete ---")
	miscutil.printconsole("Total Categories Checked: " + soundsChecked)
	miscutil.printconsole("Missing: " + soundsMissing)
endfunction

Function PlaySound(String Category, Bool Wait = false) Global
	Actor Playerref = Game.GetPlayer()
	if Category == "" || StorageUtil.Getintvalue(Playerref,"HentairimSoundWait",0)
		return
	endif
	;the "ivdt_oneshot" channel natively stops the previous one-shot before playing the new one
	if wait
		StorageUtil.Setintvalue(Playerref,"HentairimSoundWait",1)
		AudioUtil.PlayVoiceAndWait(Playerref, Category, 1.0, "oneshot", "ivdt_oneshot")
		StorageUtil.Setintvalue(Playerref,"HentairimSoundWait",0)
	else
		AudioUtil.PlayVoice(Playerref, Category, 1.0, "oneshot", "ivdt_oneshot")
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
