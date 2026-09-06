--深渊的呼唤VII 紧急运输
local s,id,o=GetID()
function s.initial_effect(c)
	s.sp(c)
	s.set(c)
end
function s.set(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1110)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.thfilter(c,e,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToHand()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x882) and c:IsFaceupEx() and (b1 or b2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local mat_operation=nil
	local operation_params=nil
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=tc:IsAbleToHand()
	local op=aux.SelectFromOptions(tp,{b1,2},{b2,1190})
	if op==1 then
		mat_operation=Duel.SpecialSummon
		operation_params={0,tp,tp,false,false,POS_FACEUP}
	end
	if op==2 then
		mat_operation=Duel.SendtoHand
		operation_params={nil,REASON_EFFECT}
	end
	if mat_operation(tc,table.unpack(operation_params))~=0 
		and s.postg(e,tp,eg,ep,ev,re,r,rp,0) then
		s.posop(e,tp,eg,ep,ev,re,r,rp)
	end
end 

function s.posposposfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local sg=Duel.GetMatchingGroup(s.posposposfilter,tp,0,LOCATION_MZONE,nil)
		return #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(88800103,0)) end
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sc=Duel.SelectMatchingCard(tp,s.posposposfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
end
function s.sp(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(2)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFacedown() 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	s.spposlimt(e,tp,eg,ep,ev,re,r,rp)
end

function s.spposlimt(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return (sumpos&POS_ATTACK)>0
end