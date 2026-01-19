--光耀之精灵王 戴斯蒂娜
-- c12345687.lua
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- Xyz Summon: 2 Rank 9 monsters with different Attributes
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)
	
	-- Effect 1: Attach from GY/Rem, then Deck (Conditional)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)
	
	-- Effect 2: Bounce material to hand, SpSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
	-- Effect 3: Search S/T, Xyz Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.xyzcon)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end

-- Xyz Procedure Filters
function s.mfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ) and c:IsRank(9,xyz,sumtype,tp)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

-- Effect 1
function s.attfilter(c)
	return (c:IsLevel(9) or c:IsRank(9)) and c:IsCanOverlay() and c:IsFaceupEx()
end
function s.dkfilter(c)
	return c:IsLevel(9) and c:IsCanOverlay()
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.attfilter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) 
		and Duel.IsExistingTarget(s.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	if c:IsRelateToChain() and c:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,s.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
		
		-- Additional Deck Attach
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if ag:GetClassCount(Card.GetAttribute)>=3 
			and Duel.IsExistingMatchingCard(s.dkfilter,tp,LOCATION_DECK,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local dg=Duel.SelectMatchingCard(tp,s.dkfilter,tp,LOCATION_DECK,0,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Overlay(c,dg)
			end
		end
	end
end

-- Effect 2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.thfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(9) 
		and c:GetOverlayGroup():IsExists(s.matfilter,1,nil)
end
function s.matfilter(c)
	return c:IsLevel(9) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsLevel(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		local mg=tc:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=mg:FilterSelect(tp,s.matfilter,1,1,nil)
		if sg:GetCount()>0 then
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,sg)
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
					and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) 
					and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
					if sc:GetCount()>0 then
						Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			end
		end
	end
end

-- Effect 3
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) 
		and c:GetReasonPlayer()==1-tp and c:GetPreviousOverlayCountOnField()>0
end
function s.stfilter(c)
	return c:IsSetCard(0x6c74) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function s.xyzfilter(c,tp)
	return c:IsRank(9) and c:IsXyzSummonable(nil)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(s.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(s.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if sc then
				Duel.XyzSummon(tp,sc,nil)
			end
		end
	end
end
