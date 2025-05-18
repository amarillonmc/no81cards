--神·龙·破
local s,id,o=GetID()
function c75000028.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,75000028)
	e1:SetTarget(c75000028.target)
	e1:SetOperation(c75000028.activate)
	c:RegisterEffect(e1)
---
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000028,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75000028+o)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c75000028.spcon)
	e2:SetTarget(c75000028.sptg)
	e2:SetOperation(c75000028.spop)
	c:RegisterEffect(e2)
end


function c75000028.filter(c)
	return (c:IsSetCard(0x3751) and c:IsType(TYPE_MONSTER))
end
function c75000028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c75000028.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c75000028.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c75000028.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
--------1
function c75000028.filter1(c,e,tp)
	return c:IsCode(75000001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75000028.filter2(c,e,tp)
	return (c:IsSetCard(0x3751) and c:IsType(TYPE_MONSTER)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75000028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-2000
end
function c75000028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75000028.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c75000028.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75000028.filter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	ft=ft-1
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75000028.filter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if e:GetLabel()==1 and sg:GetCount()>0 and ft>0
		and Duel.SelectYesNo(tp,aux.Stringid(75000028,2)) then
		Duel.BreakEffect()
		ft=math.min(ft,sg:GetCount(),2)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,ft,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end