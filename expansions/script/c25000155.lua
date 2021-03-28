local m=25000155
local cm=_G["c"..m]
cm.name="宇宙恐龙 海帕杰顿·幼体"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(cm.igcost)
	e5:SetTarget(cm.tg)
	e5:SetOperation(cm.op)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCost(cm.qcost)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(cm.lvupcon)
	e7:SetTarget(cm.lvuptg)
	e7:SetOperation(cm.lvupop)
	c:RegisterEffect(e7)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.spfilter_1(c,tp,tgc)
	if not (c:IsLevel(1) and c:IsReleasable()) then return false end
	return Duel.IsExistingMatchingCard(cm.spfilter_2,tp,LOCATION_MZONE,0,1,c,c,tp,tgc)
end
function cm.spfilter_2(c,tc,tp,tgc)
	if not (c:IsLevel(1) and c:IsCode(25000154) and c:IsReleasable()) then return false end
	local g=Group.CreateGroup()
	g:AddCard(c)
	g:AddCard(tc)
	return Duel.GetLocationCountFromEx(tp,tp,g,tgc)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.spfilter_1,c:GetControler(),LOCATION_MZONE,0,1,nil,e:GetHandlerPlayer(),c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter_1,tp,LOCATION_MZONE,0,1,1,nil,tp,e:GetHandler())
	g:Merge(Duel.SelectMatchingCard(tp,cm.spfilter_2,tp,LOCATION_MZONE,0,1,1,g:GetFirst(),g:GetFirst(),tp,e:GetHandler()))
	Duel.Release(g,REASON_COST)
end
function cm.adval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsLevel,c:GetControler(),LOCATION_GRAVE,0,nil,1)*1000
end
function cm.igcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.qcostfilter(c)
	return c:IsDiscardable() and c:IsLevel(1)
end
function cm.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.qcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.qcostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
	return not c:IsDisabled()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.lvupcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.lvupfilter(c,e,tp)
	return c:IsCode(25000156) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.lvuptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lvupfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.lvupop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.lvupfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end