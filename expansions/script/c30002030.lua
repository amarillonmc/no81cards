--PSY骨架扫描
function c30002030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30002030,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c30002030.target)
	e1:SetOperation(c30002030.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30002030,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c30002030.cost)
	e2:SetTarget(c30002030.target2)
	e2:SetOperation(c30002030.activate2)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c30002030.handcon)
	c:RegisterEffect(e3)
end
function c30002030.filter(c)
	return c:IsSetCard(0xc1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c30002030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30002030.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30002030.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30002030.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c30002030.filter2(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0xc1) and c:IsAbleToGraveAsCost()
end
function c30002030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c30002030.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) end
	local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(c30002030.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	local ct=math.min(ft,g:GetCount())
	local sg=g:Select(tp,1,ct,nil)
	e:SetLabel(sg:GetCount())
	Duel.SendtoGrave(sg,REASON_COST)
end
function c30002030.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c30002030.activate2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c30002030.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc1)
end
function c30002030.handcon(e)
	return Duel.IsExistingMatchingCard(c30002030.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
