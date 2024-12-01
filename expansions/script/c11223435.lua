local m=11223435
local cm=_G["c"..m]
cm.name="夜斗神 - 古心恒"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link
	aux.AddLinkProcedure(c,cm.lfilter,2,2)
	--Destroy Replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(cm.reptg)
	e1:SetOperation(cm.repop)
	e1:SetValue(cm.repval)
	c:RegisterEffect(e1)
	--Disable Attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.dacost)
	e2:SetCondition(cm.dacon)
	e2:SetTarget(cm.datg)
	e2:SetOperation(cm.daop)
	c:RegisterEffect(e2)
end
--Link
function cm.lfilter(c)
	return c:IsLinkRace(RACE_WARRIOR) and c:IsLinkAttribute(ATTRIBUTE_DARK)
end
--Destroy Replace
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.rmfilter(c)
	return c:GetAttack()==500 and c:IsAbleToRemoveAsCost()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	return false
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
--Disable Attack
function cm.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(c)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
	end
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()~=e:GetHandler()
end
function cm.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetAttacker()
	if chkc then return chkc==tc end
	if chk==0 then return tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetAttack())
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(m)~=0 then
		Duel.ReturnToField(c)
	end
end