--Dreaming the Sepialife
--Scripted by AlphaKretin
--For Nemoma
local s = c33701023
local id = 33701023
function s.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMING_MAIN_END)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --tograve
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.tgtg)
    e2:SetOperation(s.tgop)
    c:RegisterEffect(e2)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() ~= tp and Duel.IsAbleToEnterBP()
end
function s.rfilter(c,tp)
	return c:IsSetCard(0x144e) and (c:IsControler(tp) or c:IsFaceup())
end
function s.fgoal(sg,tp)
	if sg:GetCount()>0 and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
--    if chk == 0 then
--        return Duel.CheckReleaseGroupCost(tp, Card.IsSetCard, 2, false, aux.ReleaseCheckMMZ, nil, 0x144e)
--    end
--    local g = Duel.SelectReleaseGroupCost(tp, Card.IsSetCard, 2, 2, false, aux.ReleaseCheckMMZ, nil, 0x144e)
--    Duel.Release(g, REASON_COST)
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	if chk==0 then return rg:CheckSubGroup(s.fgoal,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,s.fgoal,false,2,2,tp)
	Duel.Release(g,REASON_COST)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    if Duel.IsChainDisablable(0) then
        local g = Duel.GetMatchingGroup(Card.IsAbleToGrave, tp, 0, LOCATION_MZONE, nil)
        if g:GetCount()>1 then --and Duel.SelectYesNo(1 - tp, aux.Stringid(id, 0)) then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
            Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_TOGRAVE)
            local sg = g:Select(1 - tp, 2, 2, nil)
            Duel.SendtoGrave(sg, REASON_EFFECT)
            Duel.NegateEffect(0)
            return
        end
    end
    Duel.SkipPhase(1 - tp, PHASE_BATTLE, RESET_PHASE + PHASE_END, 1)
end
function s.tgfilter(c)
    return c:IsSetCard(0x144e) and c:IsAbleToGrave()
end
function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 2, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 2, tp, LOCATION_DECK)
end
function s.tgop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 2, 2, nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g, REASON_EFFECT)
    end
end
