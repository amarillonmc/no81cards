--旗鼓相当
function c22023520.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c22023520.atkcon)
	e1:SetOperation(c22023520.atkop)
	c:RegisterEffect(e1)
end
function c22023520.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not ac:IsControler(tp) then ac,tc=tc,ac end
	return ac and ac:IsControler(tp) and ac:IsFaceup() and tc and tc:IsControler(1-tp) and tc:IsFaceup() and (ac:IsCanChangePosition() or tc:IsCanChangePosition())
end
function c22023520.atkfilter(c)
	return c:IsFaceup() and c:IsRelateToBattle()
end
function c22023520.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	local g=Group.FromCards(ac,tc):Filter(c22023520.atkfilter,nil)
	local gc=g:GetFirst()
	while gc do
		Duel.ChangePosition(gc,POS_FACEUP_DEFENSE)
		gc=g:GetNext()
	end
end