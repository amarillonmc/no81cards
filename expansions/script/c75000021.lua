--神速迴避
local m=75000021
local cm=_G["c"..m]
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(3,75000021)
	e1:SetTarget(c75000021.target)
	e1:SetOperation(c75000021.activate)
	c:RegisterEffect(e1)
	
end
function c75000021.tgfilter(c,e,tp)
	return c:IsFaceup() and ((c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x75a1,1) and c:IsRace(RACE_DRAGON)) or not c:IsRace(RACE_DRAGON))
end
function c75000021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and  c75000021.tgfilter(chkc,e,tp)  end
	if chk==0 then return Duel.IsExistingTarget(c75000021.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c75000021.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if g:GetFirst():IsRace(RACE_DRAGON) then
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x75a1)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c75000021.chainlm)
	end
end
function c75000021.chainlm(re,rp,tp)
	return re:GetHandler():IsSetCard(0x75a)
end
function c75000021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetTarget(c75000021.rmlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e2)
		if tc:IsRace(RACE_DRAGON) and tc:IsCanAddCounter(0x75a1,1) then
			tc:AddCounter(0x75a1,1)
			local e3=Effect.CreateEffect(c)
			e3:SetCategory(CATEGORY_NEGATE)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_CHAINING)
			e3:SetRange(LOCATION_MZONE)
			e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e3:SetCondition(c75000021.discon)
			e3:SetCost(c75000021.discost)
			e3:SetOperation(c75000021.disop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function c75000021.rmlimit(e,c,tp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
function c75000021.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c75000021.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x75a1,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x75a1,1,REASON_COST)
end
function c75000021.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

