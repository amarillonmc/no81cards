--青岚之精灵王 希纳瓦
-- c12345686.lua
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- Xyz Summon: 2 Level 9 monsters with different Attributes
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)
	
	-- Effect 1: On SpSummon, Remove materials -> Set S/T -> Enable Activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	
	-- Effect 2: No material, On P-Summon -> SpSummon from Grave/Rem
	-- "Existing on field have 1 time" implies NO_TURN_RESET
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	-- Effect 3: Grant Effect (Shuffle GY)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.xcon)
	e3:SetCost(s.xcost)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end

-- Xyz Procedure Filters
function s.mfilter(c,xyz,sumtype,tp)
	return c:IsXyzLevel(xyz,9)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

-- Effect 1
function s.setfilter(c)
	return c:IsSetCard(0x6c74) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local ct=c:GetOverlayCount()
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		
		if ct>0 and g:GetCount()>0 and ft>0 then
			local max=math.min(ct,g:GetCount(),ft,2)
			local num=c:RemoveOverlayCard(tp,1,max,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,num,num,nil)
			if sg:GetCount()>0 then
				Duel.SSet(tp,sg)
				
				-- Additional Effect: Enable activation
				local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				if ag:GetClassCount(Card.GetAttribute)>=3 then
					for tc in aux.Next(sg) do
						if tc:IsType(TYPE_TRAP) then
							local e1=Effect.CreateEffect(c)
							e1:SetType(EFFECT_TYPE_SINGLE)
							e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
							e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
							e1:SetReset(RESET_EVENT+RESETS_STANDARD)
							tc:RegisterEffect(e1)
						end
						if tc:IsType(TYPE_QUICKPLAY) then
							local e2=Effect.CreateEffect(c)
							e2:SetType(EFFECT_TYPE_SINGLE)
							e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
							e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
							e2:SetReset(RESET_EVENT+RESETS_STANDARD)
							tc:RegisterEffect(e2)
						end
					end
				end
			end
		end
	end
end

-- Effect 2
function s.pcheck(c,tp)
	return c:IsControler(tp) and c:IsLevel(9) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.pcheck,1,nil,tp) and e:GetHandler():GetOverlayCount()==0
end
function s.spfilter_e2(c,e,tp)
	return (c:IsLevel(9) or c:IsRank(9)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter_e2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter_e2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- Effect 3 (Granted)
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_XYZ) and c:GetRank()==9
end
function s.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end