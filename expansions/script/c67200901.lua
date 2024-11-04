--岩戟之御咒姬
function c67200901.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200901,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,67200901)
	e2:SetCondition(c67200901.spcon)
	e2:SetTarget(c67200901.sptg)
	e2:SetOperation(c67200901.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200901,1))
	--e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetRange(LOCATION_HAND)
	--e3:SetCountLimit(1,67200902)
	e3:SetCondition(c67200901.stcon)
	e3:SetTarget(c67200901.sttg)
	e3:SetOperation(c67200901.stop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200901,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,67200902)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c67200901.settg)
	e4:SetOperation(c67200901.setop)
	c:RegisterEffect(e4)
end
function c67200901.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),0x67a)
end
function c67200901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200901.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200901.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_DECK) and e:GetHandler():IsFaceup()
end
function c67200901.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200901.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200901.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a) and c:IsType(TYPE_PENDULUM)
end
function c67200901.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsSetCard(0x67a) and chkc:IsType(TYPE_PENDULUM) end
	if chk==0 then return Duel.IsExistingTarget(c67200901.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectTarget(tp,c67200901.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	--Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c67200901.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x367a) 
end
function c67200901.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		if Duel.MoveToField(tg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 and tg:GetFirst():IsLocation(LOCATION_PZONE) and Duel.IsExistingMatchingCard(c67200901.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(67200901,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local gg=Duel.SelectMatchingCard(tp,c67200901.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #gg>0 then 
				Duel.SendtoHand(gg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,gg)
			end
		end
	end
end

