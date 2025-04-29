--雪狱之罪人 剥茧
function c9911353.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9911353)
	e1:SetCondition(c9911353.descon)
	e1:SetCost(c9911353.descost)
	e1:SetOperation(c9911353.desop)
	c:RegisterEffect(e1)
	--choose effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911353,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9911354)
	e2:SetCondition(c9911353.cecon)
	e2:SetTarget(c9911353.cetg)
	e2:SetOperation(c9911353.ceop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c9911353.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9911353.cffilter(c)
	return not c:IsPublic()
end
function c9911353.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911353.cffilter,rp,0,LOCATION_HAND,1,nil) end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9911353.repop)
end
function c9911353.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911353.cffilter,tp,0,LOCATION_HAND,nil)
	local ct=g:GetCount()
	if ct<=0 then return end
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=g:Select(1-tp,ct,ct,nil)
	Duel.ConfirmCards(tp,sg)
	for tc in aux.Next(sg) do
		tc:RegisterFlagEffect(9911353,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c9911353.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(9911354,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911353,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetCondition(c9911353.descon2)
	e1:SetOperation(c9911353.desop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9911353.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(9911354)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c9911353.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c9911353.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_REDIRECT)
end
function c9911353.tgfilter(c)
	return c:IsSetCard(0xc956) and c:IsDiscardable(REASON_EFFECT)
end
function c9911353.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c9911353.tgfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(Card.IsPublic,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(9911353,2)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9911353,3)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_HAND+LOCATION_ONFIELD)
	end
end
function c9911353.ceop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		if Duel.DiscardHand(tp,c9911353.tgfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	else
		local g1=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_HAND,nil)
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		if g1:GetCount()>0 and g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.HintSelection(sg1)
			Duel.Destroy(sg1,REASON_EFFECT)
		end
	end
end
