--彰显王威吧，踏遍世间的十二辉剑
function c22023660.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023340+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c22023660.condition)
	e1:SetTarget(c22023660.target)
	e1:SetOperation(c22023660.activate)
	c:RegisterEffect(e1)
end
function c22023660.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023340)>2
end
function c22023660.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
	end
end
function c22023660.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) and not Duel.GetFlagEffect(tp,22023340)>2 then return end
	Duel.SelectOption(tp,aux.Stringid(22023660,0))
	Duel.SelectOption(tp,aux.Stringid(22023660,1))
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.SelectOption(tp,aux.Stringid(22023660,2))
	Duel.Damage(1-tp,1500,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c22023660.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function c22023660.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsCode(22023340)
end