--救援ACE队 无人消防战车
function c98920374.initial_effect(c)
	 --Special Summon (from hand : itself)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920374,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920374)
	e1:SetCondition(c98920374.spcon)
	e1:SetTarget(c98920374.sptg)
	e1:SetOperation(c98920374.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920374,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+98920374)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930374)
	e3:SetCost(c98920374.cost)
	e3:SetCondition(c98920374.spcon2)
	e3:SetTarget(c98920374.sptg2)
	e3:SetOperation(c98920374.spop2)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,98920374,EVENT_TO_GRAVE,g)
end
function c98920374.costfilter(c)
	return c:IsSetCard(0x18b) and c:IsAbleToGraveAsCost()
end
function c98920374.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920374.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c98920374.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
end
function c98920374.cfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
		and c:IsSetCard(0x18b) and not c:IsCode(98920374)
end
function c98920374.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920374.cfilter1,1,nil,tp)
end
function c98920374.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98920374.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920374.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE)
		and c:IsPreviousControler(1-tp)
end
function c98920374.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920374.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c98920374.spfilter2(c,e,tp,g)
	return g:IsContains(c) and c98920374.cfilter(c,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920374.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c98920374.spfilter2(chkc,e,tp,eg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920374.spfilter2,tp,0,LOCATION_GRAVE,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920374.spfilter2,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920374.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsLocation(LOCATION_MZONE) then
		  local c=e:GetHandler()
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		  e1:SetTarget(c98920374.distg)
		  e1:SetLabelObject(tc)
		  e1:SetReset(RESET_PHASE+PHASE_END,1)
		  Duel.RegisterEffect(e1,tp)
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e2:SetCode(EVENT_CHAIN_SOLVING)
		  e2:SetCondition(c98920374.discon)
		  e2:SetOperation(c98920374.disop)
		  e2:SetLabelObject(tc)
		  e2:SetReset(RESET_PHASE+PHASE_END,1)
		  Duel.RegisterEffect(e2,tp)
	   end
	end
end
function c98920374.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c98920374.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c98920374.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end