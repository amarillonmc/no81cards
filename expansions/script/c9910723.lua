--远古造物大爆发
function c9910723.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910723,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910723+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910723.target)
	e1:SetOperation(c9910723.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910723,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9910723+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9910723.cost)
	e2:SetTarget(c9910723.target2)
	e2:SetOperation(c9910723.activate2)
	c:RegisterEffect(e2)
end
function c9910723.filter(c,lv,e,tp)
	return c:IsSetCard(0xc950) and c:IsLevelBelow(lv)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9910723.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910723.filter,tp,LOCATION_DECK,0,1,nil,lv,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910723.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910723.filter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c9910723.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910723.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910723.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910723.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910723.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910723.filter,tp,LOCATION_DECK,0,1,nil,lv+1,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(c9910723.chlimit)
end
function c9910723.chlimit(e,ep,tp)
	return tp==ep
end
function c9910723.activate2(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910723.filter,tp,LOCATION_DECK,0,1,2,nil,lv+1,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
