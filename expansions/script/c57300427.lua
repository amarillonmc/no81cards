--pvz bt z Z科技堡垒机器人
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcFunRep(c,s.ffilter,5,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	c:EnableReviveLimit()
	Zombie_Characteristics_X(c)
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x5521) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end