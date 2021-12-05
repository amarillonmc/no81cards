--神代丰的领域 香山竞马场
function c64800109.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64800109+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c64800109.thop)
	c:RegisterEffect(e1)
	--spsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64800109,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(64810109)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c64800109.target)
	e2:SetOperation(c64800109.operation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c64800109.atkcon)
	e3:SetTarget(c64800109.atktg)
	e3:SetValue(c64800109.atkval)
	c:RegisterEffect(e3)
end

--e1
function c64800109.thfilter(c)
	return c:IsSetCard(0x641a) and c:IsAbleToHand()
end
function c64800109.exfilter(c)
	return c:IsFacedown()
end
function c64800109.cfilter(c)
	return c:IsSetCard(0x641a)
end
function c64800109.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800109.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c64800109.exfilter,tp,LOCATION_EXTRA,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
end
function c64800109.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64800109.exfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>=5 and Duel.IsExistingMatchingCard(c64800109.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(64800109,0)) then
		local sg=g:RandomSelect(tp,5)
		Duel.ConfirmCards(1-tp,sg)
		if sg:IsExists(c64800109.cfilter,1,nil) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local thg=Duel.SelectMatchingCard(tp,c64800109.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if thg:GetCount()>0 then
				Duel.SendtoHand(thg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,thg)
			end
		end 
	end
end

--e2
function c64800109.filter(c,e,tp)
	return c:IsSetCard(0x641a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c64800109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,nil) 
		or (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) and Duel.IsExistingMatchingCard(c64800109.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c64800109.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c64800109.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c64800109.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
end

--e3
function c64800109.atkfilter(c)
	return c:IsCode(64800097) and c:IsFaceup()
end
function c64800109.atktg(e,c)
	return c:IsSetCard(0x641a) and not c:IsCode(64800097)
end
function c64800109.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
end
function c64800109.atkval(e,c)
	local ct=Duel.GetMatchingGroupCount(c64800109.atkfilter,p,LOCATION_ONFIELD,0,nil)
	return ct*500
end
