--欲念魅魔
function c10105555.initial_effect(c)
	--Atk update
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c10105555.condition)
	e2:SetOperation(c10105555.operation)
	c:RegisterEffect(e2)
end
function c10105555.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_LINK)
end
function c10105555.filter(c)
	return c:IsAttackPos() and c:IsControlerCanBeChanged()
end
function c10105555.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=Duel.SelectMatchingCard(tp,c10105555.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.GetControl(sg:GetFirst(),tp)
	end
end