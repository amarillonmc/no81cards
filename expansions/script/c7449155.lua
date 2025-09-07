--虫害侵扰
function c7449155.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7449155.target)
	e1:SetOperation(c7449155.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7449155,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,7449155)
	e2:SetCondition(c7449155.setcon)
	e2:SetTarget(c7449155.settg)
	e2:SetOperation(c7449155.setop)
	c:RegisterEffect(e2)
end
function c7449155.setfilter(c,chk)
	return c:IsCode(7449113) and c:IsSSetable() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c7449155.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return Duel.IsExistingMatchingCard(c7449155.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,0) and ft>=2
	end
end
function c7449155.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c7449155.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,2,2,nil)
	if #sg~=2 then return end
	Duel.SSet(tp,sg)
end
function c7449155.cfilter(c)
	return bit.band(c:GetPreviousRaceOnField(),RACE_INSECT)~=0
end
function c7449155.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7449155.cfilter,1,nil)
end
function c7449155.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c7449155.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
