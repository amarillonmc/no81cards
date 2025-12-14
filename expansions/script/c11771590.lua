--智革的械驱 德穆兰
function c11771590.initial_effect(c)
	c:EnableReviveLimit()
	-- 融合素材
	aux.AddFusionProcCodeFun(c,11771275,c11771590.mfilter,1,true,true)
	-- 召唤限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c11771590.limit)
	c:RegisterEffect(e0)
	-- 注册Flag
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0b:SetCondition(c11771590.regcon)
	e0b:SetOperation(c11771590.regop)
	c:RegisterEffect(e0b)
	-- 特殊召唤手续
	local e0c=Effect.CreateEffect(c)
	e0c:SetType(EFFECT_TYPE_FIELD)
	e0c:SetCode(EFFECT_SPSUMMON_PROC)
	e0c:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0c:SetRange(LOCATION_EXTRA)
	e0c:SetCondition(c11771590.spcon)
	e0c:SetTarget(c11771590.sptg)
	e0c:SetOperation(c11771590.spop)
	c:RegisterEffect(e0c)
	-- 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(11771275)
	c:RegisterEffect(e1)
	-- 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771590,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11771590)
	e2:SetCondition(c11771590.con2)
	e2:SetCost(c11771590.cost2)
	e2:SetTarget(c11771590.tg2)
	e2:SetOperation(c11771590.op2)
	c:RegisterEffect(e2)
	-- 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771590,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,11771590)
	e3:SetCondition(c11771590.con3)
	e3:SetCost(c11771590.cost3)
	e3:SetTarget(c11771590.tg3)
	e3:SetOperation(c11771590.op3)
	c:RegisterEffect(e3)
end
-- 融合素材filter
function c11771590.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(8)
end
-- 召唤限制
function c11771590.limit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
		and Duel.GetFlagEffect(sp,11771590)==0
end
-- 特殊召唤成功时的条件
function c11771590.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) or c:GetFlagEffect(11771590)>0
end
-- 注册Flag
function c11771590.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,11771590,RESET_PHASE+PHASE_END,0,1)
end
-- 素材filter1
function c11771590.spfilter1(c,tp,sc)
	return c:IsCode(11771275) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c11771590.spfilter2,tp,LOCATION_MZONE,0,1,nil,tp,sc,c)
end
-- 素材filter2
function c11771590.spfilter2(c,tp,sc,mc)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(8) and c:IsReleasable()
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),sc)>0
end
-- 特召条件
function c11771590.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,11771590)>0 then return false end
	return Duel.IsExistingMatchingCard(c11771590.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c)
end
-- 特召手续
function c11771590.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(c11771590.spfilter1,tp,LOCATION_ONFIELD,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc1=g1:SelectUnselect(nil,tp,false,true,1,1)
	if not tc1 then return false end
	local g2=Duel.GetMatchingGroup(c11771590.spfilter2,tp,LOCATION_MZONE,0,nil,tp,c,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc2=g2:SelectUnselect(nil,tp,false,true,1,1)
	if tc2 then
		local g=Group.FromCards(tc1,tc2)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
-- 特殊召唤手续operation
function c11771590.spop(e,tp,eg,ep,ev,re,r,rp,c)
	c:RegisterFlagEffect(11771590,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
-- 1
function c11771590.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and rp==1-tp and Duel.IsChainNegatable(ev)
end
function c11771590.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,REASON_COST,false,nil,RACE_MACHINE) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,1,1,REASON_COST,false,nil,RACE_MACHINE)
	Duel.Release(g,REASON_COST)
end
function c11771590.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11771590.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
-- 2
function c11771590.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c11771590.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,REASON_COST,false,nil,RACE_MACHINE) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,1,1,REASON_COST,false,nil,RACE_MACHINE)
	Duel.Release(g,REASON_COST)
end
function c11771590.spfilter3(c,e,tp)
	return (c:IsRace(RACE_MACHINE) or c:IsCode(11771275))
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c11771590.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) 
		and c11771590.spfilter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11771590.spfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11771590.spfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11771590.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
