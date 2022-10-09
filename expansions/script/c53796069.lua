local m=53796069
local cm=_G["c"..m]
cm.name="遗忘之海"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x8530)
	aux.AddCodeList(c,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,e,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and ((c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp) or (c:IsReason(REASON_BATTLE) and Duel.GetTurnPlayer()==1-tp)) and c:IsCanBeEffectTarget(e) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.cfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(cm.cfilter,1,nil,e,tp) and e:GetHandler():IsCanAddCounter(0x8530,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,cm.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then c:AddCounter(0x8530,1) end
end
function cm.filter(c,ct,e,tp)
	return c:IsLevelBelow(ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.mfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=e:GetHandler():GetCounter(0x8530)>11
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e:GetHandler():GetCounter(0x8530),e,tp)) or (b and Duel.IsExistingMatchingCard(cm.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x8530)
	local b=ct>11
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if b and Duel.IsExistingMatchingCard(cm.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg) and (not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,ct,e,tp)) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.ritfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg):GetFirst()
		mg=mg:Filter(cm.chkfilter,tc,tc)
		if tc.mat_filter then mg=mg:Filter(tc.mat_filter,tc,tp) else mg:RemoveCard(tc) end
		tc:SetMaterial(mg)
		Duel.ReleaseRitualMaterial(mg)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,ct,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function cm.chkfilter(c,tc)
	return c:IsCanBeRitualMaterial(tc) or not c:IsType(TYPE_MONSTER)
end
function cm.ritfilter(c,e,tp,g)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCode(m+1) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=g:Filter(cm.chkfilter,c,c)
	if c.mat_filter then mg=mg:Filter(c.mat_filter,c,tp) else mg:RemoveCard(c) end
	return #mg>0 and Duel.GetMZoneCount(tp,mg,tp)>0
end
