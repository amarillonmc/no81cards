-- 
Duel.LoadScript("c60010000.lua")
if not cm.t then
	cm.t=true
	local cm._summon=Duel.Summon
	Duel.Summon=function(tp,ca,num,numm,...)
		if Duel.GetFlagEffect(ca:GetOwner(),m)==0 ca:IsSetCard(0x631) and ca:IsLevelBelow(4) and Duel.IsExistingMatchingCard(Card.IsCode,ca:GetOwner(),LOCATION_EXTRA,0,1,nil,m) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local g=Duel.SelectMatchingCard(ca:GetOwner(),Card.IsCode,ca:GetOwner(),LOCATION_EXTRA,0,1,1,nil,m)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.RegisterFlagEffect(ca:GetOwner(),m,RESET_PHASE+PHASE_END,0,1)
		else
			cm._summon(tp,ca,num,numm,...)
		end
	end
end
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
end
function cm.ffilter(c)
	return c:IsSetCard(0x631)
end