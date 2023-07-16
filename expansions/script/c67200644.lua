--拟态武装 恩赐共鸣
function c67200644.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(c67200644.limcon)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667b))
	e6:SetValue(1000)
	c:RegisterEffect(e6) 
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c67200644.limcon)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667b))
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200644,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,67200644)
	e1:SetCondition(c67200644.plcon)
	e1:SetTarget(c67200644.pltg)
	e1:SetOperation(c67200644.plop)
	c:RegisterEffect(e1) 
end
function c67200644.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x667b)  and c:IsLevel(3)
end
function c67200644.limcon(e)
	return Duel.GetMatchingGroupCount(c67200644.cfilter1,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)>1
end
--
function c67200644.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
		and c:IsSetCard(0x667b) and c:IsSummonType(TYPE_LINK)
end
function c67200644.plcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200644.cfilter,1,nil,tp)
end
function c67200644.plfilter(c)
	return c:IsSetCard(0x667b) and c:IsType(TYPE_MONSTER) and c:IsLevel(3) and not c:IsForbidden()
end
function c67200644.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c67200644.plfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) end
end
function c67200644.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not c:IsRelateToEffect(e) then return end
	local link=eg:GetFirst():GetLink()
	local count=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if count<link then
		link=count
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c67200644.plfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,link,nil)
	--g2:AddCard(c)
	local tc=g2:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200644,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1,true)
		tc=g2:GetNext()
	end
end
