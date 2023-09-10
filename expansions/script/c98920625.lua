--重装解体
function c98920625.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920625)
	e1:SetTarget(c98920625.target)
	e1:SetOperation(c98920625.activate)
	c:RegisterEffect(e1)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98920625)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920625.target1)
	e2:SetOperation(c98920625.activate1)
	c:RegisterEffect(e2)
end
function c98920625.filter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xc2) or c:IsCode(25165047))
		and Duel.IsExistingMatchingCard(c98920625.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c98920625.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c98920625.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920625.filter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c98920625.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920625.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c98920625.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c98920625.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
function c98920625.filter1(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xc2) or c:IsCode(25165047))
		and Duel.IsExistingMatchingCard(c98920625.eqfilter1,tp,LOCATION_GRAVE,0,1,nil,c,tp)
end
function c98920625.eqfilter1(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c98920625.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920625.filter1(chkc,tp) end
	local ft=0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c98920625.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920625.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c98920625.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c98920625.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end