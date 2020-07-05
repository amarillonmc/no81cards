--整合运动·无人机-爆鸰·G
function c79020016.initial_effect(c)
   --counter
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetTarget(c79020016.ctg)
   e1:SetOperation(c79020016.cop)
   c:RegisterEffect(e1) 
   local e2=e1:Clone()
   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e2)
   local e3=e1:Clone()
   e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
   c:RegisterEffect(e3)
   --Destroy
   local e4=Effect.CreateEffect(c)
   e4:SetType(EFFECT_TYPE_IGNITION)
   e4:SetCategory(CATEGORY_DESTROY)
   e4:SetRange(LOCATION_MZONE)
   e4:SetCountLimit(1,79020016)
   e4:SetCost(c79020016.cost)
   e4:SetTarget(c79020016.dtg)
   e4:SetOperation(c79020016.dop)
   c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12097275,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(c79020016.thtg)
	e5:SetOperation(c79020016.thop)
	c:RegisterEffect(e5)
end
function c79020016.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c79020016.cop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then 
	e:GetHandler():AddCounter(0x1099,1)
end
end
function c79020016.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1099,1,REASON_COST)

	end
	e:GetHandler():RemoveCounter(tp,0x1099,1,REASON_COST)
end
function c79020016.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c79020016.dop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	e:SetLabel(seq+16)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(e:GetLabel())
	e1:SetOperation(c79020016.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SWAP_AD)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e2)
end
end
function c79020016.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
function c79020016.thfilter(c)
	return c:IsSetCard(0x3900) and c:IsAbleToHand()
end
function c79020016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79020016.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79020016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79020016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end







