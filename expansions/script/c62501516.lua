--联协者 双子星·幻
function c62501516.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,62501516)
	e1:SetCondition(c62501516.spscon)
	e1:SetCost(c62501516.spscost)
	e1:SetTarget(c62501516.spstg)
	e1:SetOperation(c62501516.spsop)
	c:RegisterEffect(e1)
	--spsummon-other
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501516,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501516+1)
	e2:SetTarget(c62501516.sptg)
	e2:SetOperation(c62501516.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c62501516.spscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c62501516.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c62501516.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c62501516.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c62501516.spfilter(c,e,tp,chk,check)
	return (c:IsCode(62501511) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 or check and c:IsSetCard(0xea3) and c:IsType(TYPE_EQUIP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(e:GetHandler())) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c62501516.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil):IsExists(Card.IsCode,1,nil,62501511)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501516.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,0,check) end
end
function c62501516.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil):IsExists(Card.IsCode,1,nil,62501511) and c:IsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,c62501516.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,1,check):GetFirst()
	if sc and sc:IsCode(62501511) then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	elseif sc then
		Duel.Equip(tp,sc,c)
	end
	if Duel.GetTurnPlayer()~=tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c62501516.splcon)
		e1:SetTarget(c62501516.splimit)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c62501516.splcon(e,c)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c62501516.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
