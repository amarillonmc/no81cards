--噬骸之兽－阿穆特
function c11900093.initial_effect(c)
	aux.AddCodeList(c,11900061) 
	c:EnableReviveLimit() 
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION) 
	e0:SetCondition(function(e) 
	return not e:GetHandler():IsLocation(LOCATION_GRAVE) end)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11900093)
	e1:SetCost(c11900093.cost)
	e1:SetTarget(c11900093.target)
	e1:SetOperation(c11900093.operation)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)   
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11900093)
	e2:SetCondition(c11900093.discon) 
	e2:SetTarget(c11900093.distg)
	e2:SetOperation(c11900093.disop)
	c:RegisterEffect(e2)
end
function c11900093.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11900093.filter(c)
	return c:GetAttack()+c:GetDefense()==3200 and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c11900093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11900093.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11900093.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c11900093.filter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c11900093.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c11900093.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11900093.cfilter,1,e:GetHandler(),tp) 
end 
function c11900093.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Filter(c11900093.cfilter,e:GetHandler(),tp):Select(tp,1,1,nil) 
	Duel.SetTargetCard(tg) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800) 
end
function c11900093.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then 
		Duel.BreakEffect()
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then 
			Duel.Recover(tp,800,REASON_EFFECT)
		end  
	end 
end