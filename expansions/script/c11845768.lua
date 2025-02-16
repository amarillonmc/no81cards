-- 数契尖兵 宇普西龙斩
local s, id ,o= GetID()
function s.initial_effect(c)
    -- 融合召唤
    c:EnableReviveLimit()
    
    aux.AddFusionProcFunFunRep(c,s.ffilter1,s.ffilter2, 2, 2,true, true) --②删去s.fcheck
      -- 效果①：特殊召唤成功时，选卡返回卡组
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.tdtg)
    e1:SetOperation(s.tdop)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(s.atkcon)
	e3:SetCost(s.atkcost)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.fcheck(g,lc)
	return g:IsExists(Card.IsFusionType,3,nil,(TYPE_MONSTER))
end
function s.ffilter1(c)
	return c:IsSetCard(0xf80) and c:IsType(TYPE_MONSTER)
end    
function s.ffilter2(c)
    return (c:IsFusionType(TYPE_FUSION) or c:IsFusionType(TYPE_SYNCHRO) or c:IsFusionType(TYPE_XYZ) or c:IsFusionType(TYPE_LINK)) and c:IsRace(RACE_CYBERSE)
end
-- 效果①目标筛选函数，修改为可检查对手区域的卡片
function s.tdfilter(c)
    return c:IsAbleToDeck()
end
-- 效果①目标设定函数，增加对手区域的检查
function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local owng = Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
        local oppg = Duel.IsExistingMatchingCard(s.tdfilter, 1 - tp, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
        return owng or oppg
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 0, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED)
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 1, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED)
end
-- 效果①操作函数，增加对手区域的选择
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
    local owng = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
    local oppg = Duel.GetMatchingGroup(s.tdfilter, 1 - tp, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
    local g = owng:Clone()
    g:Merge(oppg)
    if #g > 0 then
        local sg = g:Select(tp, 1, 5, nil)
        Duel.SendtoDeck(sg, nil, 1, REASON_EFFECT)
    end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end