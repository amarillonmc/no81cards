--点火骑士·铠甲
function c98920581.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),3,3,c98920581.lcheck)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920581,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c98920581.destg)
	e1:SetOperation(c98920581.desop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c98920581.damtg)
	e2:SetOperation(c98920581.damop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920581.indcon)
	e3:SetValue(c98920581.efilter)
	c:RegisterEffect(e3)
	if c98920581.counter==nil then
		c98920581.counter=true
		c98920581[0]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c98920581.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_DESTROYED)
		e5:SetOperation(c98920581.addcount)
		Duel.RegisterEffect(e5,0)
	end
end
function c98920581.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc8)
end
function c98920581.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c98920581.ifilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc8)
end
function c98920581.indcon(e)
	return Duel.IsExistingMatchingCard(c98920581.ifilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c98920581.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920581.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c98920581.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c98920581.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c98920581.desfilter(c)
	return c:IsSetCard(0xc8) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c98920581.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c98920581[0]=0
end
function c98920581.addcount(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c98920581.dfilter,nil)
	c98920581[0]=c98920581[0]+ct
end
function c98920581.dfilter(c)
	return c:IsSetCard(0xc8)
end
function c98920581.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98920581.damop(e,tp,eg,ep,ev,re,r,rp)
	if c98920581[0]>0 then
		local ct=c98920581[0]*100
		Duel.Hint(HINT_CARD,0,98920581)
		Duel.Damage(1-tp,ct,REASON_EFFECT)
	end
end