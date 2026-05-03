--超跃星★重辉逐光电影弹！
local s,id,o=GetID()
function s.initial_effect(c)
	--无效
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
   	end     
end
function s.checkfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xca0) and c:IsLinkAbove(2) and c:IsSummonPlayer(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(s.checkfilter,1,nil,p) then 
        	Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1) 
        end
	end
end
function s.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca0) and c:IsType(TYPE_LINK)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.desfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
    	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,rc:GetType()&0x7)
        g:Merge(eg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca0) and c:IsLinkAbove(5)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0
    	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then
        local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,rc:GetType()&0x7)
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        	Duel.BreakEffect()
            Duel.Destroy(g,REASON_EFFECT)
        end
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end