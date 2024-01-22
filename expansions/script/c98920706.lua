--梅拉比之虫惑魔
function c98920706.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c98920706.efilter)
	c:RegisterEffect(e1)
	--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920706,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+98920706)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930706)
	e3:SetCondition(c98920706.spcon2)
	e3:SetTarget(c98920706.sptg2)
	e3:SetOperation(c98920706.spop2)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,98920706,EVENT_DESTROYED,g)
	aux.RegisterMergedDelayedEvent(c,98920706,EVENT_REMOVE,g)
	--sp
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920706,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SSET)
	e5:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e5:SetCountLimit(1,98920706)
	e5:SetCondition(c98920706.damcon2)
	e5:SetTarget(c98920706.damtg2)
	e5:SetOperation(c98920706.damop2)
	c:RegisterEffect(e5)
end
function c98920706.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
end
function c98920706.sfilter(c,e)
	return c:IsFacedown() and (not e or c:IsRelateToEffect(e))
end
function c98920706.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function c98920706.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()==1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=eg:Filter(c98920706.sfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920706.damop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98920706.sfilter,nil,e)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()==1 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:GetType()==TYPE_TRAP and tc:IsSetCard(0x4c,0x89) and e:GetHandler():IsRelateToEffect(e) then
		   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98920706.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp and c:IsPreviousControler(1-tp) and c:GetReasonEffect():GetHandler():IsSetCard(0x4c,0x89)
end
function c98920706.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920706.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler()) 
end
function c98920706.spfilter2(c,e,tp,g)
	return g:IsContains(c) and c98920706.cfilter(c,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920706.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c98920706.spfilter2(chkc,e,tp,eg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920706.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920706.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920706.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end