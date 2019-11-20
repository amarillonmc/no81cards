--战车道前线维修
function c9910152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910152.target)
	e1:SetOperation(c9910152.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910152,0))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetLabelObject(c)
	e2:SetCondition(c9910152.indcon)
	e2:SetCost(c9910152.indcost)
	e2:SetTarget(c9910152.indtg)
	e2:SetOperation(c9910152.indop)
	c:RegisterEffect(e2)
end
function c9910152.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x952) and c:IsType(TYPE_XYZ)
end
function c9910152.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910152.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910152.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910152.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910152.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c9910152.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c9910152.efilter(e,re)
	local c=e:GetHandler()
	local g=Group.FromCards(c)
	if c:GetOverlayCount()>0 then g:Merge(c:GetOverlayGroup()) end
	return not g:IsContains(re:GetOwner())
end
function c9910152.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c9910152.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local c=e:GetLabelObject()
	local g=e:GetHandler():GetOverlayGroup()
	if not g:IsContains(c) then return false end
	g:RemoveCard(c)
	if g:GetCount()==0 or (g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910152,1))) then
		Duel.SendtoGrave(c,REASON_COST)
	elseif Duel.SelectYesNo(tp,aux.Stringid(9910152,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local tg=g:Select(tp,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoGrave(tg,REASON_COST)
		end
	else e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end
end
function c9910152.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910152.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		c:RegisterEffect(e2)
	end
end
