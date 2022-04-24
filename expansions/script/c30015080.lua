--归墟塌陷
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015080,"Overuins")
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	e30:SetCondition(cm.actcon)
	c:RegisterEffect(e30)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.rstcon)
	e12:SetOperation(cm.rstop)
	c:RegisterEffect(e12)
	--Effect 3 
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetCondition(cm.spcon)
	e21:SetTarget(cm.sptg)
	e21:SetOperation(cm.spop)
	c:RegisterEffect(e21) 
end
--activate
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.IsExistingMatchingCard(cm.overfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
--Effect 1
function cm.cfilter(c)
	return not rk.check(c,"Overuins")
end
function cm.overfilter(c)
	return c:IsFaceup() and rk.check(c,"Overuins") and c:IsType(TYPE_MONSTER)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		if  tc:IsAbleToRemove(tp,POS_FACEDOWN) then
			local rg=tc:GetOverlayGroup()
			local rc=rg:GetFirst()
			while rc do
				if rc:IsAbleToRemove(tp,POS_FACEDOWN) then
					Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
				end
				rc=rg:GetNext()
			end
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end
--Effect 2
function cm.dtodeckfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function cm.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.dtodeckfilter,tp,LOCATION_REMOVED,0,nil)
	local mg1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	return #mg>0 or #mg1>0 
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.dtodeckfilter,tp,LOCATION_REMOVED,0,nil)
	local mg1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	if #mg1>0 and #mg>0 then  mg:Merge(mg1) end
	if #mg1>0 and #mg==0 then  mg=mg1 end
	if #mg>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local over=Duel.GetMatchingGroup(cm.overfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			Duel.Damage(1-tp,ct*100,REASON_EFFECT)
			Duel.Recover(tp,ct*100,REASON_EFFECT)		
		end
		if #over==0 then
			if c:IsAbleToRemove(tp,POS_FACEDOWN) then
				Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)  
			else
				Duel.SendtoGrave(c,REASON_RULE)
			end  
		end
	end
end
--Effect 3 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	local rc=c:GetReasonCard()
	local re=c:GetReasonEffect()
	if not rc and re then
		local sc=re:GetHandler()
		if not rc then
			Duel.SetTargetCard(sc)
			sg:AddCard(sc)
		end
	end 
	if rc then 
		Duel.SetTargetCard(rc)
		sg:AddCard(rc)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if sc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and sc:GetOwner()==1-tp then
		local rg=Group.FromCards(sc,c)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	elseif sc:IsRelateToEffect(e) and sc:GetOwner()==1-tp then
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)   
	end
end

