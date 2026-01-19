--渴望之梦 普路梅西亚
function c75075634.initial_effect(c)
	-- 翻面
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075634,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,75075634)
	e1:SetCondition(c75075634.con1)
	e1:SetTarget(c75075634.tg1)
	e1:SetOperation(c75075634.op1)
	c:RegisterEffect(e1)
	-- 赋予效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075634,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75075634+100)
	e2:SetTarget(c75075634.tg2)
	e2:SetOperation(c75075634.op2)
	c:RegisterEffect(e2)
end
-- 1
function c75075634.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0
end
function c75075634.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c75075634.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c75075634.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75075634.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c75075634.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c75075634.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
-- 2
function c75075634.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c75075634.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75075634.rmfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c75075634.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c75075634.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c75075634.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(75075634,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,c:GetFieldID())
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_CHAIN_END)
			e0:SetReset(RESET_PHASE+PHASE_END)
			e0:SetLabelObject(tc)
			e0:SetCountLimit(1)
			e0:SetOperation(c75075634.retop)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c75075634.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local cid=tc:GetFlagEffectLabel(75075634)
	local c=Duel.GetMatchingGroup(function(c) return c:GetFieldID()==cid end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetFirst()
	if tc and Duel.ReturnToField(tc) then
		local otp=tc:GetControler()
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(75075634,3))
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(75075634)
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetLabel(otp)
		e2:SetCondition(c75075634.damcon)
		e2:SetOperation(c75075634.damop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
-- 获得的效果
function c75075634.damcon(e,tp,eg,ep,ev,re,r,rp)
	local otp=e:GetLabel()
	return ep==otp and ev>0
end
function c75075634.damop(e,tp,eg,ep,ev,re,r,rp)
	local otp=e:GetLabel()
	Duel.Damage(1-otp,ev,REASON_EFFECT)
end
