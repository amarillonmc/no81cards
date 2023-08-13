--魔偶甜点兽·怒号玛卡龙
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),3,2)
	c:EnableReviveLimit()
    --gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
    --tohand
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x04)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    local e5=e1:Clone()
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCondition(cm.thcon2)
    c:RegisterEffect(e5)
end

function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,0x10,nil,TYPE_MONSTER)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsType,tp,0x10,0,nil,TYPE_MONSTER)>3
end

function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsType,tp,0x10,0,nil,TYPE_MONSTER)<=3
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil) end
    c:RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST+REASON_DISCARD,nil)
    e:SetLabelObject(Duel.GetOperatedGroup())
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.optfilter(c,g)
    return (not g:IsExists(Card.IsCode,1,nil,c:GetCode())) and cm.optfilter2(c) and c:IsSSetable()
end

function cm.optfilter2(c)
    return c:IsSetCard(0x71) and c:IsType(0x6)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Draw(tp,1,REASON_EFFECT) and e:GetLabelObject():GetFirst():IsSetCard(0x71) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local tc=Duel.SelectMatchingCard(tp,cm.optfilter,tp,0x02,0,1,1,nil,Duel.GetMatchingGroup(cm.optfilter2,tp,0x10,0,nil)):GetFirst()
        if tc and Duel.SSet(tp,tc) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
            local c=e:GetHandler()
            local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(0,LOCATION_SZONE)
			e4:SetCondition(cm.discon)
			e4:SetTarget(cm.distg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(tc:GetSequence(),tc:GetFieldID())
			e4:SetLabelObject(tc)
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetCondition(cm.discon)
			e5:SetOperation(cm.disop)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(tc:GetSequence())
			e5:SetLabelObject(tc)
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e6:SetCondition(cm.discon)
			e6:SetTarget(cm.distg)
			e6:SetReset(RESET_PHASE+PHASE_END)
			e6:SetLabel(tc:GetSequence())
			e6:SetLabelObject(tc)
			Duel.RegisterEffect(e6,tp)
			Duel.Hint(HINT_ZONE,tp,0x1<<(c:GetSequence()+8))
        end
    end
end

function cm.discon(e)
	return e:GetLabelObject():GetFlagEffect(m)~=0
end

function cm.distg(e,c)
	local seq,fid=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.GetColumn(c,tp)==seq and c:GetFieldID()~=fid
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler()~=e:GetHandler()
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end