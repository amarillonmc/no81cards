--隐匿之徒暗中刺杀
function c29415127.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)   
	e1:SetCountLimit(1,29415127+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c29415127.target)
	e1:SetOperation(c29415127.operation)
	c:RegisterEffect(e1)
	--sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(29415126)  
	e2:SetRange(LOCATION_DECK)  
	e2:SetOperation(c29415127.spop) 
	c:RegisterEffect(e2) 
end  
function c29415127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c29415127.spfilter(c,e,tp)
	return c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29415127.tdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) 
end 
function c29415127.rmfil(c,xtc) 
	return c:IsFaceup() and c:IsAttackBelow(xtc:GetAttack()) and c:IsAbleToRemove(POS_FACEDOWN)
end 
function c29415127.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local x=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if x>0 then 
		local xtc=nil 
		local xg=Group.CreateGroup() 
		local i=0
		while i+1<=x do 
			local tc=Duel.GetFieldCard(tp,LOCATION_DECK,i) 
			Duel.ConfirmCards(tp,tc)
			Duel.ConfirmCards(1-tp,tc) 
			xg:AddCard(tc) 
			i=i+1 
			if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x980) then 
				xtc=tc 
				i=x+1 
			end 
		end   
		if xg:GetCount()>0 and Duel.Remove(xg,POS_FACEDOWN,REASON_EFFECT)~=0 and xtc and Duel.IsExistingMatchingCard(c29415127.rmfil,tp,0,LOCATION_MZONE,1,nil,xtc) and Duel.SelectYesNo(tp,aux.Stringid(29415127,0)) then 
			local rg=Duel.GetMatchingGroup(c29415127.rmfil,tp,0,LOCATION_MZONE,nil,xtc) 
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) 
		end 
	end 
end
function c29415127.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,29415127,0x980,TYPE_NORMAL+TYPE_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(29415127,1)) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	end
end







