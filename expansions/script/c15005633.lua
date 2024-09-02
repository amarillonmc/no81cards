local m=15005633
local cm=_G["c"..m]
cm.name="枯绿机关-艾肯滚石"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.rmfilter(c)
	return c:IsSetCard(0x5f42) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemove()
end
function cm.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return 
		Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(cm.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,cm.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,tp,LOCATION_ONFIELD)
	Duel.SetChainLimit(cm.limit(g2:GetFirst()))
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if tg1:GetFirst():IsRelateToEffect(e) then
		Duel.Remove(tg1,POS_FACEUP,REASON_EFFECT)
	end
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoDeck(tg2,nil,2,REASON_EFFECT)
	end
end