--晦月之精灵王 诺伊亚斯
-- c12345688.lua
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- Xyz Summon: 2 Rank 9 monsters with different Attributes
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)
	
	-- Effect 1: Attach up to 2 from GY/Rem, then attach opponent card (Conditional)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)
	
	-- Effect 2: Negate effect, Banish FD (Conditional)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	
	-- Effect 3: Leave field SpSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

-- Xyz Procedure Filters
function s.mfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ) and c:IsRank(9)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

-- Effect 1
function s.attfilter(c)
	return (c:IsLevel(9) or c:IsRank(9)) and c:IsCanOverlay() and c:IsFaceupEx()
end
function s.oppattfilter(c,tp)
	return c:IsCanOverlay() and (c:IsControler(1-tp) or c:IsAbleToChangeControler())
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.attfilter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) 
		and Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToChain() and c:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.attfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
		
		-- Additional Attach
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if ag:GetClassCount(Card.GetAttribute)>=3 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.oppattfilter),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local oc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.oppattfilter),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,tp):GetFirst()
			if not oc:IsImmuneToEffect(e) then
				Duel.Overlay(c,oc)
			end
		end
	end
end

-- Effect 2
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc:IsLevel(9) or tc:IsRank(9) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if e:GetLabel()==1 and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and e:GetLabel()==1 then
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end

-- Effect 3
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) 
		and c:GetReasonPlayer()==1-tp and c:GetPreviousOverlayCountOnField()>0
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x6c74) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
