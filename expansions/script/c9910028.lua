--灵式装置 大袖冥加
function c9910028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9910028.destg)
	e2:SetOperation(c9910028.desop)
	c:RegisterEffect(e2)
	if not c9910028.global_check then
		c9910028.global_check=true
		LSZZ_DESTROY_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c9910028.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c9910028.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9910028.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local code,code2=tc:GetCode()
		table.insert(LSZZ_DESTROY_CHECK,code)
		if code2 then table.insert(LSZZ_DESTROY_CHECK,code2) end
		tc=eg:GetNext()
	end
end
function c9910028.clear(e,tp,eg,ep,ev,re,r,rp)
	LSZZ_DESTROY_CHECK={}
end
function c9910028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910028.thfilter(c)
	if not c:IsAbleToHand() then return false end
	if c:IsSetCard(0x3950) then return true end
	if not c:IsType(TYPE_PENDULUM) then return false end
	for i=1,#LSZZ_DESTROY_CHECK do
		local code=LSZZ_DESTROY_CHECK[i]
		if c:IsCode(code) then return true end
	end
	return false
end
function c9910028.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()==0 or Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local lab=Duel.GetFlagEffectLabel(tp,9910048)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
	local g3=Duel.GetMatchingGroup(c9910028.thfilter,tp,LOCATION_DECK,0,nil)
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.SendtoHand(sg3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg3)
		if not lab then
			lab=4
			Duel.RegisterFlagEffect(tp,9910048,RESET_PHASE+PHASE_END,0,1,4)
		else
			lab=lab+4
			Duel.SetFlagEffectLabel(tp,9910048,lab)
		end
	end
end
