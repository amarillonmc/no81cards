--海造贼—海上摇滚团
function c67642209.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67642209,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67642209*1)
	e1:SetCondition(c67642209.spcon1)
	e1:SetTarget(c67642209.pctg)
	e1:SetOperation(c67642209.pcop)
	c:RegisterEffect(e1)	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67642209,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67642209*2)
	e2:SetCondition(c67642209.spcon2)
	e2:SetCost(c67642209.spcost)
	e2:SetTarget(c67642209.sptg)
	e2:SetOperation(c67642209.spop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,67642209*3)
	e3:SetCondition(c67642209.pencon)
	e3:SetTarget(c67642209.pentg)
	e3:SetOperation(c67642209.penop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c67642209.thcon3)
	c:RegisterEffect(e4)
end
--pendulum set
function c67642209.sdfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x13f)
end
function c67642209.spcon1(e)
	return not Duel.IsExistingMatchingCard(c67642209.sdfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67642209.pcfilter(c,tp)
	return not c:IsCode(67642209) and c:IsSetCard(0x13f) and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c67642209.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c67642209.pcfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c67642209.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67642209.pcfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g==0 or not Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
--special summon
function c67642209.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c67642209.costfilter(c,e,tp)
	return c:IsSetCard(0x13f) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c67642209.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c67642209.spfilter(c,e,tp)
	return c:IsSetCard(0x13f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c67642209.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67642209.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.DiscardHand(tp,c67642209.costfilter,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
end
function c67642209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67642209.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c67642209.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c67642209.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c67642209.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ft<=0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c67642209.splimit(e,c)
	return not c:IsSetCard(0x13f)
end
--move
function c67642209.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c67642209.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67642209.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c67642209.thcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end