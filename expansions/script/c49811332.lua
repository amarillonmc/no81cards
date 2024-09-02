--守正僧 净气
function c49811332.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c49811332.sumcon)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e11)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c49811332.sumlimit)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetCondition(c49811332.discon)
	e3:SetTarget(c49811332.distg)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c49811332.atkcon)
	e4:SetTarget(c49811332.atktg)
	e4:SetOperation(c49811332.atkop)
	c:RegisterEffect(e4)
end
function c49811332.sumcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c49811332.sumlimit(e,se,sp,st,pos,tp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and not se:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c49811332.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>=Duel.GetLP(1-tp)
end
function c49811332.distg(e,c)
	return c~=e:GetHandler()
end
function c49811332.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c49811332.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_MZONE)
end
function c49811332.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end