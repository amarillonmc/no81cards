local m=82228610
local cm=_G["c"..m]
cm.name="荒兽 翊"
function cm.initial_effect(c)
	--multi attack  
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(m,1)) 
	e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)
	e1:SetCondition(cm.atkcon)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.atktg)  
	e1:SetOperation(cm.atkop)  
	c:RegisterEffect(e1)
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.tg)  
	e2:SetOperation(cm.op)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e3)  
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	return c:IsSetCard(0x2299) and Duel.IsAbleToEnterBP()  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end 
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0  
		and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK_MONSTER)==0 end  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_EXTRA_ATTACK)  
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.filter(c)  
	return c:IsSetCard(0x2299) and c:IsAbleToHand() and not c:IsType(TYPE_MONSTER)
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end  
function cm.splimit(e,c)  
	return not c:IsSetCard(0x2299) and c:IsLocation(LOCATION_EXTRA)  
end  