--女妖旋律  美树沙耶加
function c1000810.initial_effect(c)
	c:EnableReviveLimit()
	--SPECIALSUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,7224)
	e1:SetCost(c1000810.cost)
	e1:SetTarget(c1000810.target)
	e1:SetOperation(c1000810.thaop)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCondition(c1000810.condition)
	e2:SetCost(c1000810.decost)
	e2:SetTarget(c1000810.detarget)
	e2:SetOperation(c1000810.deoperation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--SPECIALSUMMON2
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,7224)
	e5:SetCondition(aux.exccon)
	e5:SetCost(c1000810.fucost)
	e5:SetTarget(c1000810.futarget)
	e5:SetOperation(c1000810.futhaop)
	c:RegisterEffect(e5)
end
function c1000810.cosfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3204) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToDeckAsCost()
end
function c1000810.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c1000810.filter(c,e,tp,m)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x3204) and not c:IsCode(1000810)
end
function c1000810.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1000810.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1000810.thaop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000810.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		Duel.BreakEffect()
		Duel.SetLP(tp,Duel.GetLP(tp)-800)
	end
end
function c1000810.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c1000810.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1000810.detarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c1000810.deoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c1000810.fucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c1000810.futarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c1000810.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1000810.futhaop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetMZoneCount(tp)<=0 then return end
   local mg=Duel.GetRitualMaterial(tp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local tg=Duel.SelectMatchingCard(tp,c1000810.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
   local tc=tg:GetFirst()
   if tc then
	 mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	 if tc.mat_filter then
		 mg=mg:Filter(tc.mat_filter,nil)
		 end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		 local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		 tc:SetMaterial(mat)
		 Duel.ReleaseRitualMaterial(mat)
		 Duel.BreakEffect()
		 Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		 tc:CompleteProcedure()
	 end
end