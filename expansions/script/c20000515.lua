--来自黑暗的魔导具
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if Duel.NegateAttack() then
		Duel.BreakEffect()
		if Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,c):FilterCount(Card.IsSetCard,nil,0x3fd5)>1 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
		if Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) 
			and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local g = Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
			local sg = Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
			g:Merge(sg)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end