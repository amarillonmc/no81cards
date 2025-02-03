--由清风倾听的灵魂
function c60001170.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60001170.wxcon)
	e1:SetTarget(c60001170.wxtg)
	e1:SetOperation(c60001170.wxop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001170,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001170)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c60001170.hstg)
	e2:SetOperation(c60001170.hsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)

	if not c60001170.global_check then
		c60001170.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001170.setcon)
		e4:SetOperation(c60001170.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001170.setter(c)
	return c:IsCode(60001170) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001170.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001170.setter,1,nil)
end
function c60001170.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001170.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001170.cdter(c)
	return c:IsFaceup() and c:IsCode(60001179)
end
function c60001170.wxcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c60001170.cdter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60001170.wxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60001170.wxop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:GetFlagEffect(60001168)>0 and (c:IsLocation(LOCATION_SZONE) or c:IsPreviousLocation(LOCATION_SZONE)) and (#g1>0 or #g2>0 or #g3>0) and Duel.SelectYesNo(tp,aux.Stringid(60001170,2)) then
		if #g1~=0 and Duel.SelectYesNo(tp,aux.Stringid(60001170,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
		end
		if #g2~=0 and Duel.SelectYesNo(tp,aux.Stringid(60001170,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg2)
			sg:Merge(sg2)
		end
		if #g3~=0 and Duel.SelectYesNo(tp,aux.Stringid(60001170,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg3=g3:RandomSelect(tp,1)
			sg:Merge(sg3)
		end
		if #sg~=0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e4:SetCountLimit(1)
			e4:SetLabel(#Duel.GetOperatedGroup())
			e4:SetOperation(c60001170.ntop)
			Duel.RegisterEffect(e4,1-tp)
		end
	end
end
function c60001170.ntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	if Duel.IsPlayerCanDraw(tp,num) and Duel.SelectYesNo(tp,aux.Stringid(60001170,0)) then
		Duel.Draw(tp,num,REASON_EFFECT)
	end
	e:Reset()
end
function c60001170.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60001170.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001170.filter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60001170.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001170.filter2,tp,LOCATION_HAND,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,c60001170.filter2,1,1,nil):GetFirst()
			if tc and Duel.SSet(tp,tc)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				tc:RegisterEffect(e2)
			end
		end
	end
end