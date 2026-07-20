-- 斩烬织巢之刃 良秀
local s,id,o=GetID()
local EFFECT_RYOSHU_QUICK=0x53360001
s.VHisc_WEAVENEST=true

function s.initial_effect(c) 
	-- ==================== ①效果：本家召唤/特召触发 ==================== 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(id,0)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) -- 此效果没有 CountLimit 限制 
	e1:SetCondition(s.spcon1) 
	e1:SetTarget(s.sptg1) 
	e1:SetOperation(s.spop1) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2)

	-- ==================== ①效果：本家战斗的伤害步骤结束时 ==================== 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0)) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DAMAGE_STEP_END) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP) 
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e3:SetCondition(s.spcon2) 
	e3:SetTarget(s.sptg2) 
	e3:SetOperation(s.spop2) 
	c:RegisterEffect(e3)  

	-- ==================== ②效果：支付基本分盖放魔陷 ==================== 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(3,id)
	e4:SetCondition(s.quickcon1)
	e4:SetCost(s.setcost)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
	--得到「织巢之血 幻指护父」的效果后，可以在对方回合发动
	local e4q=e4:Clone()
	e4q:SetType(EFFECT_TYPE_QUICK_O)
	e4q:SetCode(EVENT_FREE_CHAIN)
	e4q:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e4q:SetCondition(s.quickcon2)
	c:RegisterEffect(e4q)

	-- ==================== ③效果：依据墓地卡名种类增加攻击次数 ==================== 
	local e5=Effect.CreateEffect(c) 
	e5:SetType(EFFECT_TYPE_SINGLE) 
	e5:SetCode(EFFECT_EXTRA_ATTACK) 
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e5:SetRange(LOCATION_MZONE) 
	e5:SetValue(s.atkval) 
	c:RegisterEffect(e5) 

	--flag reset
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(s.flagop)
	c:RegisterEffect(e6)
end

function s.flagop(e,tp,eg,ep,ev,re,r,rp)
	Card.ResetFlagEffect(e:GetHandler(),33310451)
end
-- ==================== ①效果处理逻辑 (召唤/特召时) ====================
function s.cfilter(c,tp)
-- 使用 IsSetCard(0x5330) 检测字段，且排除自身同名卡
	return c:IsFaceup() and c.VHisc_WEAVENEST and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local tg=eg:Filter(s.cfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tg=eg:Filter(s.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
		if #tg>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=tg:Select(tp,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

-- ==================== ①效果处理逻辑 (伤害步骤结束时) ====================
function s.batfilter(c)
	return c.VHisc_WEAVENEST and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsRelateToBattle() and c:IsLocation(LOCATION_MZONE)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and s.batfilter(a)) or (d and s.batfilter(d))
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if a and s.batfilter(a) then g:AddCard(a) end
	if d and s.batfilter(d) then g:AddCard(d) end
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		local g=Group.CreateGroup()
		if a and s.batfilter(a) then g:AddCard(a) end
		if d and s.batfilter(d) then g:AddCard(d) end
		if #g>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

-- ==================== ②效果处理逻辑 ====================
function s.quickcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(EFFECT_RYOSHU_QUICK)
end
function s.quickcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(EFFECT_RYOSHU_QUICK)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

function s.setfilter(c)
	return c.VHisc_WEAVENEST and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id-1)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(id-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

-- ==================== ③效果处理逻辑 ====================
function s.atkfilter(c)
	return c.VHisc_WEAVENEST and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.atkval(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return math.floor(ct/3)
end

