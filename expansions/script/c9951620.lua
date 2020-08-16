--闪耀无限可能性的伊莉雅
function c9951620.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9951620.target)
	e1:SetOperation(c9951620.activate)
	c:RegisterEffect(e1)
end
function c9951620.tfilter(c,att,code,e,tp)
	return c:IsSetCard(0xaba8) and not c:IsCode(code) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951620.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaba8) and Duel.IsExistingMatchingCard(c9951620.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetCode(),e,tp)
end
function c9951620.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9951620.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9951620.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9951620.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9951620.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9951620.tfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute(),tc:GetCode(),e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c9951620.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c9951620.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	tc:RegisterEffect(e1)
end
function c9951620.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c9951620.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end