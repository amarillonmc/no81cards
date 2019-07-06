--霓火打手
function c33700127.initial_effect(c)
   ---damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(33700127,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1)
	e2:SetCondition(c33700127.condition)
	e2:SetTarget(c33700127.target)
	e2:SetOperation(c33700127.activate)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33700127.spcon)
	c:RegisterEffect(e3)   
end
function c33700127.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE) and c:GetReasonPlayer()==tp
end
function c33700127.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700127.cfilter,1,nil,1-tp)
end
function c33700127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c33700127.activate(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Damage(1-tp,500,REASON_EFFECT)
end

function c33700127.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return Duel.GetMZoneCount(tp)>0
		and tg:IsExists(Card.IsControler,1,nil,1-tp)
end