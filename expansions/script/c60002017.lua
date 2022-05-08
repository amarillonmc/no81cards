--时光酒桌 菊月
local m=60002017
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.thfil(c) 
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x629) 
end
function cm.extraMove(e,tp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
end
--e2
function cm.extra3(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.addtg)
	e1:SetOperation(cm.addop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.extra5(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.gcost)
	e2:SetTarget(cm.gtg)
	e2:SetOperation(cm.gop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)  
end
function cm.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end 
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst()
	while tc do 
	--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()/2)
		tc=g:GetNext()
	end
end
function cm.ggctfil(c)
	return c:IsSetCard(0x629) and c:IsDiscardable() 
end
function cm.gcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ggctfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.ggctfil,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.gtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.gxgcon)
	e1:SetOperation(cm.gxgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(cm.gxspcon)
	e1:SetOperation(cm.gxspop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.gxgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:GetHandler():IsType(TYPE_SPELL) 

end
function cm.gxgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanDraw(tp,1) then 
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.gxspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>=5 
end
function cm.gxspfil(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL)
end 
function cm.gxspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.gxspfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(LOCATION_SZONE,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
	local g=Duel.SelectMatchingCard(tp,cm.gxspfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil) 
	Duel.SSet(tp,g)
	end
end

