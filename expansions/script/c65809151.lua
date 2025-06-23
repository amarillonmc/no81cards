--资源获取点·发电厂
local s,id,o=GetID()
function s.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.drtg)
	e1:SetCost(s.drcost)
	e1:SetCountLimit(1)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(1-tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local ag1=g:Select(tp,1,1,nil)
		Duel.SendtoHand(ag1,tp,REASON_EFFECT)
	end
end
function s.filter(c)
	return c:IsSetCard(0xca30,0xaa30) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) 
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end