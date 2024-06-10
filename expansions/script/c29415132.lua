--隐匿之徒 特美隆
function c29415132.initial_effect(c)
--xyz summon
c:EnableReviveLimit()
aux.AddXyzProcedureLevelFree(c,c29415132.mfilter,nil,5,99,c29415132.ovfilter,aux.Stringid(29415132,0),c29415132.xyzop)
	--spe
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,29415132)
	e1:SetCondition(c29415132.specon) 
	e1:SetTarget(c29415132.spetg)
	e1:SetOperation(c29415132.speop)
	c:RegisterEffect(e1)
	--xx 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19415132)
	e2:SetCondition(c29415132.xxcon)
	e2:SetCost(c29415132.xxcost) 
	e2:SetTarget(c29415132.xxtg)
	e2:SetOperation(c29415132.xxop)
	c:RegisterEffect(e2)
    if not c29415132.global_check then
        c29415132.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c29415132.checkop)
        Duel.RegisterEffect(ge1,0) 
    end
end
--xyz
function c29415132.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) then 
			tc:RegisterFlagEffect(29415132,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
		end 
		tc=eg:GetNext()
	end
end
function c29415132.mfilter(c,xyzc)
	return (c:IsSetCard(0x980) and c:IsLevelAbove(1)) or c:GetFlagEffect(29415132)~=0 
end
function c29415132.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x980) and c:IsRank(9) 
end
function c29415132.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil) 
	Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_COST) 
end
--remove
function c29415132.specon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end 
function c29415132.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function c29415132.srmfil(c,xtype) 
	return c:IsType(xtype) and c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)
end 
function c29415132.speop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		local xtype=0 
		if tc:IsType(TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		if Duel.IsExistingMatchingCard(c29415132.srmfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,1,c,xtype) then  
			local rg=Duel.GetMatchingGroup(c29415132.srmfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,c,xtype) 
			local ag=rg:Filter(c29415132.f,nil)
			if #ag>0 then
				Duel.ConfirmCards(tp,ag) 
				Duel.ConfirmCards(1-tp,ag)
			end
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end 
	end   
end
function c29415132.f(c)
	return c:IsFacedown()
end
--disable
function c29415132.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c29415132.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29415132.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=9 and 
	Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)end  
end 
function c29415132.seq(c,seq)
	return c:GetSequence()<seq
end
function c29415132.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>=9 then 
		local g=Duel.GetMatchingGroup(c29415132.seq,tp,LOCATION_DECK,0,nil,9)
		Duel.ConfirmCards(tp,g) 
		Duel.ConfirmCards(1-tp,g)
		local xtype=0 
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		local xg=Duel.GetMatchingGroup(c29415132.disfil,tp,0,LOCATION_ONFIELD,nil,xtype) 
		local tc=xg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
			tc=xg:GetNext()
		end
	end   
end 
function c29415132.disfil(c,xtype) 
	return c:IsType(xtype) and c:IsFaceup() 
end
