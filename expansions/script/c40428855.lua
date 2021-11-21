--战华之霸-孙符
function c40428855.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40428855)
	e1:SetCondition(c40428855.spcon)
	e1:SetTarget(c40428855.sptg)
	e1:SetOperation(c40428855.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(40428855,ACTIVITY_CHAIN,c40428855.chainfilter)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40428855,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40428856)
	e2:SetCost(c40428855.spcost2)
	e2:SetTarget(c40428855.sptg2)
	e2:SetOperation(c40428855.spop2)
	c:RegisterEffect(e2)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40428855,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,40428857)
	e4:SetCondition(c40428855.atkcon)
	e4:SetTarget(c40428855.atktg)
	e4:SetOperation(c40428855.atkop)
	c:RegisterEffect(e4)
end
function c40428855.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return not (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c40428855.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(40428855,1-tp,ACTIVITY_CHAIN)~=0
end
function c40428855.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40428855.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c40428855.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c40428855.spfilter(c,e,tp)
	return c:IsSetCard(0x137) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c40428855.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c40428855.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
end
function c40428855.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40428855.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40428855.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40428855.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40428855.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40428855.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40428855.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40428855.atkfilter(c,tc)
	return c:IsCanBeBattleTarget(tc)
end
function c40428855.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x137) and rp==tp and re:GetHandler()~=e:GetHandler()
end
function c40428855.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c40428855.atkfilter(chkc,e:GetHandler())  end
	if chk==0 then return Duel.IsExistingTarget(c40428855.atkfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40428855.atkfilter,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler())
end
function c40428855.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeBattleTarget(e:GetHandler()) and tc:IsControler(1-tp) then
		Duel.CalculateDamage(e:GetHandler(),tc)
	end
end
