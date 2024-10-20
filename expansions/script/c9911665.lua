--岭偶守护兽·坚磐融聚体
function c9911665.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9911665)
	e1:SetTarget(c9911665.rmtg)
	e1:SetOperation(c9911665.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911665,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911666)
	e3:SetCondition(c9911665.discon)
	e3:SetCost(c9911665.discost)
	e3:SetTarget(c9911665.distg)
	e3:SetOperation(c9911665.disop)
	c:RegisterEffect(e3)
	--recycle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911665,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911667)
	e4:SetCondition(c9911665.rcccon)
	e4:SetTarget(c9911665.rcctg)
	e4:SetOperation(c9911665.rccop)
	c:RegisterEffect(e4)
end
function c9911665.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c9911665.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c9911665.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c9911665.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c9911665.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c9911665.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c9911665.costfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c9911665.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9911665.costfilter,1,REASON_COST,true,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9911665.costfilter,1,1,REASON_COST,true,nil)
	Duel.Release(g,REASON_COST)
end
function c9911665.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9911665.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==ev+1 then
		Duel.NegateActivation(ev)
	end
end
function c9911665.cfilter(c,tp)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c9911665.rcccon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and eg:IsExists(c9911665.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c9911665.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not g:IsExists(c9911665.ntdfilter,1,c)
end
function c9911665.ntdfilter(c)
	return not c:IsAbleToDeck()
end
function c9911665.rcctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c9911665.cfilter,nil,tp)
	g:AddCard(c)
	if chk==0 then return #g>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(c9911665.spfilter,1,nil,e,tp,g) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g-1,0,0)
end
function c9911665.rccop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if #g<2 or not g:IsContains(c) or aux.NecroValleyNegateCheck(tg) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:FilterSelect(tp,c9911665.spfilter,1,1,nil,e,tp,g):GetFirst()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	g:RemoveCard(tc)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
