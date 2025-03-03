--红 之 印 象 古 生 始 源 之 海
local m=22348060
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_POSITION+CATEGORY_DECKDES)
	e0:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(c22348060.Condition)
	e0:SetTarget(c22348060.target)
	e0:SetOperation(c22348060.operation)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--set2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348060,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22348060.target)
	e2:SetOperation(c22348060.operation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348060,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22348060.spcon)
	e3:SetTarget(c22348060.sptg)
	e3:SetOperation(c22348060.spop)
	c:RegisterEffect(e3)
	if not c22348060.global_check then
		c22348060.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348060.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c22348060.filter1(c)
	return c:IsOriginalCodeRule(22348060) and c:IsFacedown() and c:IsHasEffect(EFFECT_CHANGE_TYPE) and c:IsType(TYPE_TRAP) and c:GetOriginalType()~=TYPE_TRAP
end
function c22348060.filter2(c)
	return c:IsOriginalCodeRule(22348060) and c:IsFaceup() and c:GetOriginalType()~=0x200021
end
function c22348060.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348060.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local g2=Duel.GetMatchingGroup(c22348060.filter2,tp,0xff,0xff,nil)
	if KOISHI_CHECK and g1:GetCount()>0 then
		g1:GetFirst():SetCardData(CARDDATA_TYPE,0x4)
	end
	if KOISHI_CHECK and g2:GetCount()>0 then
		g2:GetFirst():SetCardData(CARDDATA_TYPE,0x200021)
	end
end
function c22348060.setfilter(c,lv)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsLevelBelow(lv)
end
function c22348060.tgfilter(c,tp)
	return c:IsAbleToGrave() and c:IsSetCard(0x3702) and Duel.IsExistingMatchingCard(c22348060.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetLevel())
end
function c22348060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348060.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c22348060.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22348060.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tg)
	local tc=g1:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c22348060.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc:GetLevel()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c22348060.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc:GetLevel())
		if g2:GetFirst():IsFaceup() then
			Duel.ChangePosition(g2:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end
function c22348060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetType()==TYPE_TRAP
end
function c22348060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c22348060.Condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end






