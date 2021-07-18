--妖圣骑士 崔斯坦
function c40009784.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009784,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,40009784)
	e2:SetCost(c40009784.thcost)
	e2:SetTarget(c40009784.thtg)
	e2:SetOperation(c40009784.thop)
	c:RegisterEffect(e2)
   --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009784,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_EQUIP)
	e3:SetCondition(c40009784.descon)
	e3:SetTarget(c40009784.destg)
	e3:SetOperation(c40009784.desop)
	c:RegisterEffect(e3)   
end
function c40009784.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local eg=e:GetHandler():GetEquipGroup()
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(0)
	if Duel.Release(e:GetHandler(),REASON_COST)>0 and eg:GetCount()>0 then e:SetLabel(1) end
end
function c40009784.thfilter(c)
	return ((c:IsSetCard(0x107a) and c:IsType(TYPE_SPELL)) or(c:IsSetCard(0x207a) and c:IsType(TYPE_TRAP)) or c:IsCode(51412776,82140600)) and c:IsAbleToHand()
end
function c40009784.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009784.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009784.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009784.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
function c40009784.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x207a)
end
function c40009784.desfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c40009784.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c40009784.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c40009784.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c40009784.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end