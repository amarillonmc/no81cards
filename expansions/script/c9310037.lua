--单调战姬 史黛拉·艾尔缇丝
function c9310037.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3f91),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	aux.AddCodeList(c,20000000,20000100)
	--change code
	aux.EnableChangeCode(c,20000000,LOCATION_MZONE)
	--change code
	aux.EnableChangeCode(c,20000100,LOCATION_GRAVE)
	--act limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_ONFIELD)
	e0:SetOperation(c9310037.chainop)
	c:RegisterEffect(e0)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9310037,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9310037.target)
	e2:SetOperation(c9310037.activate)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9310037.spcon)
	e3:SetTarget(c9310037.sptg)
	e3:SetOperation(c9310037.spop)
	c:RegisterEffect(e3)
end
c9310037.material_setcode=0x3f91
function c9310037.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() and ep==tp then
		Duel.SetChainLimit(c9310037.chainlm)
	end
end
function c9310037.chainlm(e,rp,tp)
	return tp==rp
end
function c9310037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL+TYPE_TRAP) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0) end
end
function c9310037.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(4)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(e:GetLabel())
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		   Duel.Destroy(tc,REASON_EFFECT)
		end
		tc=sg:GetNext()
	end
end
function c9310037.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function c9310037.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9310037.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9310037.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c9310037.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9310037.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetChainLimit(c9310037.chainlm)
end
function c9310037.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	local c=Duel.GetFirstTarget()
	if c and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end