-- 虚拟YouTuber 德比鲁与大和的初次约会 / VTubers Debiru & Iori, First Date
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1x)
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x445,0x344c) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function s.adjfilter(c)
	return not c:IsSetCard(0x445,0x344c) or c:IsFacedown()
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(s.adjfilter,tp,LOCATION_ONFIELD,0,nil)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.Readjust()
	end
end
function s.indtg(e,c)
	return c:IsSetCard(0x445,0x344c)
end