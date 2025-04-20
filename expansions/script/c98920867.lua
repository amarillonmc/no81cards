--火灵术解放
function c98920867.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920867+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c98920867.condition1)
	e1:SetTarget(c98920867.target)
	e1:SetOperation(c98920867.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920867,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c98920867.handcon)
	c:RegisterEffect(e4)
	--SSet
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,98920867)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98920867.setcon)
	e2:SetTarget(c98920867.settg)
	e2:SetOperation(c98920867.setop)
	c:RegisterEffect(e2)
end
function c98920867.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xbf) or c:IsSetCard(0x10c0)) and c:IsType(TYPE_MONSTER)
end
function c98920867.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98920867.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920867.filter(c,e,tp)
	return c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920867.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c98920867.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920867.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920867.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920867.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local g=tc:GetColumnGroup():Filter(aux.AND(Card.IsFaceup,Card.IsControler),nil,1-tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c98920867.filters(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920867.handcon(e)
	return Duel.IsExistingMatchingCard(c98920867.filters,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98920867.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActivated() and re:GetHandler():IsSetCard(0x614c) and not re:GetHandler():IsCode(98920867)
end
function c98920867.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98920867.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end