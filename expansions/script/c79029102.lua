--使徒·行动-济世
function c79029102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c79029102.condition)
	e1:SetTarget(c79029102.target)
	e1:SetOperation(c79029102.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c79029102.spcon)
	e2:SetTarget(c79029102.sptg)
	e2:SetOperation(c79029102.spop)
	c:RegisterEffect(e2) 
	--to deck and draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c79029102.tdtg)
	e3:SetOperation(c79029102.tdop)
	c:RegisterEffect(e3)
end
function c79029102.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,e,tp,0xa900)
end
function c79029102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(ev))
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029102.activate(e,tp,eg,ep,ev,re,r,rp)
		local val=Duel.Recover(tp,math.ceil(ev),REASON_EFFECT)  
if val>=800 then
			Duel.Draw(tp,1,REASON_EFFECT)
if val>=1600 then
			Duel.Draw(tp,1,REASON_EFFECT)
if val>=2400 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
end
function c79029102.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c79029102.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2909)
end
function c79029102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		return loc~=0 and Duel.IsExistingMatchingCard(c79029102.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c79029102.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029102.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029102.sfilter(c)
	return c:IsSetCard(0x2909)
end
function c79029102.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029102.sfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c79029102.sfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local x=Duel.GetFirstTarget():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,x)
end
function c79029102.tdop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFirstTarget():GetAttack()
	Duel.Recover(tp,x,REASON_EFFECT)
end






	


