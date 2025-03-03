--红 之 印 象 银 白 冒 险 之 城
local m=22348061
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c22348061.Condition)
	e0:SetTarget(c22348061.target)
	e0:SetOperation(c22348061.operation)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--SendtoGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348061,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22348061.target)
	e2:SetOperation(c22348061.operation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348061,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22348061.spcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22348061.sttg)
	e3:SetOperation(c22348061.stop)
	c:RegisterEffect(e3)
	if not c22348061.global_check then
		c22348061.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348061.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c22348061.filter1(c)
	return c:IsOriginalCodeRule(22348061) and c:IsFacedown() and c:IsHasEffect(EFFECT_CHANGE_TYPE) and c:IsType(TYPE_TRAP) and c:GetOriginalType()~=TYPE_TRAP
end
function c22348061.filter2(c)
	return c:IsOriginalCodeRule(22348061) and c:IsFaceup() and c:GetOriginalType()~=0x200021
end
function c22348061.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348061.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local g2=Duel.GetMatchingGroup(c22348061.filter2,tp,0xff,0xff,nil)
	if KOISHI_CHECK and g1:GetCount()>0 then
		g1:GetFirst():SetCardData(CARDDATA_TYPE,0x4)
	end
	if KOISHI_CHECK and g2:GetCount()>0 then
		g2:GetFirst():SetCardData(CARDDATA_TYPE,0x200021)
	end
end
function c22348061.tgfilter(c)
	return c:IsAbleToGrave() and c:IsFacedown()
end
function c22348061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348061.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c22348061.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsSetCard(0x3702)
end
function c22348061.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348061.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsPreviousControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348061.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(22348061,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c22348061.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc2=g2:GetFirst()
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc2)
		end
	end
end
function c22348061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetType()==TYPE_TRAP
end
function c22348061.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348061.stfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c22348061.stfilter(c,tp)
	return c:IsCode(22348452) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c22348061.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348061.stfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c22348061.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end
function c22348061.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end








