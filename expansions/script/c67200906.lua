--盛典之都 欧莫菲斯
function c67200906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200906+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200906.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200906,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200906.mvcon)
	e2:SetTarget(c67200906.mvtg)
	e2:SetOperation(c67200906.mvop)
	c:RegisterEffect(e2)	
end
--
function c67200906.pcfilter(c)
	return c:IsSetCard(0x367a) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200906.activate(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c67200906.pcfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(67200906,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200906.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
--
function c67200906.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x367a) and c:IsType(TYPE_PENDULUM) and c:IsPreviousControler(tp)
end
function c67200906.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200906.cfilter,1,nil)
end
function c67200906.stfilter(c)
	return c:IsSetCard(0x367a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c67200906.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c67200906.stfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c67200906.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200906.stfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
