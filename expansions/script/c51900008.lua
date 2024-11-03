--《空白·之日》失光刃
function c51900008.initial_effect(c)
	aux.AddCodeList(c,51900003) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c51900008.target)
	e1:SetOperation(c51900008.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2500)
	c:RegisterEffect(e2) 
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5) 
	--remove 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1,11900008) 
	e1:SetCost(c51900008.rmcost)
	e1:SetTarget(c51900008.rmtg) 
	e1:SetOperation(c51900008.rmop) 
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c51900008.regop)
	c:RegisterEffect(e3)
	--to hand/set
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,51900008)
	e4:SetCondition(c51900008.thcon)
	e4:SetTarget(c51900008.thtg)
	e4:SetOperation(c51900008.thop)
	c:RegisterEffect(e4)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c51900008.eqlimit)
	c:RegisterEffect(e2)
	if not c51900008.global_check then
		c51900008.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c51900008.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c51900008.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsSummonType(SUMMON_TYPE_FUSION) and tc:GetMaterial():IsExists(Card.IsCode,1,nil,51900003) then 
			tc:RegisterFlagEffect(51900008,RESET_EVENT+RESETS_STANDARD,0,1) 
		end 
		tc=eg:GetNext()
	end
end
function c51900008.eqlimit(e,c)
	return c:IsCode(51900003) or c:GetFlagEffect(51900008)~=0 
end
function c51900008.filter(c)
	return c:IsFaceup() and (c:IsCode(51900003) or c:GetFlagEffect(51900008)~=0)
end
function c51900008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c51900008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51900008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c51900008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c51900008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c51900008.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c51900008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsPlayerCanDiscardDeck(tp,3) 
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,3,nil)
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,POS_DEFENSE) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end 
function c51900008.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local b1=Duel.IsPlayerCanDiscardDeck(tp,3) 
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,3,nil)  
	if b1 or b2 then 
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(51900008,1),aux.Stringid(51900008,2))==0) then
			Duel.DiscardDeck(tp,3,REASON_EFFECT)
		else
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,3,3,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end 
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,POS_DEFENSE) then 
			Duel.BreakEffect()
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,POS_DEFENSE)  
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) 
		end 
	end 
end 
function c51900008.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(51900008,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c51900008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(51900008)>0
end
function c51900008.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c51900008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51900008.thfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c51900008.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c51900008.thfilter,tp,LOCATION_GRAVE,0,1,1,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		g:AddCard(c)
		Duel.SendtoHand(g,nil,REASON_EFFECT) 
	end
end









