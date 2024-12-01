--被封印者的魔神左腕
function c98920749.initial_effect(c)
	--code
	aux.EnableChangeCode(c,7902349,LOCATION_GRAVE+LOCATION_HAND)	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920749)
	e1:SetCost(c98920749.cost)
	e1:SetTarget(c98920749.target)
	e1:SetOperation(c98920749.operation)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c98920749.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98920749.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98920749.thfilter(c,check)
	return c:IsAbleToHand()
		and ((check and c:IsSetCard(0x1af) and c:IsType(TYPE_TRAP+TYPE_SPELL)) or c:IsCode(7902349))
end
function c98920749.checkfilter(c)
	return c:IsOriginalCodeRule(7902349) and not c:IsPublic()
end
function c98920749.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(c98920749.checkfilter,tp,LOCATION_HAND,0,1,nil)
		return Duel.IsExistingMatchingCard(c98920749.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920749.operation(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c98920749.checkfilter,tp,LOCATION_HAND,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920749.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if check and tc:IsSetCard(0x1af) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		   local sc=Duel.SelectMatchingCard(tp,c98920749.checkfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		   Duel.ConfirmCards(1-tp,sc)
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920749.indtg(e,c)
	return c:IsSetCard(0xde) or c:IsCode(13893596)
end