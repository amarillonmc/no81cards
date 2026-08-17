-- 凄陌寒昼·破桎霜剑
local s,id,o=GetID()
function s.initial_effect(c)
    --①效果：无效发动并解放，之后解放自己手牌1张
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(s.negcon)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)

    --②效果：这张卡被解放的场合，从墓地盖放并当回合可发动
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_RELEASE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(s.reltg)
    e2:SetOperation(s.relop)
    c:RegisterEffect(e2)
end

--自定义解放检查：允许解放任意卡，只检查不能解放的效果
function s.releasefilter(c,tp)
    local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
    if re then
        local val=re:GetValue()
        if val and val(re,c) then return false end
    end
    return true
end

--①效果发动条件：可连锁的效果发动
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev)
end

--①效果目标
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.releasefilter,tp,LOCATION_HAND,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

--①效果操作
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local tc=re:GetHandler()
    if not Duel.NegateActivation(ev) then return end
    --解放发动效果的卡
    if tc and tc:IsRelateToEffect(re) and s.releasefilter(tc,tp) then
        if Duel.Release(tc,REASON_EFFECT)>0 then
            --那之后选自己1张手牌解放
            if Duel.IsExistingMatchingCard(s.releasefilter,tp,LOCATION_HAND,0,1,nil,tp) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                local g=Duel.SelectMatchingCard(tp,s.releasefilter,tp,LOCATION_HAND,0,1,1,nil,tp)
                if g then
                    Duel.SendtoGrave(g,REASON_RELEASE)
                end
            end
        end
    end
end

--②效果目标：魔陷区有空位
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

--②效果操作：盖放并赋予当回合可发动效果
function s.relop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end