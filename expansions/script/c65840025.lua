--空间的守护灵
function c65840025.initial_effect(c)
	aux.AddCodeList(c,65840000)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c65840025.target2)
	e2:SetOperation(c65840025.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65840025)
	e3:SetCost(c65840025.drcost)
	e3:SetTarget(c65840025.drtg)
	e3:SetOperation(c65840025.drop)
	c:RegisterEffect(e3)
end

function c65840025.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c65840025.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end


function c65840025.cfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c65840025.setfilter(c)
	return c:IsSetCard(0xa34) and (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS)) and c:IsSSetable()
end
function c65840025.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65840025.cfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65840025.cfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c65840025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65840025.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c65840025.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65840025.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(c65840025.aclimit)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65840025.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_REMOVED and not re:GetHandler():IsCode(65840000) and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
end