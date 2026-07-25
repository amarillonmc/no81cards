--源于黑影 反应
local s,id,o=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,0))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e0:SetCondition(s.qpcon)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.maintg)
    e1:SetOperation(s.mainop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SSET)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CUSTOM+65820000)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.settg2)
    e2:SetOperation(s.setop2)
    c:RegisterEffect(e2)
end

s.effect_lixiaoguo=true

function s.qpcon(e)
    local tp=e:GetHandlerPlayer()
    local atk_sum=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
    return atk_sum>=Duel.GetLP(tp)
end

function s.consume_use_counter(e,tp)
    for i=0,10 do
        Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
    end
    local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
    Duel.ResetFlagEffect(tp,65820099)
    for i=1,count do
        Duel.RegisterFlagEffect(tp,65820099,0,0,1)
    end
    local te=Effect.CreateEffect(e:GetHandler())
    te:SetDescription(aux.Stringid(65820000,count))
    te:SetType(EFFECT_TYPE_FIELD)
    te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
    te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    te:SetTargetRange(1,0)
    Duel.RegisterEffect(te,tp)
end
function s.deckfilter(c,e,tp,eg,ep,ev,re,r,rp)
    local te=c:CheckActivateEffect(true,false,false)
    if not te then return false end
	if not (c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and te:CheckCountLimit(tp) and not c:IsCode(id) and c:CheckUniqueOnField(tp) and not c:IsForbidden()) then return false end
    local con=te:GetCondition()
	if con and not con(te,tp,eg,ep,ev,re,r,rp) then return false end
    local co=te:GetCost()
    if co and not co(te,tp,eg,ep,ev,re,r,rp,0) then return false end
    local tg=te:GetTarget()
    if tg and not tg(te,tp,eg,ep,ev,re,r,rp,0) then return false end
    return true
end
function s.deckfilter1(c,e,tp,eg,ep,ev,re,r,rp)
    local te=c:CheckActivateEffect(false,false,false)
    if not te then return false end
	if not (c:IsType(TYPE_QUICKPLAY+TYPE_TRAP) and te:CheckCountLimit(tp) and not c:IsCode(id) and c:CheckUniqueOnField(tp) and not c:IsForbidden()) then return false end
	local con=te:GetCondition()
	if con and not con(te,tp,eg,ep,ev,re,r,rp) then return false end
	local co=te:GetCost()
    if co and not co(te,tp,eg,ep,ev,re,r,rp,0) then return false end
    local tg=te:GetTarget()
    if tg and not tg(te,tp,eg,ep,ev,re,r,rp,0) then return false end
    return true
