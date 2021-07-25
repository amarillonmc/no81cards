--六角之巅 朔月
function c12524010.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c12524010.mfilter,1,1)
	c:EnableReviveLimit()
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12524010)
	e2:SetCondition(c12524010.thcon)
	e2:SetTarget(c12524010.thtg)
	e2:SetOperation(c12524010.thop)
	c:RegisterEffect(e2)
end
function c12524010.mfilter(c)
	return not c:IsCode(12524010) and c:IsLinkSetCard(0x730,0x732)
end
function c12524010.thcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and (mg:IsExists(Card.IsSetCard,1,nil,0x732) or mg:IsExists(Card.IsSetCard,1,nil,0x730))
end
function c12524010.thfilter(c,setname)
	return c:IsSetCard(setname) and c:IsAbleToHand()
end
function c12524010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local ct1=g:FilterCount(Card.IsSetCard,nil,0x732)
	local ct2=g:FilterCount(Card.IsSetCard,nil,0x730)
	local ct3=g:FilterCount(Card.IsSetCard,nil,0x730,0x732)
	local b1=mg:IsExists(Card.IsSetCard,1,nil,0x730) and ct1>0
	local b2=mg:IsExists(Card.IsSetCard,1,nil,0x732) and ct2>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if ct3>1 then
			op=Duel.SelectOption(tp,aux.Stringid(12524010,0),aux.Stringid(12524010,1),aux.Stringid(12524010,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(12524010,0),aux.Stringid(12524010,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(12524010,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(12524010,1))+1
	end
	e:SetLabel(op)
	if op~=2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	end
end
function c12524010.thop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c12524010.thfilter,tp,LOCATION_DECK,0,1,1,nil,0x732)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c12524010.thfilter,tp,LOCATION_DECK,0,1,1,nil,0x730)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
