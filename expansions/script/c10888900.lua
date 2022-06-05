--龙猿圣尊·混沌形态
local m=10888900
local cm=_G["c"..m]

function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),nil,nil,aux.Tuner(cm.mfilter),2,99)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--special summon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(aux.synlimit)
	c:RegisterEffect(e2)
	--Activate(summon)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition1)
	e3:SetCost(cm.cost1)
	e3:SetTarget(cm.target1)
	e3:SetOperation(cm.activate1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	--Activate(effect)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1,m)
	e6:SetCondition(cm.condition2)
	e6:SetCost(cm.cost2)
	e6:SetTarget(cm.target2)
	e6:SetOperation(cm.activate2)
	c:RegisterEffect(e6)
	--special Summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e7:SetCost(cm.spco1)
	e7:SetTarget(cm.sptg1)
	e7:SetOperation(cm.spop1)
	c:RegisterEffect(e7)
	--remove
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,3))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,m+1)
	e8:SetCost(cm.rmco)
	e8:SetTarget(cm.rmtg)
	e8:SetOperation(cm.rmop)
	c:RegisterEffect(e8)
	--selfspsummon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,4))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_REMOVE)
	e9:SetOperation(cm.spop2)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e10)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and c:IsLocation(LOCATION_EXTRA)
end

function cm.mfilter(c)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsLevelBelow(3)
end

function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end

function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end

function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end

function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function cm.cosfilter(c,tp)
	return c:GetOwner()==1-tp and 
	c:IsType(TYPE_MONSTER) 
	and c:IsReleasable()
	and (c:IsSummonType(SUMMON_TYPE_SPECIAL) or c:IsSummonType(SUMMON_TYPE_NORMAL)) 
end

function cm.spco1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cosfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cosfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
	end
end

function cm.chlimit(e,ep,tp)
	return tp==ep
end

function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
	Duel.SetChainLimit(cm.chlimit)
end

function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.rmco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() or c:IsAbleToRemoveAsCost() end
	if c:IsReleasable() and 
		(not c:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))==0) then
		Duel.Release(c,nil,REASON_COST)
	else
		Duel.Remove(c,POS_FACEUP,REASON_COST)
	end
end

function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end

function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE,0,1,Duel.GetTurnCount())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetLabelObject(c)
	e1:SetCondition(cm.spspcon)
	e1:SetOperation(cm.spspop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
end

function cm.spspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp and c:GetFlagEffectLabel(m)==e:GetLabel()
end

function cm.spspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,m)
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
