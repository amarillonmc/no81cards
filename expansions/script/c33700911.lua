--最终的勇气
function c33700911.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp) return Duel.GetTurnCount(tp)>=5 end)
	e1:SetOperation(c33700911.activate)
	c:RegisterEffect(e1)   
	if c33700911.counter==nil then
		c33700911.counter=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetOperation(c33700911.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c33700911.addcount(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,33700911,0,0,0)
	Duel.RegisterFlagEffect(1-ep,33700911,0,0,0)
end
function c33700911.activate(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetOperation(c33700911.dop)
	Duel.RegisterEffect(e2,tp)
end
function c33700911.dop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and Duel.GetFlagEffect(tp,33700911)>=10 then
		Duel.ChangeBattleDamage(ep,10000)
		e:Reset()
	end
end