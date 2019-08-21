--夜间游荡的唐伞妖怪
local m=1141005
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1141005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c1141005.cost1)
	e1:SetTarget(c1141005.tg1)
	e1:SetOperation(c1141005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1141005,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP)
	e2:SetTarget(c1141005.tg2)
	e2:SetOperation(c1141005.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetOperation(c1141005.op3)
	c:RegisterEffect(e3)
--
end
--
c1141005.muxu_ih_KTatara=1
--
function c1141005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,e:GetHandler(),REASON_COST)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
--
function c1141005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_CHAINING)
		and Duel.GetMZoneCount(tp)>0
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1141005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos1=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and POS_FACEUP_ATTACK or 0
	local pos2=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and POS_FACEDOWN_DEFENSE or 0
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,pos1+pos2)
	if c:IsFacedown() then Duel.ConfirmCards(1-tp,c) end
end
--
function c1141005.tfilter2(c)
	return c.muxu_ih_KTatara and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c1141005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1141005.tfilter2,tp,LOCATION_HAND,0,1,nil)
	local c=e:GetHandler()
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c1141005.tfilter2,tp,LOCATION_HAND,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c1141005.tfilter2,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(1141005)>0 
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (b1 or b2)
	end
	if e:GetHandler():GetFlagEffect(1141005)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(1141005)
	else
		e:SetLabel(0)
	end
end
--
function c1141005.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_HAND 
	if e:GetLabel()==1 then loc=LOCATION_DECK+LOCATION_HAND end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,c1141005.tfilter2,tp,loc,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SSet(tp,sg)
		Duel.ConfirmCards(1-tp,sg)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		sg:GetFirst():RegisterEffect(e2_1,true)
	end
end
--
function c1141005.op3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1141005,0,0,0)
end