--半魔的骑士演讲
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id) 
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id) 
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end

function s.cfilter1(c)
	return c:IsCode(17337400) and not c:IsPublic()
end

function s.confilter1(c)
	return c:IsFaceup() and c:IsCode(17337400)
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.confilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	
	if chk==0 then 
		return b1 or b2 
	end
	
	if b1 then
		if b2 and not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			return true
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	
	return true
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TRUE)
	e3:SetValue(function(e,re,r,rp)
		return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and 1 or 0
	end)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thfilter2(c,e,tp,check)
	return c:IsCode(17337400) and 
		(c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end

function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,check)
	
	if #g==0 then return end
	
	local tc=g:GetFirst()
	local op=0

	if tc:IsAbleToHand() then
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,1190,1152)  
		else
			op=0 
		end
	else
		op=1  
	end
	
	if op==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end