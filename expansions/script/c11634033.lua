--假面英雄带货
local m=11634033
local cm=_G["c"..m]
function cm.initial_effect(c)
	--DRAW
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11634033,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCondition(cm.opcon)
	e1:SetTarget(cm.optg)
	e1:SetOperation(cm.opop)
	c:RegisterEffect(e1)  
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa008) and c:IsType(TYPE_FUSION)
end
function cm.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.opop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end