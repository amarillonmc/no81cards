--CAN:D 辛珂莉娅
function c88888213.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8908),4,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888213,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,88888213)
	e1:SetCost(c88888213.thcost)
	e1:SetTarget(c88888213.thtg)
	e1:SetOperation(c88888213.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(aux.AND(aux.NOT(Card.IsType),Card.IsFaceup),TYPE_FIELD))
	e2:SetCondition(c88888213.effcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c88888213.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local mg=e:GetHandler():GetOverlayGroup()
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>0 and Duel.IsPlayerAffectedByEffect(tp,88888217) and Duel.SelectYesNo(tp,aux.Stringid(88888217,1)) then
		local sg=mg:Select(tp,1,ct,nil)
		if #sg~=0 then
			for sc in aux.Next(sg) do
				Duel.MoveToField(sc,tp,sc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				sc:RegisterEffect(e1)
				mg:Sub(Group.FromCards(sc))
			end
		end
	end
	if #mg>0 then e:GetHandler():RemoveOverlayCard(tp,#mg,#mg,REASON_COST) end
end
function c88888213.thfilter(c)
	if not (c:IsSetCard(0x8908) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c88888213.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c88888213.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c88888213.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888213.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
		local ct=Duel.GetMatchingGroupCount(c88888213.filter,tp,LOCATION_ONFIELD,0,nil)
		if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c88888213.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) 
			and Duel.SelectYesNo(tp,aux.Stringid(88888213,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888213.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c88888213.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c88888213.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88888213.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end