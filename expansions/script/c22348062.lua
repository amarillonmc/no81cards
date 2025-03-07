--红 之 印 象 惑 虫 奸 乐 之 穴
local m=22348062
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c22348062.Condition)
	e0:SetTarget(c22348062.target)
	e0:SetOperation(c22348062.operation)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--SendtoGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348062,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22348062.target)
	e2:SetOperation(c22348062.operation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348060,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22348062.spcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22348062.sttg)
	e3:SetOperation(c22348062.stop)
	c:RegisterEffect(e3)
	if not c22348062.global_check then
		c22348062.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348062.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_FIELD)
		ge2:SetOperation(c22348062.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c22348062.checkfilter(c)
	return c:IsOriginalCodeRule(22348062)
end
function c22348062.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c22348062.checkfilter,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(22348062,RESET_CHAIN,0,1)
		tc=g:GetNext()
	end
end
function c22348062.filter1(c)
	return c:IsOriginalCodeRule(22348062) and c:IsFacedown() and c:IsHasEffect(EFFECT_CHANGE_TYPE) and c:IsType(TYPE_TRAP) and c:GetOriginalType()~=TYPE_TRAP
end
function c22348062.filter2(c)
	return c:IsOriginalCodeRule(22348062) and c:IsFaceup() and c:GetOriginalType()~=0x200021 and not Duel.GetFlagEffect(tp,22348062)
end
function c22348062.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348062.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local g2=Duel.GetMatchingGroup(c22348062.filter2,tp,0xff,0xff,nil)
	if KOISHI_CHECK and g1:GetCount()>0 then
		g1:GetFirst():SetCardData(CARDDATA_TYPE,0x4)
	end
	if KOISHI_CHECK and g2:GetCount()>0 then
		g2:GetFirst():SetCardData(CARDDATA_TYPE,0x200021)
	end
end
function c22348062.tgfilter(c)
	return c:IsAttackAbove(1000) and c:IsFaceup()
end
function c22348062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c22348062.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22348062.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22348062.setfilter(c)
	return c:IsSetCard(0x3702) and c:IsType(TYPE_MONSTER)
end
function c22348062.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:GetPreviousControler()==tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348062.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348062,2)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			 local g=Duel.SelectMatchingCard(tp,c22348062.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			 local tc1=g:GetFirst()
			 if tc1 then
			  Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_TRAP)
			  tc1:RegisterEffect(e1)
			 end
			 Duel.ConfirmCards(1-tp,tc1)
		end
	end
end
function c22348062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetType()==TYPE_TRAP
end
function c22348062.stfilter(c,e,tp)
	return (c:IsSetCard(0x3702) or c:GetType()==TYPE_TRAP) and ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or ((c:IsType(TYPE_FIELD) or (c:IsType(TYPE_TRAP+TYPE_SPELL) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) and c:IsSSetable(true)))
end
function c22348062.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348062.stfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
end
function c22348062.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c22348062.stfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	local tc=g:GetFirst()
	if tc and tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	elseif tc and tc:IsType(TYPE_TRAP+TYPE_SPELL) and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22348062.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end

