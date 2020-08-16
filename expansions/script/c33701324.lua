--虚拟YouTuber 宇志海莓
function c33701324.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()	
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c33701324.damcon)
	e2:SetOperation(c33701324.damop)
	c:RegisterEffect(e2)	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c33701324.intg)
	e3:SetCondition(c33701324.incon)
	e3:SetValue(c33701324.inefil)
	c:RegisterEffect(e3)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33701324.incon1)
	e3:SetValue(c33701324.val)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33701324.incon1)
	e4:SetValue(c33701324.inefil)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
end
function c33701324.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c33701324.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c33701324.intg(e,c)
	return c~=e:GetHandler()
end
function c33701324.incon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1 
end
function c33701324.inefil(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c33701324.incon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==1
end
function c33701324.val(e,c)
	return c:GetDefense()
end




