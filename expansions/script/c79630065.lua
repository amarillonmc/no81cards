--幻想悠悠
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,27288416,LOCATION_MZONE+LOCATION_GRAVE)
	--ritual summon
	local e0=aux.AddRitualProcGreater2(c,s.filter,nil,nil,s.matfilter,true)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e0:SetCountLimit(1,id)
	e0:SetCondition(s.rscon)
	e0:SetCost(s.cost)
	c:RegisterEffect(e0)
	--release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.rlcon)
	e1:SetTarget(s.rltg)
	e1:SetOperation(s.rlop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and (not chk or c~=e:GetHandler())
end
function s.matfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function s.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(1-tp,nil,1,REASON_RULE,false,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroupEx(1-tp,nil,1,1,REASON_RULE,false,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Release(g,REASON_RULE,1-tp)
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x183)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
