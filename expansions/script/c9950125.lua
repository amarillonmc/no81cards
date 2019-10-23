--乌鲁克的贤王·吉尔伽美什
function c9950125.initial_effect(c)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelBelow,8))
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950125,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99501250)
	e2:SetTarget(c9950125.destg)
	e2:SetOperation(c9950125.desop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950125,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,9950125)
	e3:SetCondition(c9950125.condition)
	e3:SetTarget(c9950125.atktg2)
	e3:SetOperation(c9950125.atkop2)
	c:RegisterEffect(e3)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950125.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950125.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950125,0))
end
function c9950125.cfilter(c)
	return c:IsAttackBelow(2000) or c:IsDefenseBelow(2000)
end
function c9950125.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9950125.cfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	 local g=Duel.GetMatchingGroup(c9950125.cfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	 Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c9950125.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950125.cfilter,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c9950125.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c9950125.spfilter(c,e,tp)
	return c:IsCode(9950126) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950125.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9950125.atkop2(e,tp,eg,ep,ev,re,r,rp)
	 local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9950125.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
