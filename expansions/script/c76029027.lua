--辉翼天骑 烛光蚀影
function c76029027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c76029027.target)
	e1:SetOperation(c76029027.activate)
	c:RegisterEffect(e1) 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c76029027.rmcost)
	e2:SetTarget(c76029027.rmtg)
	e2:SetOperation(c76029027.rmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(76029027,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,76029027)
	e4:SetTarget(c76029027.cptg)
	e4:SetOperation(c76029027.cpop)
	c:RegisterEffect(e4)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
c76029027.named_with_Kazimierz=true 
function c76029027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return sg:GetCount()>0 end
	e:GetHandler():SetTurnCounter(0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c76029027.descon)
	e1:SetOperation(c76029027.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	c76029027[e:GetHandler()]=e1
end
function c76029027.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c76029027.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(1082946)
	end
end
function c76029027.cstfil(c)
	return c.named_with_Kazimierz 
end
function c76029027.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,3,nil) and Duel.SelectYesNo(tp,aux.Stringid(76029027,0)) then 
	local xg=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil):RandomSelect(tp,3)
	local g=xg:Select(tp,0,3,nil)
	local g=xg:Select(1-tp,0,3,nil)
	local x=xg:FilterCount(c76029027.cstfil,nil)
	Duel.Draw(tp,x,REASON_EFFECT) 
	end
	end
end
function c76029027.ckfil(c,tp)
	return c.named_with_Kazimierz and c:IsControler(tp)
end
function c76029027.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if Duel.Remove(tc,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c76029027.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c76029027.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c76029027.ckfil,1,nil,tp) end 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c76029027.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c76029027.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
function c76029027.cxkfil(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_REMOVED) and c:IsType(TYPE_MONSTER)
end
function c76029027.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c76029027.cxkfil,1,nil,tp) and Duel.IsExistingMatchingCard(c76029027.cstfil,tp,LOCATION_MZONE,0,1,nil) end 
end
function c76029027.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c76029027.cstfil,tp,LOCATION_MZONE,0,nil)
	local tc=eg:Filter(c76029027.cxkfil,nil,tp):Select(tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local xc=g:Select(tp,1,1,nil):GetFirst()
	local code=tc:GetOriginalCodeRule() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(code)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	xc:RegisterEffect(e1)
	xc:SetHint(CHINT_CARD,code)
	if not tc:IsType(TYPE_TRAPMONSTER) then
	xc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end











