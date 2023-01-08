--神造遗物 渡鸦
function c72409090.initial_effect(c)
	aux.AddCodeList(c,72409000)
	aux.AddCodeList(c,72409030)
	c:SetUniqueOnField(1,0,72409090)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c72409090.target)
	e1:SetOperation(c72409090.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72409090,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCountLimit(1)
	e2:SetCondition(c72409090.igcon)
	e2:SetTarget(c72409090.indtg)
	e2:SetOperation(c72409090.indop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c72409090.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72409090,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetHintTiming(TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1)
	e4:SetCondition(c72409090.qccon)
	e4:SetTarget(c72409090.indtg)
	e4:SetOperation(c72409090.indop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c72409090.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c72409090.eqlimit)
	c:RegisterEffect(e6)
end
function c72409090.eqlimit(e,c)
	return c:IsSetCard(0xe729)
end
function c72409090.filter(c)
	return c:IsFaceup()  and c:IsSetCard(0xe729)
end
function c72409090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c72409090.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72409090.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c72409090.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c72409090.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)  
	end
end
function c72409090.igcon(e)
	return not (e:GetHandler():IsCode(72409000,72409030) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155))
end
function c72409090.qccon(e)
   return aux.dscon() and (e:GetHandler():IsCode(72409000,72409030) or Duel.IsPlayerAffectedByEffect(tp,72409155) or e:GetHandler():IsHasEffect(72409155))
end
function c72409090.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c72409090.chfilter(c)
	return c:IsControlerCanBeChanged()
end
function c72409090.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c72409090.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c72409090.indop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c72409090.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local cd=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(72409090,2)) and cd~=0 then
				--disable field
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetOperation(c72409090.disop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c72409090.tgfilter(c)
	return c:IsSetCard(0x6729) and c:IsAbleToGrave()
end
function c72409090.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	return dis1
end