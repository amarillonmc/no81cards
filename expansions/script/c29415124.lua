--隐匿之徒 菲尔
function c29415124.initial_effect(c)
	--xx 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29415124)
	e1:SetCondition(c29415124.xxcon)
	e1:SetTarget(c29415124.xxtg)
	e1:SetOperation(c29415124.xxop)
	c:RegisterEffect(e1) 
	--spe
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,19415124)
	e2:SetCondition(c29415124.specon) 
	e2:SetTarget(c29415124.spetg)
	e2:SetOperation(c29415124.speop)
	c:RegisterEffect(e2)
end 
function c29415124.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c29415124.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end  
end 
function c29415124.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		if tc:IsSummonableCard() and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29415124,0)) then 
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and c:IsAbleToDeck() then
				    Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				end 
		else  
			local te=tc:IsHasEffect(29415126)
			if te then 
				local op=te:GetOperation() 
				op(te,tp,eg,ep,ev,re,r,rp) 
			else 
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)  
			end  
		end 
	end   
end 
function c29415124.specon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x980)  
end 
function c29415124.thfilter(c)
	return c:IsSetCard(0x980) and c:IsAbleToHand()
end
function c29415124.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c29415124.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c29415124.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x980) 
end
function c29415124.xyzfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x980) 
end
function c29415124.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29415124.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g) 
		local xtable={aux.Stringid(29415124,3)} 
		if Duel.IsExistingMatchingCard(c29415124.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then 
			table.insert(xtable,aux.Stringid(29415124,1))
		end 
		if Duel.IsExistingMatchingCard(c29415124.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) then 
			table.insert(xtable,aux.Stringid(29415124,2))
		end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if xtable[op]==aux.Stringid(29415124,1) then 
			local sc=Duel.SelectMatchingCard(tp,c29415124.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst() 
			Duel.Summon(tp,sc,true,nil)
		end 
		if xtable[op]==aux.Stringid(29415124,2) then 
			local sc=Duel.SelectMatchingCard(tp,c29415124.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst() 
			Duel.XyzSummon(tp,sc,nil) 
		end 
	end
end









