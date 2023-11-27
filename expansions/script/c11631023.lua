--革新之药剂师 兰
local m=11631023
local cm=_G["c"..m]
--strings
cm.yaojishi=true 
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,cm.matfilter,aux.NonTuner(cm.matfilter2),1,1)  
	c:EnableReviveLimit()
	--show
	if not cm.summonwords then
		cm.summonwords=true
		local e114=Effect.CreateEffect(c)
		e114:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e114:SetCode(EVENT_SPSUMMON)
		e114:SetOperation(cm.show)
		Duel.RegisterEffect(e114,tp)
	end
	local e514=Effect.CreateEffect(c)
	e514:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e514:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e514:SetCode(EVENT_SPSUMMON_SUCCESS)
	e514:SetOperation(cm.show2)
	c:RegisterEffect(e514)
	--search/negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--add attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetOperation(aux.chainreg)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EVENT_CHAIN_SOLVED)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetOperation(cm.atkop)  
	c:RegisterEffect(e3)  
	--activate from hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.actfilter)  
	e4:SetTargetRange(LOCATION_HAND,0)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e5) 
end

--material
function cm.matfilter(c)  
	return c:IsCode(11631007)
end  
function cm.matfilter2(c)
	return c.yaojishi
end

--show
function cm.showfilter(c)
	return c:IsOriginalCodeRule(m) and c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.show(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(cm.showfilter,1,nil) then return end
	Debug.Message("继承师长意志的革新者啊！为陈旧的药界带来新风吧！")
	Debug.Message("同调召唤！等级7！革新之药剂师 兰！")
end
function cm.show2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
	if cm.matcheck1(c) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_TURN_SET)
		c:RegisterEffect(e1)
	end
	if cm.matcheck2(c) then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,3))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(m)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_TURN_SET)
		c:RegisterEffect(e2)
	end
end

--search/negate
function cm.cfilter1(c)
	return c.yaojishi and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_TUNER)
end
function cm.cfilter2(c)
	return c.yaojishi and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_TUNER)
end
function cm.matcheck1(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterial():IsExists(cm.cfilter1,1,nil)
end
function cm.matcheck2(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterial():IsExists(cm.cfilter2,1,nil)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end  
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (cm.matcheck1(c) or Duel.IsChainNegatable(ev))
end
function cm.thfilter(c)
	return c:IsAbleToHand() and (c.tezhiyao or c.zhiyaoshu)
end
function cm.tgf(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 
		(cm.matcheck1(c) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)) or 
		(cm.matcheck2(c) and Duel.IsChainNegatable(ev))
	end
	if cm.matcheck1(c) then  
		e:SetCategory(e:GetCategory()+CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if cm.matcheck2(c) and Duel.IsChainNegatable(ev) then
		e:SetCategory(e:GetCategory()+CATEGORY_NEGATE)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
		end  
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end

	if cm.matcheck1(c) then
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
			Duel.ConfirmCards(1-tp,g)  
			local tc=Duel.GetOperatedGroup():GetFirst()
			if tc and tc:IsLocation(LOCATION_HAND) and tc.tezhiyao then
				Duel.ShuffleHand(tp)
				local e1=Effect.CreateEffect(c) 
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end  
	
	if cm.matcheck2(c) and Duel.IsChainNegatable(ev) then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
		end
	end  

end

--add attack
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and re:GetHandler().tezhiyao and c:GetFlagEffect(1)>0 then  
		Duel.Hint(HINT_CARD,0,m)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end  
end  

--act in hand
function cm.actfilter(e,c)
	return c.tezhiyao and c:IsPublic()
end
