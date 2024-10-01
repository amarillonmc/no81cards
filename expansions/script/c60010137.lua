--铭记于心的约定
function c60010137.initial_effect(c)
	aux.AddCodeList(c,60010031)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010137.condition)
	e0:SetOperation(c60010137.activate)
	c:RegisterEffect(e0)
	--code
	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(aux.Stringid(60010137,1))
	ge1:SetCategory(CATEGORY_DRAW)
	ge1:SetType(EFFECT_TYPE_IGNITION)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetCountLimit(1)
	ge1:SetCost(c60010137.drcost)
	ge1:SetOperation(c60010137.drop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,60010031))
	e1:SetLabelObject(ge1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010137)
	e2:SetCondition(c60010137.decon)
	e2:SetTarget(c60010137.detg)
	e2:SetOperation(c60010137.deop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010137.checkop)
	c:RegisterEffect(e3)
end
function c60010137.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not SpaceCheck then
		SpaceCheck={}
		for i=0,1 do
			local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
			if #g==g:GetClassCount(Card.GetCode) then
				SpaceCheck[i]=true
			end
		end
	end
end
function c60010137.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010137.thfilter(c)
	return c:IsCode(60010031) and c:IsAbleToHand()
end
function c60010137.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010137.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010137,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010137.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60010137.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c60010137.draw)
	Duel.RegisterEffect(e1,tp)
end
function c60010137.draw(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60010137)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		local tg=Duel.GetOperatedGroup():Filter(Card.IsSSetable,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(60010137,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=tg:Select(tp,1,2,nil)
			Duel.SSet(tp,sg)
		end
	end
end
function c60010137.ownerfilter(c,tp)
	return c:IsCode(60010031) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010137.decon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010137.ownerfilter,1,nil,tp)
end
function c60010137.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60010137.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
