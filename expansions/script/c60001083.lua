local m=60001083
local cm=_G["c"..m]
cm.name="闪刀术式-剑舞"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rmfilter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL)
end
function cm.stfilter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_REMOVED,0,1,nil) end
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_TOGRAVE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local ag=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if Duel.SSet(tp,ag)==1 and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_REMOVED,0,1,3,nil)
		if g:GetCount()~=0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		end
	end
end