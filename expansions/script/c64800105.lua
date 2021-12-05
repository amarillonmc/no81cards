--神代丰的激斗 二千坚尼大赛
function c64800105.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64800105)
	e1:SetTarget(c64800105.thtg)
	e1:SetOperation(c64800105.thop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,64800105)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c64800105.eqtg)
	e2:SetOperation(c64800105.eqop)
	c:RegisterEffect(e2)
end

--e1
function c64800105.thfilter(c)
	return c:IsSetCard(0x641a) and c:IsAbleToHand()
end
function c64800105.exfilter(c)
	return c:IsFacedown()
end
function c64800105.cfilter(c)
	return c:IsSetCard(0x641a)
end
function c64800105.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800105.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c64800105.exfilter,tp,LOCATION_EXTRA,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
end
function c64800105.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64800105.exfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>=5 then
		local sg=g:RandomSelect(tp,5)
		Duel.ConfirmCards(1-tp,sg)
		if sg:IsExists(c64800105.cfilter,1,nil) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local thg=Duel.SelectMatchingCard(tp,c64800105.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if thg:GetCount()>0 then
				Duel.SendtoHand(thg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,thg)
			end
		end 
	end
end

--e2
function c64800105.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x641a) and not c:IsCode(64800097)
end
function c64800105.eqfilter(c)
	return c:IsCode(64800097) and not c:IsForbidden()
end
function c64800105.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c64800105.mfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c64800105.mfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c64800105.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c64800105.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,2,0,0)
end
function c64800105.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c64800105.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
	then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c64800105.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc1=g1:GetFirst()
		if tc1 then
			if Duel.Equip(tp,tc1,tc) then  
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c64800105.eqlimit)
				tc1:RegisterEffect(e1)
			end
		end
	end
end
function c64800105.eqlimit(e,c)
	return e:GetOwner()==c
end