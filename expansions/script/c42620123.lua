--魔偶甜点迎接
local cm,m=GetID()

function cm.initial_effect(c)
    --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
    --standby
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(0x01)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.stcon)
	e1:SetOperation(cm.stop)
	c:RegisterEffect(e1)
    --standby
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetOperation(cm.acop)
	c:RegisterEffect(e3)
    if not cm.blue_check then
        cm.blue_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        ge1:SetCode(EVENT_TO_DECK)
        ge1:SetOperation(cm.adjop)
        Duel.RegisterEffect(ge1,0)
        local ge2=Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge2:SetOperation(cm.ckdeckop)
        Duel.RegisterEffect(ge2,0)
    end
end

function cm.handcon(e)
	return Duel.GetFlagEffectLabel(e:GetHandlerPlayer(),m+1)==1
end

function cm.opafilter(c)
    return c:IsPreviousLocation(0x1c) and c:IsSetCard(0x71)
end

function cm.adjop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(0,m)==0 then
        Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1,0)
        Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1,0)
    end
	if eg:IsExists(cm.opafilter,1,nil) then
        for tc in aux.Next(eg:Filter(cm.opafilter,nil)) do
            local cp=tc:GetControler()
            Duel.SetFlagEffectLabel(cp,m,Duel.GetFlagEffectLabel(cp,m)+1)
        end
    end
end

function cm.ckdeckop(e,tp,eg,ep,ev,re,r,rp)
    local sg0=Duel.GetFieldGroup(0,0x03,0)
    local sg1=Duel.GetFieldGroup(1,0x03,0)
    if sg0:FilterCount(Card.IsSetCard,nil,0x71)>0 then
        local n,per=sg0:FilterCount(Card.IsSetCard,nil,0x71),0
        if (#sg0)/n<=2 then per=1 end
        Duel.RegisterFlagEffect(0,m+1,0,0,1,per)
    end
    if sg1:FilterCount(Card.IsSetCard,nil,0x71)>0 then
        local n,per=sg1:FilterCount(Card.IsSetCard,nil,0x71),0
        if (#sg1)/n<=2 then per=1 end
        Duel.RegisterFlagEffect(1,m+1,0,0,1,per)
    end
    e:Reset()
end

function cm.consfilter(c)
    return c:IsAbleToHand() and c:IsCode(m)
end

function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.consfilter,tp,0x01,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil) and cm.handcon(e)
end

function cm.stop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_CARD,0,m)
        if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT,nil) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local dg=Duel.SelectMatchingCard(tp,cm.consfilter,tp,0x01,0,1,1,nil)
            if #dg>0 then
                Duel.SendtoHand(dg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,dg)
            end
        end
    end
end

function cm.acop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToChain() then
        c:CancelToGrave()
    end
    Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
    if Duel.GetFlagEffect(tp,m-1)==0 then
        Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_END,0,1)
        local tde1=Effect.CreateEffect(c)
        tde1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        tde1:SetCode(EVENT_LEAVE_FIELD)
        tde1:SetOperation(cm.ad2op)
        tde1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(tde1,tp)
        local tde2=Effect.CreateEffect(c)
        tde2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        tde2:SetCode(EVENT_ADJUST)
        tde2:SetOperation(cm.ad2op)
        tde2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(tde2,tp)
        local tde3=Effect.CreateEffect(c)
        tde3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        tde3:SetCode(EVENT_SPSUMMON_SUCCESS)
        tde3:SetOperation(cm.ad2op)
        tde3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(tde3,tp)
        local tde4=Effect.CreateEffect(c)
        tde4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        tde4:SetCode(EVENT_SUMMON_SUCCESS)
        tde4:SetOperation(cm.ad2op)
        tde4:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(tde4,tp)
        local tde5=Effect.CreateEffect(c)
        tde5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        tde5:SetCode(EVENT_CUSTOM+42620123)
        tde5:SetOperation(cm.ad3op)
        tde5:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(tde5,tp)
        -- local e1=Effect.CreateEffect(c)
        -- e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        -- e1:SetCode(EVENT_CUSTOM+42620124)
        -- e1:SetCondition(cm.ad4con)
        -- e1:SetOperation(cm.ad4op)
        -- e1:SetReset(RESET_PHASE+PHASE_END)
        -- Duel.RegisterEffect(e1,tp)
        Duel.AdjustAll()
    end
    if Duel.GetFlagEffect(tp,m-2)==0 then
        Duel.RegisterFlagEffect(tp,m-2,0,0,1)
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
        e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(cm.aclimit)
		Duel.RegisterEffect(e1,tp)
        local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_INACTIVATE)
        e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetValue(cm.efilter)
		Duel.RegisterEffect(e3,tp)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_DISEFFECT)
        Duel.RegisterEffect(e5,tp)
    end
end

function cm.aclimit(e,re,tp)
    if Duel.GetFlagEffect(0,m)~=0 then
        return Duel.GetFieldGroupCount(re:GetHandlerPlayer(),re:GetHandler():GetLocation(),0)<=Duel.GetFlagEffectLabel(e:GetHandlerPlayer(),m)
    else
        return false
    end
end

function cm.efilter(e,ct)
    local tloc,te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_EFFECT)
    if te:GetHandlerPlayer()==e:GetHandlerPlayer() then
        if Duel.GetFlagEffect(0,m)~=0 then
            return Duel.GetFieldGroupCount(te:GetHandlerPlayer(),tloc,0)>=Duel.GetFlagEffectLabel(e:GetHandlerPlayer(),m)
        else
            return true
        end
    else
        return false
    end
end

function cm.ad2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+2)==0 or (Duel.GetFieldGroupCount(tp,0,0x0c)~=Duel.GetFlagEffectLabel(tp,m+2)) then
        Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+42620123,e,0,0,0,0)
    end
end

function cm.opafilter3(c)
    return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_EARTH)
end

function cm.ad3op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,m+2)==0 then
        Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1,Duel.GetFieldGroupCount(tp,0,0x0c))
    else
        local n=Duel.GetFieldGroupCount(tp,0,0x0c)
        if n~=Duel.GetFlagEffectLabel(tp,m+2) then
            local dg=Duel.GetMatchingGroup(cm.opafilter3,tp,0x01,0,nil)
	        local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x5e,nil,tp,POS_FACEDOWN)
            if #dg>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
                Duel.Hint(HINT_CARD,0,m)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                dg=dg:Select(tp,1,1,nil)
                if #dg>0 and Duel.SendtoGrave(dg,nil,REASON_EFFECT) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
                    tg=tg:Select(tp,1,1,nil)
                    if #tg>0 then
                        if tg:GetFirst():IsLocation(0x0c) then
                            Duel.HintSelection(tg)
                        end
                        Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
                    end
                end
                e:Reset()
            end
            Duel.SetFlagEffectLabel(tp,m+2,n)
        end
    end
end