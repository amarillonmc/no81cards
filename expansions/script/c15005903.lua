local m=15005903
local cm=_G["c"..m]
cm.name="狂音主的拨弦"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsSetCard(0x6f43) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST)
end
function cm.selffilter(c,e,tp)
	if not (c:IsSetCard(0x6f43) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.oppofilter(c,e,tp)
	if not (c:IsSetCard(0x6f43) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToGrave() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetTurnPlayer()==tp then
		if chk==0 then return Duel.IsExistingMatchingCard(cm.selffilter,tp,LOCATION_DECK,0,1,nil) end
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		if chk==0 then return Duel.IsExistingMatchingCard(cm.oppofilter,tp,LOCATION_DECK,0,1,nil) end
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function cm.oppodisfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.selffilter,tp,LOCATION_DECK,0,1,1,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.oppofilter,tp,LOCATION_DECK,0,1,1,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToGrave() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.IsExistingMatchingCard(cm.oppodisfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.SelectOption(tp,1191,1152)==0) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end