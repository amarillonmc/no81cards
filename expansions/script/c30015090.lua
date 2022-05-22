--终墟鸟击
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015090,"Overuins")
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.negreg)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--e2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetCondition(cm.thcon2)
	c:RegisterEffect(e3)
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e30:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e30:SetCode(EVENT_LEAVE_FIELD_P)
	e30:SetOperation(cm.regop3)
	c:RegisterEffect(e30)
	local e31=Effect.CreateEffect(c)
	e31:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e31:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e31:SetProperty(EFFECT_FLAG_DELAY)
	e31:SetCode(EVENT_LEAVE_FIELD)
	e31:SetLabelObject(e30)
	e31:SetCondition(cm.impcon)
	e31:SetTarget(cm.imptg)
	e31:SetOperation(cm.impop)
	c:RegisterEffect(e31)
end
--Activate
--negate--
function cm.negreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetLabelObject(e)
	e1:SetOperation(cm.negcheck)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.negcheck(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if rp==tp and de and dp==1-tp and re==te then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(cm.negevent)
		e1:SetLabelObject(te)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.negevent(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.RaiseEvent(te:GetHandler(),EVENT_CUSTOM+m,te,0,tp,tp,0)
	e:Reset()
end
----
function cm.filter(c,e)
	return c~=e:GetHandler()
end
function cm.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter3,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,e:GetHandler(),e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,cm.filter3,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,g1:GetFirst(),e)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,1-tp,POS_FACEDOWN) 
		and Duel.SelectYesNo(1-tp,aux.Stringid(30015500,1)) 
		and Duel.IsPlayerCanRemove(1-tp) then
		local g=Duel.GetFieldGroup(1-tp,0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
		if #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:FilterSelect(1-tp,aux.NecroValleyFilter(cm.downremovefilter),1,3,nil,1-tp,POS_FACEDOWN)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleExtra(tp)
		end
	end
end
function cm.downremovefilter(c,tp)
	return c:IsAbleToRemove(1-tp,POS_FACEDOWN)
end
--Effect 2  
function cm.regop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.impcon(e,tp,eg,ep,ev,re,r,rp) --rp==1-tp and
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetLabel()==1 
end
function cm.imptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if e:GetLabelObject():GetLabel()==1 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				sg:AddCard(sc)
			end
		end 
		if rc then 
			sg:AddCard(rc)
		end
	else
		e:GetLabelObject():SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.impop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if  c:IsRelateToEffect(e) then
		if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0  then
			if e:GetLabelObject():GetLabel()==1 then
				Duel.RegisterFlagEffect(tp,30015000,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
				Duel.RegisterFlagEffect(tp,30015500,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1) 
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,3))
				Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,3))
			else
				Duel.RegisterFlagEffect(tp,30015000,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
			end
			local n=Duel.GetFlagEffect(tp,30015000)
			local n1=Duel.GetFlagEffect(tp,30015500)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
			e1:SetValue(n+n1+1)
			Duel.RegisterEffect(e1,tp)
		end   
	end
	if sc and sc:IsRelateToEffect(e) 
		and sc:GetOwner()==1-tp 
		and not sc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) 
		and sc:IsAbleToRemove(tp,POS_FACEDOWN) then
			Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	end 
end
----neg----
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	local rc=c:GetReasonCard()
	local re=c:GetReasonEffect()
	if not rc and re then
		local sc=re:GetHandler()
		if not rc then
			sg:AddCard(sc)
		end
	end 
	if rc then 
		sg:AddCard(rc)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if  c:IsRelateToEffect(e) then
		if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0  then
			Duel.RegisterFlagEffect(tp,30015000,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
			Duel.RegisterFlagEffect(tp,30015500,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1) 
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,3))
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,3))
			local n=Duel.GetFlagEffect(tp,30015000)
			local n1=Duel.GetFlagEffect(tp,30015500)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
			e1:SetValue(n+n1+1)
			Duel.RegisterEffect(e1,tp)
		end   
	end
	if sc and sc:IsRelateToEffect(e) 
		and sc:GetOwner()==1-tp 
		and not sc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) 
		and sc:IsAbleToRemove(tp,POS_FACEDOWN) then
		Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	end 
end
----neg----