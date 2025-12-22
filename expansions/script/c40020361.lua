--天人-ELS量子型
local s,id=GetID()
s.ui_hint_effect = s.ui_hint_effect or {}
local CORE_ID = 40020353 
local ArmedIntervention = CORE_ID	
local ArmedIntervention_UI = CORE_ID + 10000
local GLOBAL_END_PHASE_CHECK = id + 900
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
--量子型
s.named_with_QanT=1
function s.QanT(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_QanT
end
--ELS
s.named_with_ELS=1
function s.ELS(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELS
end
function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local owner=c:GetOwner()
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and Duel.GetFlagEffect(owner,ArmedIntervention)>=9
end

function s.costfilter(c, use_extended)
	if not (c:IsFaceup() and c:IsReleasable()) then return false end
	if use_extended and s.Exia(c) then return true end
	if not c:IsType(TYPE_MONSTER) then return false end
	return s.Exia(c) or s.QanT(c) or s.ELS(c)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local use_extended = aux.IsCanBeQuickEffect(c,tp,40020377)
	local loc = LOCATION_MZONE
	if use_extended then loc = LOCATION_ONFIELD end
	
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,1,nil,use_extended)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,1,1,nil,use_extended)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetTarget(s.drawtg)
		e1:SetOperation(s.drawop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)

		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetCondition(s.copycon)
		e2:SetTarget(s.copytg)
		e2:SetOperation(s.copyop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local c1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		local c2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		return Duel.IsPlayerCanDraw(tp,c1) and Duel.IsPlayerCanDraw(1-tp,c2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,0)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	local c1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local c2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.Draw(tp,c1,REASON_EFFECT)
	Duel.Draw(1-tp,c2,REASON_EFFECT)
	if Duel.GetFlagEffect(0, GLOBAL_END_PHASE_CHECK) == 0 then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(0, GLOBAL_END_PHASE_CHECK, 0, 0, 1)
		local turn_p = Duel.GetTurnPlayer()
		Duel.SkipPhase(turn_p, PHASE_BATTLE, RESET_PHASE+PHASE_END, 1)
		Duel.SkipPhase(turn_p, PHASE_MAIN2, RESET_PHASE+PHASE_END, 1)
	end
end
function s.copycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function s.copyfilter(c)
	return c:IsRace(RACE_MACHINE) and s.CelestialBeing(c) and c:IsType(TYPE_MONSTER)
end

function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.copyfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.copyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end

function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 1)
	end
end
