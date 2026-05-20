Scriptname HentairimDoNotDisturb extends ActiveMagicEffect

Actor Actorref
Actor Playerref
Spell DoNotDisturb
Faction DoNotDisturbFaction
Actor[] enemiesToRestart
SexlabThread CurrentThread
SexLabFramework Property SexLab Auto
Bool Persist
Float TimeStarted
Bool SexStarted = false

; This event runs once when the magic effect is first applied.
Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Check if the target of the spell is a valid actor.
	if !akTarget
		return
	endif
	
	Playerref = game.getplayer()
	TimeStarted = GetCurrentRealTimeSeconds()
	Persist = Storageutil.GetIntValue(Actorref,"DoNotDisturbPersist",0) == 1
	Actorref = akTarget
	DoNotDisturb = Game.GetFormFromFile(0x824, "Hentairim Director.esp") as Spell
	DoNotDisturbFaction = Game.GetFormFromFile(0x826, "Hentairim Director.esp") as Faction
	CurrentThread = Sexlab.GetThreadByActor(Actorref)
	Actorref.AddToFaction(DoNotDisturbFaction)
	PO3_SKSEFunctions.PreventActorDetection(Actorref)
	PO3_SKSEFunctions.PreventActorDetecting(Actorref)
	; Register for the first update after 3 seconds.
	RegisterForSingleUpdate(3.0)
EndEvent

; This event is called every time we register for an update.
Event OnUpdate()
;	miscutil.printconsole("Hentairim Do Not Disturb : " + Actorref.GetDisplayName())
	; Get the thread status to check if the actor is in a valid state.
	int threadstatus = CurrentThread.GetStatus()
	if actorref.getdistance(Playerref) > 5000
		Actorref.RemoveSpell(DoNotDisturb)
	endif
	; If the actor is dead, no longer in the game, or not in a SexLab activity,
	; remove the spell and stop the script.
	
	if !SexStarted && Sexlab.GetThreadByActor(Actorref)
		SexStarted = true
	elseif !SexStarted && GetCurrentRealTimeSeconds() - TimeStarted > 15 && !Persist
		Actorref.RemoveSpell(DoNotDisturb)
	elseif Actorref == none || Actorref.IsDead() || (!Sexlab.GetThreadByActor(Actorref) && SexStarted)
	;	miscutil.printconsole("Hentairim Do Not Disturb: Target is invalid or dead. Removing spell and stopping polling.")
		if Actorref && DoNotDisturb
			Actorref.RemoveSpell(DoNotDisturb)
		endif
		UnregisterForUpdate()
		return
	endif
	
	if (SexStarted && (threadstatus == 0 || threadstatus == 4) && !Persist) || GetCurrentRealTimeSeconds() - TimeStarted > 1000
    ; Print debug info
  ; MiscUtil.PrintConsole("Hentairim Do Not Disturb Triggered!")
   ; MiscUtil.PrintConsole("SexStarted = " + SexStarted)
   ; MiscUtil.PrintConsole("threadstatus = " + threadstatus)
   ; MiscUtil.PrintConsole("Persist = " + Persist)
    ;MiscUtil.PrintConsole("Time since start = " + (GetCurrentRealTimeSeconds() - TimeStarted))

    if Actorref && DoNotDisturb
    ;    MiscUtil.PrintConsole("Removing DoNotDisturb spell from Actor: " + Actorref.GetDisplayName())
        Actorref.RemoveSpell(DoNotDisturb)
    endif

  ;  MiscUtil.PrintConsole("Unregistering for update and exiting function.")
    UnregisterForUpdate()
    return
