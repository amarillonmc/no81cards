--幽骑兵-烈焰燃灯
function c46250002.initial_effect(c)
	c:SetSPSummonOnce(46250002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c46250002.linklimit)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c46250002.spcost)
	e3:SetTarget(c46250002.sptg)
	e3:SetOperation(c46250002.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCountLimit(1,46250002)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCost(c46250002.tspcost)
	e4:SetTarget(c46250002.tsptg)
	e4:SetOperation(c46250002.tspop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c46250002.linklimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WYRM)
end
function c46250002.rfilter(c)
	return c:IsSetCard(0xfc0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c46250002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c46250002.rfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c46250002.rfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c46250002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c46250002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c46250002.trfilter(c)
	return c:IsSetCard(0x1fc0) and c:IsAbleToGraveAsCost()
end
function c46250002.tspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=math.floor(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)/3) 
	if chk==0 then return n>0 and Duel.IsExistingMatchingCard(c46250002.trfilter,tp,LOCATION_DECK,0,n,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c46250002.trfilter,tp,LOCATION_DECK,0,n,n,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:FilterCount(Card.IsType,nil,TYPE_MONSTER))
end
function c46250002.tsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=e:GetLabel()
	if chk==0 then return (n<2 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=n
		and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,n,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,n,0,0)
end
function c46250002.tspop(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetLabel()
	if n>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=n
		and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK) then
		for i=1,n do
			Duel.SpecialSummonStep(Duel.CreateToken(tp,46250001),0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
