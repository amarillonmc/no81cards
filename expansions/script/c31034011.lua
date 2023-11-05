--Accelerate!
function c31034011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, 31034011+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c31034011.cost)
	e1:SetTarget(c31034011.target)
	e1:SetOperation(c31034011.activate)
	c:RegisterEffect(e1)
end

function c31034011.costfilter(c)
	return c:IsSetCard(0x892) and c:IsType(TYPE_MONSTER) and  c:IsAbleToGraveAsCost()
end

function c31034011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31034011.costfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp, c31034011.costfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(g, REASON_COST)
	e:SetLabelObject(tc)
end

function c31034011.tgfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsFaceup()
end

function c31034011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_SYNCHRO)
		and chkc:IsAttribute(ATTRIBUTE_WIND) and chkc:IsFaceup() end
	if chk == 0 then return Duel.IsExistingTarget(c31034011.tgfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, c31034011.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

function c31034011.rapidcon(e,tp,eg,ep,ev,re,r,rp)
	return ep == 1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function c31034011.rapidtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk == 0 then return c:IsDefenseAbove(600) end
end

function c31034011.rapidop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:GetDefense() < 600
		or Duel.GetCurrentChain() ~= ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-600)
	c:RegisterEffect(e1)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		local ct=Duel.GetCurrentChain()
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep == 1-tp then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(c31034003.efilter)
			e2:SetLabelObject(te)
			e2:SetReset(RESET_EVENT+RESET_CHAIN)
			c:RegisterEffect(e2, true)
		end
	end
end

function c31034011.efilter(e,re)
	return re == e:GetLabelObject()
end

function c31034011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tg:IsRelateToEffect(e)) then return end
	if tc:IsCode(31034003) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(31034003, 0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
		e2:SetCondition(c31034011.rapidcon)
		e2:SetTarget(c31034011.rapidtg)
		e2:SetOperation(c31034011.rapidop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e2)
	elseif tc:IsCode(31034005) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(31034005, 0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetValue(aux.ChangeBattleDamage(1, DOUBLE_DAMAGE))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e2)
	elseif tc:IsCode(31034007) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(31034007, 0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e2)
	end
end
	