--疾驰之翼
function c95101252.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101252,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c95101252.damcost)
	e1:SetTarget(c95101252.damtg)
	e1:SetOperation(c95101252.damop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	c:RegisterEffect(e2)
end
function c95101252.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c95101252.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsControler(1-tp) and at:IsRelateToBattle() and at:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,at:GetAttack())
end
function c95101252.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() and tc:GetAttack()~=0 then
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
