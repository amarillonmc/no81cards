--Protoss·折跃
function c65870020.initial_effect(c)
	aux.AddCodeList(c,65870015)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c65870020.excondition)
	e3:SetDescription(aux.Stringid(65870020,3))
	c:RegisterEffect(e3)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65870020,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	--e0:SetCost(c65870020.cost)
	e0:SetTarget(c65870020.target0)
	e0:SetOperation(c65870020.operation)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870020,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(c65870020.cost)
	e1:SetTarget(c65870020.target)
	e1:SetOperation(c65870020.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65870020,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetCost(c65870020.cost)
	e2:SetTarget(c65870020.target1)
	e2:SetOperation(c65870020.activate1)
	c:RegisterEffect(e2)
end

function c65870020.cfilter(c)
	return c:IsCode(65870015) and c:IsFaceup()
end
function c65870020.excondition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65870020.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c65870020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end

function c65870020.pfilter(c,tp)
	return c:IsCode(65870015) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c65870020.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870020.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c65870020.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c65870020.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then 
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
	end
end

function c65870020.filter(c)
	return c:IsSetCard(0x3a37) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelBelow(4) and aux.NecroValleyFilter()
end
function c65870020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870020.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65870020.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65870020.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c65870020.spfilter(c,e,tp)
	return c:IsSetCard(0x3a37) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and aux.NecroValleyFilter() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65870020.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65870020.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c65870020.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65870020.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end