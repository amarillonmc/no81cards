--纵横弈界 - 河堑战棋
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9f6))
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.hspcon)
	e2:SetValue(SUMMON_TYPE_SPECIAL)
	local eg=Effect.CreateEffect(c)
	eg:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	eg:SetRange(LOCATION_FZONE)
	eg:SetTargetRange(LOCATION_HAND,0)
	eg:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9f6))
	eg:SetLabelObject(e2)
	c:RegisterEffect(eg)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
function s.efilter(e,te,c)
	local tc=te:GetHandler()
	local tp=e:GetHandlerPlayer()
	return te:GetOwnerPlayer()==1-tp and tc:IsOnField() and c:GetColumnGroup():IsContains(tc)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(54520005)
end
function s.mmzfilter(c)
	return c:GetSequence()<=4
end
function s.emzfilter(c)
	return c:GetSequence()>=5
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0 and aux.NegateSummonCondition()
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and eg:IsExists(s.emzfilter,1,nil)
		and not Duel.IsExistingMatchingCard(s.mmzfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.emzfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.emzfilter,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
