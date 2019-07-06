--古董咖啡屋-FOREST
function c33700048.initial_effect(c)
 c:EnableCounterPermit(0x1021)  
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700048,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,33700048)
	e2:SetCost(c33700048.thcost)
	e2:SetTarget(c33700048.thtg)
	e2:SetOperation(c33700048.thop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700048,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,33700049)
	e3:SetCost(c33700048.ccost)
	e3:SetTarget(c33700048.ctg)
	e3:SetOperation(c33700048.cop)
	c:RegisterEffect(e3)
 --destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c33700048.reptg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c33700048.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1021)>0 end
	Duel.RemoveCounter(tp,1,0,0x1021,1,REASON_COST)
end
function c33700048.thfilter(c)
	return c:IsSetCard(0x441) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33700048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700048.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33700048.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33700048.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33700048.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c33700048.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1021,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1021)
end
function c33700048.cop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	 e:GetHandler():AddCounter(0x1021,1)
end
function c33700048.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and tc:IsFaceup() and tc:IsLocation(LOCATION_ONFIELD)  and Duel.GetFlagEffect(tp,33700046)==0
		and tc:IsSetCard(0x441) and  e:GetHandler():GetCounter(0x1021)>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(33700048,2)) then
		 e:GetHandler():RemoveCounter(tp,0x1021,1,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,33700046,RESET_PHASE+PHASE_END,0,1)  
	return true
	else return false end
end