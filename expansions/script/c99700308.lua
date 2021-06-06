--灵界书库管理员
function c99700308.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700308,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99700308)
	e1:SetCondition(c99700308.spcon)
	e1:SetCost(c99700308.spcost)
	e1:SetTarget(c99700308.sptg)
	e1:SetOperation(c99700308.spop)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700308,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99700309)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c99700308.ritualcon)
	e2:SetTarget(c99700308.ritualtg)
	e2:SetOperation(c99700308.ritualop)
	e2:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e2)
end
function c99700308.tgilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99700308.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700308.tgilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99700308.tgilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99700308.cfilter(c,tp)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and not c:IsCode(99700308) and c:IsControler(tp)
end
function c99700308.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99700308.cfilter,1,nil,tp)
end
function c99700308.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99700308.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99700308.ritualfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)
end
function c99700308.ritualfilter1(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER+TYPE_RITUAL)
end
function c99700308.ritualcon(c,lc,tp,og,lmat)
	 return Duel.IsExistingMatchingCard(c99700308.ritualfilter,tp,LOCATION_GRAVE,0,3,nil) and Duel.IsExistingMatchingCard(c99700308.ritualfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
end
function c99700308.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81
		or not ((c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER+TYPE_RITUAL)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil,tp)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c99700308.matfilter(c)
	return c:IsAbleToRemove() and (c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER)) and not (c:IsSetCard(0xfd03) and c:IsType(TYPE_RITUAL))
end
function c99700308.ritualtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c99700308.matfilter,tp,LOCATION_GRAVE,0,1,nil)
		return Duel.IsExistingMatchingCard(c99700308.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c99700308.ritualop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,c,lc)<=0 then return end
	local mg=Duel.GetMatchingGroup(c99700308.matfilter,tp,LOCATION_GRAVE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c99700308.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end