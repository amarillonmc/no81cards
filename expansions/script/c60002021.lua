--时光酒桌 意识
function c60002021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60002021,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60002021+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60002021.accon)
	e1:SetTarget(c60002021.actg)
	e1:SetOperation(c60002021.acop)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60002021,2))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCost(c60002021.xxcost)
	e2:SetTarget(c60002021.xxtg)
	e2:SetOperation(c60002021.xxop)
	c:RegisterEffect(e2)
	if not c60002021.global_check then
		c60002021.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c60002021.checkcon)
		ge1:SetOperation(c60002021.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60002021.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return rc:IsType(TYPE_TRAP) and rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c60002021.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,60002021,RESET_PHASE+PHASE_END,0,1) 
end
function c60002021.cfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x629)
end
function c60002021.accon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60002021.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60002021.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end 
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local x=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,x,tp,LOCATION_HAND) 
	if Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil):GetCount()>=3 then 
	Duel.SetChainLimit(c60002021.chlimit)
	end
end
function c60002021.chlimit(e,ep,tp)
	return tp==ep
end
function c60002021.ckfil(c)
	return c:IsSetCard(0x629) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function c60002021.ssfil(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function c60002021.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
	local x=g:FilterCount(c60002021.ckfil,nil)
	if x>=0 then 
	Duel.Draw(tp,x,REASON_EFFECT) 
	local tc=g:GetFirst()
	while tc do 
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c60002021.aclimit)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)  
	tc=g:GetNext()
	end
	end 
	if x>=2 then 
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	if x>=4 and g:IsExists(c60002021.ssfil,1,nil) then 
	local sc=g:FilterSelect(tp,c60002021.ssfil,1,1,nil):GetFirst()
	Duel.SSet(tp,sc)
	end
end
function c60002021.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c60002021.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c60002021.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c60002021.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function c60002021.thfil1(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER)
end
function c60002021.thfil2(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function c60002021.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFlagEffect(tp,60002021) 
	if x>=0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60002021.xsplimit)
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c60002021.xactlimit)
	e4:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e4,tp)	
	end
	local g=Duel.GetMatchingGroup(c60002021.setfilter,tp,LOCATION_HAND,0,nil) 
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),g:GetCount())
	if x>=3 and ct>0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,1,ct,nil)
	Duel.SSet(tp,sg)
	--
	local tc=sg:GetFirst()
	while tc do 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)   
	tc=sg:GetNext()
	end 
	end
	if x>=5 and Duel.IsExistingMatchingCard(c60002021.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c60002021.thfil2,tp,LOCATION_DECK,0,1,nil) then 
	local g1=Duel.SelectMatchingCard(tp,c60002021.thfil1,tp,LOCATION_DECK,0,1,1,nil) 
	local g2=Duel.SelectMatchingCard(tp,c60002021.thfil2,tp,LOCATION_DECK,0,1,1,nil) 
	g1:Merge(g2)
	Duel.SendtoHand(g1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	end
end
function c60002021.xsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60002021.xactlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x629)
end



