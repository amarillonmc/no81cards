--超古代的尖兵
function c98930003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98930003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98930003)
	e1:SetCondition(c98930003.condition)
	e1:SetTarget(c98930003.target)
	e1:SetOperation(c98930003.operation)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,60000024)
	e2:SetCondition(c98930003.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98930003.destg)
	e2:SetOperation(c98930003.desop)
	c:RegisterEffect(e2)
end
function c98930003.cfilter2(c)
	return c:IsSetCard(0xad0)
end
function c98930003.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98930003.cfilter2,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>2
end
function c98930003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98930003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98930003.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xad0) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetSummonPlayer()==tp
end
function c98930003.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98930003.cfilter,1,nil,tp)
end
function c98930003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,98930000)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.RegisterFlagEffect(tp,98930000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98930003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end