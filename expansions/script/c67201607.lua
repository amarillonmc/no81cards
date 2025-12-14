--复转之丰穰
function c67201607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,67201607+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67201607.cost)
	e1:SetTarget(c67201607.target)
	e1:SetOperation(c67201607.activate)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201607,3))
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(c67201607.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c67201607.condition(e)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_WIND and e:GetHandler():IsSetCard(0x367f)
end
--
function c67201607.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(67201607,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,1,REASON_COST)
	end
	e:SetLabel(spct)
end
function c67201607.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x367f) and c:IsAbleToHand()
end
function c67201607.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201607.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201607.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c67201607.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67201607.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local spct=e:GetLabel()
		if spct>0 and c:IsRelateToEffect(e) and c:IsCanOverlay() and Duel.IsExistingMatchingCard(c67201607.matfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(67201607,2)) then
			Duel.BreakEffect()
			c:CancelToGrave()
			local tc=Duel.SelectMatchingCard(tp,c67201607.matfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
				Duel.Overlay(tc,Group.FromCards(c))
			end
		end
	end
end
