--归回净乐士妄想幻视
function c19209686.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c19209686.excondition)
	e0:SetDescription(aux.Stringid(19209686,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,19209686)
	e1:SetCondition(c19209686.condition)
	e1:SetTarget(c19209686.target)
	e1:SetOperation(c19209686.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209686,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19209686+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209686.thtg)
	e2:SetOperation(c19209686.thop)
	c:RegisterEffect(e2)
end
function c19209686.chkfilter(c)
	return c:IsCode(19209669) and c:IsFaceup()
end
function c19209686.excondition(e)
	return Duel.IsExistingMatchingCard(c19209686.chkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c19209686.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3
end
function c19209686.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c19209686.cfilter(c,e,tp)
	return c:IsSetCard(0x3b52,0xb53) and (c:IsType(TYPE_MONSTER) and not c:IsPublic() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c19209686.activate(e,tp,eg,ep,ev,re,r,rp)
	local chk=false
	for i=1,ev do
		if Duel.NegateActivation(i) then chk=true end
	end
	if not chk then return end
	local g=Duel.GetMatchingGroup(c19209686.cfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(19209686,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc:IsPublic() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,66,1152)==0) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c19209686.thfilter(c,chk)
	return c:IsSetCard(0x3b52,0xb53) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c19209686.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209686.thfilter,tp,0x30,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c19209686.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209686.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
