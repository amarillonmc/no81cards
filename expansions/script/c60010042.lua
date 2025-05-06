--此眼遍观浮世
local m=60010042
local cm=_G["c"..m]
function c60010042.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetCondition(cm.condition)
    e1:SetDescription(aux.Stringid(m,2))
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.activate)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(cm.cost2)
    e3:SetTarget(cm.postg)
    e3:SetOperation(cm.posop)
    c:RegisterEffect(e3)
end
function cm.condition(e)
    local tp=e:GetHandlerPlayer()
    -- 检查是否是自己的回合，且对方场上的卡比自己多
    return Duel.GetTurnPlayer()==tp 
        and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end 
    local g=Group.CreateGroup()
    -- 修改判断条件，确保对方场上卡片数量大于我方
    if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then      
        g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
        if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
            local tc=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
            if tc then
                g:AddCard(tc)
            end
        end
        Duel.ConfirmCards(tp,g)
        local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND)
			e1:SetTarget(cm.distg1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_CHAIN)  -- 改为连锁结束时
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_CHAIN)  -- 改为连锁结束时
			Duel.RegisterEffect(e2,tp)
			tc=g:GetNext()
		end
    end
end
function cm.distg1(e,c)
    local tc=e:GetLabelObject()
    if c==e:GetOwner() then return false end  -- 使用GetOwner来获取原卡
    if c:IsType(TYPE_SPELL+TYPE_TRAP) then
        return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
    else
        return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
    end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if not tc or not re:GetHandler() then return false end
    if re:GetHandler()==e:GetOwner() then return false end  -- 排除这张卡自身
    return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.negfilter(c)
    return c:IsFaceup() and not c:IsDisabled()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.posfilter(c)
    return c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()==0 then return end
    if Duel.ChangePosition(g,POS_FACEUP_ATTACK)~=0 then
    local sg=Duel.GetOperatedGroup()
    local tc=sg:GetFirst()
        while tc do 
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
            e1:SetValue(tc:GetAttack()*2)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
            e2:SetValue(tc:GetDefense()*2)
            tc:RegisterEffect(e2)
        tc=sg:GetNext()
        end
    end
end