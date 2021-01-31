--璞玉雕琢之月神
function c9910070.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c9910070.ffilter1,c9910070.ffilter2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9910070.sprcon)
	e2:SetOperation(c9910070.sprop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCost(c9910070.thcost)
	e3:SetTarget(c9910070.thtg)
	e3:SetOperation(c9910070.thop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910070,ACTIVITY_CHAIN,c9910070.chainfilter)
end
function c9910070.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_FAIRY) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9910070.ffilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c9910070.ffilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c9910070.sprfilter1(c,sc)
	return c:IsReleasable() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9910070.sprfilter2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
		and g:IsExists(c9910070.ffilter1,1,nil) and g:IsExists(c9910070.ffilter2,1,nil)
end
function c9910070.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9910070.sprfilter1,tp,LOCATION_MZONE,0,nil,c)
	return Duel.GetCustomActivityCount(9910070,tp,ACTIVITY_CHAIN)~=0
		and g:CheckSubGroup(c9910070.sprfilter2,2,2,tp,c)
end
function c9910070.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9910070.sprfilter1,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9910070.sprfilter2,true,2,2,tp,c)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST)
end
function c9910070.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910070.thfilter(c)
	return c:IsCode(9910059) and c:IsAbleToHand()
end
function c9910070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c9910070.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910070.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910070.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
