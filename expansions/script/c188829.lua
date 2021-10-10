--暴戾的刻证兽
function c188829.initial_effect(c)
	--Equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCountLimit(1,188829+EFFECT_COUNT_CODE_OATH)
	e0:SetValue(c188829.eqlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c188829.target)
	e1:SetOperation(c188829.operation)
	c:RegisterEffect(e1)
	--disable special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188829,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c188829.discon)
	e2:SetTarget(c188829.distg)
	e2:SetOperation(c188829.disop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(188829,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c188829.spcon)
	e3:SetTarget(c188829.sptg)
	e3:SetOperation(c188829.spop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(188829,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c188829.ngtg)
	e4:SetOperation(c188829.ngop)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(188829,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c188829.eqcon)
	e5:SetTarget(c188829.eqtg)
	e5:SetOperation(c188829.operation)
	c:RegisterEffect(e5)
	
end
function c188829.eqlimit(e,c)
	return c:IsSetCard(0xf3d)
end
function c188829.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf3d)
end
function c188829.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c188829.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c188829.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c188829.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c188829.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c188829.discon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg and tg:IsAttribute(ATTRIBUTE_DARK) and tp~=ep and Duel.GetCurrentChain()==0 and eg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND|LOCATION_GRAVE)>0 
end
function c188829.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(188829)==0 end
	local mg=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND|LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,mg,mg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg,mg:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(188829,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,1)
end
function c188829.disop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local mg=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND|LOCATION_GRAVE)
	Duel.NegateSummon(mg)
	Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
end

function c188829.spfilter(c,e,tp)
	return c:IsSetCard(0xf3d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c188829.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg and tg:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c188829.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	g:RemoveCard(e:GetHandler())
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c188829.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and g:GetCount()>0 and e:GetHandler():GetFlagEffect(188829)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(188829,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,1)
end
function c188829.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c188829.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g2)
			Duel.Release(g2,REASON_EFFECT)
		end
	end
end
function c188829.ngtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and tg and not tg:IsAttribute(ATTRIBUTE_DARK) and not tg:IsAttribute(ATTRIBUTE_LIGHT) and e:GetHandler():GetFlagEffect(188829)==0 and aux.disfilter1(tg) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(188829,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,1)
end
function c188829.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=e:GetHandler():GetEquipTarget()
	if not c:IsRelateToEffect(e) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	Duel.HintSelection(g)
	if tg and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and (not tg:IsDisabled() or tg:IsType(TYPE_TRAPMONSTER)) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		local te1=e1:Clone()
		tg:RegisterEffect(te1)
		local te2=e2:Clone()
		tg:RegisterEffect(te2)
		if tg:IsType(TYPE_TRAPMONSTER) then
			local te3=e3:Clone()
			tg:RegisterEffect(te3)
		end
	end
end

function c188829.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:GetFlagEffect(188829)==0
end
function c188829.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xf3d)
end
function c188829.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c188829.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c188829.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c188829.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

