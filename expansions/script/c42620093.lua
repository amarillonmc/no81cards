--魔偶甜点·草莓蛋糕夫人
local cm,m=GetID()

function cm.initial_effect(c)
	--th
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_TO_DECK)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_MOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(0x10)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.adcon)
	e3:SetTarget(cm.adtg)
	e3:SetOperation(cm.adop)
	c:RegisterEffect(e3)
end

function cm.contfilter(c)
    return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end

function cm.contfilter2(c)
    return c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler() and eg and eg:FilterCount(cm.contfilter2,nil)==1 and Duel.IsExistingMatchingCard(cm.contfilter,tp,0x04,0x04,1,nil)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local n=eg:Filter(cm.contfilter2,nil):GetFirst():GetLevel()
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x71,TYPES_EFFECT_TRAP_MONSTER,1000,2000,n,RACE_WARRIOR,ATTRIBUTE_EARTH) end
    e:SetLabel(n)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local n=e:GetLabel()
    if c:IsRelateToChain() and c:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	    local g=Duel.SelectMatchingCard(tp,cm.contfilter,tp,0x04,0x04,1,1,nil)
        if #g>0 then
            Duel.HintSelection(g)
            local tc=g:GetFirst()
            local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(-500)
			tc:RegisterEffect(e2)
        end
        Duel.BreakEffect()
        if Duel.GetLocationCount(tp,0x04)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x71,TYPES_EFFECT_TRAP_MONSTER,1000,2000,n,RACE_WARRIOR,ATTRIBUTE_EARTH) then
            c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		    if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CHANGE_LEVEL)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+0xb7c0000)
                e1:SetValue(n)
                c:RegisterEffect(e1)
            end
            Duel.SpecialSummonComplete()
        end
    end
end

function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
    if re then
        local rc=re:GetHandler()
        return re:IsActiveType(TYPE_MONSTER) and rc and rc:IsSetCard(0x71) and rc:IsType(TYPE_XYZ) and e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
    else
        return false
    end
end

function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.contfilter,tp,0x04,0x04,1,nil) end
end

function cm.adop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,cm.contfilter,tp,0x04,0x04,1,1,nil)
    if #g>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(-500)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetValue(-500)
        tc:RegisterEffect(e2)
    end
end