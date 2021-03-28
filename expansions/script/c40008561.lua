--刻兽使·伊米
function c40008561.initial_effect(c)
	c:SetUniqueOnField(1,0,40008561)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(40008561,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c40008561.cost1)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008561,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c40008561.cost)
	e1:SetTarget(c40008561.target1)
	e1:SetOperation(c40008561.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008561,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c40008561.cost)
	e2:SetTarget(c40008561.target)
	e2:SetOperation(c40008561.activate)
	c:RegisterEffect(e2) 
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008561,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c40008561.tdtg)
	e3:SetOperation(c40008561.tdop)
	c:RegisterEffect(e3)	   
end
function c40008545.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c40008561.cfilter(c)
	return c:IsSetCard(0xf17) and c:IsAbleToGraveAsCost()
end
function c40008561.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008561.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	Duel.DiscardHand(tp,c40008561.cfilter,1,1,REASON_COST,nil)
end
function c40008561.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c40008561.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c40008561.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c40008561.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17) and c:IsAbleToHand() and not c:IsCode(40008561)
end
function c40008561.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c40008561.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingTarget(c40008561.thfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c40008561.thfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c40008561.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
