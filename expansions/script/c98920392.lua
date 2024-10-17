--诺修之虫惑魔 
function c98920392.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920392,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,98930392)
	e1:SetCondition(c98920392.spcon)
	e1:SetTarget(c98920392.sptg)
	e1:SetOperation(c98920392.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920392,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98920392)
	e2:SetCost(c98920392.sscost)
	e2:SetTarget(c98920392.sstg)
	e2:SetOperation(c98920392.ssop)
	c:RegisterEffect(e2)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c98920392.efilter)
	c:RegisterEffect(e2)
end
function c98920392.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c98920392.tdfilter(c,tp)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c98920392.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c98920392.thfilter(c,code)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89) and not c:IsCode(code)
end
function c98920392.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c98920392.tdfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c98920392.tdfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c98920392.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98920392.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c98920392.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c98920392.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
end
function c98920392.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x4c,0x89)
end
function c98920392.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920392.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end