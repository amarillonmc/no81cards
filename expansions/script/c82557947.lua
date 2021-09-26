--钢战-流星的痕迹
function c82557947.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,82557947)
	e0:SetCost(c82557947.setcost)
	e0:SetTarget(c82557947.settg)
	e0:SetOperation(c82557947.setop)
	c:RegisterEffect(e0)
	Duel.AddCustomActivityCounter(82557947,ACTIVITY_SPSUMMON,c82557947.counterfilter)
end
function c82557947.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(82557947,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82557947.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82557947.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x829)
end
function c82557947.counterfilter(c)
	return c:IsSetCard(0x829) 
end
function c82557947.setfilter1(c,tp)
	return c:IsSetCard(0x829) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c82557947.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c82557947.setfilter2(c,code)
	return c:IsSetCard(0x829) and not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c82557947.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c82557947.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c82557947.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c82557947.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c82557947.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode())
	local tc2=g2:GetFirst()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
	Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) 
		tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	
end