--创胜龙 天才搭配
function c25000036.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c25000036.lcheck)
	c:EnableReviveLimit()
	--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c25000036.effectfilter)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c25000036.eftg)
	c:RegisterEffect(e2) 
	--xx
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,25000036)  
	e3:SetTarget(c25000036.xxtg)
	e3:SetOperation(c25000036.xxop)
	c:RegisterEffect(e3)
end
function c25000036.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c25000036.effectfilter(e,ct)
	local tp=e:GetHandler():GetControler()
	local te,p,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	if te:GetHandler()==e:GetHandler() then 
	return e:GetHandler():IsLinkState() 
	else
	return e:GetHandler():GetLinkedGroup():IsContains(te:GetHandler())
	end
end
function c25000036.eftg(e,c)
	if c==e:GetHandler() then 
	return e:GetHandler():IsLinkState() 
	else
	return e:GetHandler():GetLinkedGroup():IsContains(c)
	end
end
function c25000036.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:GetLinkedGroupCount()==c:GetLinkedGroup():GetClassCount(Card.GetAttribute)  
	local b2=c:GetLinkedGroupCount()==c:GetLinkedGroup():GetClassCount(Card.GetRace) 
	if chk==0 then return b1 or b2 end 
end
function c25000036.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:GetLinkedGroupCount()==c:GetLinkedGroup():GetClassCount(Card.GetAttribute)  
	local b2=c:GetLinkedGroupCount()==c:GetLinkedGroup():GetClassCount(Card.GetRace)	 
	if b1 then 
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(c25000036.negcon1)
	e1:SetOperation(c25000036.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
	if b2 then 
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(c25000036.negcon2)
	e1:SetOperation(c25000036.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end 
function c25000036.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c25000036.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c25000036.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,25000036)
	Duel.NegateEffect(ev) 
end






