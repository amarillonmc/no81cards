--神花的来访者
function c72413480.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c72413480.ovfilter,aux.Stringid(72413480,0),4,c72413480.xyzop)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(72413480,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72413480)
	e1:SetCost(c72413480.cost)
	e1:SetTarget(c72413480.sptg)
	e1:SetOperation(c72413480.spop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72413480,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72413480)
	e2:SetCost(c72413480.tfcost)
	e2:SetTarget(c72413480.tftg)
	e2:SetOperation(c72413480.tfop)
	c:RegisterEffect(e2)
end
function c72413480.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6728) and not c:IsCode(72413480)
end
function c72413480.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,72413480)==0 end
	Duel.RegisterFlagEffect(tp,72413480,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c72413480.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72413480.spfilter(c,e,tp)
	return c:IsSetCard(0xe728) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72413480.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72413480.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c72413480.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72413480.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
		local tc=g:GetFirst()
		if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	Duel.SpecialSummonComplete()
	end
end
--
function c72413480.tffilter(c,cc,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xe728) and c:IsFaceup()
		and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_ONFIELD,cc)
end
function c72413480.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c72413480.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c72413480.tffilter,tp,LOCATION_REMOVED,0,1,nil,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c72413480.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c72413480.tffilter,tp,LOCATION_REMOVED,0,1,1,nil,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end