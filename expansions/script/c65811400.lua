-- 狂野神碑的锋芒
local s,id=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
    -- 这张卡在对方回合也能从手卡发动。
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,2))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e0)

    -- ①：可以从以下效果选择1个发动。
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

    -- ②：这张卡不能盖放。
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(0xff)
    e2:SetTargetRange(1,1)
    e2:SetTarget(s.atarget)
    c:RegisterEffect(e2)
end
---------------- ②效果：不能盖放 ----------------
function s.atarget(e,c)
    return c==e:GetHandler()
end

---------------- ①效果：主逻辑 ----------------
function s.thfilter(c)
    -- 同名卡以外的1张「神碑」卡
    return c:IsSetCard(0x17f) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.spfilter(c,e,tp)
    -- 额外卡组的「神碑」怪兽
    return c:IsSetCard(0x17f) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1 = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    local b2 = Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    
    if chk==0 then return b1 or b2 end
    
    local op = 0
    if b1 and b2 then
        op = Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
    elseif b1 then
        op = Duel.SelectOption(tp,aux.Stringid(id,0))
    else
        op = Duel.SelectOption(tp,aux.Stringid(id,1)) + 1
    end
    
    e:SetLabel(op)
    
    if op==0 then
        -- 检索
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
        e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    else
        -- 特召
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local op = e:GetLabel()
    if op==0 then
        -- ● 检索并消灭卡组顶
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
            Duel.ConfirmCards(1-tp,g)
            
            -- 那之后，尽可能把对方卡组上面把1张卡确认并消灭。
            if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
                Duel.BreakEffect() -- 插入“那之后”的时点
                Duel.DisableShuffleCheck()
                Duel.ConfirmDecktop(1-tp,1)
                local dg = Duel.GetDecktopGroup(1-tp,1)
                local tc = dg:GetFirst()
                if tc then
                    -- 检测对方的卡组顶卡片是否具有“不受效果影响”的抗性
                    if not tc:IsImmuneToEffect(e) then
                        if KOISHI_CHECK then Duel.Exile(tc,0) else Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,nil) end
                    end
                end
            end
            if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then
                Duel.Win(tp,0xa31)
            end
        end
    else
        -- ● 从额外卡组特殊召唤
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end