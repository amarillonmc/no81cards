--术结天缘 变异水母
function c67200419.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5671),3,2)   
	--destroy & search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200411,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200411)
	e1:SetTarget(c67200411.sptg)
	e1:SetOperation(c67200411.spop)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200419,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c67200419.poscost)
	e2:SetTarget(c67200419.postg)
	e2:SetOperation(c67200419.posop)
	c:RegisterEffect(e2) 
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200419,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c67200419.pencon)
	e5:SetTarget(c67200419.pentg)
	e5:SetOperation(c67200419.penop)
	c:RegisterEffect(e5)
end
c67200419.pendulum_level=3
--
function c67200411.thfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHand()
end
function c67200411.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(c67200411.spfilter,tp,LOCATION_DECKBOT,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200411.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if tc:IsSetCard(0x5671) then
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(c,tc)
	end
end
--
function c67200419.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c67200419.posfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanTurnSet()
end
function c67200419.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200419.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c67200419.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c67200419.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local pg=Duel.SelectMatchingCard(tp,c67200419.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if pg:GetCount()>0 then
		Duel.HintSelection(pg)
		local pc=pg:GetFirst()
		if pc:IsFaceup() then
			Duel.ChangePosition(pc,POS_FACEDOWN_DEFENSE)
		end
	end
end
--
function c67200419.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200419.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200419.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


