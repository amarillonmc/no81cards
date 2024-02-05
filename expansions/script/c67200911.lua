--奥山修正者 小困
function c67200911.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200911,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200912)
	e1:SetCost(c67200911.cost)
	e1:SetTarget(c67200911.sptg)
	e1:SetOperation(c67200911.spop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200911,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	e2:SetCountLimit(1,67200911)
	e2:SetTarget(c67200911.sttg)
	e2:SetOperation(c67200911.stop)
	c:RegisterEffect(e2)	 
end
function c67200911.cfilter(c,tc,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.GetMZoneCount(tp,Group.FromCards(c,tc))>0 
end
function c67200911.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200911.cfilter,tp,LOCATION_ONFIELD,0,1,c,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200911,3))
	local g=Duel.SelectMatchingCard(tp,c67200911.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,c,tp)+c
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200911.sfilter(c,e,tp)
	return c:IsSetCard(0x367a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(67200911)
end
function c67200911.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:IsCostChecked() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(c67200911.sfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c67200911.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200911.sfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--
function c67200911.stfilter(c)
	return c:IsSetCard(0x67a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden() and c:IsLevelBelow(4)
end
function c67200911.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not e:GetHandler():IsForbidden() and Duel.IsExistingMatchingCard(c67200911.stfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
end
function c67200911.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200911.stfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
		local tc=g:GetFirst()
		if tc then
			if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
				Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
