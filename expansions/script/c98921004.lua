--复苏的机壳
function c98921004.initial_effect(c)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921004,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,98921004)
	e1:SetTarget(c98921004.thtg)
	e1:SetOperation(c98921004.thop)
	c:RegisterEffect(e1)	
--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c98921004.reptg)
	e2:SetValue(c98921004.repval)
	e2:SetOperation(c98921004.repop)
	c:RegisterEffect(e2)
end
function c98921004.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xaa) and c:IsType(TYPE_MONSTER)
end
function c98921004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921004.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c98921004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98921004.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)		
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c98921004.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(98921004,0)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,c98921004.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
				local sc=sg:GetFirst()
				if sc then
					Duel.Summon(tp,sc,true,nil)
				end
		end
	end
end
function c98921004.sumfilter(c)
	return c:IsSetCard(0xaa) and c:IsSummonable(true,nil)
end
function c98921004.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xaa)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsType(TYPE_PENDULUM)
end
function c98921004.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c98921004.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c98921004.repval(e,c)
	return c98921004.repfilter(c,e:GetHandlerPlayer())
end
function c98921004.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end