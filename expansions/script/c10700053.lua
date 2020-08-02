--炼金釜－混沌提炼
function c10700053.initial_effect(c)
	c:SetUniqueOnField(1,1,10700053)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10700053.target)
	e1:SetOperation(c10700053.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c10700053.rmtg)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(500)
	e3:SetCondition(c10700053.effcon)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700053,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10700053.effcon)
	e4:SetLabel(3)
	e4:SetTarget(c10700053.thtg)
	e4:SetOperation(c10700053.thop)
	c:RegisterEffect(e4)
	--double 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(1)
	e5:SetTarget(c10700053.etarget)
	e5:SetCondition(c10700053.effcon)
	e5:SetLabel(4)
	c:RegisterEffect(e5)
	--Effect Draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DRAW_COUNT)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_SZONE) 
	e6:SetTargetRange(1,0)
	e6:SetValue(2)
	e6:SetCondition(c10700053.effcon)
	e6:SetLabel(5)
	c:RegisterEffect(e6)
	--immune effect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c10700053.etarget)
	e7:SetValue(c10700053.efilter)
	e7:SetCondition(c10700053.effcon)
	e7:SetLabel(6)
	c:RegisterEffect(e7)
end
function c10700053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end
function c10700053.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c10700053.rmtg(e,c,tp,sumtype,sumpos,targetp) 
	return c:GetOwner()==e:GetHandlerPlayer()
end 
function c10700053.confilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10700053.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c10700053.effcon(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(c10700053.confilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetAttribute)>=e:GetLabel() and not Duel.IsExistingMatchingCard(c10700053.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c10700053.tffilter(c)
	return (aux.IsCodeListed(c,10700053) and c:IsAbleToHand()) or (c:IsSetCard(0x3911) and c:IsAbleToHand())
end
function c10700053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700053.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c10700053.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700053.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10700053.etarget(e,c)
	return c:IsSetCard(0x3911)
end
function c10700053.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end