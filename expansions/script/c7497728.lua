--元素灵剑士·炎炙
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
end
function s.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x400d) or c:IsLocation(LOCATION_HAND))
end
function s.regfilter(c,attr)
	return c:IsSetCard(0x400d) and bit.band(c:GetOriginalAttribute(),attr)~=0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,61557074)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,61557074)
		fe:UseCountLimit(tp)
	end
	local flag=0
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then flag=bit.bor(flag,0x1) end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then flag=bit.bor(flag,0x2) end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then flag=bit.bor(flag,0x4) end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and e:GetLabelObject():GetLabel()~=0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(s.efftg)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	if bit.band(flag,0x1)~=0 then
		--destroy
		local e01=Effect.CreateEffect(c)
		e01:SetDescription(aux.Stringid(id,5))
		e01:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e01:SetType(EFFECT_TYPE_IGNITION)
		e01:SetRange(LOCATION_MZONE)
		--e01:SetCountLimit(1,id+1)
		e01:SetTarget(s.destg1)
		e01:SetOperation(s.desop1)
		local e1=e0:Clone()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetLabelObject(e01)
		e1:SetDescription(aux.Stringid(id,1))
		c:RegisterEffect(e1)
		local e001=e01:Clone()
		e001:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e001)
	end
	if bit.band(flag,0x2)~=0 then
		--destroy
		local e02=Effect.CreateEffect(c)
		e02:SetDescription(aux.Stringid(id,6))
		e02:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e02:SetType(EFFECT_TYPE_IGNITION)
		e02:SetRange(LOCATION_MZONE)
		--e02:SetCountLimit(1,id+2)
		e02:SetTarget(s.destg2)
		e02:SetOperation(s.desop2)
		local e2=e0:Clone()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetLabelObject(e02)
		e2:SetDescription(aux.Stringid(id,2))
		c:RegisterEffect(e2)
		local e002=e02:Clone()
		e002:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e002)
	end
	if bit.band(flag,0x4)~=0 then
		--set
		local e03=Effect.CreateEffect(c)
		e03:SetDescription(aux.Stringid(id,7))
		e03:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e03:SetType(EFFECT_TYPE_IGNITION)
		e03:SetRange(LOCATION_MZONE)
		--e03:SetCountLimit(1,id+2)
		e03:SetTarget(s.settg)
		e03:SetOperation(s.setop)
		local e3=e0:Clone()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e3:SetLabelObject(e03)
		e3:SetDescription(aux.Stringid(id,3))
		c:RegisterEffect(e3)
		local e003=e03:Clone()
		e003:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e003)
	end
end
function s.efftg(e,c)
	return c:IsSetCard(0x113)
end
function s.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local oc=e:GetOwner()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and oc and oc:GetFlagEffect(id+1)<=0 end
	oc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local oc=e:GetOwner()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and oc and oc:GetFlagEffect(id+2)<=0 end
	oc:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end
function s.setfilter(c,e,tp,ec)
	local rc=c:GetReasonCard()
	local re=c:GetReasonEffect()
	return ((rc and rc==ec) or (re and re:GetHandler()==ec)) and ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,tp)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and c:IsSSetable(true)))
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local oc=e:GetOwner()
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,e:GetHandler()) and oc and oc:GetFlagEffect(id+3)<=0 end
	oc:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function s.gcfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD)
end
function s.gcheck(g,mft,sft)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mft
		and g:FilterCount(s.gcfilter,nil)<=sft
		and g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and mft>=1 then mft=1 end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,e:GetHandler())
		local sg=g:SelectSubGroup(tp,s.gcheck,false,1,63,mft,sft)
		if sg:GetCount()>0 then
			local msg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
			local ssg=sg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
			Duel.SpecialSummon(msg,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
			Duel.SSet(tp,ssg,tp,false)
			Duel.ConfirmCards(tp,sg)
			--Duel.ConfirmCards(tp,sg)
		end
	end
end
