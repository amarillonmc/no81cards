--时光酒桌 相月
function c60002015.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002015,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60002015)
	e1:SetCondition(c60002015.stcon1)
	e1:SetCost(c60002015.stcost)
	e1:SetTarget(c60002015.sttg)
	e1:SetOperation(c60002015.stop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c60002015.stcon2)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,60002015)
	e2:SetCondition(c60002015.spcon)
	e2:SetTarget(c60002015.sptg)
	e2:SetOperation(c60002015.spop)
	c:RegisterEffect(e2)
	if not c60002015.global_check then
		c60002015.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c60002015.checkcon)
		ge1:SetOperation(c60002015.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60002015.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60002015.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,60002015,RESET_PHASE+PHASE_END,0,1) 
end
function c60002015.stcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,60002024)
end
function c60002015.stcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,60002024)
end
function c60002015.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c60002015.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c60002015.thfil(c)
	return c:IsSetCard(0x629) and not c:IsCode(60002015) and c:IsAbleToHand() 
end
function c60002015.stop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetCost(c60002015.gtcost)
	e1:SetTarget(c60002015.gttg)
	e1:SetOperation(c60002015.gtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(c60002015.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60002015,0)) then 
	Duel.BreakEffect()
	local tc=Duel.SelectMatchingCard(tp,c60002015.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	Duel.SendtoHand(tc,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc)
	end
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end
end
function c60002015.gctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() 
end
function c60002015.gtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
end
function c60002015.gckfil1(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function c60002015.gckfil2(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE)
end
function c60002015.gck(g,tp)
	if Duel.IsPlayerAffectedByEffect(tp,20002024) then 
	return g:FilterCount(c60002015.gckfil1,nil,tp)<=1 and g:FilterCount(c60002015.gckfil2,nil,tp)<=1
	elseif Duel.IsPlayerAffectedByEffect(tp,10002024) then 
	return not g:IsExists(c60002015.gckfil1,1,nil,tp) and g:FilterCount(c60002015.gckfil2,nil,tp)<=1
	else
	return not g:IsExists(Card.IsControler,1,nil,tp)
	end
end 
function c60002015.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=0
	if Duel.IsPlayerAffectedByEffect(tp,60002011) then 
	x=2 
	else 
	x=3
	end
	local g=Duel.GetMatchingGroup(c60002015.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if chk==0 then return g:CheckSubGroup(c60002015.gck,x,3,tp) and Duel.IsExistingMatchingCard(c60002015.rmfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)  end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
	Duel.SetChainLimit(c60002015.chainlm) 
	end
end
function c60002015.chainlm(e,rp,tp)
	return e:GetHandler():IsType(TYPE_COUNTER)
end
function c60002015.gtop(e,tp,eg,ep,ev,re,r,rp)
	local x=0
	if Duel.IsPlayerAffectedByEffect(tp,60002011) then 
	x=2 
	else 
	x=3
	end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002015.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if not g:CheckSubGroup(c60002015.gck,x,3,tp) then return end
	local sg=g:SelectSubGroup(tp,c60002015.gck,false,x,3,tp)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	--
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c60002015.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
	local g=Duel.SelectMatchingCard(tp,c60002015.rmfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
function c60002015.immval(e,te)
	return ((te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)) or te:IsActiveType(TYPE_TRAP)) and te:GetHandlerPlayer()~=tp
end
function c60002015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x629)
end
function c60002015.tgfil(c)
	return c:IsLevel(9) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0 
end
function c60002015.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60002015.tgfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c60002015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002015.tgfil,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	--
	if Duel.GetFlagEffect(tp,60002015)>=0 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002015,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60002015.xsplimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	c:RegisterEffect(e1)  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c60002015.xactlimit)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)  
	c:RegisterEffect(e4)	
	end
	--
	if Duel.GetFlagEffect(tp,60002015)>=3 then  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002015,3)) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c60002015.gxstcost)
	e1:SetTarget(c60002015.gxsttg) 
	e1:SetOperation(c60002015.gxstop)
	c:RegisterEffect(e1)
	end
	--
	if Duel.GetFlagEffect(tp,60002015)>=5 then  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60002015,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(60002015)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)	
	end
	end
	end
end
function c60002015.xsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60002015.xactlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x629)
end
function c60002015.gxstctfil(c)
	return c:IsDiscardable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function c60002015.gxstcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60002015.gxstctfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c60002015.gxstctfil,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c60002015.gxstfil(c) 
	if not Duel.IsPlayerAffectedByEffect(tp,60002015) then 
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable() 
	else
	return (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable()) or (c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER))
	end
end
function c60002015.gxstfil1(c) 
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) 
end
function c60002015.gxstgck(g,tp)
	if Duel.IsPlayerAffectedByEffect(tp,60002015) then 
	return g:FilterCount(c60002015.gxstfil1,nil)<=1 
	else 
	return g:FilterCount(c60002015.gxstfil1,nil)<=0
	end
end 
function c60002015.gxsttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c60002015.gxstfil,tp,LOCATION_GRAVE,0,nil)  
	if chk==0 then return g:CheckSubGroup(c60002015.gxstgck,1,3,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c60002015.gxstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 or not g:CheckSubGroup(c60002015.gxstgck,1,3,tp) then return end 
	if ft>3 then ft=3 end 
	local sg=g:SelectSubGroup(tp,c60002015.gxstgck,false,1,ft,tp) 
	local tc=sg:GetFirst() 
	while tc do  
	if tc:IsType(TYPE_TRAP) then 
	Duel.SSet(tp,tc)
	else 
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
	Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
		tc:RegisterEffect(e1)  
	--get
	local e1=Effect.CreateEffect(tc)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c60002015.gtcost)
	e1:SetTarget(c60002015.gttg)
	e1:SetOperation(c60002015.gtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)	
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_DECK)
	tc:RegisterEffect(e1)
	tc=sg:GetNext()
	end
end



