--“卡兹戴尔在哪里？”
--2021.06.07
local m=11451574
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_SSET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsAbleToRemove(c:GetControler(),POS_FACEUP,REASON_RULE) and c:GetType()&0x80002==0x80002 and Duel.IsPlayerCanRemove(c:GetControler()) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_FZONE,0)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0) or (Duel.IsPlayerCanRemove(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_FZONE)>0) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,nil)
	if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_RULE) end
end