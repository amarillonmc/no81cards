--星幽正道者
function c9910281.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910281.lcheck)
	c:EnableReviveLimit()
	--can not be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910281.indtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910281,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,9910281)
	e2:SetCondition(c9910281.spcon)
	e2:SetTarget(c9910281.sptg)
	e2:SetOperation(c9910281.spop)
	c:RegisterEffect(e2)
end
function c9910281.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x957)
end
function c9910281.indtg(e,c)
	return e:GetHandler()==c or (c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910281.cfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFacedown()
end
function c9910281.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910281.cfilter,1,nil)
end
function c9910281.spfilter(c,e,tp)
	return c:IsSetCard(0x957) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910281.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c9910281.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910281.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910281.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910281.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e1)
	end
end
