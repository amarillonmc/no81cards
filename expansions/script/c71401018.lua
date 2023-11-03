--花忆-「循」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401018.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71401018)
	e1:SetCost(yume.ButterflyLimitCost)
	e1:SetCondition(c71401018.con1)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflyTrapOp)
	c:RegisterEffect(e1)
	local e1a = e1:Clone()
	e1a:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e1a)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401013,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,71501018)
	e2:SetCondition(c71401018.con2)
	e2:SetCost(c71401018.cost2)
	e2:SetTarget(c71401018.tg2)
	e2:SetOperation(c71401018.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401018.filter1(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_MONSTER)
		and (not c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_MZONE))
end
function c71401018.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71401018.filter1,1,nil)
end
function c71401018.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c71401018.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEUP)==2 and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.DiscardDeck(tp,3,REASON_COST)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401018.filterc2(c)
	return c:IsSetCard(0x38) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c71401018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetDecktopGroup(1-tp,2)
	if chk==0 then return tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEUP)==2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_DECK)
end
function c71401018.filter2a(c)
	return c:IsFaceup() and c:GetType() & 0x20004==0x20004
end
function c71401018.filter2b(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not c:IsForbidden() and c:CheckUniqueOnField(tp))
end
function c71401018.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetDecktopGroup(1-tp,2)
	if #tg==0 then return end
	Duel.DisableShuffleCheck()
	local og=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71401018.filter2b),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(c71401018.filter2a,tp,LOCATION_ONFIELD,0,1,c)
		and og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401018,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local oc=og:Select(tp,1,1,nil):GetFirst()
		if oc then
			local b1=oc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
			local b2=not oc:IsForbidden() and oc:CheckUniqueOnField(tp)
			if b1 and (not b2 or Duel.SelectOption(tp,1152,aux.Stringid(71401001,5))==0) then
				Duel.SpecialSummon(oc,0,tp,tp,false,false,POS_FACEUP)
			else
				if Duel.MoveToField(oc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
					local e1=Effect.CreateEffect(c)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
					oc:RegisterEffect(e1)
				end
			end
		end
	end
end