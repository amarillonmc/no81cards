--URBEX ACTION-集结
function c65010519.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65010519+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65010519.cost)
	e1:SetTarget(c65010519.target)
	e1:SetOperation(c65010519.activate)
	c:RegisterEffect(e1)
end
c65010519.setname="URBEX"
function c65010519.thfil(c)
	return c.setname=="URBEX" and c:IsAbleToHand() and not c:IsCode(65010519)
end
function c65010519.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetDecktopGroup(tp,3)
	local b1=g1:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3 and Duel.IsExistingMatchingCard(c65010519.thfil,tp,LOCATION_DECK,0,1,nil)
	local g2=Duel.GetDecktopGroup(tp,8)
	local b2=g2:FilterCount(Card.IsAbleToRemoveAsCost,nil)==8 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=6
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65010519,0),aux.Stringid(65010519,1))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g1,POS_FACEDOWN,REASON_COST)
	elseif op==1 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g2,POS_FACEDOWN,REASON_COST)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65010519,op))
end
function c65010519.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=e:GetLabel()
	if op==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function c65010519.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g1=Duel.SelectMatchingCard(tp,c65010519.thfil,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	elseif op==1 then
		local g2=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_REMOVED,0,1,1,nil)
		if g2:GetCount()>0 then
			local gc=g2:GetFirst()
			if gc:IsType(TYPE_MONSTER) and gc.setname=="URBEX" and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(65010519,2)) then
			   Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c65010519.splimit)
			Duel.RegisterEffect(e1,tp)
	end
end
function c65010519.splimit(e,c)
	return not c.setname=="URBEX"
end