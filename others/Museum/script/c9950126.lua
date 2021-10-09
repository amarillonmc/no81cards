--冥府归来的英雄王·吉尔伽美什
function c9950126.initial_effect(c)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9ba5))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9950126)
	e2:SetTarget(c9950126.settg)
	e2:SetOperation(c9950126.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950126,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99501260)
	e1:SetCondition(c9950126.spcon)
	e1:SetCost(c9950126.cost)
	e1:SetTarget(c9950126.target)
	e1:SetOperation(c9950126.operation)
	c:RegisterEffect(e1)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950126.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950126.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950126,0))
end
function c9950126.filter(c)
	return c:IsCode(9950128) and c:IsSSetable()
end
function c9950126.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9950126.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9950126.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9950126.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c9950126.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9950126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9950126.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c9950126.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	local dc=Duel.GetFirstTarget()
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and dc and dc:IsSetCard(0xba5) then
	local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local atk=0
		while tc do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
			tc=dg:GetNext()
		end
	   if atk>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950126,0))
end
