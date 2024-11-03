--冥渊先驱舰
local m=91040036
local cm=c91040036
function c91040036.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,true)
end
