--Irregular Existence
function c33700210.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Neither player take battle damage if no monsters are destroyed by that battle (excludes Direct Attacks).
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c33700210.actcon)
	e2:SetOperation(c33700210.ndop)
	c:RegisterEffect(e2)
end
function c33700210.actcon(e)
	return Duel.GetAttackTarget()~=nil
end
function c33700210.ndop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(ev)
	Duel.ChangeBattleDamage(ep,0)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetLabel(ep)
	e3:SetLabelObject(e)
	e3:SetOperation(c33700210.damage)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e3)
end
function c33700210.damage(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(e:GetLabel(),e:GetLabelObject():GetLabel(),REASON_BATTLE)
end
