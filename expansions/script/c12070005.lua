--永燃的薪炎 薪炎王剑的凯旋
function c12070005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,12070005)
	e1:SetCost(c12070005.cost)
	e1:SetTarget(c12070005.target)
	e1:SetOperation(c12070005.operation)
	c:RegisterEffect(e1)	  
	--destroy
	--local e2=Effect.CreateEffect(c) 
	--e2:SetDescription(aux.Stringid(12070005,1))
	--e2:SetCategory(CATEGORY_DESTROY)
	--e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1) 
	--e2:SetCost(c12070005.descost)
	--e2:SetTarget(c12070005.destg)
	--e2:SetOperation(c12070005.desop)
	--c:RegisterEffect(e2) 
	--dam 
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(12070005,2))
	--e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_NEGATE)
	--e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	--e3:SetCode(EVENT_CHAINING)
	--e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	--e3:SetCondition(c12070005.damcon)
	--e3:SetCost(c12070005.damcost)
	--e3:SetTarget(c12070005.damtg)
	--e3:SetOperation(c12070005.damop)
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
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1) 
	e3:SetCondition(function(e) 
	return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) end)
	e3:SetCost(c12070005.xdescost)
	e3:SetTarget(c12070005.xdestg)
	e3:SetOperation(c12070005.xdesop)
	c:RegisterEffect(e3)
end  
c12070005.SetCard_NeoK_Flame=true 
function c12070005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c12070005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c12070005.filter(c)
	return c.SetCard_NeoK_Flame and c:IsAbleToHand() 
end
function c12070005.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5) 
	local g=Duel.GetDecktopGroup(tp,5):Filter(c12070005.filter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12070005,0)) then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)  
	end
	Duel.ShuffleDeck(tp)
end 
function c12070005.desfil(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsSummonType(SUMMON_TYPE_SPECIAL) 
end 
function c12070005.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c12070005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12070005.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c12070005.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end
function c12070005.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local g=Duel.GetMatchingGroup(c12070005.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e),c:GetAttack())
	Duel.Destroy(g,REASON_EFFECT)   
	end 
end
function c12070005.damcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and bit.band(re:GetActivateLocation(),LOCATION_MZONE)~=0 and Duel.IsChainNegatable(ev) 
end
function c12070005.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12070005.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) end 
	local atk=re:GetHandler():GetBaseAttack()  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c12070005.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.NegateActivation(ev) then 
	local atk=re:GetHandler():GetBaseAttack()  
	Duel.Damage(1-tp,atk,REASON_EFFECT)  
	end 
end

function c12070005.xdescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2) 
end 
function c12070005.xdesfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsSummonType(SUMMON_TYPE_SPECIAL)  
end
function c12070005.xdestg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12070005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c12070005.xdesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end
function c12070005.xdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c12070005.xdesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e),c:GetAttack()) 
	if g:GetCount()>0 then 
	Duel.Destroy(g,REASON_EFFECT) 
	end  
end





