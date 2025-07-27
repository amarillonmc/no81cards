--人理之基 宇宙艾蕾什基伽尔
function c22023930.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020300,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),1,true,true)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023930,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,22023930)
	e1:SetCost(c22023930.cost)
	e1:SetTarget(c22023930.target)
	e1:SetOperation(c22023930.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023930,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,22023930)
	e2:SetCondition(c22023930.spcon)
	e2:SetCost(c22023930.cost1)
	e2:SetTarget(c22023930.target1)
	e2:SetOperation(c22023930.operation1)
	c:RegisterEffect(e2)
	--Effect Draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c22023930.spcon)
	e3:SetValue(3)
	c:RegisterEffect(e3)
	--Effect Draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c22023930.gudacon)
	e4:SetValue(3)
	c:RegisterEffect(e4)
end
function c22023930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22023930,2))
	Duel.SelectOption(tp,aux.Stringid(22023930,3))
end
function c22023930.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22023930.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22023930,2))
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c22023930.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22023930,4))
end
function c22023930.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c22023930.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023930.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.SelectOption(tp,aux.Stringid(22023930,5))
		Duel.Recover(tp,5000,REASON_EFFECT)
	end
end
function c22023930.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS 
end
function c22023930.spfilter(c)
	return c:IsCode(22020000) and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c22023930.gudacon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22023930.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS 
end