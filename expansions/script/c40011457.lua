--蒸汽淑女 艾璐璐
function c40011457.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xaf1a),1)
	c:EnableReviveLimit()
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end) 
	e1:SetOperation(c40011457.xxop) 
	c:RegisterEffect(e1) 
	--to hand/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40011457,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40011457)
	e2:SetCost(c40011457.thcost) 
	e2:SetTarget(c40011457.thtg)
	e2:SetOperation(c40011457.thop)
	c:RegisterEffect(e2) 
	--to hand/spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40011457,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40011457+1)
	e3:SetCost(c40011457.rmcost) 
	e3:SetTarget(c40011457.rmtg)
	e3:SetOperation(c40011457.rmop)
	c:RegisterEffect(e3)
end
function c40011457.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(40011457)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end 
function c40011457.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function c40011457.thfilter(c,e,tp)
	if not (c:IsSetCard(0x1af1a) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c40011457.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011457.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c40011457.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c40011457.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end 
function c40011457.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xaf1a) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xaf1a) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function c40011457.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and Card.IsAbleToRemove(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c40011457.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end






