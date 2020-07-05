--炎国·术士干员-惊蛰
function c79029135.initial_effect(c)
	c:EnableCounterPermit(0x192)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c79029135.lcheck)
	c:EnableReviveLimit() 
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029135.hdcon)
	e1:SetTarget(c79029135.hdtg)
	e1:SetOperation(c79029135.hdop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79029135.cost)
	e2:SetTarget(c79029135.lztg)
	e2:SetOperation(c79029135.lzop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029135.hdcon1)
	e3:SetTarget(c79029135.hdtg)
	e3:SetOperation(c79029135.hdop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c79029135.hdcon1)
	e4:SetValue(c79029135.atkval)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(1)
	e5:SetCondition(c79029135.actcon)
	c:RegisterEffect(e5)
end  
function c79029135.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph>PHASE_MAIN1 and ph<PHASE_MAIN2) and e:GetHandler():IsExtraLinkState()
end
function c79029135.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa900)
end
function c79029135.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c79029135.hdcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsExtraLinkState()
end
function c79029135.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c79029135.cfilter,1,nil,zone)
end
function c79029135.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x192,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,tp,ev)
end
function c79029135.hdop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x192,1)
end
function c79029135.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x192,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x192,4,REASON_COST)
	end
function c79029135.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029135.lzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local x=g:GetCount()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c79029135.atkfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end
function c79029135.atkval(e,c)
	local g=Duel.GetMatchingGroup(c79029135.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	return g:GetSum(Card.GetLink)*1000
end









