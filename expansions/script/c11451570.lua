--非对称均衡
--21.05.20
local m=11451570
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function cm.filter(c)
	return c:IsAbleToRemove(c:GetControler(),POS_FACEDOWN,REASON_RULE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then return (Duel.IsPlayerCanRemove(tp) or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0) and (Duel.IsPlayerCanRemove(1-tp) or Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0) and g:IsExists(cm.filter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,0,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
	local sg=g:Select(1-tp,1,#g,nil)
	Duel.HintSelection(sg)
	g:Sub(sg)
	if Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0 then
		Duel.Remove(sg:Filter(cm.filter,nil),POS_FACEDOWN,REASON_RULE)
	else
		Duel.Remove(g:Filter(cm.filter,nil),POS_FACEDOWN,REASON_RULE)
	end
end