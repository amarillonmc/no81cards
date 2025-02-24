--Day by Day 鹿乃
function c75646418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646418,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c75646418.condition)
	e2:SetCost(c75646418.cost)
	e2:SetTarget(c75646418.target)
	e2:SetOperation(c75646418.operation)
	c:RegisterEffect(e2)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75646418,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,75646418)
	e5:SetCost(c75646418.cost1)
	e5:SetTarget(c75646418.tg)
	e5:SetOperation(c75646418.op)
	c:RegisterEffect(e5)
end
function c75646418.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c75646418.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 end
	if g:GetFirst():IsSetCard(0x32c4) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646418.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c4)
end
function c75646418.spfilter(c,e,tp)
	return c:IsSetCard(0x32c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646418.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c75646418.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646418.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c75646418.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646418.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c75646418.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		else
			e1:SetReset(RESET_PHASE+PHASE_MAIN2)
		end
		e1:SetValue(c75646418.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
	if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646418.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75646418,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75646418.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c75646418.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end

function c75646418.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c75646418.filter1(c,e,tp)
	return c:IsSetCard(0x32c4) and c:GetPreviousControler()==tp
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_COST) and c:IsCanBeEffectTarget(e) and not c:IsForbidden()
end
function c75646418.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c75646418.filter1(chkc,e,tp) end
	if chk==0 then return re and re:GetHandler()~=e:GetHandler() and re:IsHasType(0x7f0) and eg:IsExists(c75646418.filter1,1,nil,e,tp) end
	local g=eg:Filter(c75646418.filter1,nil,e,tp)
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c75646418.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end