--符能禁锢
function c10113070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c10113070.condition)
	e1:SetTarget(c10113070.target)
	e1:SetOperation(c10113070.activate)
	c:RegisterEffect(e1)	
end
function c10113070.cfilter(c)
	return c:GetEquipCount()>0 and c:GetEquipGroup():FilterCount(Card.IsType,nil,TYPE_SPELL)>0
end
function c10113070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10113070.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10113070.filter(c)
	return c:IsFaceup() and not c:IsForbidden()
end
function c10113070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10113070.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113070.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10113070.filter,tp,0,LOCATION_MZONE,1,1,nil)

end
function c10113070.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsForbidden() then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_FORBIDDEN)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
	   tc:RegisterEffect(e1)
	end
end
