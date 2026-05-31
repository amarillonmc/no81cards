-- 狂野神碑之泉
local s,id=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,2))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e0)

    -- 作为速攻魔法发动，进入场地区并变为场地魔法
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    c:RegisterEffect(e1)

    -- ① 没卡胜利（以及允许神碑速攻手卡发动，这部分在YGO里可以加个光环）
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_FZONE)
    e2:SetOperation(s.winop)
    c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_HAND,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x17f))
    c:RegisterEffect(e3)

    -- ② 回收抽卡
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetCountLimit(1)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)

    -- ③ 不能盖放
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_SSET)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(0xff)
    e5:SetTargetRange(1,1)
    e5:SetTarget(function(e,c) return c==e:GetHandler() end)
    c:RegisterEffect(e5)
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then
        Duel.Win(tp,0xa31)
    end
end
function s.thfilter(c)
    return c:IsSetCard(0x17f) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.thfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) 
        and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #sg==0 then return end
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==0 then return end
	Duel.BreakEffect()
	Duel.Draw(tp,ct,REASON_EFFECT)
end