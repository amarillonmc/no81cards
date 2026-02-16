local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--destroy & damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.indcon)
	e2:SetOperation(s.indop)
	c:RegisterEffect(e2)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_FIRE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	if tc:IsLocation(LOCATION_MZONE) then
		local atk=0
		if tc:IsFaceup() then atk=tc:GetAttack() end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk//2)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local atk=0
	if tc:IsFaceup() then atk=tc:GetAttack() end
	if Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsPreviousLocation(LOCATION_MZONE) and atk>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk//2,REASON_EFFECT)
	end
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and ep~=tp
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end