--拉尼亚凯亚之先导
function c9910645.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
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
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910645)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910645.sptg)
	e2:SetOperation(c9910645.spop)
	c:RegisterEffect(e2)
end
function c9910645.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c9910645.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
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
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local fid=c:GetFieldID()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and not tc:IsReason(REASON_REDIRECT) then
		tc:RegisterFlagEffect(9910645,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c9910645.retcon)
		e1:SetOperation(c9910645.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9910645.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9910645)==e:GetLabel() then
		return Duel.GetCurrentChain()==1
	else
		e:Reset()
		return false
	end
end
function c9910645.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local loc=tc:GetPreviousLocation()
	if loc==LOCATION_MZONE then
		Duel.ReturnToField(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(c9910645.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if loc==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
	e:Reset()
end
function c9910645.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and re:IsHasType(EFFECT_TYPE_SINGLE) and re:GetCode() and re:GetCode()==EVENT_REMOVE
end
function c9910645.spfilter(c,e,tp)
	return c:IsSetCard(0xa952) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910645.filter(c)
	return c:IsSetCard(0xa952) and not c:IsReason(REASON_RETURN) and c:IsCanOverlay()
end
function c9910645.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910645.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c9910645.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c9910645.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910645.gselect(g)
	return g:GetClassCount(Card.GetTurnID)==#g
end
function c9910645.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9910645.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c9910645.filter,tp,LOCATION_GRAVE,0,nil)
		local mg=g:SelectSubGroup(tp,c9910645.gselect,false,1,#g)
		if #mg>0 then
			Duel.HintSelection(mg)
			Duel.Overlay(sc,mg)
		end
	end
end