end
function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local has_use=Duel.GetFlagEffect(tp,65820099)>0
    local is_flipped=c:GetFlagEffect(65820010)>0
    if (has_use and not is_flipped) or (not has_use and is_flipped) then
        if chk==0 then
            local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
            if not c:IsLocation(LOCATION_SZONE) then ft=ft-1 end
            if ft<=0 then return false end
            return Duel.IsExistingMatchingCard(s.deckfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
        end
        if has_use then s.consume_use_counter(e,tp) end
        e:SetLabel(1)
    else
        if chk==0 then
			local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
            if not c:IsLocation(LOCATION_SZONE) then ft=ft-1 end
            if ft<=0 then return false end
            return Duel.IsExistingMatchingCard(s.deckfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1)
        end
        if has_use then s.consume_use_counter(e,tp) end
        e:SetLabel(2)
    end
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local tc=Duel.SelectMatchingCard(tp,s.deckfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
        if not tc then return end

        local te=tc:GetActivateEffect()
        local tpe=tc:GetType()
        local con=te:GetCondition()
        local co=te:GetCost()
        local tg=te:GetTarget()
        local op=te:GetOperation()
        e:SetCategory(te:GetCategory())
        e:SetProperty(te:GetProperty())
        Duel.ClearTargetCard()
        if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
            if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        elseif bit.band(tpe,TYPE_FIELD)~=0 then
            Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        else
            if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            tc:SetStatus(STATUS_LEAVE_CONFIRMED,true)
        end
        if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) and bit.band(tpe,TYPE_FIELD)==0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_CHAIN_END)
            e1:SetLabelObject(tc)
            e1:SetCountLimit(1)
            e1:SetOperation(s.leaveop)
            Duel.RegisterEffect(e1,tp)
        end

        tc:CreateEffectRelation(te)
        if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
        if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
        Duel.BreakEffect()
        local tgc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
        if tgc and #tgc>0 then
            local etc=tgc:GetFirst()
            while etc do
                etc:CreateEffectRelation(te)
                etc=tgc:GetNext()
            end
        end
        if op then op(te,tp,eg,ep,ev,re,r,rp) end
        tc:ReleaseEffectRelation(te)
        if tgc and #tgc>0 then
            local etc=tgc:GetFirst()
            while etc do
                etc:ReleaseEffectRelation(te)
                etc=tgc:GetNext()
            end
        end
        te:UseCountLimit(tp,1)
    else
        -- ○后效果：翻卡直到可发动的速攻魔法·陷阱卡出现，发动，其余回卡组
        local mg = Duel.GetMatchingGroup(s.deckfilter1, tp, LOCATION_DECK, 0, nil, e, tp, eg, ep, ev, re, r, rp)
        if #mg == 0 then return end
        local dcount = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)
        local seq = -1
        local qc = nil
        for tc in aux.Next(mg) do
            if tc:GetSequence() > seq then
                seq = tc:GetSequence()
                qc = tc
            end
        end
        if seq == -1 then return end
        Duel.ConfirmDecktop(tp, dcount - seq)
        local cg = Duel.GetDecktopGroup(tp, dcount - seq - 1)
        Duel.DisableShuffleCheck()
        if #cg > 0 then
            Duel.SortDecktop(tp, tp, #cg)
            for i = 1, #cg do
                local mvg = Duel.GetDecktopGroup(tp, 1)
                Duel.MoveSequence(mvg:GetFirst(), SEQ_DECKBOTTOM)
            end
        end
        local tc = qc
        if not tc then return end
        local te = tc:GetActivateEffect()
        local tpe = tc:GetType()
        local co = te:GetCost()
        local tg = te:GetTarget()
        local op = te:GetOperation()
        e:SetCategory(te:GetCategory())
        e:SetProperty(te:GetProperty())
        Duel.ClearTargetCard()
        if bit.band(tpe, TYPE_EQUIP + TYPE_CONTINUOUS) ~= 0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
            if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
            Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
        elseif bit.band(tpe, TYPE_FIELD) ~= 0 then
            Duel.MoveToField(tc, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
        else
            if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
            Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
            tc:SetStatus(STATUS_LEAVE_CONFIRMED, true)
        end
        if bit.band(tpe, TYPE_EQUIP + TYPE_CONTINUOUS) == 0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) and bit.band(tpe, TYPE_FIELD) == 0 then
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_CHAIN_END)
            e1:SetLabelObject(tc)
            e1:SetCountLimit(1)
            e1:SetOperation(s.leaveop)
            Duel.RegisterEffect(e1, tp)
        end
        tc:CreateEffectRelation(te)
        if co then co(te, tp, eg, ep, ev, re, r, rp, 1) end
        if tg then tg(te, tp, eg, ep, ev, re, r, rp, 1) end
        Duel.BreakEffect()
        local tgc = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
        if tgc and #tgc > 0 then
            local etc = tgc:GetFirst()
            while etc do
                etc:CreateEffectRelation(te)
                etc = tgc:GetNext()
            end
        end
        if op then op(te, tp, eg, ep, ev, re, r, rp) end
        tc:ReleaseEffectRelation(te)
        if tgc and #tgc > 0 then
            local etc = tgc:GetFirst()
            while etc do
                etc:ReleaseEffectRelation(te)
                etc = tgc:GetNext()
            end
        end
        te:UseCountLimit(tp, 1)
    end
end

function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc and tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() then
        Duel.SendtoGrave(tc,REASON_RULE)
    end
    e:Reset()
end

function s.setfilter2(c)
    return c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end

function s.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

function s.setop2(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end