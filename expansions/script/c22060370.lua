--秽惧黄昏 拉尔戈
function c22060370.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,2,c22060370.ovfilter,aux.Stringid(22060370,0),2,c22060370.xyzop)
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060370,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22060370)
	e1:SetCondition(c22060370.chcon)
	e1:SetCost(c22060370.chcost)
	e1:SetTarget(c22060370.chtg)
	e1:SetOperation(c22060370.chop)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22060370,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22060351)
	e2:SetCondition(c22060370.damtcon)
	e2:SetTarget(c22060370.thtg)
	e2:SetOperation(c22060370.thop)
	c:RegisterEffect(e2)

	if not c22060370.global_check then
		c22060370.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c22060370.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22060370.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(ep,22060370,RESET_PHASE+PHASE_END,0,1)
	end
end
function c22060370.ovfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsSetCard(0xff5)
end
function c22060370.xyzop(e,tp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetFlagEffect(1-tp,22060370)~=0 and Duel.GetFlagEffect(tp,22060351)==0 end
	Duel.RegisterFlagEffect(tp,22060351,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c22060370.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-tp
end
function c22060370.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22060370.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c22060370.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22060370.repop)
end
function c22060370.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,200,REASON_EFFECT)
end

function c22060370.damtcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and re and re:GetHandler():IsSetCard(0xff5)
end
function c22060370.thfilter(c)
	return c:IsSetCard(0xff5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22060370.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22060370.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22060370.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22060370.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end