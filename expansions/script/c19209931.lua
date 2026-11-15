--饥献花笼 霍普坡普
function c19209931.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209931,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19209931)
	e1:SetCondition(c19209931.spscon)
	e1:SetTarget(c19209931.spstg)
	e1:SetOperation(c19209931.spsop)
	c:RegisterEffect(e1)
	--spsummon-other
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209931,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209931+1)
	e2:SetTarget(c19209931.sptg)
	e2:SetOperation(c19209931.spop)
	c:RegisterEffect(e2)
end
function c19209931.cfilter(c)
	return not c:IsSetCard(0xb54) or c:IsFacedown()
end
function c19209931.spscon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c19209931.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19209931.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209931.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209931.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xb54) and not c:IsCode(19209931) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(5)
end
function c19209931.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanDraw(0,1) and Duel.IsPlayerCanDraw(1,1)and Duel.IsExistingMatchingCard(c19209931.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c19209931.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c19209931.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		for p in aux.TurnPlayers() do
			Duel.Draw(p,1,REASON_EFFECT)
		end
	end
end
