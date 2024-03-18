--浮 世 柩 的 武 人
local m=22348373
local cm=_G["c"..m]
function cm.initial_effect(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c22348373.adjustop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c22348373.setcon)
	e2:SetTarget(c22348373.settg)
	e2:SetOperation(c22348373.setop)
	c:RegisterEffect(e2)
	--ss
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348187,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCost(c22348373.sscost)
	e3:SetTarget(c22348373.sstg)
	e3:SetOperation(c22348373.ssop)
	c:RegisterEffect(e3)
	if not c22348373.global_check then
		c22348373.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348373.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22348373.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function c22348373.mvfilter(c)
	return c:GetSequence()<5
end
function c22348373.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348373.mvfilter,tp,LOCATION_MZONE,0,2,nil) end
end
function c22348373.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectMatchingCard(tp,c22348373.mvfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.HintSelection(g1)
	local tc1=g1:GetFirst()
	local tc2=g1:GetNext()
	Duel.SwapSequence(tc1,tc2)
end

function c22348373.filter1(c)
	return c:IsOriginalCodeRule(22348373) and c:IsFacedown() and c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-c:GetControler())
end
function c22348373.checkop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348373.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.ChangePosition(g1,POS_FACEUP_ATTACK)
end
function c22348373.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if not c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end



function c22348373.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and r==REASON_FUSION
end
function c22348373.setfilter(c)
	return c:IsSetCard(0x370b) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c22348373.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c22348373.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c22348373.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22348373.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SSet(tp,tc) end
end