--兔符『开运大纹』
function c11200068.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200068+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11200068.con1)
	e1:SetTarget(c11200068.tg1)
	e1:SetOperation(c11200068.op1)
	c:RegisterEffect(e1)
--
end
--
c11200068.xig_ihs_0x133=1
--
function c11200068.con1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
--
function c11200068.tfilter1(c)
	return c:IsSetCard(0x621) or c.xig_ihs_0x133 and (c:IsLocation(LOCATION_DECK) or c:IsAbleToDeck())
end
function c11200068.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local alnum=0
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND+LOCATION_ONFIELD,0)>Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0) then
		alnum=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND+LOCATION_ONFIELD,0)-Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	end
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return (alnum<2 or (b1 and b2))
		and Duel.IsExistingMatchingCard(c11200068.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetLabel(alnum)
	if alnum>2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1100)
	end
end
--
function c11200068.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local alnum=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local sg=Duel.SelectMatchingCard(tp,c11200068.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_DECK) then
			Duel.MoveSequence(tc,0)
		else
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
		Duel.ConfirmDecktop(tp,1)
	end
	if alnum<3 then
		local b1=Duel.IsPlayerCanDraw(tp,1)
		local b2=true
		local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		local b4=c:IsRelateToEffect(e) and c:IsCanTurnSet()
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(11200068,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200068,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(11200068,3)
			opval[off-1]=3
			off=off+1
		end
		if b4 then
			ops[off]=aux.Stringid(11200068,4)
			opval[off-1]=4
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then Duel.Draw(tp,1,REASON_EFFECT) end
		if sel==2 then Duel.Damage(1-tp,1100,REASON_EFFECT) end
		if sel==3 then
			local lg=Duel.GetFieldGroup(Card.IsFaceup,0,LOCATION_MZONE)
			local lc=lg:GetFirst()
			while lc do
				local e1_1=Effect.CreateEffect(c)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_UPDATE_ATTACK)
				e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1_1:SetValue(-550)
				lc:RegisterEffect(e1_1)
				local e1_2=e1_1:Clone()
				e1_1:SetCode(EFFECT_UPDATE_DEFENSE)
				lc:RegisterEffect(e1_2)
				lc=lg:GetNext()
			end
		end
		if sel==4 then
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
	if alnum>2 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Damage(1-tp,1100,REASON_EFFECT)
		local lg=Duel.GetFieldGroup(Card.IsFaceup,0,LOCATION_MZONE)
		local lc=lg:GetFirst()
		while lc do
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_UPDATE_ATTACK)
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1_1:SetValue(-550)
			lc:RegisterEffect(e1_1)
			local e1_2=e1_1:Clone()
			e1_1:SetCode(EFFECT_UPDATE_DEFENSE)
			lc:RegisterEffect(e1_2)
			lc=lg:GetNext()
		end
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
--
