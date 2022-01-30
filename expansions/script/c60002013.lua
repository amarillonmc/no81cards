--时光酒桌 幕月
function c60002013.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002013,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60002013)
	e1:SetCondition(c60002013.stcon1)
	e1:SetCost(c60002013.stcost)
	e1:SetTarget(c60002013.sttg)
	e1:SetOperation(c60002013.stop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c60002013.stcon2)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,60002013)
	e2:SetCondition(c60002013.spcon)
	e2:SetTarget(c60002013.sptg)
	e2:SetOperation(c60002013.spop)
	c:RegisterEffect(e2)
	if not c60002013.global_check then
		c60002013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c60002013.checkcon)
		ge1:SetOperation(c60002013.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60002013.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60002013.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,60002013,RESET_PHASE+PHASE_END,0,1) 
end
function c60002013.stcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,60002024)
end
function c60002013.stcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,60002024)
end
function c60002013.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c60002013.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c60002013.cpfil(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c60002013.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then 
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
		c:RegisterEffect(e1)  
	--get
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c60002013.gtcost)
	e1:SetTarget(c60002013.gttg)
	e1:SetOperation(c60002013.gtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(c60002013.cpfil,tp,0,LOCATION_MZONE,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(60002013,0)) then 
	Duel.BreakEffect()
	local pc=Duel.SelectMatchingCard(tp,c60002013.cpfil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.ChangePosition(pc,POS_FACEDOWN_DEFENSE)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end
end
function c60002013.gctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() 
end
function c60002013.gtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
end
function c60002013.rmfil(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c60002013.gckfil1(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function c60002013.gckfil2(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE)
end
function c60002013.gck(g,tp)
	if Duel.IsPlayerAffectedByEffect(tp,20002024) then 
	return g:FilterCount(c60002013.gckfil1,nil,tp)<=1 and g:FilterCount(c60002013.gckfil2,nil,tp)<=1
	elseif Duel.IsPlayerAffectedByEffect(tp,10002024) then 
	return not g:IsExists(c60002013.gckfil1,1,nil,tp) and g:FilterCount(c60002013.gckfil2,nil,tp)<=1
	else
	return not g:IsExists(Card.IsControler,1,nil,tp)
	end
end 
function c60002013.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=0
	if Duel.IsPlayerAffectedByEffect(tp,60002013) then 
	x=2 
	else 
	x=3
	end
	local g=Duel.GetMatchingGroup(c60002013.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if chk==0 then return g:CheckSubGroup(c60002013.gck,x,3,tp) and Duel.IsExistingMatchingCard(c60002013.rmfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)  end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
	Duel.SetChainLimit(c60002013.chainlm) 
	end
end
function c60002013.chainlm(e,rp,tp)
	return e:GetHandler():IsType(TYPE_COUNTER)
end
function c60002013.gtop(e,tp,eg,ep,ev,re,r,rp)
	local x=0
	if Duel.IsPlayerAffectedByEffect(tp,60002013) then 
	x=2 
	else 
	x=3
	end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002013.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if not g:CheckSubGroup(c60002013.gck,x,3,tp) then return end
	local sg=g:SelectSubGroup(tp,c60002013.gck,false,x,3,tp)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	--
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c60002013.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
	local g=Duel.SelectMatchingCard(tp,c60002013.rmfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
function c60002013.immval(e,te)
	return ((te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)) or te:IsActiveType(TYPE_TRAP)) and te:GetHandlerPlayer()~=tp
end
function c60002013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x629)
end
function c60002013.tgfil(c)
	return c:IsLevel(9) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0 
end
function c60002013.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60002013.tgfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c60002013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002013.tgfil,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	--
	if Duel.GetFlagEffect(tp,60002013)>=0 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002013,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60002013.xsplimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	c:RegisterEffect(e1)  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c60002013.xactlimit)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)  
	c:RegisterEffect(e4)	
	end
	--
	if Duel.GetFlagEffect(tp,60002013)>=3 then  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60002013,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
	e3:SetCondition(c60002013.rdcon)
	e3:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	end
	--
	if Duel.GetFlagEffect(tp,60002013)>=5 then  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60002013,4))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetValue(c60002013.efilter)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
	end
	end
	end
end
function c60002013.xsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60002013.xactlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x629)
end
function c60002013.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c60002013.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end




