--方舟骑士·龙铳 慑砂
function c82567849.initial_effect(c)
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567849,0))
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c82567849.ntcon)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567849,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c82567849.spcon)
	e1:SetTarget(c82567849.sptg)
	e1:SetOperation(c82567849.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567849,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c82567849.spcon)
	e2:SetTarget(c82567849.sptg)
	e2:SetOperation(c82567849.spop)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567849,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,82567849+EFFECT_COUNT_CODE_DUEL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c82567849.descost)
	e4:SetCondition(c82567849.condition)
	e4:SetTarget(c82567849.target)
	e4:SetOperation(c82567849.operation)
	c:RegisterEffect(e4)
end
function c82567849.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82567849.ncfilter(c)
	return  c:IsFaceup() and not c:IsSetCard(0x825)
end
function c82567849.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82567849.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
		and not Duel.IsExistingMatchingCard(c82567849.ncfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c82567849.gfilter(c,tp)
	return c:IsType(TYPE_TUNER) and c:GetControler()==tp
end
function c82567849.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c82567849.gfilter,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c82567849.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c82567849.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
end
end
function c82567849.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c82567849.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c82567849.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567849.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c82567849.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c82567849.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567849.filter,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
	Duel.Destroy(sg,REASON_EFFECT)
end
end