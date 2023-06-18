--霸瞳皇帝
function c11561022.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	c:EnableCounterPermit(0x1) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)
	--counter 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetCountLimit(1,11561022) 
	e1:SetTarget(c11561022.addtg)
	e1:SetOperation(c11561022.addop)
	c:RegisterEffect(e1)   
	-- 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_PREDRAW) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,21561022) 
	e2:SetTarget(c11561022.xxtg) 
	e2:SetOperation(c11561022.xxop) 
	c:RegisterEffect(e2)   
	--remove and draw  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_EXTRA) 
	e3:SetCountLimit(1,31561022) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsFaceup() end)
	e3:SetCost(c11561022.rdrcost)
	e3:SetTarget(c11561022.rdrtg) 
	e3:SetOperation(c11561022.rdrop) 
	c:RegisterEffect(e3)   
	--pendulum
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c11561022.pencon)
	e4:SetTarget(c11561022.pentg)
	e4:SetOperation(c11561022.penop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_PUBLIC)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e5) 
	--des dam rec
	local e6=Effect.CreateEffect(c) 
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_RECOVER) 
	e6:SetType(EFFECT_TYPE_IGNITION)  
	e6:SetRange(LOCATION_PZONE) 
	e6:SetCountLimit(1,41561022) 
	e6:SetCost(c11561022.ddrcost)  
	e6:SetTarget(c11561022.ddrtg) 
	e6:SetOperation(c11561022.ddrop) 
	c:RegisterEffect(e6)
end
function c11561022.addtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetMaterialCount() 
	if chk==0 then return x>0 and e:GetHandler():IsCanAddCounter(0x1,x) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,x,0,0x1)
end
function c11561022.addop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=c:GetMaterialCount()  
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1,x)
	end
end 
function c11561022.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11561022.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		if c:IsCanRemoveCounter(tp,0x1,1,REASON_EFFECT) then 
			if c:RemoveCounter(tp,0x1,1,REASON_EFFECT) then 
				--
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_REVERSE_DECK)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetRange(LOCATION_MZONE)
				e1:SetTargetRange(1,1) 
				e1:SetReset(RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)  
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCondition(c11561022.discon)
				e2:SetOperation(c11561022.disop) 
				e2:SetReset(RESET_PHASE+PHASE_END)
				c:RegisterEffect(e2) 
			end 
		else 
			Duel.Destroy(c,REASON_EFFECT+REASON_RULE)
		end  
	end 
end 
function c11561022.discon(e,tp,eg,ep,ev,re,r,rp) 
	local typ=0
	local tc=Duel.GetDecktopGroup(rp,1):GetFirst() 
	if tc==nil then return false end 
	if tc:IsType(TYPE_MONSTER) then typ=bit.bor(typ,TYPE_MONSTER) end 
	if tc:IsType(TYPE_SPELL) then typ=bit.bor(typ,TYPE_SPELL) end
	if tc:IsType(TYPE_TRAP) then typ=bit.bor(typ,TYPE_TRAP) end 
	return re:IsActiveType(typ) 
end
function c11561022.disop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,11561022)
	Duel.NegateEffect(ev)
end
function c11561022.rdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c,tp) return c:IsDiscardable() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,2,c) end,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,function(c,tp) return c:IsDiscardable() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,2,c) end,1,1,REASON_COST+REASON_DISCARD,nil,tp) 
end
function c11561022.rdrtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,x-1,tp,LOCATION_HAND) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x-1) 
end 
function c11561022.rdrop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0) 
	if g:GetCount()>=2 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		g:RemoveCard(tc) 
		local x=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) 
		if x>0 and Duel.IsPlayerCanDraw(tp,x) then 
			Duel.Draw(tp,x,REASON_EFFECT) 
			if Duel.GetFlagEffect(tp,11561022)==0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(11561022,0)) then 
				Duel.Draw(tp,1,REASON_EFFECT) 
			end   
		end 
	end  
	Duel.RegisterFlagEffect(tp,11561022,0,0,1) 
end 
function c11561022.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c11561022.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c11561022.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c11561022.ddrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c11561022.ddrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAttackBelow(2800) end,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2800) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2800) 
end 
function c11561022.ddrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAttackBelow(2800) end,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local dg=g:RandomSelect(tp,1) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then   
			Duel.Damage(1-tp,2800,REASON_EFFECT) 
			Duel.Recover(tp,2800,REASON_EFFECT)   
		end 
	end 
end








