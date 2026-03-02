--人理之基 尼莫船长
function c22022990.initial_effect(c)
	aux.AddCodeList(c,22025820)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),true)
	--spsummon token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022990,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c22022990.sptg)
	e1:SetOperation(c22022990.spop)
	c:RegisterEffect(e1)
	--spsummon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022990,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22022990.spcon)
	e2:SetTarget(c22022990.sptg)
	e2:SetOperation(c22022990.spop)
	c:RegisterEffect(e2)
	--spsummon token ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022990,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22022990.spcon1)
	e3:SetCost(c22022990.erecost)
	e3:SetTarget(c22022990.sptg)
	e3:SetOperation(c22022990.spop)
	c:RegisterEffect(e3)
	--disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22022990,1))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON)
	e4:SetCountLimit(1,22022990)
	e4:SetCondition(c22022990.discon)
	e4:SetCost(c22022990.discost)
	e4:SetTarget(c22022990.distg)
	e4:SetOperation(c22022990.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(22022990,2))
	e5:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(22022990,3))
	e6:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e6)

	--disable summon ere
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22022990,1))
	e7:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EVENT_SUMMON)
	e7:SetCountLimit(1,22022990)
	e7:SetCondition(c22022990.discon1)
	e7:SetCost(c22022990.discost1)
	e7:SetTarget(c22022990.distg)
	e7:SetOperation(c22022990.disop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetDescription(aux.Stringid(22022990,2))
	e8:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetDescription(aux.Stringid(22022990,3))
	e9:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e9)
end
function c22022990.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(22025820) and ep==tp
end
function c22022990.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(22025820) and ep==tp and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022990.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22022990.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22022991,0x6ff1,TYPES_TOKEN_MONSTER,500,500,1,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(22022990,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c22022990.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22022991,0x6ff1,TYPES_TOKEN_MONSTER,500,500,1,RACE_AQUA,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,22022991)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22022990.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c22022990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22022990.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c22022990.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c22022990.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c22022990.costfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22022990.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22022990.costfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c22022990.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22022990.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c22022990.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c22022990.discon1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrenDuel.IsPlayerAffectedByEffect(tp,22020980) and tChain()==0
end
function c22022990.discost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22022990.costfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c22022990.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end