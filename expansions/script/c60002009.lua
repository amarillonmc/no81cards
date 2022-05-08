--时光酒桌 嘉月
local m=60002009
local cm=_G["c"..m]
timeTable=timeTable or {}
--set self
function timeTable.set(c,code,extra)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,code)
	e1:SetCondition(timeTable.setIgCon)
	e1:SetCost(timeTable.setcost)
	e1:SetTarget(timeTable.settg)
	e1:SetOperation(timeTable.setop(extra))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(timeTable.setQuCon)
	c:RegisterEffect(e2)
	return e1,e2
end
function timeTable.setIgCon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,60002024)
end
function timeTable.setQuCon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,60002024)
end
function timeTable.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function timeTable.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function timeTable.getCounter(c)
	--get counter type
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
	c:RegisterEffect(e1)  
	--get effect by counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(timeTable.counterEffectCost)
	e2:SetTarget(timeTable.counterEffectTarget)
	e2:SetOperation(timeTable.counterEffectOperation)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--cant use counter effect to turn end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
end
function timeTable.setop(extra)
	return function(e,tp,eg,ep,ev,re,r,rp)
			   local c=e:GetHandler()
			   if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then 
				   Duel.ConfirmCards(1-tp,c)
				   timeTable.getCounter(c)
				   if extra then extra(e,tp,1) end
			   end
		   end
