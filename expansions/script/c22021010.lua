--人理之诗 万符必应破戒
function c22021010.initial_effect(c)
	aux.AddCodeList(c,22020950,22025820)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,22021010)
	e1:SetTarget(c22021010.target)
	e1:SetOperation(c22021010.activate)
	c:RegisterEffect(e1)
	--ng
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22021010.ngcon)
	e2:SetOperation(c22021010.ngop)
	c:RegisterEffect(e2)
end
function c22021010.filter(c,tc,ec)
	return aux.NegateAnyFilter(c)
end
function c22021010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c22021010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22021010.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,c22021010.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c22021010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	local b1=Duel.IsExistingMatchingCard(c22021010.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and tc:IsAbleToRemove() and tc:IsRelateToEffect(e)
	local b2=Duel.IsExistingMatchingCard(c22021010.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsType(TYPE_MONSTER) and tc:IsAbleToChangeControler() and tc:IsRelateToEffect(e)
	local b3=Duel.IsExistingMatchingCard(c22021010.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(22021010,0),1},
		{b2,aux.Stringid(22021010,1),2},
		{b3,aux.Stringid(22021010,2),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	elseif op==2 then
		Duel.BreakEffect()
		Duel.GetControl(tc,tp)
	end
	end
end
function c22021010.spfilter(c,e,tp)
	return c:IsCode(22020950) and c:IsFaceup()
end

function c22021010.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp==tp and te:GetHandlerPlayer()==1-tp and eg:GetFirst():IsCode(22025820) and Duel.GetFlagEffect(tp,22021010)==0 and c:IsAbleToRemove() 
end
function c22021010.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(22021010,3)) then 
		Duel.Hint(HINT_CARD,0,22021010)
		local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		Duel.NegateEffect(ev-1)
		Duel.RegisterFlagEffect(tp,22021010,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22021010,4))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end