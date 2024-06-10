--隐匿之徒地下集会
function c29415126.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)   
	e1:SetCountLimit(1,29415126+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c29415126.target)
	e1:SetOperation(c29415126.operation)
	c:RegisterEffect(e1)
	--sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(29415126)  
	e2:SetRange(LOCATION_DECK)  
	e2:SetOperation(c29415126.spop) 
	c:RegisterEffect(e2) 
end 
function c29415126.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function c29415126.spfilter(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSummonableCard()) or c:IsHasEffect(29415126)  
end
function c29415126.tdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) 
end 
function c29415126.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 then 
		local tc1=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc1) 
		Duel.ConfirmCards(1-tp,tc1)  
		local tc2=Duel.GetFieldCard(tp,LOCATION_DECK,1) 
		Duel.ConfirmCards(tp,tc2) 
		Duel.ConfirmCards(1-tp,tc2)  
		local tc3=Duel.GetFieldCard(tp,LOCATION_DECK,2) 
		Duel.ConfirmCards(tp,tc3) 
		Duel.ConfirmCards(1-tp,tc3)  
		local g=Group.FromCards(tc1,tc2,tc3):Filter(c29415126.spfilter,nil,e,tp)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29415126,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			local te=sc:IsHasEffect(29415126) 
			if te then 
				local op=te:GetOperation() 
				op(te,tp,eg,ep,ev,re,r,rp)
			else 
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
			g:RemoveCard(sc)
			if g:GetCount()~=0 then
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			end
			if sc:IsSetCard(0x980) and Duel.IsExistingMatchingCard(c29415126.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29415126,2)) then 
				local sg=Duel.SelectMatchingCard(tp,c29415126.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)  
				Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT) 
			end
		else
			g=Group.FromCards(tc1,tc2,tc3)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end 
end
function c29415126.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,29415126,0x980,TYPE_NORMAL+TYPE_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(29415126,1)) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	end
end
