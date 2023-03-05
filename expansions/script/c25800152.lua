--弹药库殉爆
local m=25800152
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,c) end
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct1=g1:GetCount()
	local ct2=g2:GetCount()
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,ct1+((ct1>ct2) and ct2 or ct1),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	local ct1=Duel.Destroy(g1,REASON_EFFECT)
	if ct1==0 then return end
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct2=g2:GetCount()
	if ct2==0 then return end
	Duel.BreakEffect()
	if ct2<=ct1 then
		Duel.Destroy(g2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=g2:Select(tp,ct1,ct1,nil)
		Duel.HintSelection(g3)
		Duel.Destroy(g3,REASON_EFFECT)
	end
end

