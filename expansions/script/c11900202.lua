--密林异种
local s,id,o=GetID()
function s.initial_effect(c)
    --kill
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.klcon)
	e1:SetOperation(s.klop)
	c:RegisterEffect(e1)
end
function s.klcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
function s.klop(e,tp,eg,ep,ev,re,r,rp)
	local k=Duel.GetLP(1-tp)
    Duel.Damage(1-tp,k,REASON_EFFECT)
end