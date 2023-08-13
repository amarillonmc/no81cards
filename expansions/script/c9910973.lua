--永夏的扬帆
function c9910973.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910973)
	e1:SetTarget(c9910973.target)
	e1:SetOperation(c9910973.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910988)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910973.thtg)
	e2:SetOperation(c9910973.thop)
	c:RegisterEffect(e2)
end
function c9910973.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsCanAddCounter(0x6954,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,1,nil,0x6954,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,0,1,1,nil,0x6954,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x6954)
end
function c9910973.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x6954,1) then
		tc:AddCounter(0x6954,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910973.rlcon)
	e1:SetOperation(c9910973.rlop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910973.rfilter(c)
	return c:GetCounter(0x6954)>0 and c:IsReleasableByEffect()
end
function c9910973.setfilter(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910973.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910973.rfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910973.setfilter,tp,LOCATION_DECK,0,1,nil)
end
function c9910973.rlop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(9910973,0)) then
		Duel.Hint(HINT_CARD,0,9910973)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=Duel.SelectMatchingCard(tp,c9910973.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=rg:GetFirst()
		local count=tc:GetCounter(0x6954)
		Duel.HintSelection(rg)
		if Duel.Release(tc,REASON_EFFECT)==0 then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return end
		if ft>4 then ft=4 end
		if ft>count then ft=count end
		local g=Duel.GetMatchingGroup(c9910973.setfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
			if sg:GetCount()>0 then
				Duel.SSet(tp,sg)
			end
		end
	end
end
function c9910973.thfilter(c)
	return c:IsSetCard(0x5954) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(9910973)
end
function c9910973.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9910973.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910973.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9910973.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910973.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
