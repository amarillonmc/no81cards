--童话荆棘雪魔女
function c77096004.initial_effect(c)
	aux.AddCodeList(c,72283691)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,77096004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c77096004.actg)
	e1:SetOperation(c77096004.acop)
	c:RegisterEffect(e1)
end
function c77096004.thfilter(c,e,tp)
	if not (c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,72283691) and not c:IsCode(77096002)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c77096004.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsCode(77096002) and c:IsAbleToHand() end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c77096004.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsCode(77096002) and c:IsAbleToHand() end,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0) 
end
function c77096004.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then 
		local tc=Duel.SelectMatchingCard(tp,c77096004.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end 




