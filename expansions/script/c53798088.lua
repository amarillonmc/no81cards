local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Effect 1: Send to GY and Special Summon (Quick Effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	
	--Effect 2: Cannot be targeted
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end

--Effect 1 Check: Water & Fire in GY
function s.cfilter(c,att)
	return c:IsAttribute(att)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_FIRE)
end

--Effect 1 Targets
function s.tgfilter1(c,tp)
	return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function s.tgfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingTarget(s.tgfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,s.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	--Send Field monster to GY
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0 and tc1:IsLocation(LOCATION_GRAVE) then
		--Special Summon GY monster
		if tc2:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--Effect 2 Logic
function s.spfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end