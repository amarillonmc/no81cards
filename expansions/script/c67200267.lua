--见封缄押
function c67200267.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200267+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67200267.condition)
	e1:SetTarget(c67200267.target)
	e1:SetOperation(c67200267.activate)
	c:RegisterEffect(e1)
	--activity check
	Duel.AddCustomActivityCounter(67200267,ACTIVITY_CHAIN,c67200267.chainfilter)
end
function c67200267.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return (re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and bit.band(loc,LOCATION_PZONE)==LOCATION_PZONE and rc:IsSetCard(0x674))
end
function c67200267.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(67200267,tp,ACTIVITY_CHAIN)>0
end
function c67200267.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x674) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c67200267.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x674)
end
function c67200267.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200267.ctfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200267.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c67200267.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	end
	local ct=Duel.GetMatchingGroupCount(c67200267.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c67200267.thfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c67200267.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200267.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x674) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

