--PSY骨架装备·Ω
function c98920637.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920637.matfilter,1,1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920637.atkval)
	c:RegisterEffect(e1) 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920637,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98920637)
	e2:SetCondition(c98920637.regcon)
	e2:SetTarget(c98920637.rmtg)
	e2:SetOperation(c98920637.regop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c98920637.indtg)
	e3:SetValue(c98920637.efilter)
	c:RegisterEffect(e3)
end
function c98920637.matfilter(c)
	return c:IsLinkRace(RACE_PSYCHO) and not c:IsLinkCode(98920637)
end
function c98920637.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc1) and c:GetBaseAttack()>=0
end
function c98920637.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c98920637.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c98920637.indtg(e,c)
	return c:IsSetCard(0xc1) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c98920637.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c98920637.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:IsPreviousControler(1-tp) then seq=seq+16 end
	return c:IsFaceup() and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSetCard(0xc1) and c:IsPreviousControler(tp) and bit.extract(zone,seq)~=0
end
function c98920637.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920637.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c98920637.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98920637.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end