end
function timeTable.toGraveFilter(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() 
end
function timeTable.groupCheckMzone(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function timeTable.groupCheckSzone(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE)
end
function timeTable.selectToGrave(g,tp)
	if Duel.IsPlayerAffectedByEffect(tp,10002024) and Duel.IsPlayerAffectedByEffect(tp,20002024) then 
		return g:FilterCount(timeTable.groupCheckMzone,nil,tp)<=1 and g:FilterCount(timeTable.groupCheckSzone,nil,tp)<=1
	elseif Duel.IsPlayerAffectedByEffect(tp,10002024) then 
		return g:FilterCount(timeTable.groupCheckMzone,nil,tp)<=1 and g:FilterCount(timeTable.groupCheckSzone,nil,tp)<=0
	elseif Duel.IsPlayerAffectedByEffect(tp,20002024) then 
		return g:FilterCount(timeTable.groupCheckMzone,nil,tp)<=0 and g:FilterCount(timeTable.groupCheckSzone,nil,tp)<=1
	else
		return g:FilterCount(timeTable.groupCheckMzone,nil,tp)<=0 and g:FilterCount(timeTable.groupCheckSzone,nil,tp)<=0
	end
end
function timeTable.counterEffectCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=3
	if Duel.IsPlayerAffectedByEffect(tp,60002011) then 
		x=2
	end
	local g=Duel.GetMatchingGroup(timeTable.toGraveFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(timeTable.selectToGrave,x,99,tp) end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
	local sg=g:SelectSubGroup(tp,timeTable.selectToGrave,false,x,3,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function timeTable.removeFilter(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function timeTable.chainlm(e,rp,tp)
	return e:GetHandler():IsType(TYPE_COUNTER)
end
function timeTable.counterEffectTarget(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(timeTable.removeFilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.SetChainLimit(timeTable.chainlm) 
	end
end
function timeTable.immval(e,te)
	return ((te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)) or te:IsActiveType(TYPE_TRAP)) and te:GetHandlerPlayer()~=tp
end
function timeTable.immue(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(timeTable.immval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
end
function timeTable.counterEffectOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--spsum
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		--immue
		timeTable.immue(c)
		--remove
		local g=Duel.SelectMatchingCard(tp,timeTable.removeFilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
--spsummon
function timeTable.spsummon(c,code,extra3,extra5)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,code)
	e1:SetCondition(timeTable.spsummonCon)
	e1:SetTarget(timeTable.spsummonTarget)
	e1:SetOperation(timeTable.spsummonOperation(extra3,extra5))
	c:RegisterEffect(e1)
	return e1
end
function timeTable.spsummonCon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x629)
end
function timeTable.spsummonTargetFilter(c)
	return c:IsLevel(9) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0 
end
function timeTable.spsummonTarget(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(timeTable.spsummonTargetFilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function timeTable.spsummonOperation(extra3,extra5)
	return function(e,tp,eg,ep,ev,re,r,rp)
			   local c=e:GetHandler()
			   local g=Duel.GetMatchingGroup(timeTable.spsummonTargetFilter,tp,LOCATION_MZONE,0,nil)
			   if g:GetCount()>0 then 
				   local dg=g:Select(tp,1,1,nil)
				   if Duel.SendtoGrave(dg,REASON_EFFECT)==0 then return end
				   if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
					   Duel.BreakEffect()
					   if Duel.GetFlagEffect(tp,m)>=0 then
						   local e1=Effect.CreateEffect(c)
						   e1:SetDescription(aux.Stringid(m,2))
						   e1:SetType(EFFECT_TYPE_FIELD)
						   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
						   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
						   e1:SetRange(LOCATION_MZONE)
						   e1:SetTargetRange(1,0)
						   e1:SetTarget(timeTable.exsplimit)
						   e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
						   c:RegisterEffect(e1)
						   local e2=Effect.CreateEffect(c)
						   e2:SetType(EFFECT_TYPE_FIELD)
						   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
						   e2:SetCode(EFFECT_CANNOT_ACTIVATE)
						   e2:SetRange(LOCATION_MZONE)
						   e2:SetTargetRange(1,0)
						   e2:SetValue(timeTable.effectlimit)
						   e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
						   c:RegisterEffect(e2)
					   end
					   if Duel.GetFlagEffect(tp,m)>=3 and extra3 then extra3(c) end
					   if Duel.GetFlagEffect(tp,m)>=5 and extra5 then extra5(c) end
				   end
			   end
		   end
end
function timeTable.exsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function timeTable.effectlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x629)
end
function timeTable.globle(c)
	if not timeTable.global_check then
		timeTable.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(timeTable.checkcon)
		e1:SetOperation(timeTable.checkop)
		Duel.RegisterEffect(e1,0)
		return e1
	end
end
function timeTable.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function timeTable.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1) 
end
--spell
function timeTable.spell(c,extra3,extra5)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002021,2))
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(timeTable.actionCon)
	e1:SetCost(timeTable.setcost)
	e1:SetOperation(timeTable.SpellOperation(extra3,extra5))
	c:RegisterEffect(e1)
end
function timeTable.actionConFilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x629)
end
function timeTable.actionCon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(timeTable.actionConFilter,tp,LOCATION_MZONE,0,1,nil)
end
function timeTable.SpellOperation(extra3,extra5)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if Duel.GetFlagEffect(tp,m)>=0 then 
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(m,2))
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1:SetRange(LOCATION_MZONE)
					e1:SetTargetRange(1,0)
					e1:SetTarget(timeTable.exsplimit)
					e1:SetReset(RESET_PHASE+PHASE_END)  
					Duel.RegisterEffect(e1,tp)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetCode(EFFECT_CANNOT_ACTIVATE)
					e2:SetRange(LOCATION_MZONE)
					e2:SetTargetRange(1,0)
					e2:SetValue(timeTable.effectlimit)
					e2:SetReset(RESET_PHASE+PHASE_END)  
					Duel.RegisterEffect(e2,tp)  
				end
				if Duel.GetFlagEffect(tp,m)>=3 and extra3 then extra3(e,tp) end
				if Duel.GetFlagEffect(tp,m)>=5 and extra5 then extra5(e,tp) end
			end
end
if not cm then return end
---------------------------------------
function cm.initial_effect(c)
	local e1=timeTable.set(c,m,cm.extraMove)
	local e2=timeTable.spsummon(c,m,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.setf(c)
	return c:IsCode(60002024) and not c:IsForbidden()
end
function cm.extraMove(e,tp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.setf,tp,LOCATION_DECK,0,1,nil) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,cm.setf,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
end
--e2
function cm.extra3(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e1:SetValue(1)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
end
function cm.extra5(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then 
		Duel.Hint(HINT_CARD,0,m)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		e:Reset()
	end
end