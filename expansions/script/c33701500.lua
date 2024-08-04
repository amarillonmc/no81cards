--【背景音台】POP TEAM EPIC
local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not TYPE_SOUNDSTAGE then
	Duel.LoadScript("glitchylib_soundstage.lua")
end
function s.initial_effect(c)
	--[[Template to add a Sound Stage procedure
	1) Card the procedure will be registered to
	2) Activation effect of the card (must be EFFECT_TYPE_ACTIVATE)
	3) ID of the card
	4) Contract turns of the card
	5) Description string ID that contains the name of the music file that plays when the card is activated (aux.Stringid is called by passing the arguments (3) and (5))
	aux.AddSoundStageProc(c,卡片发动效果,卡号,契约回合数,音乐文件名CDB提示ID)
	]]
	
	aux.AddSoundStageProc(c,c:Activation(),id,6,1)
end