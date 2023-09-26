--永燃的薪炎 淬火骑士的剑袭
function c12070003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,12070003)
	e1:SetCost(c12070003.cost)
	e1:SetTarget(c12070003.target)
	e1:SetOperation(c12070003.operation)
	c:RegisterEffect(e1)	  
	--dam 
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(12070003,1))
	--e2:SetCategory(CATEGORY_DAMAGE)
	--e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	--e2:SetCode(EVENT_CHAINING)
	--e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1)
	--e2:SetCondition(c12070003.damcon)
	--e2:SetCost(c12070003.damcost)
	--e2:SetTarget(c12070003.damtg)
	--e2:SetOperation(c12070003.damop)
	--c:RegisterEffect(e2)  
	--all 
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_XMATERIAL)
	--e3:SetCode(EFFECT_ATTACK_ALL)
	--e3:SetValue(1) 
	--e3:SetCondition(c12070003.alcon)
	--c:RegisterEffect(e3) 

	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(function(e) 
	return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) end)
	e2:SetValue(function(e,c)
	return c:GetOverlayCount()*100 end)
	c:RegisterEffect(e2) 
	--dam cal 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)   
	e3:SetCondition(function(e) 
	return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) end)
	e3:SetCost(c12070003.damccost)
	e3:SetTarget(c12070003.damctg) 
	e3:SetOperation(c12070003.damcop) 
	c:RegisterEffect(e3) 
end  
c12070003.SetCard_NeoK_Flame=true 
function c12070003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c12070003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c12070003.filter(c)
	return c.SetCard_NeoK_Flame and c:IsAbleToHand() 
end
function c12070003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5) 
	local g=Duel.GetDecktopGroup(tp,5):Filter(c12070003.filter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12070003,0)) then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)  
	end
	Duel.ShuffleDeck(tp)
end 
function c12070003.damcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and bit.band(re:GetActivateLocation(),LOCATION_MZONE)~=0 
end
function c12070003.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12070003.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) and re:GetHandler():GetBaseAttack()>0 end 
	local atk=re:GetHandler():GetBaseAttack() 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c12070003.damop(e,tp,eg,ep,ev,re,r,rp) 
	local atk=re:GetHandler():GetBaseAttack() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,atk,REASON_EFFECT) 
end
function c12070003.alcon(e) 
	local tp=e:GetHandlerPlayer() 
	return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) and Duel.GetLP(tp)<=Duel.GetLP(1-tp) 
end 

function c12070003.damccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12070003.damctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end 
function c12070003.damcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	Duel.CalculateDamage(c,tc) 
	end 
end 




