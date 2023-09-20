--蝶构-「逢」
function c71401016.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c71401016.mfilter,nil,2,2)
	--attack limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c71401016.attg)
	c:RegisterEffect(e1)
	--place and remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401016,0))
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_EQUIP)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401016)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(c71401016.tg2)
	e2:SetOperation(c71401016.op2)
	c:RegisterEffect(e2)
	--spsummon and remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401016,1))
	e3:SetCountLimit(1,71501016)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c71401016.con3)
	e3:SetCost(yume.ButterflyLimitCost)
	e3:SetTarget(c71401016.tg3)
	e3:SetOperation(c71401016.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
function c71401016.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsRank(4)
end
function c71401016.filter1(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c71401016.attg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c71401016.filter1,1,nil)
end
function c71401016.filter2(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,c,tp,POS_FACEDOWN)
end
function c71401016.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c71401016.filter2,tp,LOCATION_EXTRA,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c71401016.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,1,REASON_EFFECT)
	if sg:GetCount()==0 then return end
	Duel.HintSelection(sg)
	sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c71401016.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc then
		local c=e:GetHandler()
		local ctype=Duel.SelectOption(tp,aux.Stringid(71401016,2),aux.Stringid(71401016,3))==0 and TYPE_SPELL or TYPE_TRAP
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(ctype+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,1,nil,tp,POS_FACEDOWN)
			if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(71401016,4)) then
				Duel.BreakEffect()
				if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
					local e2=Effect.CreateEffect(c)
					e2:SetCode(EFFECT_CHANGE_TYPE)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
					c:RegisterEffect(e2)
				end
			end
		end
	end
end
function c71401016.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c71401016.filter3(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and not c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401016.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c71401016.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71401016.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(c71401016.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,1,nil,tp,POS_FACEDOWN)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end