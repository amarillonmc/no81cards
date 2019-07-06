--琪比摩斯
function c33700023.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),2,2,c33700023.ovfilter,aux.Stringid(33700023,0))
	c:EnableReviveLimit()
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700023,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCost(c33700023.cost)
	e1:SetTarget(c33700023.attg)
	e1:SetOperation(c33700023.atop)
	c:RegisterEffect(e1)
end
function c33700023.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER)
end
function c33700023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33700023.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsChainAttackable(0) end
end
function c33700023.atop(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
	Duel.ChainAttack()
end