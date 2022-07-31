--
function c6160001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6160001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,6160001)
	e1:SetTarget(c6160001.target)
	e1:SetOperation(c6160001.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	 --splimit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(c6160001.splimit)  
	c:RegisterEffect(e3)
end
function c6160001.filter(c,e,tp)
	return c:IsSetCard(0x616) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(3) and not c:IsCode(6160001)
end
function c6160001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.IsExistingMatchingCard(c6160001.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c6160001.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HintSelection,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6160001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end  
end 
function c6160001.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end