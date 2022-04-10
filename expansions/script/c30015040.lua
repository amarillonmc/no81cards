--归墟溃散
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015040,"Overuins")
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(cm.thcon)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e33:SetCode(EVENT_CHAIN_SOLVING)
	e33:SetRange(LOCATION_SZONE)
	e33:SetCondition(cm.negcon)
	e33:SetOperation(cm.negop)
	c:RegisterEffect(e33)
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3) 
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
--Effect 1
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetDrawCount(tp)>0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
	end
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount<=aux.DrawReplaceMax then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end 
end   
function cm.drmfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(tp) 
		and (rc:GetOriginalType()&TYPE_SPELL~=0 or rc:GetOriginalType()&TYPE_TRAP~=0)
		and (re:GetActivateLocation()&LOCATION_HAND~=0 or re:GetActivateLocation()&LOCATION_GRAVE~=0)
		and rk.check(rc,"Overuins")
		and re:IsHasCategory(CATEGORY_REMOVE)
		and Duel.IsExistingMatchingCard(cm.drmfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.drmfilter,tp,LOCATION_REMOVED,0,1,nil) then
		local mg=Duel.GetMatchingGroup(cm.drmfilter,tp,LOCATION_REMOVED,0,nil)
		if mg:GetCount()~=0 then
			Duel.Hint(HINT_CARD,0,m)
			local sg=mg:RandomSelect(tp,1)
			local tc=sg:GetFirst() 
			if tc then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end   
		end
	end
end
--Effect 2
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil,tp,POS_FACEDOWN) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,3,nil,tp,POS_FACEDOWN)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
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
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
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
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end 
