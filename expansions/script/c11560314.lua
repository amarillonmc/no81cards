--宿命的狐火 雪华
function c11560314.initial_effect(c) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),3,3) 
	--redirect 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--atk limit
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetValue(function(e,c)
	return c~=e:GetHandler() end)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCondition(c11560314.thcon)
	e2:SetTarget(c11560314.thtg) 
	e2:SetOperation(c11560314.thop) 
	c:RegisterEffect(e2) 
	local e4=e2:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	--atk up 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1)
	e3:SetCondition(c11560314.apcon) 
	e3:SetTarget(c11560314.aptg)
	e3:SetOperation(c11560314.apop)
	c:RegisterEffect(e3)
	if not c11560314.global_check then
		c11560314.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c11560314.rmckop)
		Duel.RegisterEffect(ge1,0) 
	end 
end
c11560314.SetCard_XdMcy=true   
function c11560314.rmckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() 
	while tc do   
	local flag=Duel.GetFlagEffectLabel(tc:GetControler(),11560314)
	if flag==nil then 
	Duel.RegisterFlagEffect(tc:GetControler(),11560314,0,0,0,1) 
	else 
	Duel.SetFlagEffectLabel(tc:GetControler(),11560314,flag+1)   
	end 
	tc=eg:GetNext() 
	end 
end 
function c11560314.thcon(e,tp,eg,ep,ev,re,r,rp) 
	local flag=Duel.GetFlagEffectLabel(tp,11560314)
	return flag and flag>=10		  
end 
function c11560314.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoHand(tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0) 
end 
function c11560314.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local token=Duel.CreateToken(tp,11560315) 
	if token and Duel.IsPlayerCanSendtoHand(tp) then 
	Duel.SendtoHand(token,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,token)  
	end  
end 
function c11560314.apcon(e,tp,eg,ep,ev,re,r,rp)  
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:GetHandler().SetCard_XdMcy and g and g:IsContains(e:GetHandler()) 
end 
function c11560314.aptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end  
function c11560314.armfil(c,flag) 
	return flag and c:IsAbleToRemove() and c:IsAttackBelow(flag*800)   
end 
function c11560314.apop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(1600) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)  
	local flag=Duel.GetFlagEffectLabel(tp,11560314)
	if flag and Duel.IsExistingMatchingCard(c11560314.armfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,flag) and Duel.SelectYesNo(tp,aux.Stringid(11560314,1)) then 
	local dg=Duel.SelectMatchingCard(tp,c11560314.armfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,flag) 
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	end   
	end 
end 









