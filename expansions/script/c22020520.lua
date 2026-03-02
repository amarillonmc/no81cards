--人理之诗 射杀百头
function c22020520.initial_effect(c)
	c:EnableCounterPermit(0xfed)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22020520.target)
	e1:SetOperation(c22020520.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c22020520.eqlimit)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020520,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22020520)
	e3:SetCost(c22020520.cost12)
	e3:SetTarget(c22020520.damtg)
	e3:SetOperation(c22020520.damop)
	c:RegisterEffect(e3)
	--aeg
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c22020520.aegcon)
	e4:SetOperation(c22020520.aegop)
	c:RegisterEffect(e4)
end
function c22020520.eqlimit(e,c)
	return c:IsFaceup() and (Duel.IsCanAddCounter(tp,0xfed,1,c) or c.effect_canequip_hogu)
end
function c22020520.filter(c)
	return c:IsFaceup() and (Duel.IsCanAddCounter(tp,0xfed,1,c) or c.effect_canequip_hogu)
end
function c22020520.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22020520.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020520.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22020520.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22020520.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLevel()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:AddCounter(0xfed,ct)
	end
end
function c22020520.cost12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfed,12,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfed,12,REASON_COST)
end
function c22020520.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Damage(1-tp,10,REASON_EFFECT)
	Duel.Damage(1-tp,20,REASON_EFFECT)
	Duel.Damage(1-tp,30,REASON_EFFECT)
	Duel.Damage(1-tp,40,REASON_EFFECT)
	Duel.Damage(1-tp,50,REASON_EFFECT)
	Duel.Damage(1-tp,60,REASON_EFFECT)
	Duel.Damage(1-tp,70,REASON_EFFECT)
	Duel.Damage(1-tp,80,REASON_EFFECT)
	Duel.Damage(1-tp,90,REASON_EFFECT)
	Duel.Damage(1-tp,100,REASON_EFFECT)
	Duel.Damage(1-tp,110,REASON_EFFECT)
	Duel.Damage(1-tp,1200,REASON_EFFECT)
end
function c22020520.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c22020520.aegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.GetFlagEffect(tp,22020520)==0 and c:IsFaceup() and c:IsCanAddCounter(0xfed,12) 
end
function c22020520.aegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22020520,1)) then
		Duel.Hint(HINT_CARD,0,22020520)
		c:AddCounter(0xfed,12)
		Duel.RegisterFlagEffect(tp,22020520,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22020520,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end