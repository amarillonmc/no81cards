--灾厄灵摆
function c82577947.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pendulum set
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1,82577947)
	e12:SetCost(c82577947.pcost)
	e12:SetTarget(c82577947.pctg)
	e12:SetOperation(c82577947.pcop)
	c:RegisterEffect(e12)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c82577947.psplimit)
	c:RegisterEffect(e2)
end
function c82577947.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_PENDULUM) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82577947.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c82577947.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)) and not c:IsForbidden()
			 and ((c:IsLevelAbove(1) and c:IsLevelBelow(10)) or (c:IsRankAbove(1) and c:IsRankBelow(10)))
end
function c82577947.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c82577947.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c82577947.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c82577947.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end