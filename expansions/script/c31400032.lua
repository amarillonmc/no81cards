local m=31400032
local cm=_G["c"..m]
cm.name="圣刻龙-朱斯提亚"
function cm.initial_effect(c)
	local e0_a=Effect.CreateEffect(c)
	e0_a:SetType(EFFECT_TYPE_SINGLE)
	e0_a:SetCode(EFFECT_ADD_TYPE)
	e0_a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0_a:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0_a:SetCondition(aux.DualNormalCondition)
	e0_a:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0_a)
	local e0_b=e0_a:Clone()
	e0_b:SetCode(EFFECT_REMOVE_TYPE)
	e0_b:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e0_b)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(SUMMON_TYPE_DUAL)
	e2:SetCondition(cm.dualcon)
	e2:SetOperation(cm.dualop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.IsDualState)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(cm.spfilter,nil)~=0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.dualfilter(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsReleasable()
end
function cm.dualcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.DualNormalCondition(e) and Duel.IsExistingMatchingCard(cm.dualfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.dualop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():EnableDualState()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.dualfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	if g then
		Duel.Release(g,REASON_COST)
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end