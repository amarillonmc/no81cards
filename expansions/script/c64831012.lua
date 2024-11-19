--终末旅者指挥 梅尔维尔
function c64831012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c64831012.tunefil,c64831012.nottunefil,1)
	c:EnableReviveLimit()
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c64831012.matcheck)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c64831012.distg)
	e1:SetOperation(c64831012.disop)
	c:RegisterEffect(e1)
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e0)
	e3:SetTargetRange(1,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c64831012.effectcondition)
	e3:SetTarget(c64831012.distarget)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabelObject(e0)
	e4:SetCondition(c64831012.effectcondition)
	e4:SetValue(c64831012.effectfilter)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e5)
end
c64831012.material_type=TYPE_SYNCHRO
function c64831012.tunefil(c)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x5410)
end
function c64831012.nottunefil(c)
	return c:IsSetCard(0x5410) and c:IsType(TYPE_SYNCHRO) and not c:IsType(TYPE_TUNER)
end
function c64831012.matfil(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c64831012.matcheck(e,c)
	local check=0
	if c:GetMaterial():IsExists(c64831012.matfil,1,nil) then check=1 end
	e:SetLabel(check)
end
function c64831012.effectcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c64831012.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsType(TYPE_SYNCHRO) 
end
function c64831012.distarget(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c64831012.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c64831012.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c64831012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c64831012.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c64831012.filter,tp,LOCATION_MZONE,0,1,1,c)
end
function c64831012.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
		if Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(64831012,0)) then
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end