--俱 灭 之 白 骨 圣 堂 教 主
local m=22348127
local cm=_G["c"..m]
function cm.initial_effect(c)
	--自 己 场 上 1张 表 侧 表 示 的 魔 法 ·陷 阱 卡 破 坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348127,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c22348127.descost)
	e1:SetTarget(c22348127.destg)
	e1:SetOperation(c22348127.desop)
	c:RegisterEffect(e1)
	--这 张 卡 从 手 卡 特 殊 召 唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348127,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c22348127.spcon)
	e2:SetTarget(c22348127.sptg)
	e2:SetOperation(c22348127.spop)
	c:RegisterEffect(e2)
	--全 部 破 坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348127,3))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c22348127.destg2)
	e3:SetOperation(c22348127.desop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
end
function c22348127.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	if c then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348127,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
end
function c22348127.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsPublic()
end
function c22348127.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348127.filter,tp,LOCATION_ONFIELD,0,1,nil)
	end
	local sg=Duel.GetMatchingGroup(c22348127.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c22348127.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348127.filter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,22348127))
		e1:SetValue(-1)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22348127.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLevelAbove(4)
end
function c22348127.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffect(22348127)==0 end
	c:RegisterFlagEffect(22348127,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348127.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22348127.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22348127.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(c22348127.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local sg1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(c22348127.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.__add(sg1,sg2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c22348127.desop2(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(c22348127.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.__add(sg1,sg2)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
	Duel.BreakEffect()
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end










