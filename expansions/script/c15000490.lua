local m=15000490
local cm=_G["c"..m]
cm.name="无名者之地"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	--target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(cm.tgcon)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	--target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetCondition(cm.tcon)
	e4:SetOperation(cm.top)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0xff,0xff)
	e5:SetTarget(cm.target)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if ag:GetCount()==0 then return end
	local g=ag:Filter(Card.IsType,nil,TYPE_MONSTER)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,99)
		tc=g:GetNext()
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.tgfilter(c)
	return c:GetFlagEffect(m)~=0 and c:IsType(TYPE_MONSTER)
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,15000490)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0xff,0xff,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(m)
		tc:RegisterFlagEffect(15000491,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:RegisterFlagEffect(15000492,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))  
		tc=g:GetNext()
	end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.target(e,c)
	return c:GetFlagEffect(15000491)~=0
end