--隐匿之地
function c29415125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetOperation(c29415125.operation)
	c:RegisterEffect(e1) 
	-- 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCondition(c29415125.edcon)
	e2:SetTarget(c29415125.edtg)
	e2:SetOperation(c29415125.edop)
	c:RegisterEffect(e2) 
	-- 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c29415125.xxcon)
	e3:SetTarget(c29415125.xxtg)
	e3:SetOperation(c29415125.xxop)
	c:RegisterEffect(e3) 
	if not c29415125.global_check then
		c29415125.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29415125.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c29415125.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) then 
			tc:RegisterFlagEffect(29415125,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
		end 
		tc=eg:GetNext()
	end
end
function c29415125.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x980) 
end
function c29415125.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsSummonableCard,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) 
	if dcount>0 and Duel.SelectYesNo(tp,aux.Stringid(29415125,0)) then 
		local seq=-1
		local tc=g:GetFirst()
		local spcard=nil
		while tc do
			if tc:GetSequence()>seq then
				seq=tc:GetSequence()
				spcard=tc
			end
			tc=g:GetNext()
		end
		if seq==-1 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,dcount-seq) 
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,spcard) 
		if Duel.IsExistingMatchingCard(c29415125.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29415125,1)) then 
			local sc=Duel.SelectMatchingCard(tp,c29415125.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst() 
			Duel.Summon(tp,sc,true,nil) 
		end 
	end 
end
function c29415125.edcon(e,tp,eg,ep,ev,re,r,rp)  
	local bc=Duel.GetAttackTarget() 
	return bc and (bc:GetFlagEffect(29415125)~=0 or bc:IsSetCard(0x980))
end 
function c29415125.edtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local bc=Duel.GetAttackTarget() 
	if chk==0 then return bc and bc:IsAbleToDeck() end  
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end 
function c29415125.edop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget() 
	if bc:IsRelateToEffect(e) and Duel.SendtoDeck(bc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 and Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end 
function c29415125.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) 
end
function c29415125.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end  
end 
function c29415125.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		if tc:IsSummonableCard() then  
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then   
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end 
		else   
			local te=tc:IsHasEffect(29415126)
			if te then 
				local op=te:GetOperation() 
				op(te,tp,eg,ep,ev,re,r,rp)  
			end  
		end 
	end   
end 


