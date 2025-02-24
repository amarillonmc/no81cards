local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10111169)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
    
   -- ①：自己场上的「无敌机械王」不受对方的怪兽的效果影响
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.etarget)
    e1:SetValue(s.efilter)
    c:RegisterEffect(e1)

    -- ②：结束阶段效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.endcon)
    e2:SetTarget(s.endtg)
    e2:SetOperation(s.endop)
    c:RegisterEffect(e2)
end
function s.filter(c)
	return aux.IsCodeOrListed(c,10111169) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- ①：目标为「无敌机械王」
function s.etarget(e,c)
    return c:IsCode(10111169) -- 无敌机械王的卡号
end

-- ①：免疫对方的怪兽效果
function s.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

-- ②：结束阶段条件
function s.endcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end

-- ②：结束阶段目标（动态选项）
function s.endtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local has_mech=Duel.IsExistingMatchingCard(s.mechfilter,tp,LOCATION_MZONE,0,1,nil)
    local no_mech=not Duel.IsExistingMatchingCard(s.mechfilter,tp,LOCATION_MZONE,0,1,nil)
    
    if chk==0 then 
        return (no_mech and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
            or (has_mech and Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil))
    end
    
    local op=0
    if no_mech then
        op=Duel.SelectOption(tp,aux.Stringid(id,1))
    elseif has_mech then
        op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
    end
    e:SetLabel(op)
end

-- ②：结束阶段操作
function s.endop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local op=e:GetLabel()

    -- 选项0：特殊召唤（当没有机械王时）
    if op==0 then
        -- 再次检查条件
        if Duel.IsExistingMatchingCard(s.mechfilter,tp,LOCATION_MZONE,0,1,nil) then return end
        
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    
    -- 选项1：提升攻击力（当有机械王时）
    elseif op==1 then
        -- 再次检查条件
        if not Duel.IsExistingMatchingCard(s.mechfilter,tp,LOCATION_MZONE,0,1,nil) then return end
        
        local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,nil)
        for tc in aux.Next(g) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(1000)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            tc:RegisterEffect(e2)
        end
    end
end

-- 辅助函数
function s.mechfilter(c)
    return c:IsCode(10111169) and c:IsFaceup()
end

function s.spfilter(c,e,tp)
    return c:IsCode(10111169) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.atkfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end