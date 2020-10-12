function c82221062.initial_effect(c) 
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()  
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(aux.ritlimit)  
	c:RegisterEffect(e0) 
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221062,1))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCost(c82221062.spcost)  
	e1:SetTarget(c82221062.sptg)  
	e1:SetOperation(c82221062.spop)  
	c:RegisterEffect(e1)  
	--send to extrap
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221062,2))  
	e2:SetCategory(CATEGORY_TOEXTRA)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetCountLimit(1,82221062)  
	e2:SetTarget(c82221062.sctg)  
	e2:SetOperation(c82221062.scop)  
	c:RegisterEffect(e2)  
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82221062,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82231062)
	e3:SetTarget(c82221062.rmtg)
	e3:SetOperation(c82221062.rmop)
	c:RegisterEffect(e3)
end
function c82221062.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
end  
function c82221062.spfilter(c,e,tp)  
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsSetCard(0x99) or c:IsSetCard(0x9f)) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82221062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82221062.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)  
end  
function c82221062.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82221062.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function c82221062.scfilter(c,pc)  
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x99) or c:IsSetCard(0x9f)) and not c:IsForbidden()  
end  
function c82221062.sctg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221062.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end  
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)  
end  
function c82221062.scop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)  
	local g=Duel.SelectMatchingCard(tp,c82221062.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)  
	local tc=g:GetFirst()  
	if tc then
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT) 
	end  
end  
function c82221062.rmfilter(c)  
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)  
end  
function c82221062.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221062.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(c82221062.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function c82221062.rmop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c82221062.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)  
	end  
end  