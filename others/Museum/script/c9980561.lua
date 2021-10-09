--MRS甲斗-骑士形态
function c9980561.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980561,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980561)
	e1:SetCost(c9980561.spcost)
	e1:SetTarget(c9980561.sptg)
	e1:SetOperation(c9980561.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980561,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9980561.descost)
	e2:SetTarget(c9980561.destg)
	e2:SetOperation(c9980561.desop)
	c:RegisterEffect(e2)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c9980561.sumsuc)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c9980561.card_code_list={9980556}
function c9980561.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980561,2))
end
function c9980561.costfilter(c)
	return c:IsFaceup() and c:IsCode(9980556) and c:IsAbleToHandAsCost()
end
function c9980561.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IsExistingMatchingCard(c9980561.costfilter,tp,LOCATION_MZONE,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(c9980561.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,c9980561.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c9980561.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function c9980561.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	Duel.SetChainLimit(c9980561.chlimit)
end
function c9980561.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Damage(tp,1000,REASON_EFFECT)
	end
end
function c9980561.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,e:GetHandler(),0xcbca) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,e:GetHandler(),0xcbca)
	Duel.Release(g,REASON_COST)
end
function c9980561.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c9980561.chlimit)
end
function c9980561.chlimit(e,ep,tp)
	return tp==ep
end
function c9980561.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980561,3))
	end
end