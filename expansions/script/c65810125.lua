--盛夏回忆·牛虻
function c65810125.initial_effect(c)
	aux.AddCodeList(c,65810125)
	--replace
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65810125,0))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_DECK)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetTarget(c65810125.reptg)
	e0:SetValue(function(e,c) return c:GetFlagEffect(65810125)>0 end)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65810125,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,65810126)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c65810125.spcon)
	e1:SetTarget(c65810125.sptg)
	e1:SetOperation(c65810125.spop)
	c:RegisterEffect(e1)
	--攻宣无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65810125.condition3)
	e3:SetCost(c65810125.cost3)
	e3:SetOperation(c65810125.activate3)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,65810127)
	e4:SetTarget(c65810125.target4)
	e4:SetOperation(c65810125.activate4)
	c:RegisterEffect(e4)
	local e2=e4:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end


function c65810125.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_HAND and c:IsRace(RACE_INSECT) and c:IsAbleToHand() and not c:IsCode(65810125)
end
function c65810125.filter1(c,e,g)
	return (c:GetOriginalCode()==65810125 or c==e:GetHandler()) and c:IsAbleToHand() and not g:IsContains(c)
end
function c65810125.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c65810125.filter1,tp,LOCATION_DECK,0,nil,e,eg)
	if chk==0 then return eg:IsExists(c65810125.filter,1,nil,tp) and c==g:GetFirst() end
	if Duel.SelectYesNo(tp,aux.Stringid(65810125,0)) then
		local g=eg:Filter(c65810125.filter,nil,tp)
		local ttc=g:GetFirst()
		while ttc do
			Card.RegisterFlagEffect(ttc,65810125,RESET_CHAIN,0,1,e)
			ttc=g:GetNext()
		end
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		return true
	else return false end
end

function c65810125.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c65810125.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c65810125.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65810125.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65810125.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end

function c65810125.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c65810125.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c65810125.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

function c65810125.spfilter(c,e,tp)
	return c:IsCode(65810125)
end
function c65810125.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65810125.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED)
end
function c65810125.activate4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65810125.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c65810125.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65810125.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end