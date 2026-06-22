-- 樱花落尽 (通常陷阱)
local s,id=GetID()
function s.initial_effect(c)
    -- 添加记名卡牌以便游戏内核和其它检索卡正确识别
    aux.AddCodeList(c,71521025,63086455,11110218,85698115)
    
    -- 自己场上没有卡存在的场合，这张卡的发动从手卡也能用。
    local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(id,1))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)

    -- ①：从自己卡组·墓地把1只「幽世之血樱」加入手卡。那之后...
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)

    -- ②：把墓地的这张卡除外才能发动。自己回复1000基本分。那之后...
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,3))
    e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetCountLimit(1,id+1)
    e2:SetCost(aux.bfgcost) -- 把墓地的此卡除外的通用标准代价
    e2:SetTarget(s.rectg)
    e2:SetOperation(s.recop)
    c:RegisterEffect(e2)
end

---------------- 手卡发动条件 ----------------
function s.handcon(e)
    -- 自己场上卡片数量为0
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

---------------- ①效果：检索与盖放 ----------------
function s.thfilter(c)
    return c:IsCode(71521025) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.setfilter(c)
    -- 检索除外区时，必须是表侧表示才能看清卡名
    return c:IsCode(63086455,11110218,85698115) and c:IsSSetable()
        and c:IsFaceupEx() 
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    -- 加入 NecroValleyFilter 兼容王家之谷
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,g)
        
        -- “那之后，可以盖放陷阱”
        local setg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
        if #setg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.BreakEffect() -- 插入“那之后”的时点
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local sg=setg:Select(tp,1,1,nil)
            local tc=sg:GetFirst()
            if tc then
                Duel.SSet(tp,tc)
                -- 赋予盖放的回合也能发动的状态
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
                e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
    end
end

---------------- ②效果：回复与连缀操作 ----------------
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    -- 1. 回复1000
    if Duel.Recover(p,d,REASON_EFFECT)>0 then
        -- 2. 那之后，除外区回手
        local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,nil)
        if #g1>0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg1=g1:Select(tp,1,1,nil)
            if Duel.SendtoHand(sg1,nil,REASON_EFFECT)>0 and sg1:GetFirst():IsLocation(LOCATION_HAND) then
                -- 3. 那之后，手卡送去墓地
                local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
                if #g2>0 then
                    Duel.BreakEffect()
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                    local sg2=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
                    if #sg2>0 and Duel.SendtoGrave(sg2,REASON_EFFECT)>0 and sg2:GetFirst():IsLocation(LOCATION_GRAVE) then
                        -- 4. 那之后，墓地除外
                        local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
                        if #g3>0 then
                            Duel.BreakEffect()
                            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                            local sg3=g3:Select(tp,1,1,nil)
                            Duel.Remove(sg3,POS_FACEUP,REASON_EFFECT)
                        end
                    end
                end
            end
        end
    end
end