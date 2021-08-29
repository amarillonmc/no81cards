--方舟骑士·炎魔 伊芙利特
function c82567804.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x825),3,2)
	c:EnableReviveLimit()
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567804,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82567804.condition)
	e2:SetCost(c82567804.cost)
	e2:SetOperation(c82567804.operation)
	c:RegisterEffect(e2)
	--self Damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetCountLimit(1)
	e4:SetTarget(c82567804.dmtg)
	e4:SetCondition(c82567804.damcondition)
	e4:SetOperation(c82567804.damoperation)
	c:RegisterEffect(e4)
end
function c82567804.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_ATTACK_ALL)
end
function c82567804.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567804.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c82567804.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c82567804.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567804.damfilter(c,e)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567804.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c82567804.damfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_CARD,0,82567804)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
function c82567804.RLfilter(c,e)
	return c:IsSetCard(0x3825) and c:IsFaceup()
end
function c82567804.damcondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetBattledGroupCount()>0 or c:GetAttackAnnouncedCount()>0) and not Duel.IsExistingMatchingCard(c82567804.RLfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c82567804.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetHandler():GetAttack())
end
function c82567804.damoperation(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local val=c:GetAttack()
	Duel.Damage(tp,val,REASON_EFFECT)
end