--罗德岛·行动-战后清扫
function c79029104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029104)
	e1:SetTarget(c79029104.target)
	e1:SetOperation(c79029104.operation)
	c:RegisterEffect(e1)  
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029104)
	e2:SetCondition(c79029104.tgcon)	
	e2:SetTarget(c79029104.tgtg)
	e2:SetOperation(c79029104.tgop)
	c:RegisterEffect(e2)
end
function c79029104.ckfil(c)
	return c:IsAbleToDeck() and (c:IsSetCard(0xa900) or c:IsSetCard(0xc90e) or c:IsSetCard(0xb90d))
end
function c79029104.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029104.ckfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,0,0)
end
function c79029104.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local x=Duel.SelectMatchingCard(tp,c79029104.ckfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	local g=Duel.SendtoDeck(x,nil,0,REASON_EFFECT)
	Duel.Recover(tp,g*500,REASON_EFFECT)
end
function c79029104.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return t>s
end
function c79029104.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,t-s) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(t-s)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,t-s)
end
function c79029104.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local t=Duel.GetFieldGroupCount(p,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)
	if t>s then
		Duel.DiscardDeck(p,t-s,REASON_EFFECT)
	end
end