--pvz bt z 深海巨尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	c:EnableReviveLimit()
	Zombie_Characteristics_X(c)
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionCode(57300445)
end