--非对称均衡
--21.05.20
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.abs(Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD))
	return ct<=3
end
function cm.filter(c)
	return c:IsAbleToRemove(c:GetControler(),POS_FACEDOWN,REASON_RULE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then return (Duel.IsPlayerCanRemove(tp) or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0) and (Duel.IsPlayerCanRemove(1-tp) or Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0) and g:IsExists(cm.filter,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,0,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if not g:IsExists(cm.filter,1,c) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
	local sg=g:Select(1-tp,1,#g,nil)
	Duel.HintSelection(sg)
	g:Sub(sg)
	if aux.SelectFromOptions(tp,{sg:IsExists(cm.filter,1,c),aux.Stringid(m,0)},{g:IsExists(cm.filter,1,c),aux.Stringid(m,1)})==1 then
		Duel.Remove(sg:Filter(cm.filter,c),POS_FACEDOWN,REASON_RULE)
	else
		Duel.Remove(g:Filter(cm.filter,c),POS_FACEDOWN,REASON_RULE)
	end
end