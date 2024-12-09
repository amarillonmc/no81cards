--『大家一起赏樱花』户山香澄
local s,id,o=GetID()
function s.initial_effect(c)
	   c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
   --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function s.ckfilter1(c,att)
	return not c:IsAttribute(att)
end
function s.ckfilter2(c,race)
	return not c:IsRace(race)
end
function s.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (  not sg:IsExists(s.ckfilter1,1,c,c:GetAttribute())) or (  not sg:IsExists(s.ckfilter1,1,c,c:GetRace()))
end