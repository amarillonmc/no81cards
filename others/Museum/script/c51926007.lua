--炼金工具 锡之法阵
function c51926007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c51926007.condition)
	e1:SetTarget(c51926007.target)
	e1:SetOperation(c51926007.activate)
	c:RegisterEffect(e1)
	--Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c51926007.cost)
	e2:SetTarget(c51926007.sumtg)
	e2:SetOperation(c51926007.sumop)
	c:RegisterEffect(e2)
end
function c51926007.cfilter(c)
	return c:IsCode(51926001) and c:IsFaceup()
end
function c51926007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51926007.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c51926007.spfilter(c,e,tp)
	return c:IsSetCard(0x3257) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51926007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51926007.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c51926007.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x6257) and c:IsSSetable()
end
function c51926007.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51926007.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsCode(51926013) and  
		Duel.IsExistingMatchingCard(c51926007.setfilter,tp,LOCATION_DECK,0,1,nil) and 
		Duel.SelectYesNo(tp,aux.Stringid(51926007,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c51926007.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c51926007.tdfilter(c)
	return c:IsCode(51926013) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c51926007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c51926007.tdfilter,tp,LOCATION_REMOVED,0,1,nil)
		and c:IsAbleToDeckAsCost() end
	local g=Duel.SelectMatchingCard(tp,c51926007.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c51926007.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function c51926007.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51926007.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c51926007.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c51926007.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
