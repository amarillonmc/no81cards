--选择未来的公主 神威-罪秽装束
function c75081021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75c),6,2,c75081021.ovfilter,aux.Stringid(75081021,0),2,c75081021.xyzop)
	c:EnableReviveLimit() 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081021,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,75081021)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c75081021.cost)
	e2:SetTarget(c75081021.distg)
	e2:SetOperation(c75081021.disop)
	c:RegisterEffect(e2)	
end
function c75081021.ovfilter(c)
	return c:IsFaceup() and c:IsCode(75000701)
end
function c75081021.cfilter(c)
	return c:IsSetCard(0x75c) and c:IsDiscardable()
end
function c75081021.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75081021)==0 and Duel.IsExistingMatchingCard(c75081021.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c75081021.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,75081021,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c75081021.spfilter(c,e,tp,exc)
	local b2=c:IsSetCard(0x375c) and c:IsType(TYPE_XYZ)
		and Duel.GetLocationCountFromEx(tp,tp,exc,c)>0
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and b2
end
function c75081021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	if chk==0 then return c:IsAbleToRemoveAsCost() and ct>0 and Duel.IsExistingMatchingCard(c75081021.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081021 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetLabel(ct)
		e1:SetOperation(c75081021.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081021.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75081021.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75081021.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c75081021.spfilter12(c,e,tp)
	return c:IsCode(75000701) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75081021.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tc=e:GetLabelObject()
	if Duel.ReturnToField(e:GetLabelObject())~=0 and tc:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75081021.spfilter12,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75081021,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75081021.spfilter12,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


