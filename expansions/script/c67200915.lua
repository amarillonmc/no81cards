--尼罗修正者 灵猫
function c67200915.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c67200915.indtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200915,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200915)
	e1:SetCost(c67200915.damcost)
	e1:SetTarget(c67200915.damtg)
	e1:SetOperation(c67200915.damop)
	c:RegisterEffect(e1)
end
function c67200915.indtg(e,c)
	return c:IsSetCard(0x967a) and c:IsFaceup()
end
--
function c67200915.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a)
end
function c67200915.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c67200915.costfilter,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and b2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200915,3))
	local g=Duel.SelectMatchingCard(tp,c67200915.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200915.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200915.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200915.spfilter(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsCode(67200915)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_PZONE)
	return ft or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c67200915.spfilter1(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsCode(67200915)) then return false end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200915.thfilter(c)
	return c:IsSetCard(0x967a) and not c:IsCode(67200915) and c:IsAbleToHand()
end
function c67200915.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200915.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c67200915.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200915,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=sg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
			local b2=sc:IsExists(c67200915.spfilter1,1,nil,e,tp)
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200915,3)},{b2,1152})
			if op==1 then
				Duel.MoveToField(sc:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			end
			if op==2 then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end