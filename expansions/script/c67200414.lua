--枢冥的契约箱 维尔奇斯
function c67200414.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--remove and add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67200414.target)
	e1:SetOperation(c67200414.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,67200414)
	e2:SetCondition(c67200414.thcon)
	e2:SetTarget(c67200414.thtg)
	e2:SetOperation(c67200414.thop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c67200414.discon)
	e3:SetOperation(c67200414.disop)
	c:RegisterEffect(e3)
end
function c67200414.rmfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x5671) and c:IsType(TYPE_MONSTER)
end
function c67200414.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200414.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67200414.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200414.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	e:SetLabelObject(tg)
	e:GetHandler():RegisterFlagEffect(67200414,RESET_EVENT+0x1e60000,0,1)
	tg:RegisterFlagEffect(67200414,RESET_EVENT+RESETS_STANDARD,0,1)
	local ct=tg:GetLevel()
	if c:IsFaceup() and c:IsRelateToEffect(e) and ct>0 then
		c:AddCounter(0x1,ct)
	end
end
--
function c67200414.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():GetCounter(0x1)<1 and e:GetHandler():GetFlagEffect(67200414)~=0
end
function c67200414.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and tc:GetFlagEffect(67200414)~=0 and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c67200414.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffect(67200414)~=0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
--
function c67200414.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1)>9
end
function c67200414.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc and tc:IsControler(1-tp) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e2)
		tc=eg:GetNext()
	end
end



