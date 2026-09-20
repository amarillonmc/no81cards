--异界星的落胤
local s,id,o=GetID()
function s.initial_effect(c)
    -- e1: 检测从场上以外加入手卡，打 flag + 公开效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetOperation(s.op1)
    c:RegisterEffect(e1)

    -- e2: CHAIN_SOLVING 时检查 flag，不入连锁直接特招
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.con2)
    e2:SetOperation(s.op2)
    c:RegisterEffect(e2)

    -- ② 召唤·特殊召唤的场合，抽1张并给双方确认，选1张手卡丢弃
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES_SELF)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetTarget(s.drtg2)
    e3:SetOperation(s.drop2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
end

-- ============ e1: 打 flag + 公开 ============
function s.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 排除从场上加入手卡（覆盖"送去墓地→回手卡"等场上路径）
    if c:IsPreviousLocation(LOCATION_ONFIELD) then return end

    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
end

-- ============ e2: CHAIN_SOLVING 检查 ============
function s.con2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsLocation(LOCATION_HAND) then return false end
    if c:GetFlagEffect(id)==0 then return false end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
    if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
    return true
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 询问是否特招（不入连锁，在 CHAIN_SOLVING 处理中同步执行）
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        return
    end
    -- 先清 flag，避免特招过程中再次触发自身
    c:ResetFlagEffect(id)
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

-- ============ ② 抽1丢1 ============
function s.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_HANDES_SELF,nil,0,tp,1)
end

function s.drop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
    local tc=Duel.GetOperatedGroup():GetFirst()
    if not tc then return end
    Duel.ConfirmCards(1-tp,tc)
    Duel.ShuffleHand(tp)
    -- 抽到「异界星的落胤」或有那个卡名记述的卡 → 可以不丢弃
    local can_skip = tc:IsCode(id) or aux.IsCodeListed(tc,id)
    if can_skip and not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        return
    end

    -- 强制选1张手卡丢弃
    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
    end
end