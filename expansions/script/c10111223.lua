local s, id = GetID()

function s.initial_effect(c)
    -- 特殊召唤 + 抽卡效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 战斗效果封锁
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
end

-- 效果①：丢弃兽族/兽战士族幻兽特召+抽卡
function s.spfilter(c)
    return c:IsSetCard(0x1b) and (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR))
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then 
        return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND, 0, 1, c) 
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND, 0, 1, 1, c)
    Duel.SendtoGrave(g, REASON_COST + REASON_DISCARD)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        Duel.Draw(tp, 1, REASON_EFFECT)
    end
end

function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1b) and c:IsControler(tp)
end
function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and s.cfilter(a,tp)) or (d and s.cfilter(d,tp))
end