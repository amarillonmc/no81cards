--亚雷斯塔
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	c:EnableReviveLimit()
	--spsum condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(0xff)
	e5:SetValue(s.effectfilter)
	c:RegisterEffect(e5)
	--disable
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.discon)
	e8:SetOperation(s.disop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCondition(s.discon2)
	e9:SetOperation(s.disop2)
	c:RegisterEffect(e9)
	--atk/def
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_SET_ATTACK_FINAL)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(s.ndcon)
	e10:SetValue(0)
	c:RegisterEffect(e10)
	--selfdes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_SELF_DESTROY)
	e11:SetCondition(s.descon)
	c:RegisterEffect(e11)
end
function s.rmop(e)
	local g=Duel.GetOverlayGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local tgg=g:Filter(Card.IsCode,nil,id)
	if tgg and #tgg>0 then

		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,5012604)
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler()==e:GetHandler()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)==0 and Duel.GetCurrentChain()<2
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	for i=2,ev do
		Duel.NegateEffect(i)
	end
	if e:GetHandler():GetFlagEffect(id)==0 and Duel.GetCurrentChain()>1 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end
end
function s.ndcfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.ndcon(e)
	return not Duel.IsExistingMatchingCard(s.ndcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,5012615)
end
function s.descon(e)
	return not Duel.IsExistingMatchingCard(s.ndcfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,5012623)
end