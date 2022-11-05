--蝶现-「启」
yume=yume or {}
if c71401001 then
function c71401001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,71401001)
	e1:SetCondition(c71401001.con1)
	e1:SetCost(c71401001.cost1)
	e1:SetTarget(c71401001.tg1)
	e1:SetOperation(c71401001.op1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401001,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,71501001)
	e2:SetCost(c71401001.cost2)
	e2:SetTarget(c71401001.tg2)
	e2:SetOperation(c71401001.op2)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	yume.ButterflyCounter()
end
end
function c71401001.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c71401001.filterc1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemoveAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function c71401001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401001.filterc1,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401001.filterc1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71401001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71401001.filter2ext(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c71401001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	yume.RegButterflyCostLimit(e,tp)
end
function c71401001.filter2(c,e,tp,check)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4)
		and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c71401001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(c71401001.filter2ext,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c71401001.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
end
function c71401001.op2(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71401001.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not (check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)) or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
end
function yume.ButterflyCounter()
	Duel.AddCustomActivityCounter(71401001,ACTIVITY_CHAIN,yume.ButterflyCounterFilter)
end
function yume.ButterflyCounterFilter(re,tp,cid)
	return not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function yume.RegButterflyCostLimit(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(yume.ButterflyAcLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function yume.ButterflyAcLimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function yume.AddButterflySpell(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,2))
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.ButterflyPlaceCost)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflySpellOp)
	c:RegisterEffect(e1)
end
function yume.ButterflyPlaceTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) end
end
function yume.ButterflyPlaceCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	yume.RegButterflyCostLimit(e,tp)
end
function yume.ButterflySpellOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function yume.AddButterflyTrap(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,3))
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.ButterflyPlaceCost)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflyTrapOp)
	c:RegisterEffect(e1)
end
function yume.ButterflyTrapOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end