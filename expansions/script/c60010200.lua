--永夜抄·永夜归返-世间开明-
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_TOHAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att) and c:IsSetCard(0x3620)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,ATTRIBUTE_DARK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=2
		or Duel.IsPlayerCanDraw(tp,2) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=1 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,2) then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==2 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==3 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(1-tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	elseif opval[op]==4 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
