--超古代的巨人 影之继承者
local s,id,o=GetID()
function c98930026.initial_effect(c)
	 --synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c98930026.matfilter1,nil,nil,c98930026.matfilter2,1,99)
   --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) -- 任意时点
	e1:SetRange(LOCATION_MZONE) -- 假设是怪兽卡，若为其他类型需调整
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id) -- 1回合1次
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
   --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98930026,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,84330568)
	e3:SetCondition(c98930026.spcon)
	e3:SetTarget(c98930026.sptg)
	e3:SetOperation(c98930026.spop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and rc:GetFlagEffect(id+o+p)==0 then
		rc:RegisterFlagEffect(id+o+p,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98930026.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0xad0)
end
function c98930026.matfilter2(c,syncard)
	return c:IsNotTuner(syncard) and c:IsSetCard(0xad0)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
-- 目标：场上1张表侧表示卡
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	-- 根据属性预设置可能的结果
	local c=e:GetHandler()
	local attr=c:GetAttribute()
	if attr&(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)==0 then
		-- 不是光或暗属性，不应发动（这里通过条件限制，但已在发动条件中检查）
		e:SetCategory(0)
	elseif attr&ATTRIBUTE_DARK~=0 then
		e:SetCategory(CATEGORY_DESTROY)
	else
		e:SetCategory(0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local attr=c:GetAttribute()
	-- 检查是否为光或暗属性
	if attr&(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)==0 then return end
	-- 暗属性：破坏
	if attr&ATTRIBUTE_DARK~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	-- 光属性：直到回合结束只有1次不被战斗·效果破坏
	elseif attr&ATTRIBUTE_LIGHT~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(s.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c98930026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98930026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98930026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_LIGHT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
	if not re then return false end
	local rc=re:GetHandler()
	if rc:IsCode(98930021) and Duel.IsExistingMatchingCard(c98930026.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(98930026,2)) then
		 local g=Duel.GetMatchingGroup(c98930026.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,1-tp)
		 Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c98930026.cfilter(c,p)
	return c:IsFaceup() and (c:GetFlagEffect(id+o+p)>0 or c:IsAttribute(ATTRIBUTE_DARK))
end