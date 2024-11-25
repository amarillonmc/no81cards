--欢愉之七音服·波林蒂娅
local s,id,o=GetID()
function c98921084.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c98921084.matfilter1,nil,nil,c98921084.matfilter2,1,99)
	aux.EnablePendulumAttribute(c,false)	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921084,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_ACTIVATE_CONDITION)
	e1:SetCountLimit(1,98921084)
	e1:SetCondition(c98921084.drcon)
	e1:SetTarget(c98921084.drtg)
	e1:SetOperation(c98921084.drop)
	c:RegisterEffect(e1)
	--synchro
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98921084,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98931084)
	e4:SetTarget(c98921084.sctg)
	e4:SetOperation(c98921084.scop)
	c:RegisterEffect(e4)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function c98921084.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0x162)
end
function c98921084.matfilter2(c,syncard)
	return c:IsNotTuner(syncard) and c:IsType(TYPE_PENDULUM)
end
function c98921084.cfilter(c)
	return c:GetCurrentScale()%2==1 and c:IsFaceup() and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function c98921084.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98921084.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98921084.srfilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98921084.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921084.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921084.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921084.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c98921084.tefilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(98921084,1)) then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98921084,2))
		   local exg=Duel.SelectMatchingCard(tp,c98921084.tefilter,tp,LOCATION_DECK,0,1,1,nil)
		   Duel.SendtoExtraP(exg,nil,REASON_EFFECT)
	   end
	end
end
function c98921084.tefilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()%2==0
end
function c98921084.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c98921084.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98921084.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98921084.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98921084.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.tdfilter(c,tp)
	return c:IsAttackAbove(2000) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tdfilter,1,nil) and not eg:IsContains(e:GetHandler()) and Duel.IsExistingMatchingCard(c98921084.xxfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c98921084.xxfilter(c)
	return c:GetCurrentScale()%2==1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(s.tdfilter,nil)
	if chk==0 then return Duel.GetMZoneCount(tp,g,tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsType,nil,TYPE_MONSTER)
	local tc=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	elseif #g==1 then
		tc=g:GetFirst()
	end
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end