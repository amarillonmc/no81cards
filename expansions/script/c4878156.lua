local m=4878156
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	  local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e2:SetTarget(cm.distg)
    e2:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_SELF_TOGRAVE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(cm.tgcon)
    c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
            e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e5:SetCode(EVENT_CHAIN_SOLVING)
            e5:SetOperation(cm.disop)
            c:RegisterEffect(e5)
end
function cm.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and g:IsContains(c) and 
	c:IsSetCard(0x48c,0x48f)
end
function cm.tgcon(e)
      local c=e:GetHandler()
       local cg=c:GetColumnGroup()
    return Duel.GetCurrentPhase()==PHASE_END
        and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,cg)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c)
    return c:IsSetCard(0x48c) and c:IsFaceup()
end
function cm.disval(e,c)
    local rc=e:GetHandler()
    return rc:GetColumnGroup()
end
function cm.distg(e,c)
    rc=e:GetHandler()
    local seq=rc:GetSequence()
    local fid=rc:GetFieldID()
    local tp=e:GetHandlerPlayer()
    return aux.GetColumn(c,tp)==seq and c:GetFieldID()~=fid
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local tseq=e:GetHandler():GetSequence()
    local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
    if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
        and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
        Duel.NegateEffect(ev)
    end
end
