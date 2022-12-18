--航线设计师 法夸尔
function c9910645.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910644)
	e1:SetCondition(c9910645.rmcon)
	e1:SetCost(c9910645.rmcost)
	e1:SetTarget(c9910645.rmtg)
	e1:SetOperation(c9910645.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,9910645)
	e2:SetCost(c9910645.spcost)
	e2:SetTarget(c9910645.sptg)
	e2:SetOperation(c9910645.spop)
	c:RegisterEffect(e2)
end
function c9910645.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c9910645.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9910645.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9910645.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c9910645.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910645.rmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910645.rmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9910645.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local loc=tc:GetLocation()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(9910645,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,loc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(loc)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c9910645.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910645.retop(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetLabel()
	local tc=e:GetLabelObject()
	if loc==LOCATION_MZONE then
		Duel.ReturnToField(tc)
	end
	if loc==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c9910645.cfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c9910645.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetRank())
end
function c9910645.spfilter(c,e,tp,rk)
	return c:IsLevel(rk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910645.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9910645.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910645.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetRank())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910645.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910645.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rk=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910645.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,rk)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910645.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910645.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
