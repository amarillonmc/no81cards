--时光酒桌 门扉
function c60002024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002024,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60002024+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60002024.accon)
	e1:SetTarget(c60002024.actg)
	e1:SetOperation(c60002024.acop)
	c:RegisterEffect(e1)	 
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(10002024)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c60002024.cetcon1)
	c:RegisterEffect(e2)	
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(10002024)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c60002024.cetcon2)
	c:RegisterEffect(e2)  
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(60002024)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c60002024.cetcon3)
	c:RegisterEffect(e2)  
	--change 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c60002024.cptg)
	e3:SetOperation(c60002024.cpop)
	c:RegisterEffect(e3)
	if not c60002024.global_check then
		c60002024.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c60002024.checkcon)
		ge1:SetOperation(c60002024.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60002024.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60002024.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,60002024,RESET_PHASE+PHASE_END,0,1) 
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(60002024) 
	if flag==nil then 
	c:RegisterFlagEffect(60002024,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,1,0) 
	else
	c:SetFlagEffectLabel(60002024,flag+1)
	end
	c:ResetFlagEffect(30002024)
	c:RegisterFlagEffect(30002024,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(60002024,flag)) 
end
function c60002024.cetcon1(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFlagEffect(tp,60002024) 
	return x>=0
end
function c60002024.cetcon2(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFlagEffect(tp,60002024) 
	return x>=2
end
function c60002024.cetcon3(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFlagEffect(tp,60002024) 
	return x>=12
end
function c60002024.cfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x629)
end
function c60002024.accon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60002024.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60002024.setfilter(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER)
end
function c60002024.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c60002024.setfilter,tp,LOCATION_DECK,0,3,nil) end 
	local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),tp,LOCATION_SZONE)
end
function c60002024.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,0,nil)
	if dg:GetCount()>=0 and Duel.IsExistingMatchingCard(c60002024.setfilter,tp,LOCATION_DECK,0,3,nil) then 
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	local sg=Duel.SelectMatchingCard(tp,c60002024.setfilter,tp,LOCATION_DECK,0,3,3,nil)
	local tc=sg:GetFirst()
	while tc do  
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
	e1:SetCost(c60002024.gtcost)
	e1:SetTarget(c60002024.gttg)
	e1:SetOperation(c60002024.gtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)   
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
function c60002024.gctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() 
end
function c60002024.gtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
end
function c60002024.rmfil(c)
	return c:IsSetCard(0x629) and c:IsAbleToRemove()
end
function c60002024.gckfil1(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function c60002024.gckfil2(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE)
end
function c60002024.gck(g,tp)
	if Duel.IsPlayerAffectedByEffect(tp,20002024) then 
	return g:FilterCount(c60002024.gckfil1,nil,tp)<=1 and g:FilterCount(c60002024.gckfil2,nil,tp)<=1
	elseif Duel.IsPlayerAffectedByEffect(tp,10002024) then 
	return not g:IsExists(c60002024.gckfil1,1,nil,tp) and g:FilterCount(c60002024.gckfil2,nil,tp)<=1
	else
	return not g:IsExists(Card.IsControler,1,nil,tp)
	end
end 
function c60002024.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60002024.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if chk==0 then return g:CheckSubGroup(c60002024.gck,3,3,tp) and Duel.IsExistingMatchingCard(c60002024.rmfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)  end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
	Duel.SetChainLimit(c60002024.chainlm) 
	end
end
function c60002024.chainlm(e,rp,tp)
	return e:GetHandler():IsType(TYPE_COUNTER)
end
function c60002024.gtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002024.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if not g:CheckSubGroup(c60002024.gck,3,3,tp) then return end
	local sg=g:SelectSubGroup(tp,c60002024.gck,false,3,3,tp)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	--
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c60002024.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
	local g=Duel.SelectMatchingCard(tp,c60002024.rmfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
function c60002024.immval(e,te)
	return ((te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)) or te:IsActiveType(TYPE_TRAP)) and te:GetHandlerPlayer()~=tp
end
function c60002024.tgfil1(c)
	return c:IsFacedown() and c:IsAbleToGrave() 
end
function c60002024.tgfil(c,tp)
	local g=Duel.GetMatchingGroup(c60002024.tgfil1,tp,LOCATION_ONFIELD,0,nil)
	local g1=Duel.GetMatchingGroup(c60002024.tgfil1,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c60002024.tgfil1,tp,0,LOCATION_SZONE,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10002024) then 
	g:Merge(g1)
	end 
	if Duel.IsPlayerAffectedByEffect(tp,20002024) then 
	g:Merge(g2)
	end  
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c60002024.cpfil,tp,0,LOCATION_MZONE,1,nil)
end 
function c60002024.cpfil(c)
	return c:IsCanChangePosition() and c:IsFaceup()
end
function c60002024.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c60002024.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) or Duel.IsPlayerAffectedByEffect(tp,60002011)) and Duel.IsExistingMatchingCard(c60002024.cpfil,tp,0,LOCATION_MZONE,1,nil) end
end
function c60002024.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002024.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp) 
	if g:GetCount()>0 or Duel.IsPlayerAffectedByEffect(tp,60002011) then 
	if Duel.SelectYesNo(tp,aux.Stringid(60002024,0)) then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT) 
	end
	local tc=Duel.SelectMatchingCard(tp,c60002024.cpfil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
	end 
end




