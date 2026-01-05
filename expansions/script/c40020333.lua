--溶星石 撞击瓣齿鲨
local s,id=GetID()


s.named_with_LavaAstral=1
function s.LavaAstral(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_LavaAstral
end

local OME_ID=40020321

function s.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,s.mfilter,2,2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON + CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END)
	e2:SetCountLimit(1, id+100) 
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

function s.mfilter(c)
	return s.LavaAstral(c)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.thfilter(c)
	return (c:IsCode(OME_ID) or s.LavaAstral(c)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.omepzcheck(tp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(OME_ID) end,tp,LOCATION_PZONE,0,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end

	local max=1
	if s.omepzcheck(tp) then max=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=nil
	if max==2 then
		local g1=g:Select(tp,1,1,nil)
		if g1:GetCount()>0 then
			local tc1=g1:GetFirst()
			g:Remove(Card.IsCode,nil,tc1:GetCode())
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				local g2=g:Select(tp,1,1,nil)
				g1:Merge(g2)
			end
		end
		sg=g1
	else
		sg=g:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.e2con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2
end

function s.desfilter(c)
	return c:IsCode(40020321)
end

function s.matfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.ffilter(c, e, tp, m, gc, chkf)
	return c:IsType(TYPE_FUSION) and s.LavaAstral(c)
		and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false)
		and c:CheckFusionMaterial(m, gc, chkf)
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then

		if not Duel.IsExistingMatchingCard(s.desfilter, tp, LOCATION_PZONE, 0, 1, nil) then return false end

		local mg = Duel.GetMatchingGroup(s.matfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
		local chkf = tp
		return Duel.IsExistingMatchingCard(s.ffilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg, c, chkf)
	end
	
	local g = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_PZONE, 0, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_GRAVE + LOCATION_REMOVED)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local dg = Duel.SelectMatchingCard(tp, s.desfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
	if dg:GetCount() > 0 and Duel.Destroy(dg, REASON_EFFECT) > 0 then

		if not c:IsRelateToEffect(e) or not s.matfilter(c) then return end
		
		local mg = Duel.GetMatchingGroup(s.matfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
		local chkf = tp
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local sg = Duel.SelectMatchingCard(tp, s.ffilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, mg, c, chkf)
		local tc = sg:GetFirst()
		
		if tc then

			local mat = Duel.SelectFusionMaterial(tp, tc, mg, c, chkf)
			tc:SetMaterial(mat)

			if Duel.SendtoDeck(mat, nil, SEQ_DECKSHUFFLE, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION) > 0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end