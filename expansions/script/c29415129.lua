--隐匿之徒 茵芬农
function c29415129.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c29415129.mfilter,nil,2,99) 
	--spe
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,29415129)
	e1:SetCondition(c29415129.specon) 
	e1:SetTarget(c29415129.spetg)
	e1:SetOperation(c29415129.speop)
	c:RegisterEffect(e1) 
	--xx 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19415129)
	e2:SetCondition(c29415129.xxcon)
	e2:SetCost(c29415129.xxcost) 
	e2:SetTarget(c29415129.xxtg)
	e2:SetOperation(c29415129.xxop)
	c:RegisterEffect(e2) 
	if not c29415129.global_check then
		c29415129.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29415129.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c29415129.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) then 
			tc:RegisterFlagEffect(29415129,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
		end 
		tc=eg:GetNext()
	end
end
function c29415129.mfilter(c,xyzc)
	return (c:IsSetCard(0x980) and c:IsLevelAbove(1)) or c:GetFlagEffect(29415129)~=0 
end
function c29415129.specon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end 
function c29415129.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function c29415129.srmfil(c,xtype) 
	return c:IsType(xtype) and c:IsAbleToRemove() and c:IsFaceup()  
end 
function c29415129.speop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		local xtype=0 
		if tc:IsType(TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		if Duel.IsExistingMatchingCard(c29415129.srmfil,tp,0,LOCATION_ONFIELD,1,nil,xtype) and Duel.SelectYesNo(tp,aux.Stringid(29415129,0)) then 
			Duel.BreakEffect() 
			local rg=Duel.SelectMatchingCard(tp,c29415129.srmfil,tp,0,LOCATION_ONFIELD,1,1,nil,xtype) 
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
		end 
	end   
end 
function c29415129.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c29415129.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29415129.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end  
end 
function c29415129.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		if tc:IsSummonableCard() then  
			if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29415129,1)) then  
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)  
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
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








