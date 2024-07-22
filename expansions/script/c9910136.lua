--战车道的重击
function c9910136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910136+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910136.target)
	e1:SetOperation(c9910136.activate)
	c:RegisterEffect(e1)
end
function c9910136.thfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand() and c:GetOwner()==tp
end
function c9910136.dfilter(c)
	return c:IsFaceup() and aux.nzatk(c)
end
function c9910136.filter(c,tp)
	local b1=c:GetOverlayGroup():IsExists(c9910136.thfilter,1,nil,tp)
	local b2=c:GetAttack()>0 and Duel.IsExistingMatchingCard(c9910136.dfilter,tp,0,LOCATION_MZONE,1,nil)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (b1 or b2)
end
function c9910136.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910136.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910136.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910136.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c9910136.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local chk
	local mg=tc:GetOverlayGroup():Filter(c9910136.thfilter,nil,tp)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,#mg,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			chk=true
		end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		if tc:IsFaceup() then
			local lv=og:GetSum(Card.GetLevel)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(lv*100)
			tc:RegisterEffect(e1)
		end
	end
	local g=Duel.GetMatchingGroup(c9910136.dfilter,tp,0,LOCATION_MZONE,nil)
	if tc:IsFaceup() and #g>0 then
		if chk then Duel.BreakEffect() end
		local dg=Group.CreateGroup()
		for sc in aux.Next(g) do
			local patk=sc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-tc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			if patk~=0 and sc:IsAttack(0) then dg:AddCard(sc) end
		end
		if #dg>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
