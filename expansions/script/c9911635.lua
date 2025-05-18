--昔日之黑暗骑士 影潜者 奥布斯克迪特
function c9911635.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,9911635)
	e1:SetCondition(c9911635.condition)
	e1:SetTarget(c9911635.target)
	e1:SetOperation(c9911635.activate)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9911635.transcon)
	e2:SetOperation(c9911635.transop)
	c:RegisterEffect(e2)
end
function c9911635.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c9911635.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911635,0xaf1b,TYPES_EFFECT_TRAP_MONSTER,3000,0,8,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911635.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)>0 and c:GetOriginalCode()==9911635 then
		c:SetEntityCode(40011522)
		c:ReplaceEffect(40011522,0,0)
		if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function c9911635.transcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode()==9911635
end
function c9911635.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(40011522)
	c:ReplaceEffect(40011522,0,0)
end
