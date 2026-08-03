-- 衔尾·魂器练成
local s,id,o=GetID()
function s.initial_effect(c)
Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_END_PHASE+TIMING_DAMAGE_STEP)
    e2:SetCountLimit(1, id)  
    e2:SetCondition(s.rmcon)                   -- 卡名一回合一次
    e2:SetCost(s.cost)
    e2:SetTarget(s.tg1)
    e2:SetOperation(s.op1)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_END_PHASE+TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.tg2)
	e3:SetOperation(s.op2)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e4)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,id)~=Duel.GetTurnCount()-1
end
function s.costfilter(c)
	 return c:IsAbleToDeckAsCost()
        and (not c:IsLocation(LOCATION_GRAVE) or c:IsSetCard(0xeaea))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,nil) end
	local sg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,3,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	 -- 返回卡组并洗切
    if #sg ~= 3 then return end
    -- 分两次让玩家选择放入卡组最底部的卡（先选的会沉在最底部）
    for i = 1,3 do   -- “选择要放在卡组最下面的卡”
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tc = sg:Select(tp, 1, 1, nil):GetFirst()
        sg:RemoveCard(tc)
        Duel.SendtoDeck(tc,tp,SEQ_DECKSHUFFLE,REASON_COST) 
        tc:ReverseInDeck()
    end
end
-- ①效果发动时（无实际处理，仅设置标记并注册下次战斗阶段的处理效果）
function s.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
end

function s.op1(e, tp, eg, ep, ev, re, r, rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.e1op2)
	if Duel.GetCurrentPhase()==PHASE_BATTLE_START then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.retcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE_START,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
	end
	Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE+PHASE_BATTLE,0,1,Duel.GetTurnCount())
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
-- 处理控制权夺取
function s.e1op2(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_CARD,0,id)
    if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged, tp, 0, LOCATION_MZONE, 1, nil) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONTROL)
        local g = Duel.SelectMatchingCard(tp, Card.IsControlerCanBeChanged, tp, 0, LOCATION_MZONE, 1, 1, nil)
        if #g > 0 then
            Duel.GetControl(g:GetFirst(), tp)
        end
    end
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        local g = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
        return #g >= 1 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) > 0
    end
end
-- ②效果处理
function s.op2(e,tp,eg,ep,ev,re,r,rp)
    local g = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, nil)
    if #g < 1 then return end
    Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 2))
    local sg = g:Select(tp, 1, 1, nil)
		Duel.HintSelection(sg)
    if #sg ~= 1 then return end
    -- 分两次让玩家选择放入卡组最底部的卡（先选的会沉在最底部）
    do
        local tc = sg:GetFirst()
        sg:RemoveCard(tc)
        Duel.SendtoDeck(tc, tp, SEQ_DECKBOTTOM, REASON_EFFECT)
		tc:ReverseInDeck()
    end
		Duel.BreakEffect()
    -- 从对方卡组顶翻开1张并加入手卡
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK) == 0 then return end
    local tc = Duel.GetDecktopGroup(1 - tp, 1):GetFirst()
    if tc then
        Duel.ConfirmCards(tp, tc)
        Duel.SendtoHand(tc, tp, REASON_EFFECT)
    end
end

function s.rmfilter(c,tp)
	return c:IsAbleToHand()
end
-- ②效果可选卡的过滤器：若从墓地选则必须是「衔尾·」卡
function s.filter2(c) -- TODO: 替换为实际的「衔尾·」字段 setcode
    return c:IsAbleToDeck() and  c:IsSetCard(0xeaea)
end