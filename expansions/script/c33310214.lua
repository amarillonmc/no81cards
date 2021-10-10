--空想生物 鲮鱼
function c33310214.initial_effect(c)
	 --recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33310216)
	e1:SetCost(c33310214.cost)
	e1:SetTarget(c33310214.target)
	e1:SetOperation(c33310214.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33310214)
	e2:SetTarget(c33310214.thtg)
	e2:SetOperation(c33310214.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c33310214.thcon2)
	c:RegisterEffect(e3)
end
function c33310214.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c33310214.filter(c)
	return c:IsSetCard(0x551) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33310214)
end
function c33310214.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) or Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0 end
end
function c33310214.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local b1=Duel.IsPlayerCanDraw(tp)
	local b2=g:GetCount()>0
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(33310214,2)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(33310214,3)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif sel==1 then
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c33310214.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c33310214.costfil,tp,LOCATION_HAND,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33310214,1))
end
function c33310214.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c33310214.costfil(c)
	return c:IsPublic() and c:IsAbleToDeck()
end
function c33310214.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33310214.costfil,tp,LOCATION_HAND,0,e:GetHandler())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33310214,0)) then
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		end
	end
end