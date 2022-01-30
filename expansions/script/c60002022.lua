--时光酒桌 年华
function c60002022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60002022+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60002022.accon)
	e1:SetTarget(c60002022.actg)
	e1:SetOperation(c60002022.acop)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60002022,1))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCost(c60002022.xxcost)
	e2:SetTarget(c60002022.xxtg)
	e2:SetOperation(c60002022.xxop)
	c:RegisterEffect(e2)
	if not c60002022.global_check then
		c60002022.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c60002022.checkcon)
		ge1:SetOperation(c60002022.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60002022.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) 
end
function c60002022.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,60002022,RESET_PHASE+PHASE_END,0,1) 
end
function c60002022.cfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x629)
end
function c60002022.accon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60002022.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60002022.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 end 
	if Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil):GetCount()>=3 then 
	Duel.SetChainLimit(c60002022.chlimit)
	end
end
function c60002022.chlimit(e,ep,tp)
	return tp==ep
end
function c60002022.ckfil(c)
	return c:IsSetCard(0x629) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function c60002022.ckfil(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function c60002022.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return end
	Duel.ConfirmDecktop(tp,10)
	local g=Duel.GetDecktopGroup(tp,10)
	local x=g:FilterCount(c60002022.ckfil,nil) 
	g1=g:Filter(c60002022.thfil1,nil)
	g2=g1:Select(tp,1,1,nil)
	Duel.SendtoHand(g2,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
		--
		local tc=g2:GetFirst()
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c60002022.aclimit)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)  
	if x>=2 and Duel.IsPlayerCanDraw(tp,1) then 
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	if x>=4 then 
	local g1=g1:Sub(g2)
	local g3=g1:FilterSelect(Card.IsAbleToHand,nil)
	Duel.SendtoHand(g3,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g3)
	end
end
function c60002022.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c60002022.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c60002022.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c60002022.setfilter(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER)
end
function c60002022.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFlagEffect(tp,60002022) 
	if x>=0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60002022.xsplimit)
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c60002022.xactlimit)
	e4:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e4,tp)  
	end
	if x>=3 and Duel.IsExistingMatchingCard(c60002022.setfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=2 then 
	local sg=Duel.SelectMatchingCard(tp,c60002022.setfilter,tp,LOCATION_GRAVE,0,2,2,nil)
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
	e1:SetCost(c60002022.gtcost)
	e1:SetTarget(c60002022.gttg)
	e1:SetOperation(c60002022.gtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)   
	tc=sg:GetNext()
	end
	Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end
	if x>=5 and Duel.IsPlayerCanDraw(tp,3) then 
	Duel.Draw(tp,3,REASON_EFFECT)
	end
end
function c60002022.gctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() 
end
function c60002022.gtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP)
end
function c60002022.rmfil(c)
	return c:IsSetCard(0x629) and c:IsAbleToRemove()
end
function c60002022.gckfil1(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function c60002022.gckfil2(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE)
end
function c60002022.gck(g,tp)
	if Duel.IsPlayerAffectedByEffect(20002024) then 
	return g:FilterCount(c60002022.gckfil1,nil,tp)<=1 and g:FilterCount(c60002022.gckfil2,nil,tp)<=1
	elseif Duel.IsPlayerAffectedByEffect(10002024) then 
	return not g:IsExists(c60002022.gckfil1,1,nil,tp) and g:FilterCount(c60002022.gckfil2,nil,tp)<=1
	else
	return not g:IsExists(Card.IsControler,1,nil,tp)
	end
end 
function c60002022.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60002022.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if chk==0 then return g:CheckSubGroup(c60002022.gck,3,3,tp) and Duel.IsExistingMatchingCard(c60002022.rmfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)  end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
	Duel.SetChainLimit(c60002022.chainlm) 
	end
end
function c60002022.chainlm(e,rp,tp)
	return e:GetHandler():IsType(TYPE_COUNTER)
end
function c60002022.gtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002022.gctfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())   
	if not g:CheckSubGroup(c60002022.gck,3,3,tp) then return end
	local sg=g:SelectSubGroup(tp,c60002022.gck,false,3,3,tp)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	--
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c60002022.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
	local g=Duel.SelectMatchingCard(tp,c60002022.rmfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
function c60002022.immval(e,te)
	return ((te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)) or te:IsActiveType(TYPE_TRAP)) and te:GetHandlerPlayer()~=tp
end
function c60002022.xsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60002022.xactlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x629)
end




