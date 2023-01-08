--神造遗物 事实诱导
function c72409065.initial_effect(c)
	aux.AddCodeList(c,72409000)
	aux.AddCodeList(c,72409015)
	c:SetUniqueOnField(1,0,72409065)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c72409065.target)
	e1:SetOperation(c72409065.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72409065,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCountLimit(1)
	e2:SetCondition(c72409065.igcon)
	e2:SetTarget(c72409065.indtg)
	e2:SetOperation(c72409065.indop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c72409065.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72409065,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCountLimit(1)
	e4:SetCondition(c72409065.qccon)
	e4:SetTarget(c72409065.indtg)
	e4:SetOperation(c72409065.indop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c72409065.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c72409065.eqlimit)
	c:RegisterEffect(e6)
end
function c72409065.eqlimit(e,c)
	return c:IsSetCard(0xe729)
end
function c72409065.filter(c)
	return c:IsFaceup()  and c:IsSetCard(0xe729)
end
function c72409065.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c72409065.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72409065.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c72409065.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c72409065.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)  
	end
end
function c72409065.igcon(e)
	return not (e:GetHandler():IsCode(72409000,72409015) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155))
end
function c72409065.qccon(e)
   return aux.dscon() and (e:GetHandler():IsCode(72409000,72409015) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155))
end
function c72409065.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c72409065.chfilter(c)
	return c:IsControlerCanBeChanged()
end
function c72409065.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetOwner()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetOwner())
end
function c72409065.indop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetOwner():GetAttack()
	local def=e:GetOwner():GetDefense()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		tc:RegisterEffect(e2)
	end
end
