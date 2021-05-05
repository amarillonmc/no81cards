--崇高骑士-乔特
function c40008809.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,40008809)
	e1:SetCondition(c40008809.sprcon)
	c:RegisterEffect(e1)   
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008809,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,40008810)
	e2:SetTarget(c40008809.eqtg)
	e2:SetOperation(c40008809.eqop)
	c:RegisterEffect(e1)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008809,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c40008809.reptg)
	e4:SetValue(c40008809.repval)
	e4:SetOperation(c40008809.repop)
	c:RegisterEffect(e4)
end
function c40008809.sprfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_EQUIP) or c:IsType(TYPE_DUAL))
end
function c40008809.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008809.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c40008809.eqfilter(c,tp)
	return ((c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)) or c:IsType(TYPE_DUAL)) and c:CheckUniqueOnField(tp) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40008809.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008809.eqfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40008809.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c40008809.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c40008809.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,c,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c40008809.eqlimit)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
		--atkup
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c40008809.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c40008809.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and ((c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)) or c:IsType(TYPE_DUAL))
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function c40008809.desfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
		and e:GetHandler():GetEquipGroup():IsContains(c)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c40008809.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c40008809.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c40008809.desfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c40008809.desfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c40008809.repval(e,c)
	return c40008809.repfilter(c,e:GetHandlerPlayer())
end
function c40008809.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
