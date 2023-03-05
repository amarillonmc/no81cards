--神裁煌印·高洁城堡
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.F(c,m)}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCost(fu_judg.Fcos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e2
function cm.tgf2(c)
	return c:GetType()==0x20002 and c:IsAbleToDeck()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsExistingTarget(cm.tgf2,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tgf2,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end