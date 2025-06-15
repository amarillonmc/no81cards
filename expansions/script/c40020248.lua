--创世之女神
local m=40020248
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddCodeList(c,40020225)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.adcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return aux.IsCodeListed(c,40020225) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsCode(40020225)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_FZONE,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_FZONE,0,1,nil) then
		g:Merge(Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=g:Select(tp,1,1,nil)
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(40020225)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and aux.exccon(e)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsCode(40020225) and c:IsCanAddCounter(0xf12,1)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		local tc=g:GetFirst()
		tc:AddCounter(0xf12,1)
		if tc:GetCounter(0xf12)==1 or tc:GetCounter(0xf12)==2 or tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40020225,e,0,tp,tp,0)
		end
		if tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==5 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40020235,e,0,tp,tp,0)
		end
		if tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==6 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40020325,e,0,tp,tp,0)
		end
	end
end