--秘藏一闪 影潜者 赛伦迪斯
function c9911634.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,9911634)
	e1:SetCondition(c9911634.condition)
	e1:SetTarget(c9911634.target)
	e1:SetOperation(c9911634.activate)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9911634.transcon)
	e2:SetOperation(c9911634.transop)
	c:RegisterEffect(e2)
end
function c9911634.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c9911634.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911634,0xaf1b,TYPES_EFFECT_TRAP_MONSTER,1200,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911634.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)>0 and c:GetOriginalCode()==9911634 then
		c:SetEntityCode(40011519)
		c:ReplaceEffect(40011519,0,0)
		if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function c9911634.transcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode()==9911634
end
function c9911634.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(40011519)
	c:ReplaceEffect(40011519,0,0)
end
