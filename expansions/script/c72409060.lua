--神造遗物 存在抹灭
function c72409060.initial_effect(c)
	aux.AddCodeList(c,72409000)
	aux.AddCodeList(c,72409010)
	c:SetUniqueOnField(1,0,72409060)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c72409060.target)
	e1:SetOperation(c72409060.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72409060,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCountLimit(1)
	e2:SetCondition(c72409060.igcon)
	e2:SetTarget(c72409060.indtg)
	e2:SetOperation(c72409060.indop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c72409060.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72409060,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(c72409060.qccon)
	e4:SetTarget(c72409060.indtg)
	e4:SetOperation(c72409060.indop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c72409060.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c72409060.eqlimit)
	c:RegisterEffect(e6)
end
function c72409060.eqlimit(e,c)
	return c:IsSetCard(0xe729)
end
function c72409060.filter(c)
	return c:IsFaceup()  and c:IsSetCard(0xe729)
end
function c72409060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c72409060.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72409060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c72409060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c72409060.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)  
	end
end
function c72409060.igcon(e)
	return not (e:GetHandler():IsCode(72409000,72409010) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155))
end
function c72409060.qccon(e)
   return aux.dscon() and (e:GetHandler():IsCode(72409000,72409010) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155))
end
function c72409060.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c72409060.chfilter(c)
	return c:IsControlerCanBeChanged()
end
function c72409060.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c72409060.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	
	local tm=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc)
	local tg=tm:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local opt=Duel.SelectOption(tp,aux.Stringid(72409060,2),aux.Stringid(72409060,3))
		if opt==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(72409060,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(c72409060.efilter1)
			tc:RegisterEffect(e1)
		elseif opt==1 then
			while tg do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(72409060,3))
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_IMMUNE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e2:SetRange(LOCATION_ONFIELD)
				e2:SetLabelObject(tc)
				e2:SetValue(c72409060.efilter2)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e2:SetOwnerPlayer(tp)
				tg:RegisterEffect(e2)
				tg=tm:GetNext()
			end
		end
	end
end
function c72409060.efilter1(e,te)
	return not (te:GetOwner():IsSetCard(0x729) and te:GetOwner():IsType(TYPE_EQUIP))
end
function c72409060.efilter2(e,te)
	local tc=e:GetLabelObject()
	return  te:GetOwner()==tc
end