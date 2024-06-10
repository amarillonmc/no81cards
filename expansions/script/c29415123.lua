--隐匿之徒 海德
function c29415123.initial_effect(c)
	--xx 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29415123)
	e1:SetCondition(c29415123.xxcon)
	e1:SetTarget(c29415123.xxtg)
	e1:SetOperation(c29415123.xxop)
	c:RegisterEffect(e1) 
	--spe
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,19415123)
	e2:SetCondition(c29415123.specon) 
	e2:SetTarget(c29415123.spetg)
	e2:SetOperation(c29415123.speop)
	c:RegisterEffect(e2)
end 
function c29415123.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c29415123.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end  
end 
function c29415123.xxop(e,tp,eg,ep,ev,re,r,rp)
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
function c29415123.specon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x980)  
end 
function c29415123.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function c29415123.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then  
		local x=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) 
		if x>3 then x=3 end 
		xtable={} 
		for i=1,x do 
			table.insert(xtable,i)
		end 
		local ct=Duel.AnnounceNumber(tp,table.unpack(xtable)) 
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if g:GetCount()>0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,ct,nil)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			g=g-sg
			if g:GetCount()>0 then
				Duel.SortDecktop(tp,tp,g:GetCount())
			end
		end
	end 
end








