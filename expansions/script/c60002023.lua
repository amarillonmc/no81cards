--时光酒桌 刹那
local m=60002023
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(timeTable.actionCon)
	e1:SetCost(cm.accost)
	e1:SetTarget(cm.actg)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	timeTable.spell(c,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local rh=Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local count=math.min(rc,rh)
	if chk==0 then return count>0 end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,count,nil)
	local count=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(count)
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	if Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil):GetCount()>=3 then 
		Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,x,nil) then 
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,x,x,nil)   
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if x>=2 and Duel.IsPlayerCanDraw(tp,1) then 
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if x>=4 then 
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
		end
	end
end
--e2
function cm.thfil(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function cm.extra3(e,tp)
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_GRAVE,0,1,nil) then 
		local sg=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.extra5(e,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(cm.dxefil)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.dxefil(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0x629)
end