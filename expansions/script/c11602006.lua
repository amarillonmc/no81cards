--海爬兽宝宝 小沧龙

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--SpSumTrainer
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--OpMonTurnDown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.e2con)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--e1
--SpSumTrainer

function s.e1spfilter(c,e,tp)
	return c:IsCode(11602000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e1spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)  
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.e1spfilter),tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e1spfilter),tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.ConfirmCards(1-tp,g)
end

--e2
--OpMonTurnDown

function s.e2confilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.e2confilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.e2tudfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPosition(POS_FACEUP) and c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_LINK) 
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.e2tudfilter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(s.e2tudfilter,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=eg:FilterSelect(tp,s.e2tudfilter,1,1,nil,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
