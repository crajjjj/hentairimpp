Scriptname ExpressionsCall extends ReferenceAlias hidden

SexLabFramework Property SexLab Auto 

Function ExpressionsLookUp(Actor Char, String Lookup) Global
	String ExpressionsFile = GetExpressionsFileDirectory(Char)
	
	String[] ExpressionsArr = papyrusutil.stringsplit(JsonUtil.GetStringValue(ExpressionsFile,Lookup,"") ,",")
	if ExpressionsArr.length < 32
		miscutil.printconsole(Lookup + " Expression Not Found or is Invalid")
		return
	endif

	MfgConsoleFuncExt.ApplyExpressionPresetSmooth(Char, StringArrayToMFGNGArray(ExpressionsArr), false)
	
endfunction

Function ResetExpressions(Actor Char) Global
	MfgConsoleFuncExt.ResetMFGSmooth(Char , -1, 0.5)
endfunction

String Function GetExpressionsFileDirectory(Actor char) Global

	Bool IsPlayer = char == Game.GetPlayer()
	int Sex = char.GetLeveledActorBase().GetSex()
	string ExpressionsFile
	if IsPlayer
		ExpressionsFile = "HentairimExpressions/PCExpressions.json"
	elseif Sex == 0	;Male
		ExpressionsFile = "HentairimExpressions/MaleExpressions.json"
	elseif Sex == 1 ; Female
		ExpressionsFile ="HentairimExpressions/FemaleExpressions.json"	
	else
		ExpressionsFile = ""
	endif
	return ExpressionsFile
EndFunction




Float[] function StringArrayToMFGNGArray(String[] values) Global
  float[] result = new float[32]
  if values.length < 32
    miscutil.printconsole("Expressions array only has " + values.length + "items. it is either incorrectly formatted or missing in the json file")
  endif
  Int i = 0
  while i < 32
    if i == 30 && values[i]
      result[i] = values[i] as float
    elseif values[i]
      result[i] = (values[i] as float) / 100
    else
      result[i] = 0
    endif
    i = i + 1
  endwhile
  return result
endfunction