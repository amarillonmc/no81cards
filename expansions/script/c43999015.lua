--终 级 的 地 狱 恶 魔 大 审 判 官
local m=43999015
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--cannot
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c43999015.imcost)
	e2:SetOperation(c43999015.imop)
	c:RegisterEffect(e2)
	--张 卡 破 坏
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(c43999015.remtg)
	e3:SetOperation(c43999015.remop)
	c:RegisterEffect(e3)
	--lp Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(cm.lpcon)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)


	c43999015.onfield_effect=e3
	c43999015.SetCard_diyuemo=true
	
end
function c43999015.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,14000041)==0 and e:GetHandler():IsFaceup()
end
function c43999015.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,14000041,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*600,REASON_EFFECT)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c43999015.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c43999015.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	Duel.ShuffleExtra(1-tp)
end



function c43999015.cfilter(c)
	return c.SetCard_diyuemo and c:IsAbleToRemoveAsCost()
end
function c43999015.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c43999015.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43999015.cfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c43999015.imop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c43999015.imlimit)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c43999015.imlimit(e,c)
	return c:IsFaceup() and c.SetCard_diyuemo
end

