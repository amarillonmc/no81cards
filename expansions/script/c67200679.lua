--拟态武装 时之心
function c67200679.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c67200679.mfilter,c67200679.xyzcheck,3,3,c67200679.ovfilter,aux.Stringid(67200679,0),c67200679.xyzop)
	c:EnableReviveLimit() 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200679,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200679)
	e1:SetCost(c67200679.spcost)
	e1:SetTarget(c67200679.sptg)
	e1:SetOperation(c67200679.spop)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c67200679.atkval)
	c:RegisterEffect(e3)	 
end
--
function c67200679.mfilter(c,xyzc)
	return  c:IsCode(67200673) 
end
function c67200679.xyzcheck(g)
	return g:GetClassCount(c67200679.getlvrklk)==1
end
function c67200679.getlvrklk(c)
	if c:IsLevelAbove(0) then return c:GetLevel() end
	if c:IsLinkAbove(0) then return c:GetLink() end
	--return c:GetLink()
end
function c67200679.ovfilter(c)
	return c:IsFaceup() and c:IsCode(67200673)
end
function c67200679.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,67200679)==0 end
	Duel.RegisterFlagEffect(tp,67200679,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c67200679.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c67200679.spfilter(c,e,tp)
	return c:IsSetCard(0x667b) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c67200679.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67200679.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c67200679.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200679.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
--
function c67200679.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_MONSTER)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*1000
end