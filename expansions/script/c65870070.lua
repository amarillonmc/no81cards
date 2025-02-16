--Protoss·侦测器
function c65870070.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870070,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65870070)
	e1:SetTarget(c65870070.thtg)
	e1:SetOperation(c65870070.thop)
	c:RegisterEffect(e1)
end

function c65870070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c65870070.thfilter(c)
	return c:IsSetCard(0x3a37) and c:IsAbleToHand()
end
function c65870070.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,g:GetCount())
		local cg=Duel.GetDecktopGroup(tp,g:GetCount())
		local ct=cg:GetCount()
		if ct>0 and cg:FilterCount(c65870070.thfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(65870070,0)) then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=cg:FilterSelect(tp,c65870070.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			--ct=g:GetCount()-sg:GetCount()
			Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
	end
end