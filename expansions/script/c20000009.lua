--极密合约 埋伏
function c20000009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local phase=Duel.GetCurrentPhase()
		if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsCode(20000000) and a:IsRelateToBattle())
			or (d:GetControler()==tp and d:IsCode(20000000) and d:IsRelateToBattle()))
	end)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetFlagEffect(20000002)==0 end
			c:RegisterFlagEffect(20000002,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
		if a:GetControler()==tp then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(a:GetAttack()*2)
			a:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			e2:SetValue(1)
			d:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CHANGE_DAMAGE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(0,1)
			e3:SetValue(function(e,re,dam,r,rp,rc)
				return math.floor(dam/2)
			end)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e3,tp)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(a:GetAttack()*2)
			d:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			e2:SetValue(1)
			a:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CHANGE_DAMAGE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(0,1)
			e3:SetValue(function(e,re,dam,r,rp,rc)
				return math.floor(dam/2)
			end)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e3,tp)
		end
	end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,20000009)
	e3:SetCondition(c20000009.con3)
	e3:SetCost(c20000009.co3)
	e3:SetTarget(c20000009.tg3)
	e3:SetOperation(c20000009.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetCondition(c20000009.con4)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c20000009.tg4)
	e4:SetOperation(c20000009.op4)
	c:RegisterEffect(e4)
end
--e3
function c20000009.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20000009.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20000009)==0 end
	Duel.RegisterFlagEffect(tp,20000009,RESET_CHAIN,0,1)
end
function c20000009.tgf3(c)
	return c:IsCode(20000000) and c:IsFaceup() and c:GetFlagEffect(20000009)==0
end
function c20000009.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c20000009.tgf3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20000009.tgf3,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c20000009.tgf3,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c20000009.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(20000009,2))
		e1:SetCategory(CATEGORY_TODECK)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(c20000009.optg3)
		e1:SetOperation(c20000009.opop3)
		tc:RegisterEffect(e1,true)
	end
	tc:RegisterFlagEffect(20000009,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(20000009,1))
end
function c20000009.optgf3(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck()
end
function c20000009.optg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c20000009.optgf3(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c20000009.optgf3,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20000009.optgf3,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_GRAVE)
end
function c20000009.opop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
--e4
function c20000009.conf4(c,tp)
	return c:IsCode(20000000) and c:IsFaceup()
end
function c20000009.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20000009.conf4,tp,LOCATION_MZONE,0,1,nil)
end
function c20000009.tgf4(c,e,tp)
	return c:IsAbleToRemove()
end
function c20000009.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c20000009.tgf4(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c20000009.tgf4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c20000009.tgf4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c20000009.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(20000003,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c20000009.retcon)
		e1:SetOperation(c20000009.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20000009.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(20000003)~=0
end
function c20000009.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
