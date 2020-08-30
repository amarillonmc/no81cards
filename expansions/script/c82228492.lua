local m=82228492
local cm=_G["c"..m]
cm.name="飞行之精灵王 凡尔斯·混沌"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)  
	c:EnableReviveLimit()  
	--destroy 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon)  
	e1:SetTarget(cm.destg)  
	e1:SetOperation(cm.desop)  
	c:RegisterEffect(e1)  
	--cannot spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(0,1)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.splimit)  
	c:RegisterEffect(e2) 
end
function cm.cfilter(c,zone)  
	local seq=c:GetSequence()  
	if c:IsControler(1) then seq=seq+16 end  
	return bit.extract(zone,seq)~=0  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000  
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,zone)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,nil)  
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_EXTRA,nil)  
	local ct1=g1:GetCount()
	if ct1>2 then ct1=2 end
	local ct2=g2:GetCount()
	if ct2>2 then ct2=2 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,ct1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,ct2,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,nil)  
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_EXTRA,nil)  
	local ct1=g1:GetCount()
	if ct1>2 then ct1=2 end
	local ct2=g2:GetCount()
	if ct2>2 then ct2=2 end
	local dg1=g1:RandomSelect(1-tp,ct1)
	local dg2=g2:RandomSelect(tp,ct2)
	dg1:Merge(dg2)
	Duel.Destroy(dg1,REASON_EFFECT)
end  
function cm.spcon(e)  
	return e:GetHandler():IsExtraLinkState()  
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_EXTRA)  
end  