--快乐八重彩
function c33710909.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33710909.condition)
	e1:SetOperation(c33710909.activate)
	c:RegisterEffect(e1) 
end
function c33710909.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)/Duel.GetLP(1-tp)>=8
end
function c33710909.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0)
end