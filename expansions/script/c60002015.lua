--时光酒桌 相月
local m=60002015
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.thfil(c)
	return c:IsSetCard(0x629) and not c:IsCode(m) and c:IsAbleToHand() 
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
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.gxstcost)
	e1:SetTarget(cm.gxsttg) 
	e1:SetOperation(cm.gxstop)
	c:RegisterEffect(e1)
end
function cm.extra5(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)   
end
function cm.gxstctfil(c)
	return c:IsDiscardable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function cm.gxstcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.gxstctfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,cm.gxstctfil,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.gxstfil(c) 
	if not Duel.IsPlayerAffectedByEffect(tp,m) then 
		return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable() 
	else
		return (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable()) or (c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER))
	end
end
function cm.gxstfil1(c) 
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) 
end
function cm.gxstgck(g,tp)
	if Duel.IsPlayerAffectedByEffect(tp,m) then 
		return g:FilterCount(cm.gxstfil1,nil)<=1 
	else 
		return g:FilterCount(cm.gxstfil1,nil)<=0
	end
end 
function cm.gxsttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.gxstfil,tp,LOCATION_GRAVE,0,nil)  
	if chk==0 then return g:CheckSubGroup(cm.gxstgck,1,99,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.gxstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 or not g:CheckSubGroup(cm.gxstgck,1,99,tp) then return end 
	if ft>3 then ft=3 end 
	local sg=g:SelectSubGroup(tp,cm.gxstgck,false,1,ft,tp) 
	local tc=sg:GetFirst() 
	while tc do  
		if tc:IsType(TYPE_TRAP) then 
			Duel.SSet(tp,tc)
		else 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
			Duel.ConfirmCards(1-tp,tc)
			timeTable.getCounter(tc)
		end
		tc=sg:GetNext()
	end
end