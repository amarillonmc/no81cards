local m=82204239
local cm=_G["c"..m]
cm.name="虚妄灵子"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--damage  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1)  
	e2:SetCondition(cm.damcon)
	e2:SetTarget(cm.damtg)  
	e2:SetOperation(cm.damop)  
	c:RegisterEffect(e2) 
end
function cm.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6298) and c:IsAbleToHand()  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end  
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)  
	return  Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEDOWN)  
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(500)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT) 
	local g=Duel.GetMatchingGroup(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then  
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then  
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e1:SetValue(math.ceil(tc:GetAttack()/2))  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1)  
		end  
	end  
end  