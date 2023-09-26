--永燃的薪炎 燎原炎车的狼烟
function c12070006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,12070006)
	e1:SetCost(c12070006.cost)
	e1:SetTarget(c12070006.target)
	e1:SetOperation(c12070006.operation)
	c:RegisterEffect(e1)	 
	--atk up
	--local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_ATKCHANGE)
	--e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	--e2:SetCondition(c12070006.atkcon)  
	--e2:SetCost(c12070006.atkcost)
	--e2:SetOperation(c12070006.atkop)
	--c:RegisterEffect(e2) 
	--immune
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_XMATERIAL)
	--e3:SetCode(EFFECT_IMMUNE_EFFECT)
	--e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e3:SetRange(LOCATION_MZONE) 
	--e3:SetCondition(c12070006.imcon)
	--e3:SetValue(c12070006.efilter)
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
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12070006,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c12070006.discon)
	e3:SetCost(c12070006.discost)
	e3:SetTarget(c12070006.distg)
	e3:SetOperation(c12070006.disop)
	c:RegisterEffect(e3)
end
c12070006.SetCard_NeoK_Flame=true 
function c12070006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c12070006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c12070006.filter(c)
	return c.SetCard_NeoK_Flame and c:IsAbleToHand() 
end
function c12070006.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5) 
	local g=Duel.GetDecktopGroup(tp,5):Filter(c12070006.filter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12070006,0)) then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)  
	end
	Duel.ShuffleDeck(tp)
end 
function c12070006.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0 and e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ)
end
function c12070006.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(12070006)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(12070006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c12070006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c12070006.imcon(e) 
	local tp=e:GetHandlerPlayer() 
	return e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ) and Duel.GetLP(tp)<=Duel.GetLP(1-tp) 
end 
function c12070006.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActivated() 
end

function c12070006.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) and e:GetHandler().SetCard_NeoK_Flame and e:GetHandler():IsType(TYPE_XYZ)
end
function c12070006.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12070006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c12070006.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local atk=re:GetHandler():GetBaseAttack()
	if Duel.NegateActivation(ev) and atk and atk>0 then 
	Duel.Damage(1-tp,atk,REASON_EFFECT) 
	end 
end



