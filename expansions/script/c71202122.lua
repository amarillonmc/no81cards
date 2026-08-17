local s,id,o=GetID()
function s.initial_effect(c)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--② register flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--② battle protection
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.battlecon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--③
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
--①
function s.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_SZONE,0,1,nil)
end
--②
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.battlecon(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
--③
function s.costfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,3,nil)
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x88f) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		return b1 or b2
	end
	local b1=Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,ct,nil)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,ct,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	e:SetLabel(ct*10+op)
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,1-tp,LOCATION_ONFIELD)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
	end
end
function s.thcheck(sg,tp,ct)
	return sg:GetClassCount(Card.GetCode)==ct
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local ct=math.floor(label/10)
	local op=label%10
	if op==0 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,ct,ct,nil)
		if #sg>0 then
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	else
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #g<ct then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,s.thcheck,false,ct,ct,tp,ct)
		if sg and #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
