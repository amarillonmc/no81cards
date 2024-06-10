--隐匿之徒 阿贝斯
function c29415131.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c29415131.mfilter,nil,4,99,c29415131.ovfilter,aux.Stringid(29415131,0),c29415131.xyzop)
	--spe
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,29415131)
	e1:SetCondition(c29415131.specon) 
	e1:SetTarget(c29415131.spetg)
	e1:SetOperation(c29415131.speop)
	c:RegisterEffect(e1) 
	--xx 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19415131)
	e2:SetCondition(c29415131.xxcon)
	e2:SetCost(c29415131.xxcost) 
	e2:SetTarget(c29415131.xxtg)
	e2:SetOperation(c29415131.xxop)
	c:RegisterEffect(e2) 
	if not c29415131.global_check then
		c29415131.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29415131.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c29415131.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and re:GetHandler():IsSetCard(0x980) then 
			tc:RegisterFlagEffect(29415131,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TEMP_REMOVE,0,1)
		end 
		tc=eg:GetNext()
	end
end
function c29415131.mfilter(c,xyzc)
	return (c:IsSetCard(0x980) and c:IsLevelAbove(1)) or c:GetFlagEffect(29415131)~=0 
end
function c29415131.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x980) and c:IsRank(6) 
end
function c29415131.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,10,nil) end
	local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,10,10,nil) 
	Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_COST) 
end
function c29415131.specon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end 
function c29415131.spetg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function c29415131.srmfil(c,xtype) 
	return c:IsType(xtype) and c:IsAbleToDeck() and c:IsFaceup() 
end 
function c29415131.speop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0) 
		Duel.ConfirmCards(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)  
		local xtype=0 
		if tc:IsType(TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		if Duel.IsExistingMatchingCard(c29415131.srmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,xtype) then  
			local rg=Duel.GetMatchingGroup(c29415131.srmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,xtype) 
			Duel.SendtoDeck(rg,nil,SEQ_DECKBOTTOM,REASON_EFFECT) 
		end 
	end   
end 
function c29415131.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end
function c29415131.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29415131.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end  
end 
function c29415131.stdgck(g) 
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end 
function c29415131.seq(c,seq)
	return c:GetSequence()<seq
end
function c29415131.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>=6 then 
		local g=Duel.GetMatchingGroup(c29415132.seq,tp,LOCATION_DECK,0,nil,6)
		Duel.ConfirmCards(tp,g) 
		Duel.ConfirmCards(1-tp,g)
		local xtype=0 
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then xtype=bit.bor(xtype,TYPE_MONSTER) end 
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then xtype=bit.bor(xtype,TYPE_SPELL) end 
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then xtype=bit.bor(xtype,TYPE_TRAP) end 
		local xg=Duel.GetMatchingGroup(c29415131.srmfil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil,xtype) 
		if xg:CheckSubGroup(c29415131.stdgck,1,3) and Duel.SelectYesNo(tp,aux.Stringid(29415131,1)) then 
			Duel.BreakEffect() 
			local sxg=xg:SelectSubGroup(tp,c29415131.stdgck,false,1,3) 
			Duel.SendtoDeck(sxg,nil,SEQ_DECKBOTTOM,REASON_EFFECT) 
		end 
	end   
end 

