--最后的碎片
function c40008564.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008564)
	e1:SetCost(c40008564.cost)
	e1:SetTarget(c40008564.sptp)
	e1:SetOperation(c40008564.spop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008564,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,40008565+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c40008564.thcon)
	e2:SetTarget(c40008564.thtg)
	e2:SetOperation(c40008564.thop)
	c:RegisterEffect(e2)	
end
function c40008564.cfilter(c)
	return c:GetSummonPlayer()==tp and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c40008564.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40008564.cfilter,1,nil)
end
function c40008564.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c40008564.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4)
end
function c40008564.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008564.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40008564.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40008564.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
			  e2:SetType(EFFECT_TYPE_FIELD)
			  e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			  e2:SetRange(LOCATION_MZONE)
			  e2:SetTargetRange(1,0)
			  e2:SetTarget(c40008564.splimit)
			  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			  c:RegisterEffect(e2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(3758046,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetOperation(c3758046.damop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c3758046.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,8000,REASON_EFFECT)
end
function c40008564.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsType(TYPE_LINK)
end
function c40008564.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c40008564.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end