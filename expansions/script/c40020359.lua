--天人-00强化翼[粒子储存罐型]
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

function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local owner=c:GetOwner()
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and Duel.GetFlagEffect(owner,ArmedIntervention)>=5
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
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetAttacker() then
			Duel.BreakEffect()
			Duel.NegateAttack()
		end
	end
end

function s.get_lv_rk(c)
	if c:GetLevel()>0 then return c:GetLevel() end
	if c:GetRank()>0 then return c:GetRank() end
	return 0
end

function s.tgfilter(c)
	return s.CelestialBeing(c) and c:IsAbleToGrave()
end

function s.thfilter(c)
	return s.CelestialBeing(c) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end

function s.tdfilter(c)
	return (c:IsLevelAbove(5) or c:IsCode(40020383)) and c:IsAbleToDeck()
end

function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)

end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=g1:Select(tp,1,1,nil)
	if Duel.SendtoGrave(sg1,REASON_EFFECT)>0 and sg1:GetFirst():IsLocation(LOCATION_GRAVE) then
		local g2=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			if Duel.SendtoHand(sg2,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,sg2)
				local g_td=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
				local g_des=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
				if #g_td>0 and #g_des>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
					local sg_td=g_td:Select(tp,1,1,nil)
					if Duel.SendtoDeck(sg_td,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local sg_des=g_des:Select(tp,1,1,nil)
						Duel.HintSelection(sg_des)
						Duel.Destroy(sg_des,REASON_EFFECT)
					end
				end
			end
		end
	end
end