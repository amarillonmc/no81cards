--光晕『唐伞惊吓闪光』
local m=1141702
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1141702.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1141702.con1)
	e1:SetTarget(c1141702.tg1)
	e1:SetOperation(c1141702.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1141702.cost2)
	e2:SetCondition(c1141702.con2)
	e2:SetOperation(c1141702.op2)
	c:RegisterEffect(e2)
--
end
--
c1141702.muxu_ih_KTatara=1
--
function c1141702.con1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
--
function c1141702.tfilter1(c,e,tp)
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	return b1 or b2
end
function c1141702.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1141702.tfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1141702.tfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and re:GetHandler():IsCanTurnSet() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1141702.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	if re:GetHandler():IsCanTurnSet() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	end
end
--
function c1141702.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local Pos1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and POS_FACEUP_ATTACK or 0
	local Pos2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and POS_FACEDOWN_DEFENSE or 0
	if Duel.SpecialSummon(c,0,tp,tp,false,false,Pos1+Pos2)>0 then
		Duel.NegateActivation(ev)
		if not re:GetHandler():IsRelateToEffect(re) then return end
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--
function c1141702.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1141702.tfilter2(c,tp)
	return c:GetSummonPlayer()==tp and muxu.check_set_Tatara(c) and c:GetPreviousLocation()==LOCATION_EXTRA 
end
function c1141702.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN1 and eg:IsExists(c1141702.tfilter2,1,nil,tp)
end
--
function c1141702.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_MAIN1,1)
end
--
