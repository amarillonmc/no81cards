--符文魔贯炮
function c9981020.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9981020.condition)
	e1:SetTarget(c9981020.target)
	e1:SetOperation(c9981020.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9981020)
	e2:SetCondition(c9981020.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9981020.destg)
	e2:SetOperation(c9981020.desop)
	c:RegisterEffect(e2)
end
function c9981020.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c9981020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9981020.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9981020.filter(c,e,tp)
	return c:IsSetCard(0x10a2) or c:IsCode(6986414,38033121) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981020.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9981020.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981020.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9981020.cfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(6986414,38033121) and c:GetSummonPlayer()==tp
end
function c9981020.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981020.cfilter1,1,nil,tp)
end
function c9981020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9981020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
