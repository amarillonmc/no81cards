--初见之地
function c71000104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetOperation(c71000104.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c71000104.con)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c71000104.damcon)
	e4:SetOperation(c71000104.damop)
	c:RegisterEffect(e4)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,71000100))
	c:RegisterEffect(e3)
end
function c71000104.filter(c)
	return c:IsCode(71000101,71000102) and c:IsAbleToHand()
end
function c71000104.ab(e,c)
	return c:IsCode(71000100)
end
function c71000104.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71000104.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71000104,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c71000104.xf(c,tp)
	return c:GetOwner()
end
function c71000104.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c71000104.xf,nil,tp)*300
	Duel.Damage(1-tp,d1,REASON_EFFECT,true)
	Duel.Recover(tp,d1,REASON_EFFECT,true)
	Duel.RDComplete()
end

function c71000104.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end

function c71000104.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	if ct>0 then
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		Duel.Recover(tp,ct*300,REASON_EFFECT)
	end
end
function c71000104.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe73) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c71000104.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c71000104.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end