--MRS雷蜓-骑士形态
function c9980565.initial_effect(c)
   --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980565,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980565)
	e1:SetCost(c9980565.spcost)
	e1:SetTarget(c9980565.sptg)
	e1:SetOperation(c9980565.spop)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980565,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c9980565.cpcost)
	e2:SetTarget(c9980565.cptg)
	e2:SetOperation(c9980565.cpop)
	c:RegisterEffect(e2)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c9980565.sumsuc)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c9980565.card_code_list={9980560}
function c9980565.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980565,1))
end
function c9980565.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9980565.costfilter(c)
	return c:IsFaceup() and c:IsCode(9980560) and c:IsAbleToHandAsCost()
end
function c9980565.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IsExistingMatchingCard(c9980565.costfilter,tp,LOCATION_MZONE,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(c9980565.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,c9980565.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c9980565.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function c9980565.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	Duel.SetChainLimit(c9980565.chlimit)
end
function c9980565.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Damage(tp,1000,REASON_EFFECT)
	end
end
function c9980565.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9980565.cpfilter(c)
	return c:IsSetCard(0xcbca) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function c9980565.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c9980565.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9980565.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
	Duel.SetChainLimit(c9980565.chlimit)
end
function c9980565.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980565,2))
end
function c9980565.chlimit(e,ep,tp)
	return tp==ep
end