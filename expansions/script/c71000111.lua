--最后的伙伴
function c71000111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(2,71000111)
	e1:SetTarget(c71000111.tg)
	e1:SetOperation(c71000111.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2,71000111)
	e2:SetTarget(c71000111.xtg)
	e2:SetOperation(c71000111.xop)
	c:RegisterEffect(e2)
end
function c71000111.f(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0xe73)
end 
function c71000111.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71000111.f,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71000111.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71000111.f,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71000111.xf(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(71000100)
end
function c71000111.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71000111.xf(chkc) and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c71000111.xf,tp,LOCATION_MZONE,0,1,c) and c:IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SetOperationInfo(tp,c71000111.xf,tp,LOCATION_MZONE,0,1,1,c)

end
function c71000111.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  --  local tc=Duel.GetFirstTarget() 
	local g=Duel.SelectMatchingCard(tp,c71000111.xf,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) then --and not tc:IsImmuneToEffect(e) and tc:IsCanOverlay() 
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(tc,mg,false) end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end