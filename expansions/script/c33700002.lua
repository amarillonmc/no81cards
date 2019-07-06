--上级Protoform 克里沃洛格
function c33700002.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetCondition(c33700002.sumcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.penlimit)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33700002.imcon)
	e3:SetValue(c33700002.efilter)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9047460,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c33700002.descon)
	e4:SetTarget(c33700002.destg)
	e4:SetOperation(c33700002.desop)
	c:RegisterEffect(e4)
end
function c33700002.sumcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0x3440)
end
function c33700002.sfilter(c)
	return c:IsSetCard(0x3440) and c:IsFaceup()
end
function c33700002.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c33700002.imcon(e)
	return Duel.IsExistingMatchingCard(c33700002.sfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and not
	Duel.IsExistingMatchingCard(c33700002.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
end
function c33700002.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c33700002.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
	and Duel.IsExistingMatchingCard(c33700002.sfilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c33700002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetFirst()
	local atk=0
	while tg do
	local a=tg:GetAttack()
	if a<0 then
	a=0
	end
	atk=atk+a
	tg=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c33700002.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:GetCount()>0 then
	local tg=sg:GetFirst()
	local atk=0
	while tg do
	local a=tg:GetAttack()
	if a<0 then
	a=0
	end
	atk=atk+a
	tg=sg:GetNext()
	end	 
   Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end