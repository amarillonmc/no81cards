local m=22347171
local cm=_G["c"..m]
cm.name="蕾宗忍者上忍·介毒"
function cm.initial_effect(c)
	c:SetSPSummonOnce(22347171)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_MOVE)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.tfcon)
	e0:SetOperation(cm.tfop)
	c:RegisterEffect(e0)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.discon)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not (re:IsActiveType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return end
	if rc:IsSetCard(0x3705) then
		local p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
		Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE)
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_NORMAL) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TEMP_REMOVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if c:IsSummonType(SUMMON_TYPE_SPECIAL) then
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TEMP_REMOVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
end
function cm.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(m)>0
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(m+1)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end