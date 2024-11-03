--《沉默·之人》灵魂烛
function c51900009.initial_effect(c)
	aux.AddCodeList(c,51900003) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c51900009.target)
	e1:SetOperation(c51900009.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2500)
	c:RegisterEffect(e2) 
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_DISABLE) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c51900009.effectfilter)  
	c:RegisterEffect(e1)
	--remove 
	--equip
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,11900009) 
	e2:SetTarget(c51900009.eqtg)
	e2:SetOperation(c51900009.eqop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c51900009.regop)
	c:RegisterEffect(e3)
	--to hand/set
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,51900009)
	e4:SetCondition(c51900009.thcon)
	e4:SetTarget(c51900009.thtg)
	e4:SetOperation(c51900009.thop)
	c:RegisterEffect(e4)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c51900009.eqlimit)
	c:RegisterEffect(e2)
	if not c51900009.global_check then
		c51900009.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c51900009.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c51900009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsSummonType(SUMMON_TYPE_FUSION) and tc:GetMaterial():IsExists(Card.IsCode,1,nil,51900003) then 
			tc:RegisterFlagEffect(51900009,RESET_EVENT+RESETS_STANDARD,0,1) 
		end 
		tc=eg:GetNext()
	end
end
function c51900009.eqlimit(e,c)
	return c:IsCode(51900003) or c:GetFlagEffect(51900009)~=0 
end
function c51900009.filter(c)
	return c:IsFaceup() and (c:IsCode(51900003) or c:GetFlagEffect(51900009)~=0)
end
function c51900009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c51900009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c51900009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c51900009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c51900009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c51900009.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()  
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	local tc=te:GetHandler()
	return tc==e:GetHandler()  
end 
function c51900009.eqfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.IsExistingMatchingCard(c51900009.eqtgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c51900009.eqtgfilter(c,eqc)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and eqc:CheckEquipTarget(c)
end
function c51900009.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c51900009.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end 
end
function c51900009.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c51900009.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,c51900009.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst()
			Duel.Equip(tp,ec,tc)
		end
	end
end
function c51900009.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(51900009,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c51900009.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(51900009)>0
end
function c51900009.thfilter(c)
	return c:IsCode(51900003) and c:IsAbleToHand()
end
function c51900009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51900009.thfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c51900009.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c51900009.thfilter,tp,LOCATION_GRAVE,0,1,1,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		g:AddCard(c)
		Duel.SendtoHand(g,nil,REASON_EFFECT) 
	end
end










