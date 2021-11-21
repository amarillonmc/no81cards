--创胜龙 天才搭配
function c25000036.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c25000036.lcheck)
	c:EnableReviveLimit()   
	--c d
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_HAND)
	e1:SetTarget(c25000036.cdtg)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,25000036)
	e2:SetTarget(c25000036.xxtg)
	e2:SetOperation(c25000036.xxop)
	c:RegisterEffect(e2)

end
function c25000036.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLinkRace)==g:GetCount() 
end
function c25000036.cdtg(e,c)
	return c==e:GetHandler() or e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c25000036.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c25000036.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if lg<=0 then return end
	if lg:GetClassCount(Card.GetAttribute)==g:GetCount() then 
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c25000036.negcon1)
	e1:SetOperation(c25000036.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	end
	if lg:GetClassCount(Card.GetRace)==g:GetCount() then 
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c25000036.negcon2)
	e1:SetOperation(c25000036.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
	end
end
function c25000036.negcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:GetControler()~=tp and rc:IsType(TYPE_MONSTER)
end 
function c25000036.negcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:GetControler()~=tp and rc:IsType(TYPE_SPELL+TYPE_TRAP)
end 
function c25000036.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_CARD,0,25000036)
	Duel.NegateEffect(ev)
	Duel.Destroy(rc,POS_FACEUP,REASON_EFFECT)
	e:Reset()
	end
end









