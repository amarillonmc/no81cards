--欢迎来到神隐之乡
function c37900008.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37900008+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c37900008.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,47900008)
	e2:SetCost(c37900008.cost)
	e2:SetTarget(c37900008.tg)
	e2:SetOperation(c37900008.op)
	c:RegisterEffect(e2)
end
function c37900008.q(c)
	return c:IsSetCard(0xce0) and c:IsAbleToHand()
end
function c37900008.w(c,e,tp)
	return c:IsSetCard(0x389) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c37900008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.IsExistingMatchingCard(c37900008.q,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c37900008.w,tp,LOCATION_DECK,0,1,nil,e,tp)) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(37900008,2)) then
		if Duel.IsExistingMatchingCard(c37900008.q,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(c37900008.w,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c37900008.q,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			end
		end	
		if not Duel.IsExistingMatchingCard(c37900008.q,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c37900008.w,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c37900008.w,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				g:GetFirst():RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				g:GetFirst():RegisterEffect(e2,true)
				end
			end	
		end
		if Duel.IsExistingMatchingCard(c37900008.q,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c37900008.w,tp,LOCATION_DECK,0,1,nil,e,tp) then
		local op=Duel.SelectOption(tp,aux.Stringid(37900008,0),aux.Stringid(37900008,1))
			if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c37900008.q,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				end
			end
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c37900008.w,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					g:GetFirst():RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					g:GetFirst():RegisterEffect(e2,true)
					end
				end	
			end
		end
	end	
end
function c37900008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c37900008.e(c)
	return (c:IsSetCard(0x389) or c:IsSetCard(0xce0)) and c:IsAbleToHand()
end
function c37900008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900008.e,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37900008.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c37900008.e,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end