--地中族邪界兽·达尼尔黑死兽
function c98920061.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_EARTH),3,99,c98920061.lcheck)
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920061.btcon)
	e2:SetValue(c98920061.efilter)
	c:RegisterEffect(e2)
	--pos change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c98920061.target)
	e1:SetOperation(c98920061.activate)
	c:RegisterEffect(e1) 
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920061,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920061.spcon)
	e2:SetTarget(c98920061.sptg)
	e2:SetOperation(c98920061.spop)
	c:RegisterEffect(e2)
end
function c98920061.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_FLIP)
end
function c98920061.btfilter(c)
	return c:IsFacedown()
end
function c98920061.btcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c98920061.btfilter,1,nil)
end
function c98920061.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98920061.filter(c)
	return (c:IsFaceup() and c:IsCanTurnSet()) or c:IsFacedown()
end
function c98920061.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920061.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c98920061.filter,tp,0,LOCATION_MZONE,1,nil) end
	local rt=Duel.GetTargetCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if rt>5 then rt=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g1=Duel.SelectTarget(tp,c98920061.filter,tp,LOCATION_MZONE,0,1,rt,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g2=Duel.SelectTarget(tp,c98920061.filter,tp,0,LOCATION_MZONE,#g1,#g1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,#g2,0,0)
end
function c98920061.activate(e,tp,eg,ep,ev,re,r,rp)
	local gs=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for c in aux.Next(gs) do
		Duel.ChangePosition(c,c:IsFaceup() and POS_FACEDOWN_DEFENSE or POS_FACEUP_DEFENSE)
	end
end
function c98920061.cfilter1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c98920061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920061.cfilter1,1,nil,1-tp) and Duel.GetCurrentPhase()~=PHASE_DRAW 
end
function c98920061.spfilter(c,e,tp)
	return c:IsSetCard(0xed) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
end
function c98920061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920061.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920061.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920061.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
		if g:GetFirst():IsFacedown() then
			Duel.ConfirmCards(1-tp,g:GetFirst())
		end
	end
end