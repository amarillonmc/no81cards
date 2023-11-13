--灵式装置 大袖冥加
function c9910028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(3)
	e2:SetTarget(c9910028.destg)
	e2:SetOperation(c9910028.desop)
	c:RegisterEffect(e2)
	if not c9910028.global_check then
		c9910028.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c9910028.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910028.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(9910028,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(9910028,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c9910028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910028.thfilter1(c,tp,id)
	return c:IsType(TYPE_PENDULUM) and c:GetFlagEffect(9910028)~=0
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c9910028.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c9910028.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c9910028.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	local lab=Duel.GetFlagEffectLabel(tp,9910048)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g3=Duel.GetMatchingGroup(c9910028.thfilter1,tp,0x70,0x70,nil,tp,Duel.GetTurnCount())
	local off=1
	local ops={}
	local opval={}
	if g1:GetCount()>0 and (not lab or bit.band(lab,1)==0) then
		ops[off]=aux.Stringid(9910028,0)
		opval[off-1]=1
		off=off+1
	end
	if g2:GetCount()>0 and (not lab or bit.band(lab,2)==0) then
		ops[off]=aux.Stringid(9910028,1)
		opval[off-1]=2
		off=off+1
	end
	if g3:GetCount()>0 and (not lab or bit.band(lab,4)==0) then
		ops[off]=aux.Stringid(9910028,2)
		opval[off-1]=3
		off=off+1
	end
	ops[off]=aux.Stringid(9910028,3)
	opval[off-1]=4
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
		if not lab then
			lab=1
			Duel.RegisterFlagEffect(tp,9910048,RESET_PHASE+PHASE_END,0,1,1)
		else
			lab=lab+1
			Duel.SetFlagEffectLabel(tp,9910048,lab)
		end
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		Duel.SendtoGrave(sg2,REASON_EFFECT+REASON_RETURN)
		if not lab then
			lab=2
			Duel.RegisterFlagEffect(tp,9910048,RESET_PHASE+PHASE_END,0,1,2)
		else
			lab=lab+2
			Duel.SetFlagEffectLabel(tp,9910048,lab)
		end
	elseif opval[op]==3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910028,4))
		local sg3=g3:Select(tp,1,1,nil)
		Duel.HintSelection(sg3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c9910028.thfilter2,tp,LOCATION_DECK,0,1,1,nil,sg3:GetFirst():GetCode())
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		if not lab then
			lab=4
			Duel.RegisterFlagEffect(tp,9910048,RESET_PHASE+PHASE_END,0,1,4)
		else
			lab=lab+4
			Duel.SetFlagEffectLabel(tp,9910048,lab)
		end
	end
end
