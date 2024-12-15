--狂风精灵 台风
function c51928006.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),1,99)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51928006,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,51928006)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c51928006.target)
	e1:SetOperation(c51928006.activate)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(nil,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51928006,ACTIVITY_SPSUMMON,c51928006.counterfilter)
end
function c51928006.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end

function c51928006.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end

function c51928006.filter(c,e,tp)
	return c:IsSetCard(0x9256) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51928006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(51928006,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51928006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c51928006.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c51928006.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelBelow(3) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(-3)
		c:RegisterEffect(e1)
		end
		
end
----------------------------