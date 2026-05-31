-- 狂野魔导书的神判
local s,id=GetID()
function s.initial_effect(c)
    -- 这个卡名的卡在1回合只能发动1张。
    -- 发动在对方回合从手卡也能用。
    local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(id,0))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND) -- 允许对方回合从手卡发动的底层规则码
    c:RegisterEffect(e0)

    -- ①：效果发动
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    ---不能盖放
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(0xff)
	e3:SetTargetRange(1,1)
	e3:SetTarget(s.atarget)
	c:RegisterEffect(e3)
end
function s.atarget(e,c)
	return c==e:GetHandler()
end
---------------- 发动后的环境挂载 ----------------
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 1. 挂载“每次魔法卡处理完毕后”的监听
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVING)
    e1:SetCondition(s.thcon)
    e1:SetOperation(s.thop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    
    -- 2. 挂载“结束阶段无视条件特召”的监听
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetCondition(s.spcon)
    e2:SetOperation(s.spop)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end

---------------- 检索逻辑（每次魔法处理完毕时） ----------------
function s.thfilter(c)
    -- 0x106e 为「魔导书」字段
    return c:IsSetCard(0x6e) and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    -- 条件：当前刚处理完的连锁，是由魔法卡的发动引起的（表侧的永续/场地发动也算）
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) 
        and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id) -- 弹窗提示此时是这张卡在发挥作用
    -- “自己可以从卡组把...” 选发提示
    if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
            -- 成功检索后，给玩家悄悄打上1个计数器，供结束阶段使用
            Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
        end
    end
end

---------------- 特召逻辑（结束阶段） ----------------
function s.spfilter(c,e,tp,ct)
    -- 必须是魔法师族，并且排除没有等级的怪兽（Link、XYZ），等级必须 <= 检索的数量ct
    if not (c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:GetLevel()<=ct) then return false end
    
    -- 额外卡组和主卡组在判断格子时的要求不同，分开严谨判定
    if c:IsLocation(LOCATION_EXTRA) then
        -- 这里的 true 代表无视召唤条件
        return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
    else
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
    end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    -- 取出当前回合因为该卡累计成功检索了多少张
    local ct=Duel.GetFlagEffect(tp,id)
    return ct>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,ct)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFlagEffect(tp,id)
    if ct<=0 then return end
    
    Duel.Hint(HINT_CARD,0,id)
    if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,ct)
        if #g>0 then
            -- 第5个参数 true 代表“无视召唤条件”
            Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
        end
    end
end