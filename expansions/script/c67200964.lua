--尼罗修正者 狂狮
function c67200964.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67200964)
	e1:SetTarget(c67200964.sptg)
	e1:SetOperation(c67200964.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200964,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,67200965)
	e2:SetCost(c67200964.damcost)
	e2:SetTarget(c67200964.damtg)
	e2:SetOperation(c67200964.damop)
	c:RegisterEffect(e2)	
end
function c67200964.spfilter2(c,e,tp)
	return c:IsSetCard(0x967a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200964.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and chkc~=c and c67200964.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67200964.spfilter2,tp,LOCATION_PZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200964.spfilter2,tp,LOCATION_PZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c67200964.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
--
function c67200964.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a)
end
function c67200964.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c67200964.costfilter,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and b2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200964,4))
	local g=Duel.SelectMatchingCard(tp,c67200964.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200964.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200964.thfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	--Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200964.spfilter(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)) then return false end
	return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c67200964.spfilter1(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)) then return false end
	return (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c67200964.thfilter(c)
	return c:IsSetCard(0x67a) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_PENDULUM)
end
function c67200964.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200964.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) and g:GetFirst():IsLocation(LOCATION_PZONE) then
		--Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c67200964.spfilter,tp,LOCATION_EXTRA,0,g:GetFirst():GetCode(),e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200964,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=sg:Select(tp,1,1,g:GetFirst())
			Duel.BreakEffect()
			local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
			local b2=sc:IsExists(c67200964.spfilter1,1,nil,e,tp)
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200964,3)},{b2,1152})
			if op==1 then
				Duel.MoveToField(sc:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			if op==2 then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end