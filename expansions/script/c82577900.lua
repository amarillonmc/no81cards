--深渊混沌咬
function c82577900.initial_effect(c)
	--ATK 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetDescription(aux.Stringid(82577900,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,82577900)
	e4:SetCondition(c82577900.atkcon)
	e4:SetTarget(c82577900.atktg)
	e4:SetOperation(c82577900.atkop)
	c:RegisterEffect(e4)
	--shark drake
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82577900,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,82577901)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c82577900.eqtg)
	e2:SetOperation(c82577900.eqop)
	c:RegisterEffect(e2)
end
function c82577900.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c82577900.atkcon(e,tp,eg,ep,ev,re,r,rp)
	 return 
	   Duel.IsExistingMatchingCard(c82577900.xyzfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c82577900.filter(c,e,tp)
	return c:IsFaceup()
end
function c82577900.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82577900.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c82577900.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c82577900.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
				  local e2=Effect.CreateEffect(c)
				  e2:SetType(EFFECT_TYPE_SINGLE)
				  e2:SetCode(EFFECT_SET_ATTACK_FINAL)
				  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  e2:SetValue(0)
				  tc:RegisterEffect(e2) 
				  local e3=Effect.CreateEffect(c)
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  tc:RegisterEffect(e3)
				  local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
  end
end
function c82577900.vicefilter(c)
	return c:IsCode(49221191) and c:IsFaceup()
end
function c82577900.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82577900.filter(chkc) end
	if chk==0 then return 
	Duel.IsExistingTarget(c82577900.vicefilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c82577900.vicefilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c82577900.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
				  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
				  local e2=Effect.CreateEffect(c)
				  e2:SetType(EFFECT_TYPE_SINGLE)
				  e2:SetCode(EFFECT_UPDATE_ATTACK)
				  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  e2:SetValue(1000)
				  tc:RegisterEffect(e2) 
	Duel.SetLP(tp,1000)
	end
end