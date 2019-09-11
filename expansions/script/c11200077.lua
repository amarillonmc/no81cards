--团子
function c11200077.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200077+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200077.tg1)
	e1:SetOperation(c11200077.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11200077.con2)
	e2:SetCost(c11200077.cost2)
	e2:SetTarget(c11200077.tg2)
	e2:SetOperation(c11200077.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
--
end
--
function c11200077.tfilter1(c)
	return c:IsCode(11200077) and c:IsAbleToHand()
end
function c11200077.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200077.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
--
function c11200077.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Recover(tp,1100,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c11200077.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c11200077.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
--
function c11200077.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	local g=Group.CreateGroup()
	g:AddCard(c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
--
function c11200077.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1100)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1100)
end
--
function c11200077.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--
