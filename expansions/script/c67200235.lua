--反目的强袭
function c67200235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200235+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67200235.cost)
	e1:SetTarget(c67200235.sumtg)
	e1:SetOperation(c67200235.sumop)
	c:RegisterEffect(e1)	
end
function c67200235.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x678) and c:IsLevelBelow(4)
end
function c67200235.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200235.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200235,2))
	local g=Duel.SelectMatchingCard(tp,c67200235.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoExtraP(tc,tp,REASON_COST)
end
function c67200235.sumfilter(c)
	return c:IsSetCard(0x678) and c:IsSummonable(true,nil)
end
function c67200235.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200235.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c67200235.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200235.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
