--六花圣 流苏花环
function c98920004.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit() 
   --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920004)
	e1:SetCost(c98920004.spcost)
	e1:SetTarget(c98920004.sptg)
	e1:SetOperation(c98920004.spop)
	c:RegisterEffect(e1) 
   --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920004,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,98930004)
	e2:SetTarget(c98920004.settg)
	e2:SetOperation(c98920004.setop)
	c:RegisterEffect(e2)	
--spsummon
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920004.spcon)
	c:RegisterEffect(e3)
end
function c98920004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920004.spfilter(c,e,tp)
	return c:IsSetCard(0x141) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c98920004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c98920004.spfilter1(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c98920004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920004.spfilter1,1,nil,tp)
end
function c98920004.filter(c)
	return c:IsSetCard(0x141) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c98920004.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920004.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c98920004.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98920004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end