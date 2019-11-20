--D.A.L-夜刀神十香-ALTER
function c33400320.initial_effect(c)
	 c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,33400320)
	e1:SetCondition(c33400320.atkcon)
	e1:SetCost(c33400320.atkcost1)
	e1:SetTarget(c33400320.atktg)
	e1:SetOperation(c33400320.atkop1)
	c:RegisterEffect(e1)
	  --Equip Okatana
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c33400320.Eqop1)
	c:RegisterEffect(e4)
	 --
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(aux.bdcon)
	e5:SetOperation(c33400320.desop)
	c:RegisterEffect(e5)
end
function c33400320.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c33400320.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33400320.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function c33400320.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33400320.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400320.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33400320.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33400320.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c33400320.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		c33400320.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c33400320.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,33400321)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c33400320.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_SZONE)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(c33400320.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)
			--atkup
			local e3=Effect.CreateEffect(ec)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCategory(CATEGORY_ATKCHANGE)
			e3:SetRange(LOCATION_SZONE)
			e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			e3:SetCountLimit(1)
			e3:SetOperation(c33400320.atkop)
			token:RegisterEffect(e3)
		   
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function c33400320.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c33400320.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33400320.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end
function c33400320.thfilter1(c)
	return  c:IsAbleToHand() and c:IsSetCard(0x5341)
end
function c33400320.desop(e,tp,eg,ep,ev,re,r,rp)
   
	 if  Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0 then return end
	 local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	 local g2=Duel.GetMatchingGroup(c33400320.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local tc=g1:Select(tp,1,1,nil)
		 Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	 if Duel.SelectYesNo(tp,aux.Stringid(33400320,0)) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		 local tc2=g2:Select(tp,1,1,nil)
		 Duel.SendtoHand(tc2,tp,REASON_EFFECT)
	 end
end