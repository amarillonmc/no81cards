local m=82228496
local cm=_G["c"..m]
cm.name="电之精灵王 雷伊"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x291),8,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)  
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.mtcon)
	e1:SetTarget(cm.mttg)  
	e1:SetOperation(cm.mtop) 
	c:RegisterEffect(e1) 
	--negate 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_BATTLE_CONFIRM)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCost(cm.negcost)  
	e2:SetCondition(cm.negcon)   
	e2:SetOperation(cm.negop)  
	c:RegisterEffect(e2) 
	--to hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetCategory(CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)  
end
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x291) and not c:IsCode(m)
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end  
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)  
end  
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)  
end  
function cm.mtfilter(c)  
	return c:IsSetCard(0x291)  
end  
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)  
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_DECK,0,1,nil) end  
end  
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.Overlay(c,g)  
	end  
end  
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)  
end  
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return c:IsRelateToBattle() and bc and bc:GetControler()~=tp and bc:IsFaceup() and bc:IsRelateToBattle() and not (bc:GetAttack()==0 and bc:GetDefense()==0 and (bc:IsDisabled() or not bc:IsType(TYPE_EFFECT)))
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget() 
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then 
		Duel.NegateRelatedChain(bc,RESET_TURN_SET) 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e3:SetValue(0)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e3) 
		local e4=e3:Clone()  
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)   
		bc:RegisterEffect(e4)   
	end
end
function cm.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x291) and c:IsAbleToHand() and not c:IsCode(m)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end