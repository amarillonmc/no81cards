--海晶少女激溃
local m=42620057
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
    --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end

function cm.tgsfilter(g,e)
    local g1=g:Filter(Card.IsControler,nil,0)
    local g2=g:Filter(Card.IsControler,nil,1)
	return g:FilterCount(cm.tgsfilter1,nil,e)==2 and #g1==1 and #g2==1 and g:GetClassCount(Card.GetAttack)==2
end

function cm.tgsfilter1(c,e)
    return c:IsCanBeEffectTarget(e) and c:IsAttackBelow(2300) and c:IsFaceup()
end

function cm.tgsfilter2(c,tp)
    return c:IsSetCard(0x12b) and c:IsControler(tp)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetFieldGroup(tp,0x04,0x04)
    if chkc then return false end
	if chk==0 then return g:CheckSubGroup(cm.tgsfilter,2,2,e) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:SelectSubGroup(tp,cm.tgsfilter,false,2,2,e)
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,2,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,nil)
    if tg:FilterCount(cm.tgsfilter2,nil,tp)>=1 then
        Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    end
end

function cm.opsfilter(c)
    return not c:IsOnField() and c:IsReason(REASON_DESTROY)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #tg~=2 then return false end
    local ming=tg:GetMinGroup(Card.GetAttack)
    if #ming==1 then
        local marinckg=tg:Filter(cm.tgsfilter2,nil,tp)
        local tgct=tg:GetClassCount(Card.GetControler)
        local dc=ming:GetFirst()
        local dp=dc:GetControler()
        local fc=tg:Filter(aux.TRUE,dc):GetFirst()
        if Duel.Destroy(ming,REASON_EFFECT) and not dc:IsOnField() and fc:IsOnField() and tgct==2 and dc:GetBaseAttack()>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,dp,0x04,0,1,nil) and Duel.SelectYesNo(dp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	        local dg=Duel.SelectMatchingCard(dp,Card.IsFaceup,dp,0x04,0,1,1,nil)
            local dgc=dg:GetFirst()
            if dgc then
                Duel.HintSelection(dg)
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetRange(LOCATION_MZONE)
                e1:SetValue(dc:GetBaseAttack())
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                dgc:RegisterEffect(e1)
                local minusatk=dgc:GetAttack()-fc:GetAttack()
                Duel.BreakEffect()
                if minusatk>0 and Duel.Destroy(fc,REASON_EFFECT) then
                    Duel.Damage(1-dp,minusatk,REASON_EFFECT)
                end
            end
            if marinckg:FilterCount(cm.opsfilter,nil)>0 then
                local atk=marinckg:GetMaxGroup(Card.GetBaseAttack):GetFirst():GetBaseAttack()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e1:SetCode(EVENT_PHASE+PHASE_END)
                e1:SetCountLimit(1)
                e1:SetLabel(atk)
                e1:SetCondition(cm.thcon)
                e1:SetOperation(cm.thop)
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
            end
        end
    end
end

function cm.contfilter(c,atk)
	return c:IsSetCard(0x12b) and c:IsAttackAbove(atk) and c:IsAbleToHand()
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.contfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel())
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.Hint(HINT_CARD,0,m)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.contfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

function cm.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b)
end

function cm.handcon(e)
	return Duel.GetMatchingGroupCount(cm.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>=2
end