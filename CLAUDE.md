# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Mod Is

**Hentairim p+ 3.0.4** is a Skyrim Special Edition mod that extends the *Intelligent Voiced Dirty Talk (IVDT)* system with a "Hentairim" flavor. It layers on top of SexLab Framework P+ and provides:

- **Dynamic voice lines** for sex scenes (female and male), with per-actor voice slot assignment via MCM
- **Facial expressions** driven by scene state (animation tag labels)
- **Sound effects** (SFX) tied to animation/position interaction types
- **Resistance/trauma** tracking per actor
- **Adventure/out-of-scene** commentary (combat, follower bleedout, idle chatter)
- **Combat rape** triggering logic
- **NPC request** system
- **DAR (Dynamic Animation Replacer)** condition files that gate custom idles to specific factions/actors
- **MCM** (SkyUI) configuration menu for all runtime settings

## Build

The project compiles Papyrus scripts using [Pyro](https://github.com/fireundubh/pyro) via the VSCode task.

**Default build task (VSCode `Ctrl+Shift+B`):**
```
pyro: Compile Project (skyrimse.ppj)
```

This compiles all `.psc` files in `Scripts\Source\` and outputs `.pex` bytecode to `Scripts\`. When `Zip="true"` is set in `skyrimse.ppj`, it also produces a `Build\Hentairim pp patch.zip` containing only the files listed in the `<ZipFiles>` block.

**Manual Pyro invocation (from repo root):**
```
pyro -i skyrimse.ppj
```

Skyrim SE game path: `C:\SteamLibrary\steamapps\common\Skyrim Special Edition\`

**Papyrus debugger** (VSCode `F5`): attaches to the running Skyrim SE process using the `papyrus-lang` extension.

## Script Architecture

### Central controller: `IVDTControllerScript` (ReferenceAlias on IVDTMainQuest)

The single authoritative "director" for all active scenes. It:
- Receives SexLab thread events (stage change, orgasm, end)
- Reads animation tags via `HentaiRimTags` to classify the current stage into label strings (`StimulationLabel`, `PenisActionLabel`, `OralLabel`, etc.)
- Dispatches decisions to per-actor spell instances

All per-actor `ActiveMagicEffect` scripts hold a `Property MasterScript Auto` reference back to this controller.

### Per-actor spell scripts (all extend `ActiveMagicEffect`)

Each actor in a scene gets a spell applied; the associated script fires for that actor:

| Script | Role |
|---|---|
| `IVDTSceneTrackerScript` | Primary scene tracker; identifies male/female leads, determines "intense vs soft" phase, fires voice |
| `HentairimExpressions` | Facial expression cycling based on phase and label group |
| `HentairimSFX` | Plays body/impact sound effects based on interaction type and receiver/giver role |
| `HentairimResistance` | Tracks resistance/trauma state per actor |
| `HentairimCombatRape` | Listens for `OnHit` events to potentially trigger a combat rape scene |
| `HentairimNPCRequest` | Manages NPC-initiated sex requests |

`HentairimAdventure` runs outside of scenes (always-on for the PC), handling combat commentary, follower reactions, and idle animations using idles from the BaboDialogue/Defeat family.

### Voice system (`IVDTVoiceFemaleScript` / `IVDTVoiceMaleScript`)

Each voice slot is a **ReferenceAlias** on the main quest with one of these scripts. Sound properties are set per-alias to point to specific sound descriptors. The number of available slots is controlled by `FemaleVoiceSlots` / `MaleVoiceSlots` properties on `IVDTMCMConfigurationScript`.

**Adding a new voice slot** requires changes in five places — the comment at the top of `IVDTMCMConfigurationScript.psc` enumerates them exactly.

## Build Import Notes

Several imports are non-obvious — resolved during initial setup:

| Script | Import path |
|---|---|
| `Lovense` | `build\SkyrimLovense-0.1.0\Source\Scripts` |
| `UIExtensions` | `build\UIExtensions\scripts\source` |
| `AnimSpeedHelper` | `build\AnimSpeedSE\scripts\source` |
| `OSLArousedNative` | `OSL Aroused\Scripts\Source` (live mod, not under `build\`) |
| `VRIK` | `C:\Playground\stubs\VRIK.psc` (stub — mod not installed; VR-only feature) |

`CreatureFrameworkUtil` in older code is now `CreatureFrameworkUtility` — the newer Creature Framework renamed it.

### Tag resolution: `HentaiRimTags` (global functions)

`GetLabel(anim, stage, actorpos)` maps SexLab animation tags to short label strings (`LI`, `FA`, `SA`, `FV`, `SV`, `FB`, `SB`, `DP`, `TP`, `SR`, `EN`, `BA`, `BV`). These labels drive expression and voice selection throughout all other scripts. The tag naming convention uses `stage + ActorPosition + TagSuffix` (e.g. `2BFVP` = stage 2, actor B, female vaginal penetration).

### DAR condition files

`meshes\actors\character\animations\DynamicAnimationReplacer\_CustomConditions\<FormID>\` folders hold:
- `_conditions.txt` — DAR condition logic (faction checks, race checks, etc.)
- `*.hkx` — replacement animation
- `*.txt` (named like `GS3.txt`) — GenderScript/animation list files

Folder numeric IDs correspond to mod form IDs that unlock specific idle replacements.

### Configuration storage

Runtime configuration lives in two places:
- **MCM / SkyUI**: `MCM\Config\IntelligentVoicedDirtyTalk\` (`config.json` defines the UI, `settings.ini` holds defaults)
- **StorageUtil (JContainers)**: `SKSE\Plugins\StorageUtilData\IVDTHentai\Config.json` — JSON key-value store read by scripts at runtime via the StorageUtil API

### Import dependencies (build-time only)

The `.ppj` imports source from many external mods located under `C:\Playground\Skyrim\mods\build\`. These must be present on the build machine. Key ones: SexLab Framework P+, B612, SexLab Separate Orgasm (SLSO), SkyUI SDK, MCM SDK, JContainers, Papyrus Extender, ZaZ, Devious Devices, Creature Framework, RaceMenu, XP32, Apropos2, SlaveTats, Oninus Lactis, Milk Mod Economy, Schlongs of Skyrim.

## Sound Asset Layout

`Sound\fx\IVDT\` contains WAV files organized as:
```
Sound\fx\IVDT\
  M1\ … M8\        ← male voice slots (see slot descriptions.txt)
    <Category>\     ← e.g. Aggressive, Aroused, Orgasm, Struggling Early, …
      01.wav …
  Sounds\           ← shared SFX (Smack, Pull Out Gape, …)
```

Male voice slot assignments: M1=Even Tone, M2=Argonian, M3=Brute, M4=Nord, M5=Condescending, M6=Dark Elf, M7=Khajiit, M8=Orc.

## ESP Files

| File | Purpose |
|---|---|
| `IntelligentVoicedDirtyTalk.esp` | Main plugin — quests, aliases, MCM, script properties |
| `HentairimExpressions.esp` | Expression spell/magic effect records |
| `HentairimResistance.esp` | Resistance spell/magic effect records |
| `HentairimMaleVoice.esp` | Male voice sound descriptors |
