--企鹅物流·重装干员-可颂
function c79029053.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,
	0x1902),aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)   
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77967790,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c79029053.atkcon)
	e2:SetTarget(c79029053.atktg)
	e2:SetOperation(c79029053.atkop)
	c:RegisterEffect(e2)
end
function c79029053.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c79029053.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
end
function c79029053.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		Duel.RegisterFlagEffect(tp,79029053,RESET_PHASE+PHASE_BATTLE,0,1)
		tc:RegisterFlagEffect(79029053,RESET_PHASE+PHASE_BATTLE+RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c79029053.atkcon2)
		e1:SetTarget(c79029053.atktg2)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetOperation(c79029053.atkop2)
		e3:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(79029053,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetCondition(c79029053.descon)
		e2:SetOperation(c79029053.desop)
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c79029053.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(79029053)==0
end
function c79029053.atktg2(e,c)
	local tc=e:GetLabelObject()
	return c~=tc or c:GetFlagEffectLabel(79029053)~=e:GetLabel()
end
function c79029053.atkop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(79029053,RESET_PHASE+PHASE_BATTLE,0,1)
end
function c79029053.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(79029053)==e:GetLabel() and tc:GetAttackAnnouncedCount()==0
end
function c79029053.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,79029053)
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
