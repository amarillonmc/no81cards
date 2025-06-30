--翼冠·雷爪龙·沃尔特神威
function c11570006.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11570006)
	e1:SetCost(c11570006.spcost)
	e1:SetTarget(c11570006.sptg)
	e1:SetOperation(c11570006.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11570006,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11670006)
	e2:SetCondition(c11570006.discon)
	e2:SetCost(c11570006.discost)
	e2:SetTarget(c11570006.distg)
	e2:SetOperation(c11570006.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11570006,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,11770006)
	e3:SetCondition(c11570006.thcon)
	e3:SetTarget(c11570006.thtg)
	e3:SetOperation(c11570006.thop)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetCost(c11570006.splcost)
	c:RegisterEffect(e4)
end
function c11570006.sprfilter(c)
	return c:IsSetCard(0x810) and c:IsFaceupEx() and (c:IsAbleToGraveAsCost() or c:IsLocation(LOCATION_REMOVED))
end
function c11570006.gcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and #g==2
end
function c11570006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11570006.sprfilter,tp,LOCATION_REMOVED+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c11570006.gcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c11570006.gcheck,false,2,2,tp)
	local rg=sg:Filter(Card.IsLocation,1,nil,LOCATION_REMOVED)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RETURN)
	sg:Sub(rg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c11570006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c11570006.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():SetMaterial(nil)
		Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
	end
end
function c11570006.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
end
function c11570006.cfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToGraveAsCost()
end
function c11570006.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570006.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11570006.cfilter,1,1,REASON_COST,nil)
end
function c11570006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end
function c11570006.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c11570006.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c11570006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11570006.remfilter,1,nil)
end
function c11570006.thfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11570006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570006.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c11570006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11570006.thfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11570006.chkfilter(c)
	return c:IsSetCard(0x3810) and c:IsFaceup()
end
function c11570006.splcost(e,c,tp,sumtype)
	return Duel.IsExistingMatchingCard(c11570006.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
