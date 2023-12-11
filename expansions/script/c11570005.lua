--翼冠缚·血之匙
function c11570005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11570005,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,11570005)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c11570005.effcost)
	e2:SetTarget(c11570005.efftg)
	e2:SetOperation(c11570005.effop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c11570005.con)
	e3:SetTarget(c11570005.tg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c11570005.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11570005)==0 end
	e:GetHandler():RegisterFlagEffect(11570005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c11570005.costfilter(c,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0 and (c:IsAbleToGraveAsCost() or c:IsLocation(LOCATION_REMOVED))
end
function c11570005.spfilter1(c,e,tp)
	return c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11570005.spfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11570005.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11570005.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c11570005.spfilter2,tp,0,LOCATION_GRAVE,1,nil,e,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570005.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil,tp) and (b1 or b2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11570005.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,1,nil,tp)
	local b3=g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	if not g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	end
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(11570005,1),aux.Stringid(11570005,2),aux.Stringid(11570005,3))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(11570005,1),aux.Stringid(11570005,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(11570005,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(11570005,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c11570005.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local res=0
	if op~=1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11570005.spfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if op~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11570005.spfilter2),tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if op==2 and res~=0 then Duel.BreakEffect() end
			local tc=g:GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(11570005,4))
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_SETCODE)
				e1:SetValue(0x810)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local fid=e:GetHandler():GetFieldID()
				tc:RegisterFlagEffect(11570005,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetLabel(fid)
				e2:SetLabelObject(tc)
				e2:SetCondition(c11570005.descon)
				e2:SetOperation(c11570005.desop)
				Duel.RegisterEffect(e2,tp)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c11570005.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(11570005)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c11570005.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c11570005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x810) and not c:IsSetCard(0x3810)
end
function c11570005.con(e)
	return Duel.IsExistingMatchingCard(c11570005.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11570005.tg(e,c)
	return c:IsSetCard(0x3810)
end