-- 数契尖兵 贝塔的信条
local s,id,o=GetID()
function s.initial_effect(c)
    -- 融合召唤
    c:EnableReviveLimit()
    aux.AddFusionProcFunFun(c,s.ffilter1,s.ffilter2,1,1,true,true) 
    -- 效果①：检索并盖放
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.thcon)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)   
    -- 效果②：无效并返回卡组
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id+o)
    e2:SetCondition(s.negcon)
    e2:SetCost(s.negcost)
    e2:SetTarget(aux.nbtg)
    e2:SetOperation(s.negop)
    c:RegisterEffect(e2)
end
function s.fcheck(g,lc)
	return g:IsExists(Card.IsFusionType,2,nil,(TYPE_MONSTER))
end
function s.ffilter1(c)
	return c:IsSetCard(0xf80) and c:IsType(TYPE_MONSTER)
end    
function s.ffilter2(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.thcon(e,tp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.thfilter(c)
    return c:IsSetCard(0xf80) and (c:IsAbleToHand() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()))
end
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,
    LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        if Duel.SendtoHand(g, nil, REASON_EFFECT) then
            local dc = Duel.GetOperatedGroup():GetFirst()
            if dc:IsType(TYPE_QUICKPLAY + TYPE_TRAP) and dc:IsSSetable()
                and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
                Duel.BreakEffect()
                if Duel.SSet(tp, dc, tp, false) == 0 then return end
                if dc:IsType(TYPE_QUICKPLAY) then
                    local e1 = Effect.CreateEffect(e:GetHandler())
                    e1:SetDescription(aux.Stringid(id, 2))
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                    e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
                    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
                    dc:RegisterEffect(e1)
                end
                if dc:IsType(TYPE_TRAP) then
                    local e1 = Effect.CreateEffect(e:GetHandler())
                    e1:SetDescription(aux.Stringid(id, 2))
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
                    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
                    dc:RegisterEffect(e1)
                end
            end
        end
        Duel.ConfirmCards(1 - tp, g)
    end
end
function s.costfilter(c)
    return c:IsRace(RACE_CYBERSE)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,false,nil,nil,RACE_CYBERSE,LOCATION_HAND+LOCATION_MZONE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,false,nil,nil,RACE_CYBERSE,LOCATION_HAND+LOCATION_MZONE)
	Duel.Release(g,REASON_COST)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end