--阿卡那的密语
function c29088383.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29088383+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29088383.thtg)
	e1:SetOperation(c29088383.thop)
	c:RegisterEffect(e1)
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(29088383)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
end
function c29088383.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c29088383.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c29088383.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=5
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c29088383.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29088383.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,2)
		local tc=cg:GetFirst()
		while tc do
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			tc=cg:GetNext()
		end
		if Duel.SendtoHand(cg,nil,REASON_EFFECT)==2 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
end



















