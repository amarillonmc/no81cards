--爆弹傀儡
local m=82209123
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--destroy  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e2:SetCode(EVENT_BATTLE_DESTROYED)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon)  
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)  
end  
function cm.filter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1083) and c:IsAbleToHand()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,2,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
		local og=Duel.GetOperatedGroup()
		if og:GetCount()==2 then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_FIELD)  
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
			e1:SetTargetRange(1,0)  
			e1:SetTarget(cm.splimit)  
			e1:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e1,tp)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_FIELD)  
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
			e2:SetTargetRange(1,0)  
			e2:SetValue(cm.actlimit)  
			e2:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e2,tp)  
		end
	end  
end  
function cm.splimit(e,c)  
	return not c:IsSetCard(0x1083)
end  
function cm.actlimit(e,re,rp)  
	local rc=re:GetHandler()  
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsCode(m)
end
function cm.cfilter(c,tp)  
	return c:GetPreviousControler()==tp and c:IsSetCard(0x1083)
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.cfilter,1,nil,tp) 
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800) 
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end  
end  