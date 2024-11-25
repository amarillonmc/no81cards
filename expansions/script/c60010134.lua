--驶向第二次生命
function c60010134.initial_effect(c)
	aux.AddCodeList(c,60010077)
	aux.AddCodeList(c,60010029)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010134.condition)
	e0:SetOperation(c60010134.activate)
	c:RegisterEffect(e0)
	--effect gain
	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(aux.Stringid(60010134,2))
	ge1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	ge1:SetType(EFFECT_TYPE_QUICK_O)
	ge1:SetCode(EVENT_FREE_CHAIN)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetCountLimit(1)
	ge1:SetCost(c60010134.dacost)
	ge1:SetTarget(c60010134.datg)
	ge1:SetOperation(c60010134.daop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,60010077))
	e1:SetLabelObject(ge1)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010134)
	e2:SetCondition(c60010134.drcon)
	--e2:SetTarget(c60010134.drtg)
	e2:SetOperation(c60010134.drop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010134.checkop)
	c:RegisterEffect(e3)
end
function c60010134.checkop(e,tp,eg,ep,ev,re,r,rp)
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
function c60010134.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010134.thfilter(c)
	return c:IsCode(60010077,60010029) and c:IsAbleToHand()
end
function c60010134.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010134.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010134,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010134.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60010134.dafilter(c)
	return c:IsDefense(0) and c:IsFaceup()
end
function c60010134.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c60010134.dafilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c60010134.daop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c60010134.dafilter,tp,0,LOCATION_MZONE,nil)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	while g:GetClassCount(Card.GetAttribute)>1 or g:GetClassCount(Card.GetRace)>1 do
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		tg:Merge(sg)
		g:Sub(sg)
	end
	Duel.SendtoGrave(tg,REASON_RULE)
end
function c60010134.ownerfilter(c,tp)
	return c:IsCode(60010077) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010134.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010134.ownerfilter,1,nil,tp)
end
function c60010134.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c60010134.pcfilter(c)
	return aux.IsCodeListed(c,60010029) and c:IsFaceup()
end
function c60010134.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010134.pcfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(60010134,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(DOUBLE_DAMAGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
