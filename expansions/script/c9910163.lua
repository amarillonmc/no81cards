--战车道的旋律
function c9910163.initial_effect(c)
	c:SetUniqueOnField(1,0,9910163)
	c:EnableCounterPermit(0x1958)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910163.target)
	c:RegisterEffect(e1)
	--special counter permit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_COUNTER_PERMIT+0x1958)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c9910163.ctpermit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9910163.thtg)
	e3:SetOperation(c9910163.thop)
	c:RegisterEffect(e3)
	--sort deck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c9910163.sdcon)
	e4:SetOperation(c9910163.sdop)
	c:RegisterEffect(e4)
end
function c9910163.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1958,7,c) end
	c:AddCounter(0x1958,7)
end
function c9910163.ctpermit(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_CHAINING)
end
function c9910163.thfilter1(c,cc)
	local lv=c:GetLevel()
	return c:IsSetCard(0x9958) and lv>0 and c:IsAbleToHand() and cc:IsCanRemoveCounter(tp,0x1958,lv,REASON_COST)
end
function c9910163.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910163.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c9910163.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e:GetHandler())
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910163,0))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	e:GetHandler():RemoveCounter(tp,0x1958,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910163.thfilter2(c,lv)
	return c:IsSetCard(0x9958) and c:IsLevel(lv) and c:IsAbleToHand()
end
function c9910163.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910163.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910163.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local ct=c:GetCounter(0x1958)
	return rp==tp and bit.band(LOCATION_HAND,loc)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x9958)
		and ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and c:IsCanRemoveCounter(tp,0x1958,1,REASON_EFFECT)
end
function c9910163.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(9910163,1)) then
		Duel.Hint(HINT_CARD,0,9910163)
		Duel.SortDecktop(tp,tp,c:GetCounter(0x1958))
		Duel.BreakEffect()
		c:RemoveCounter(tp,0x1958,1,REASON_EFFECT)
	end
end
