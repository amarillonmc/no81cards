--天人-量子型00
local s,id=GetID()
s.ui_hint_effect = s.ui_hint_effect or {}
local CORE_ID = 40020353 
local ArmedIntervention = CORE_ID	  
local ArmedIntervention_UI = CORE_ID + 10000
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
--00
s.named_with_oo=1
function s.oo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_oo
end
--量子型
s.named_with_QanT=1
function s.QanT(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_QanT
end

function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local owner=e:GetHandler():GetOwner()
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(owner,ArmedIntervention)>=7
end
function s.costfilter(c, use_extended)
	if not (c:IsFaceup() and c:IsReleasable()) then return false end
	if s.Exia(c) then
		return use_extended or c:IsType(TYPE_MONSTER)
	end
	if s.oo(c) then
		return c:IsType(TYPE_MONSTER)
	end 
	return false
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local use_extended = aux.IsCanBeQuickEffect(c,tp,40020377)
	local loc = LOCATION_MZONE
	if use_extended then loc = LOCATION_ONFIELD end 
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,1,nil,use_extended)
	end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,1,1,nil,use_extended)
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,25)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local owner=c:GetOwner()
		if Duel.GetFlagEffect(owner,ArmedIntervention)>=9 then
			local deck_count = 25
			local eg=c:GetEquipGroup()
			local has_equip = eg:IsExists(function(ec) 
				return ec:IsCode(40020369) and not ec:IsDisabled() 
			end, 1, nil)
			
			if has_equip then
				deck_count = 20
			end
			if Duel.IsPlayerCanDiscardDeck(tp, deck_count) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				if Duel.DiscardDeck(tp, deck_count, REASON_EFFECT) > 0 then
					local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
					if #g>0 then
						Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
					end
				end
			end
		end
	end
end

function s.tdfilter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5))or c:IsCode(40020383) and c:IsAbleToDeck()
end

function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end

function s.descheck(g, lv_limit)
	local sum = g:GetSum(function(c) 
		local val = 0
		if c:GetLevel()>0 then val = val + c:GetLevel() end
		if c:GetRank()>0 then val = val + c:GetRank() end
		return val
	end)
	return sum <= lv_limit
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
			 if c:IsRelateToEffect(e) and c:IsFaceup() then
				 local e1=Effect.CreateEffect(c)
				 e1:SetType(EFFECT_TYPE_SINGLE)
				 e1:SetCode(EFFECT_UPDATE_LEVEL)
				 e1:SetValue(3)
				 e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
				 c:RegisterEffect(e1)
				 local current_lv = c:GetLevel()
				 local dg = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
				 if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					 Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
					 local sg = dg:SelectSubGroup(tp, s.descheck, false, 1, #dg, current_lv)
					 if sg and #sg>0 then
						 Duel.HintSelection(sg)
						 Duel.Destroy(sg, REASON_EFFECT)
					 end
				 end
			 end
		end
	end
end
