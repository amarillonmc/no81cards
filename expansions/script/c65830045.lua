--种子雨
function c65830045.initial_effect(c)
	--检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65830045,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,65830045+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c65830045.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c65830045.drawtg)
	e3:SetOperation(c65830045.drawop)
	c:RegisterEffect(e3)
end



function c65830045.thfilter(c)
	return c:IsSetCard(0xa33) and c:IsAbleToHand()
end
function c65830045.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65830045.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65830045,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end


function c65830045.filter2(e,c)
	return c:IsSetCard(0xa33) and c:IsAbleToHand()
end
function c65830045.filter1(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function c65830045.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65830045.filter2,tp,LOCATION_DECK,0,1,nil,c) and Duel.IsExistingMatchingCard(c65830045.filter1,tp,LOCATION_HAND,0,1,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c65830045.drawop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65830045.thfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil,c)
	end
end