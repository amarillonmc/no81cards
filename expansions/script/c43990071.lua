--流 浪 狐 狸
local m=43990071
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCost(c43990071.rspcost)
	e1:SetTarget(c43990071.rsptg)
	e1:SetOperation(c43990071.rspop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990071)
	e2:SetTarget(c43990071.sttg)
	e2:SetOperation(c43990071.stop)
	c:RegisterEffect(e2)
	
end
function c43990071.rscfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGraveAsCost()
end
function c43990071.rspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990071.rscfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990071.rscfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c43990071.rsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c43990071.rspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Damage(1-tp,500,REASON_EFFECT)~=0 and e:GetActivateLocation()==LOCATION_HAND and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(43990071,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990071.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x5510) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c43990071.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c43990071.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c43990071.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c43990071.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
