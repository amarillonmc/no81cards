--织弦律·辉影之鸣律神
function c74600061.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,6,c74600061.lcheck)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c74600061.atkval)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,74600061)
	e2:SetCondition(c74600061.setcon)
	e2:SetTarget(c74600061.settg)
	e2:SetOperation(c74600061.setop)
	c:RegisterEffect(e2)
	--mat check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c74600061.valcheck)
	c:RegisterEffect(e3)
	--synchro success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c74600061.regcon)
	e4:SetOperation(c74600061.regop)
	c:RegisterEffect(e4)
	e4:SetLabelObject(e3)
end
function c74600061.mfilter(c)
	return c:IsLinkSetCard(0x3e70) and c:IsLinkType(TYPE_LINK)
end
function c74600061.lcheck(g,lc)
	return g:IsExists(c74600061.mfilter,1,nil)
end
function c74600061.atkfilter(c)
	return c:GetType()==TYPE_CONTINUOUS+TYPE_SPELL and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsFaceup()
end
function c74600061.atkval(e,c)
	return Duel.GetMatchingGroupCount(c74600061.atkfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000
end
function c74600061.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c74600061.setfilter(c)
	local p=c:GetOwner()
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and Duel.GetLocationCount(p,LOCATION_SZONE)>0 and c:IsFaceupEx()
end
function c74600061.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74600061.setfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
end
function c74600061.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c74600061.setfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if tc:IsImmuneToEffect(e) then return end
		Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c74600061.valcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	if not g then return end
	for tc in aux.Next(g) do
		att=bit.bor(att,tc:GetOriginalAttribute())
	end
	e:SetLabel(att)
end
function c74600061.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabelObject():GetLabel()~=0
end
function c74600061.regop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(1131)
		e1:SetCategory(CATEGORY_NEGATE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c74600061.discon)
		e1:SetTarget(c74600061.distg)
		e1:SetOperation(c74600061.disop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(74600061,0))
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1131)
		e2:SetCategory(CATEGORY_DISABLE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetCountLimit(2)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c74600061.negcon)
		e2:SetCost(c74600061.negcost)
		e2:SetTarget(aux.nbtg)
		e2:SetOperation(c74600061.negop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(74600061,1))
	end
end
function c74600061.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c74600061.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c74600061.setfilter(re:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c74600061.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and c74600061.setfilter(rc) then
		if rc:IsImmuneToEffect(e) then return end
		Duel.MoveToField(rc,tp,rc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		rc:RegisterEffect(e1)
	end
end
function c74600061.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c74600061.rfilter(c,tp)
	return c:GetType()==TYPE_CONTINUOUS+TYPE_SPELL and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and (c:IsFaceup() or c:IsControler(tp)) and c:IsReleasable()
end
function c74600061.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74600061.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c74600061.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c74600061.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
