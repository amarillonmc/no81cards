--幽火军团的信使
function c51847020.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,51847020)
	e1:SetCost(c51847020.cost)
	e1:SetTarget(c51847020.settg)
	e1:SetOperation(c51847020.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--fusion substitute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e3:SetCondition(c51847020.subcon)
	c:RegisterEffect(e3)
end
function c51847020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)<=1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c51847020.setfilter(c)
	return (c:IsSetCard(0xa67) or c.fusion_effect) and c:IsType(TYPE_QUICKPLAY+TYPE_FIELD) and c:IsSSetable()
end
function c51847020.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c51847020.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c51847020.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c51847020.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 and not tc:IsSetCard(0xa67) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(51847020,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCondition(c51847020.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c51847020.actfilter(c)
	return c:IsSetCard(0xa67) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c51847020.actcon(e)
	local tp=e:GetHandlerPlayer()
	return not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
		and not Duel.IsExistingMatchingCard(c51847020.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c51847020.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c51847020.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
