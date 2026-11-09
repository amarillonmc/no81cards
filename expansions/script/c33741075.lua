--Delayed Pain
function c33741075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33741075.activate)
	c:RegisterEffect(e1)
end
function c33741075.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(33741075,0),aux.Stringid(33741075,1),aux.Stringid(33741075,2))
	local ct,dam=2^op,800/(2^op)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c33741075.damop)
	e1:SetLabel(dam)
	e1:SetReset(RESET_PHASE+PHASE_END,ct)
	Duel.RegisterEffect(e1,tp)
end
function c33741075.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33741075)
	Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
end
