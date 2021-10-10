--魔戒仪士黑暗救世主-牙狼
function c82599990.initial_effect(c)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82599990,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82599990)
	e1:SetCondition(c82599990.discon)
	e1:SetCost(c82599990.cost)
	e1:SetTarget(c82599990.distg)
	e1:SetOperation(c82599990.disop)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82599990,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82599890)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c82599990.distg2)
	e2:SetOperation(c82599990.disop2)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c82599990.retreg)
	c:RegisterEffect(e3)
end
function c82599990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c82599990.grfilter(c,e,tp)
	return c:IsSetCard(0x821) and c:IsFaceup()
end
function c82599990.discon(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and Duel.GetTurnPlayer()~=e:GetHandler():GetControler() and 
		   Duel.GetMatchingGroupCount((c82599990.grfilter),tp,LOCATION_MZONE,0,nil)>0
end
function c82599990.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	
end
function c82599990.disop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateActivation(ev) 
end
function c82599990.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(c82599990.chlimit)
end
function c82599990.disop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c82599990.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c82599990.retcon)
	e1:SetTarget(c82599990.rettg)
	e1:SetOperation(c82599990.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c82599990.retcon2)
	c:RegisterEffect(e2)
end
function c82599990.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function c82599990.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) 
end
function c82599990.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,82599980,0,0x4011,2500,2000,8,RACE_WARRIOR,ATTRIBUTE_LIGHT)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(c82599990.chlimit)
end
function c82599990.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82599980,0,0x4011,2500,2000,8,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,82599980)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(c82599990.valcon)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(TYPE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e2)
	end
end
function c82599990.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 
end
function c82599990.chlimit(e,ep,tp)
	return tp==ep
end