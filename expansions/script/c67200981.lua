--众星修正者 伐灭
function c67200981.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200981,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200981)
	e1:SetTarget(c67200981.target)
	e1:SetOperation(c67200981.activate)
	c:RegisterEffect(e1)   
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200981,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c67200981.spcon)
	e3:SetTarget(c67200981.sptg)
	e3:SetOperation(c67200981.spop)
	c:RegisterEffect(e3) 
end
function c67200981.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa67a)
end
function c67200981.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200981.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_DECK)
end
function c67200981.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200981,2))
	local g=Duel.SelectMatchingCard(tp,c67200981.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
--
function c67200981.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c67200981.spfilter(c,e,tp)
	return c:IsSetCard(0x67a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200981.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67200981.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c67200981.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200981.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end