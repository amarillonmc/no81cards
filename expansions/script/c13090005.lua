--白驹过江
local m=13090005
local cm=_G["c"..m]
function c13090005.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
c13090005.star_knight_spsummon_effect=e1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
c13090005.star_knight_summon_effect=e2
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xe08) and c:IsAbleToGraveAsCost() and c:IsFaceup() end,tp,LOCATION_EXTRA,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xe08) and c:IsAbleToGraveAsCost() and c:IsFaceup() end,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and ep~=tp
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local aa=eg:GetFirst():GetControler()
	return rp==tp and aa~=tp
end
function cm.stfilter1(c)
	return c:IsSetCard(0xe08) 
end
function cm.thfilter1(c)
	return c:IsType(TYPE_QUICKPLAY)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	--[[延迟效果可以空发，所以没必要检测卡组中是否存在满足条件的卡
	local b1=Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.stfilter1,tp,LOCATION_DECK,0,1,nil)
	local op=0
	local off=1
	local ops={}
	local opval={}
	if true then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if true then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end]]
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cm.splimit)
		Duel.RegisterEffect(e2,tp)
		end
	if op==1 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetCountLimit(1)
		e3:SetLabel(Duel.GetTurnCount())
		e3:SetCondition(cm.stcon)
		e3:SetOperation(cm.stop)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e3:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e3:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SKIP_BP)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e4:SetTargetRange(1,0)
		local ph=Duel.GetCurrentPhase()
		if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e4:SetLabel(Duel.GetTurnCount())
			e4:SetCondition(cm.skipcon)
			e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_DECK)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(cm.stfilter1,tp,LOCATION_DECK,0,1,nil)
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.stfilter1,tp,LOCATION_DECK,0,1,1,nil)
	local b1=g:GetFirst():IsAbleToHand()
	local b2=g:GetFirst():IsSSetable()
	local op=0
	local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(m,3)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,4)
			opval[off-1]=2
			off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif opval[op]==2 then
		Duel.SSet(tp,g)
	end
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.thfilter(c)
	return c:IsSetCard(0xe08) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler() and Duel.GetLocationCount(tp,LOCATION_SZONE) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetCode(EFFECT_CHANGE_TYPE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e3:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e3)
	end
end
