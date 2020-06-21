--企鹅物流·行动-AT SPEED OF LIGHTING
function c65.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65.cost)
	e1:SetTarget(c65.tg)
	e1:SetOperation(c65.op)
	c:RegisterEffect(e1)	
end
function c65.spfilter(c,e,tp,code)
	return c:IsSetCard(0xf10) and c:IsType(TYPE_SPELL)
end
function c65.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65.spfilter,tp,LOCATION_GRAVE,0,4,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g=Duel.SelectTarget(tp,c65.spfilter,tp,LOCATION_GRAVE,0,4,4,c,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65.cilter(c,e,tp)
	 return c:IsSetCard(0xf10) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
end
function c65.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c65.cilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c65.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf10) and c:IsCanBeEffectTarget(e) and c:GetClassCount()~=1
end
function c65.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
end
end