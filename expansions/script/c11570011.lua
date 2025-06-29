--翼冠龙·肥满之梅尔顾普德
function c11570011.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11570011+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11570011.sprcon)
	e1:SetOperation(c11570011.sprop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	--e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(11570011,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,11570011)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11570011.rmtg)
	e2:SetOperation(c11570011.rmop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c11570011.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c11570011.sprfilter(c)
	return c:IsSetCard(0x810) and (c:IsAbleToGraveAsCost() or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup())
end
function c11570011.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11570011.sprfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,2,c)
end
function c11570011.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11570011.sprfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,2,2,c)
	local rg=g:Filter(Card.IsLocation,1,nil,LOCATION_REMOVED)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RETURN)
	g:Sub(rg)
	Duel.SendtoGrave(g,REASON_COST)
end
function c11570011.rmfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToRemove()
end
function c11570011.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570011.rmfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetTurnPlayer()~=tp or Duel.IsExistingMatchingCard(c11570011.rmfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetTurnPlayer()==tp) end
end
function c11570011.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(c11570011.rmfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c11570011.rmfilter,tp,LOCATION_HAND,0,1,1,nil)
		rg:Merge(g1)
	end
	if Duel.IsExistingMatchingCard(c11570011.rmfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c11570011.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
		rg:Merge(g2)
	end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetTurnPlayer()~=tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.HintSelection(g3)
		rg:Merge(g3)
	end
	if rg:GetCount()~=2 or Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local tg,ct=og:GetMaxGroup(Card.GetLevel)
	if not tg then return end
	Duel.Recover(tp,ct*100,REASON_EFFECT)
end
function c11570011.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570011.recon(e)
	return not Duel.IsExistingMatchingCard(c11570011.chkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and e:GetHandler():IsFaceup()
end
