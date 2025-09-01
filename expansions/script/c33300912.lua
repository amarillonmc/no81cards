--诞地邪徒 邪教主假身
local s,id,o=GetID()
function c33300912.initial_effect(c)
	--cardname
	aux.AddCodeList(c,33300900)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,33300900,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	--change name
	aux.EnableChangeCode(c,33300900,LOCATION_MZONE+LOCATION_GRAVE)
end