endif


	; Get all actors currently targeting the recipient.
	Actor[] enemies = PO3_SKSEFunctions.GetCombatTargets(Actorref)

	; Create a new array to store potential new targets (allies or any third-party combatants).
	Actor[] potentialTargets

	; Find all combatants who are fighting the player's enemies.
	int i = 0
	while i < enemies.Length
		Actor currentEnemy = enemies[i]
		if currentEnemy != none
			; Get the combat targets of the current enemy.
			Actor[] enemyTargets = PO3_SKSEFunctions.GetCombatTargets(currentEnemy)
			int j = 0
			while j < enemyTargets.Length
				Actor enemyTarget = enemyTargets[j]
				; If the target is not the player and does not have the DoNotDisturb spell,
				; add it to our list of potential targets.
				if enemyTarget != none && enemyTarget != Actorref && !enemyTarget.HasSpell(DoNotDisturb)
					potentialTargets = papyrusutil.pushactor(potentialTargets,enemyTarget)
				endif
				j += 1
			endwhile
		endif
		i += 1
	endwhile

	; Check if there are enemies to divert and combatants to divert to.
	if enemies.Length > 0 && potentialTargets.Length > 0
	;	miscutil.printconsole("Hentairim Do Not Disturb: Found " + enemies.Length + " enemies to divert.")
	;	miscutil.printconsole("Hentairim Do Not Disturb: Found " + potentialTargets.Length + " potential targets to divert to.")

		; Loop through each enemy found.
		int k = 0
		while k < enemies.Length
			Actor currentEnemy = enemies[k]
			
			; Ensure the enemy reference is valid before proceeding.
			if currentEnemy != none
				; Get a random combatant from the list to be the new target.
				Actor newTarget = potentialTargets[Utility.RandomInt(0, potentialTargets.Length - 1)]
				
				; Check the new target for validity.
				if newTarget != none
					currentEnemy.StartCombat(newTarget)
					currentEnemy.EvaluatePackage()
					miscutil.printconsole("Hentairim Do Not Disturb: Diverted " + currentEnemy.GetDisplayName() + " from " + Actorref.GetDisplayName() + " to " + newTarget.GetDisplayName())
				else
					miscutil.printconsole("Hentairim Do Not Disturb: New target is invalid. Skipping divert for " + currentEnemy.GetDisplayName())
				endif
			endif
			
			k += 1
		endwhile

	; If there are enemies but no other combatants, force the enemies to wait.
	elseIf enemies.Length > 0 && potentialTargets.Length == 0
		miscutil.printconsole("Hentairim Do Not Disturb: No combatants to divert to. Forcing " + enemies.Length + " enemies to sheath and wait.")
		enemiesToRestart = enemies ; Store the list of enemies to restart combat with later.

		int l = 0
		while l < enemies.Length
			Actor currentEnemy = enemies[l]
			if currentEnemy != none
				currentEnemy.SheatheWeapon()
				currentEnemy.StopCombat() ; Setting target to none makes them stop combat.
				currentEnemy.EvaluatePackage()
			endif
			l += 1
		endwhile

	;else
		; Log a message if there are no enemies.
	;	miscutil.printconsole("Hentairim Do Not Disturb: No enemies to divert.")
	endif

	; Schedule the next update for 3 seconds from now.
	RegisterForSingleUpdate(3.0)
EndEvent

; This event runs once when the magic effect is removed (e.g., duration ends).
Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Stop any future scheduled updates.
	Storageutil.unSetIntValue(Actorref,"DoNotDisturbPersist")
	Actorref.RemoveFromFaction(DoNotDisturbFaction)
	PO3_SKSEFunctions.ResetActorDetection(Actorref)
	PO3_SKSEFunctions.ResetActorDetecting(Actorref)
	UnregisterForUpdate()
;	miscutil.printconsole("Hentairim Do Not Disturb: Magic effect finished. Stopping polling.")

	; Re-engage any enemies that were forced to wait.
	if enemiesToRestart && enemiesToRestart.Length > 0
	;	miscutil.printconsole("Hentairim Do Not Disturb: Re-engaging " + enemiesToRestart.Length + " enemies.")
		int i = 0
		while i < enemiesToRestart.Length
			Actor currentEnemy = enemiesToRestart[i]
			if currentEnemy != none
				currentEnemy.StartCombat(akTarget)
			endif
			i += 1
		endwhile
	endif
EndEvent

Float Function GetCurrentRealTimeSeconds()
	return utility.GetCurrentRealTime()
Endfunction
