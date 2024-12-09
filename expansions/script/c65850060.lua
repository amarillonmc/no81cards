--极简建造
function c65850060.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c65850060.excondition)
	e0:SetDescription(aux.Stringid(65850060,2))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65850060.target)
	e1:SetOperation(c65850060.activate)
	c:RegisterEffect(e1)
end
function c65850060.cfilter(c)
	return c:IsSetCard(0xa35) and c:IsFaceup()
end
function c65850060.excondition(e)
	local ct=Duel.GetCurrentChain()
	if not (ct and ct>0) then return end
	local rp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	local tp=e:GetHandlerPlayer()
	return rp~=tp and (Duel.IsExistingMatchingCard(c65850060.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end
function c65850060.thfilter(c)
	return c:IsSetCard(0xa35) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65850060.spfilter(c,e,tp)
	return c:IsSetCard(0xa35) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65850060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65850060.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,65850060)==0
	local b2=Duel.IsExistingMatchingCard(c65850060.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,65850061)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(65850060,0)},
		{b2,aux.Stringid(65850060,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,65850060,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,65850061,RESET_PHASE+PHASE_END,0,1)
	end
end
function c65850060.activate(e,tp,eg,ep,ev,re,r,rp)
	--limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850060.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	--operation
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c65850060.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c65850060.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65850060.splimit(e,c)
	return not c:IsSetCard(0xa35)
end
