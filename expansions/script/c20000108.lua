--正义的神裁
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	aux.AddCodeList(c,20000100)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.glof)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)>0
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,20000100)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and #g>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(#g)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,20000100)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,#g,REASON_EFFECT)
end
function cm.glof(c)
	return not c:IsCode(20000100)
end