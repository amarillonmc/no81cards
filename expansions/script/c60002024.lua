--时光酒桌 门扉
local m=60002024
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(timeTable.actionCon)
	e1:SetTarget(cm.actg)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(10002024)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(20002024)
	e3:SetCondition(cm.condition3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(m)
	e4:SetCondition(cm.condition4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.condition5)
	e5:SetTarget(cm.cptg)
	e5:SetOperation(cm.cpop)
	c:RegisterEffect(e5)
	timeTable.globle(c)
end
--e1
function cm.setfilter(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER)
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,3,nil) end 
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),tp,LOCATION_SZONE)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,0,nil)
	if dg:GetCount()>=0 and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,3,nil) then 
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,3,3,nil)
		local tc=sg:GetFirst()
		while tc do  
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
			Duel.ConfirmCards(1-tp,tc)
			timeTable.getCounter(tc)
			tc=sg:GetNext()
		end
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp) 
		Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)   
	end
end
--e2,3,4
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFlagEffect(tp,60002009)
	return x>=2
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFlagEffect(tp,60002009)
	return x>=12
end
function cm.condition5(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFlagEffect(tp,60002009)
	return x>=4
end
function cm.tgfil1(c)
	return c:IsFacedown() and c:IsAbleToGrave() 
end
function cm.cpfil(c)
	return c:IsCanChangePosition() and c:IsFaceup()
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfil,tp,0,LOCATION_MZONE,1,nil) and (Duel.IsPlayerAffectedByEffect(tp,60002011)
		or Duel.IsExistingMatchingCard(cm.tgfil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)) end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgfil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 or Duel.IsPlayerAffectedByEffect(tp,60002011) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT) 
		end
		local tc=Duel.SelectMatchingCard(tp,cm.cpfil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
	end 
end