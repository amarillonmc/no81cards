--废都循猎者
function c67200916.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200916)
	e1:SetCondition(c67200916.pencon)
	e1:SetTarget(c67200916.pentg)
	e1:SetOperation(c67200916.penop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200916,0))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,67200917)
	e2:SetCost(c67200916.damcost)
	e2:SetTarget(c67200916.damtg)
	e2:SetOperation(c67200916.damop)
	c:RegisterEffect(e2)
end
function c67200916.cfilter(c)
	return c:IsSetCard(0x967a)
end
function c67200916.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200916.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c67200916.spfilter2(c,e,tp)
	return c:IsSetCard(0x967a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200916.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c67200916.spfilter2,tp,LOCATION_PZONE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_PZONE)
end
function c67200916.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200916.spfilter2,tp,LOCATION_PZONE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200916.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a)
end
function c67200916.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c67200916.costfilter,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and b2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200916,3))
	local g=Duel.SelectMatchingCard(tp,c67200916.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200916.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200916.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200916.spfilter(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)) then return false end
	return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c67200916.spfilter1(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)) then return false end
	return (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c67200916.thfilter(c)
	return c:IsSetCard(0x67a) and not c:IsCode(67200916) and c:IsType(TYPE_PENDULUM)
end
function c67200916.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200916,4))
	local g=Duel.SelectMatchingCard(tp,c67200916.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_EXTRA) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c67200916.spfilter,tp,LOCATION_EXTRA,0,g:GetFirst():GetCode(),e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200916,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=sg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
			local b2=sc:IsExists(c67200916.spfilter1,1,nil,e,tp)
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200916,3)},{b2,1152})
			if op==1 then
				Duel.MoveToField(sc:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			end
			if op==2 then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end