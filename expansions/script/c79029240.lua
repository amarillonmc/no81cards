--黑钢国际·行动-代号·硝烟
function c79029240.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c79029240.cost)
	e1:SetTarget(c79029240.target)
	e1:SetOperation(c79029240.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,79029240)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029240.thtg)
	e2:SetOperation(c79029240.thop)
	c:RegisterEffect(e2)
end
function c79029240.fil(c)
	return c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_TRAP)
end
function c79029240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029220.fil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029220.fil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029240.sfil(c,e,tp)
	return c:IsSetCard(0xa900)
end
function c79029240.ssfil(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsLevel(9)
end
function c79029240.ssfil2(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsSSetable() and c:IsType(TYPE_TRAP)
end
function c79029240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029240.sfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local sg=Duel.SelectMatchingCard(tp,c79029240.sfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(sg)
end
function c79029240.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--immune
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e1:SetValue(c79029240.efilter)
	tc:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(c79029240.ssfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c79029240.ssfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79029240,0)) then
	local g=Duel.SelectMatchingCard(tp,c79029240.ssfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SSet(tp,g)
	end
end
function c79029240.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029240.thfil(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_MONSTER)
end
function c79029240.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029240.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	local sg=Duel.SelectMatchingCard(tp,c79029240.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,nil)
end
function c79029240.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end


