--疾行浪客 瀚宇星皇
function c16362052.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c16362052.matfilter1,c16362052.matfilter2,2,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c16362052.imop)
	c:RegisterEffect(e1)
	--extra attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetOperation(c16362052.exaop)
	c:RegisterEffect(e11)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c16362052.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetTarget(c16362052.atktg2)
	c:RegisterEffect(e22)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16362052)
	e3:SetTarget(c16362052.tg2)
	e3:SetOperation(c16362052.op2)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,16362152)
	e4:SetCondition(c16362052.eqcon)
	e4:SetTarget(c16362052.eqtg)
	e4:SetOperation(c16362052.eqop)
	c:RegisterEffect(e4)
end
function c16362052.matfilter1(c)
	return c:IsFusionSetCard(0xdc0) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c16362052.matfilter2(c)
	return c:IsFusionSetCard(0xdc0)
end
function c16362052.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c16362052.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c16362052.exaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c16362052.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xdc0)
end
function c16362052.atktg(e,c)
	return c:IsSetCard(0xdc0)
end
function c16362052.atktg2(e,c)
	return c:IsSetCard(0xdc0) and c:GetEquipCount()>0
end
function c16362052.tg2f(c,tp)
	return c:CheckUniqueOnField(tp)
end
function c16362052.equfilter(c)
	return c:IsSetCard(0xdc0) and c:IsFaceup()
end
function c16362052.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16362052.tg2f,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD)
end
function c16362052.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c16362052.tg2f,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,c16362052.equfilter,tp,LOCATION_MZONE,0,1,1,tc)
	local ec=sg:GetFirst()
	if tc and ec then
		if not Duel.Equip(tp,tc,ec) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c16362052.op2val)
		e1:SetLabelObject(ec)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c16362052.op2val(e,c)
	local ec=e:GetLabelObject()
	return e:GetOwner()==ec
end
function c16362052.lefilter(c)
	return c:IsType(TYPE_SPELL) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c16362052.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16362052.lefilter,1,nil)
end
function c16362052.eqfilter(c,tp)
	return c:IsSetCard(0xdc0) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c16362052.eqtgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c16362052.eqtgfilter(c,eqc)
	return c:IsFaceup() and c:IsSetCard(0xdc0) and eqc:CheckEquipTarget(c)
end
function c16362052.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16362052.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c16362052.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c16362052.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,c16362052.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst()
			Duel.Equip(tp,ec,tc)
		end
	end
end