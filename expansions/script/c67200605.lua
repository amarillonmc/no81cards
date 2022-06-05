--征冥天的诱导者
--
function c67200605.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--hyper pendulum splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c67200605.splimit)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200605,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,67200605)
	e1:SetCost(c67200605.thcost)
	e1:SetTarget(c67200605.thtg)
	e1:SetOperation(c67200605.thop)
	c:RegisterEffect(e1)
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200605,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,67200605)
	e2:SetCondition(c67200605.stcon)
	e2:SetTarget(c67200605.sttg)
	e2:SetOperation(c67200605.stop)
	c:RegisterEffect(e2)  
end
--
function c67200605.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--
function c67200605.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200605.thfilter(c)
	return c:IsSetCard(0x677) and c:IsAbleToHand() and not c:IsCode(67200605)
end
function c67200605.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200605.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200605.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200605.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200605.cfilter1(c,tp)
	return c:IsSetCard(0x677) and c:GetSummonType()==SUMMON_TYPE_RITUAL and c:IsSummonPlayer(tp)
end
function c67200605.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and eg:IsExists(c67200605.cfilter1,1,nil,tp)
end
function c67200605.filter(c,tp)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c67200605.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c67200605.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200605.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c67200605.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c67200605.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end


