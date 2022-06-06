--混沌的引导者
local m=10888894
local cm=_G["c"..m]

function cm.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--tograve or remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.tgrco)
	e2:SetTarget(cm.tgrtg)
	e2:SetOperation(cm.tgrop)
	c:RegisterEffect(e2)
end

function cm.tgtfilter(c)
	return c:IsCode(10888912) and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,LOCATION_DECK,0,1,nil) 
	and not e:GetHandler():IsPublic() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.tgtfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,g)
			local tc=g:GetFirst()
			if tc:IsLocation(LOCATION_HAND) and c:IsAbleToGrave() then
				Duel.BreakEffect()
				Duel.SendtoGrave(c,REASON_EFFECT)
			end
		end
	end
end

function cm.tgrco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function cm.tgtgrfilter(c)
	return c:IsSetCard(0x773) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end

function cm.tgrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtgrfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

function cm.tgrop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.tgtgrfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToGrave() and 
		(not tc:IsAbleToRemove() or Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0) then
			Duel.SendtoGrave(tc,nil,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end