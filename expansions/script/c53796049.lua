local m=53796049
local cm=_G["c"..m]
cm.name="你梦中者"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(cm.leave)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonPlayer()~=tp and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalCodeRule(),c)
end
function cm.filter2(c,e,tp,code,mc)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalCodeRule()==code and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetOriginalCodeRule())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code,nil):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) and c:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		e:GetLabelObject():SetLabelObject(tc)
		c:CreateRelation(tc,RESET_EVENT+0x5020000)
		tc:CreateRelation(c,RESET_EVENT+0x5fe0000)
	end
	Duel.SpecialSummonComplete()
end
function cm.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToCard(tc) and tc:IsRelateToCard(c) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
