--许下永恒的誓言
function c71000103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetOperation(c71000103.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2,71000103)
	e2:SetTarget(c71000103.xtg)
	e2:SetOperation(c71000103.xop)
	c:RegisterEffect(e2)
	--

end
function c71000103.f(c)
	return c:IsCode(71000101,71000102) and c:IsAbleToHand()
end 
function c71000103.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71000103.f,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71000103,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c71000103.xf(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(71000100)
end
function c71000103.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71000103.xf(chkc) and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c71000103.xf,tp,LOCATION_MZONE,0,1,c) and c:IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71000103.xf,tp,LOCATION_MZONE,0,1,1,c)
end
function c71000103.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsCanOverlay() then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(tc,mg,false) end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
