--赤红之神
function c43990944.initial_effect(c)
	c:EnableReviveLimit()
	--leavl field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCondition(c43990944.lfcon)
	e0:SetOperation(c43990944.lfop)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990944,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,43990944)
	e1:SetCondition(c43990944.icon)
	e1:SetCost(c43990944.tgcost)
	e1:SetTarget(c43990944.tgtg)
	e1:SetOperation(c43990944.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c43990944.qcon)
	c:RegisterEffect(e2)
	--base attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c43990944.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e4)
	--[[--imm
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(43990944,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e5:SetCondition(c43990944.immcon)
	e5:SetOperation(c43990944.immop)
	c:RegisterEffect(e5)]]
	--imm
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c43990944.efilter)
	c:RegisterEffect(e5)
	--count
	if not c43990944.global_check then
		c43990944.global_check=true
		c43990944.leave_count=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c43990944.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_LEAVE_GRAVE)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_LEAVE_DECK)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(ge4,0)
	end
end
function c43990944.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetCode()==EVENT_LEAVE_DECK and LOCATION_EXTRA or LOCATION_HAND+LOCATION_REMOVED
	local sg=(e:GetCode()==EVENT_LEAVE_FIELD or e:GetCode()==EVENT_LEAVE_GRAVE) and eg or eg:Filter(Card.IsPreviousLocation,nil,loc)
	c43990944.leave_count=c43990944.leave_count+#sg
end
function c43990944.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and (not c:IsOnField() or not c:IsRelateToEffect(re))-- and re:IsActivated()
end
function c43990944.thfilter(c)
	return c:IsSetCard(0x3511) and c:IsAbleToHand()
end
function c43990944.lfop(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.SelectYesNo(tp,aux.Stringid(43990944,2)) then return end
	Duel.Hint(HINT_CARD,0,43990944)
	Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(rp,c43990944.thfilter,rp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c43990944.cfilter(c)
	return c:IsSetCard(0x3511) and c:IsFaceup()
end
function c43990944.icon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c43990944.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c43990944.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990944.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c43990944.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c43990944.tgfilter(c)
	return c:IsSetCard(0x3511) and c:IsAbleToGrave()
end
function c43990944.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990944.tgfilter,tp,LOCATION_DECK,0,1,nil) end--Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and 
	--Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990944.tgop(e,tp,eg,ep,ev,re,r,rp)
	--[[if not (Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c43990944.tgfilter,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(g1)]]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990944.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end
function c43990944.atkval(e,c)
	return c43990944.leave_count*50
end
function c43990944.immcon(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	return re:GetHandler():IsSetCard(0x3511) and code~=43990944
end
function c43990944.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c43990944.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e1)
end
function c43990944.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
