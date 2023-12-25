--直播☆双子星 璃拉·姬丝基勒·混音
local cm,m=GetID()

function cm.initial_effect(c)
    --cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
    --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
	e2:SetRange(0x04)
	e2:SetCountLimit(1)
    e2:SetCondition(cm.srcon)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
end

function cm.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsSetCard(0x1151,0x2151)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e5:SetLabel(Duel.GetTurnCount())
	e5:SetCondition(cm.indcon)
	e5:SetOperation(cm.indop)
    e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e5)
end

function cm.conimfilter(c)
    return c:IsPreviousSetCard(0x2151) and c:GetPreviousTypeOnField()&TYPE_LINK==TYPE_LINK
end

function cm.conifilter(g,tc)
    if #g==0 then return false end
    local n=g:FilterCount(cm.conimfilter,tc)
    return g:IsContains(tc) and n>0 and n==#g-1
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=e:GetHandler():GetReasonCard()
	return r==REASON_LINK and rc:IsSetCard(0x152,0x153) and cm.conifilter(rc:GetMaterial(),e:GetHandler())
end

function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
    local n=e:GetLabel()
    if n==Duel.GetTurnCount() then n=2 else n=1 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(cm.indval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,n)
	rc:RegisterEffect(e1,true)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(0x04)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,n)
	rc:RegisterEffect(e2,true)
end

function cm.indval(e,re,rp)
	return re:GetHandler()
end

function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==1
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsType,tp,0,0x10,nil,0x1)
    if chk==0 then return Duel.IsPlayerCanRemove(tp) and #g>=3 and g:FilterCount(Card.IsAbleToRemove,nil,tp)>=#g-2 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g-2,0,0)
end

function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(tp) then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,0x10,nil,0x1)
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,#g-2,#g-2,nil,tp)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end