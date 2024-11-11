--传承之界王器 阿方冯斯
function c75080015.initial_effect(c)
	--link
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x758),2,4,c75080015.lcheck)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetValue(c75080015.matval)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c75080015.ctop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c75080015.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,75080015)
	e3:SetCondition(c75080015.condition)
	e3:SetOperation(c75080015.operation)
	c:RegisterEffect(e3)
end
function c75080015.lcheck(g,lc)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c75080015.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function c75080015.seqfilter(c,seq)
	return c:GetSequence()<5 and c:IsFaceup() and c:IsCanAddCounter(0x1751,1)
		and math.abs(seq-c:GetSequence())==1
end
function c75080015.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()>=5 then return false end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c75080015.seqfilter,tp,LOCATION_MZONE,0,nil,c:GetSequence())
	for tc in aux.Next(g) do
		tc:AddCounter(0x1751,1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c75080015.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c75080015.atkfilter(c)
	return c:GetCounter(0x1751)>0
end
function c75080015.atkval(e,c)
	local g=Duel.GetMatchingGroup(c75080015.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetBaseAttack)/2
end
function c75080015.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75080015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c75080015.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75080015)~=0
end
function c75080015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c75080015.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c75080015.discon)
	e2:SetOperation(c75080015.disop)
	c:RegisterEffect(e2)
end
function c75080015.efilter(e,re)
	local rc=re:GetHandler()
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and rc:IsType(TYPE_MONSTER) and rc:GetAttack()<e:GetHandler():GetAttack()
end
function c75080015.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(75080016)<=0
end
function c75080015.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(75080015,0)) then
		Duel.Hint(HINT_CARD,0,75080015)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(75080016,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
