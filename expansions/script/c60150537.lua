--幻想乐章的高潮·孤寂
function c60150537.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60150537.mfilter,11,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.xyzlimit)
	c:RegisterEffect(e11)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150537,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c60150537.descon)
	e1:SetTarget(c60150537.destg)
	e1:SetOperation(c60150537.desop)
	c:RegisterEffect(e1)
	
	--mzone limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c60150537.value)
	c:RegisterEffect(e2)
	--advance summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(c60150537.sumlimit)
	c:RegisterEffect(e3)
	--kaiser colosseum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_KAISER_COLOSSEUM)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	
	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(60150537,1))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c60150537.actcon)
	e7:SetCost(c60150537.rmcost)
	e7:SetTarget(c60150537.rmtg)
	e7:SetOperation(c60150537.rmop)
	c:RegisterEffect(e7)
end
function c60150537.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150537.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c60150537.filter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c60150537.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c60150537.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150537.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60150537.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60150537.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c60150537.limitcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()~=0
end
function c60150537.value(e,fp,rp,r)
	if rp==e:GetHandlerPlayer() or r~=LOCATION_REASON_TOFIELD then return 7 end
	local limit=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return limit>0 and limit or 7
end
function c60150537.sumlimit(e,c)
	local tp=e:GetHandlerPlayer()
	if c:IsControler(1-tp) then
		local mint,maxt=c:GetTributeRequirement()
		local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		local y=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local ex=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE)
		local exs=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE_SUM)
		if ex==0 and exs>0 then ex=1 end
		return y-maxt+ex+1 > x-ex
	else
		return false
	end
end
function c60150537.actcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60150515)
end
function c60150537.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150537.filter2(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c60150537.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c60150537.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end