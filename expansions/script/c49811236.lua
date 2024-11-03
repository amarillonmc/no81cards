--漆黑之魔王 LV10
function c49811236.initial_effect(c)
	--to hand or special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,49811236)
	e1:SetCondition(c49811236.thcon)
	e1:SetCost(c49811236.thcost)
	e1:SetTarget(c49811236.thtg)
	e1:SetOperation(c49811236.thop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c49811236.disop)
	c:RegisterEffect(e2)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)
	--spsummon proc
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCondition(c49811236.hspcon)
	e3:SetTarget(c49811236.hsptg)
	e3:SetOperation(c49811236.hspop)
	c:RegisterEffect(e3)
end
c49811236.lvdn={49811234,85313220,12817939,58206034}
function c49811236.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c49811236.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c49811236.thfilter(c,e,tp,check)
	return (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4))
		and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c49811236.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and re:GetActivateLocation()==LOCATION_GRAVE)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811236.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
	if check then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c49811236.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and re:GetActivateLocation()==LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c49811236.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not (check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)) or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c49811236.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	if d and d:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsType(TYPE_EFFECT) and not c:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetLabelObject(d)
		e1:SetTarget(c49811236.distg)		
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabelObject(d)
		e2:SetCondition(c49811236.discon)
		e2:SetOperation(c49811236.disop2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c49811236.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c49811236.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c49811236.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c49811236.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FIEND) and c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,nil)>0
end
function c49811236.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c49811236.spfilter,tp,LOCATION_REMOVED,0,4,nil,tp)
end
function c49811236.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c49811236.spfilter,tp,LOCATION_REMOVED,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,4,4,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c49811236.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	g:DeleteGroup()
end