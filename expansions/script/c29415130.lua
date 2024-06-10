--隐匿之徒 纽创斯达尔
function c29415130.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c29415130.mfilter,nil,3,99,c29415130.ovfilter,aux.Stringid(29415130,0),c29415130.xyzop)
	--spe
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,29415130)
	e1:SetCondition(c29415130.specon) 
	e1:SetTarget(c29415130.spetg)
	e1:SetOperation(c29415130.speop)
	c:RegisterEffect(e1) 
	--xx 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19415130)
	e2:SetCondition(c29415130.xxcon)
	e2:SetCost(c29415130.xxcost) 
	e2:SetTarget(c29415130.xxtg)
	e2:SetOperation(c29415130.xxop)
	c:RegisterEffect(e2) 
	if not c29415130.global_check then
		c29415130.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29415130.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c29415130.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) then 
			tc:RegisterFlagEffect(29415130,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
		end 
		tc=eg:GetNext()
	end
end
function c29415130.mfilter(c,xyzc)
	return (c:IsSetCard(0x980) and c:IsLevelAbove(1)) or c:GetFlagEffect(29415130)~=0 
end
function c29415130.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x980) and c:IsRank(3) 
end
function c29415130.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,nil) end
	local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,5,nil) 
	Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_COST) 
end
function c29415130.specon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end 
function c29415130.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function c29415130.srmfil(c,xtype) 
	return c:IsType(xtype) and aux.NegateAnyFilter(c)  
end 
function c29415130.speop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		local xtype=0 
		if tc:IsType(TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		if Duel.IsExistingMatchingCard(c29415130.srmfil,tp,0,LOCATION_ONFIELD,1,nil,xtype) and Duel.SelectYesNo(tp,aux.Stringid(29415130,1)) then 
			Duel.BreakEffect() 
			local dc=Duel.SelectMatchingCard(tp,c29415130.srmfil,tp,0,LOCATION_ONFIELD,1,1,nil,xtype):GetFirst() 
			Duel.NegateRelatedChain(dc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			dc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			dc:RegisterEffect(e2)
			if dc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				dc:RegisterEffect(e3)
			end
		end 
	end   
end 
function c29415130.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c29415130.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29415130.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end  
end 
function c29415130.seq(c,seq)
	return c:GetSequence()<seq
end
function c29415130.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>=3 then 
		local g=Duel.GetMatchingGroup(c29415130.seq,tp,LOCATION_DECK,0,nil,3)
		Duel.ConfirmCards(tp,g) 
		Duel.ConfirmCards(1-tp,g)
		local xtype=0 
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetTargetRange(LOCATION_MZONE,0) 
		e1:SetLabel(xtype)
		e1:SetTarget(function(e,c) 
		return c:IsSetCard(0x980) end)
		e1:SetOwnerPlayer(tp)
		e1:SetValue(function(e,te)
		return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(e:GetLabel()) end) 
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end   
end 








