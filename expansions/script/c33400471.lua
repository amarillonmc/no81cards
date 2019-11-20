--绝望的开端
function c33400471.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,33400471)
	e1:SetCondition(c33400471.thcon)
	e1:SetTarget(c33400471.thtg)
	e1:SetOperation(c33400471.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,33400471)
	e2:SetCondition(c33400471.condition)
	e2:SetTarget(c33400471.thtg1)
	e2:SetOperation(c33400471.thop1)
	c:RegisterEffect(e2)
end
function c33400471.cfilter2(c,tp,re)
	return  c:IsType(TYPE_MONSTER) and  c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and re:GetOwner():IsSetCard(0x341)
end
function c33400471.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400471.cfilter2,1,nil,tp,re)
end
function c33400471.thfilter(c)
	return c:IsSetCard(0x5342) or c:IsSetCard(0x6343)  and c:IsAbleToHand()
end
function c33400471.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400471.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33400471.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c33400471.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=g1:SelectSubGroup(tp,c33400471.check,false,1,2) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end
function c33400471.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x5342)
end
function c33400471.thfilter2(c)
	return c:IsSetCard(0x6343) and c:IsAbleToHand() 
end
function c33400471.check(g,c)
	if #g==1 then return true end
	local res=0
	if #g==2 then 
	if g:IsExists(c33400471.thfilter1,1,nil,c) then res=res+1 end
	if g:IsExists(c33400471.thfilter2,1,nil,c) then res=res+4 end
	return res==5 
	end
end

function c33400471.cnfilter(c)
	return c:IsSetCard(0xc342) 
end
function c33400471.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400471.cnfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end
function c33400471.thfilter4(c)
	return c:IsCode(33400472) and c:IsAbleToHand()
end
function c33400471.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400471.thfilter4,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400471.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not Duel.IsExistingMatchingCard(c33400471.thfilter4,tp,LOCATION_DECK,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c33400471.thfilter4,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end