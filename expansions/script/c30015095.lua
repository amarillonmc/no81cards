--终墟打落
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015095,"Overuins")
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetTarget(cm.ddtg)
	e1:SetOperation(cm.ddop)
	c:RegisterEffect(e1)
	--e2  
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(cm.regop3)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.impcon)
	e21:SetTarget(cm.imptg)
	e21:SetOperation(cm.impop)
	c:RegisterEffect(e21)
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e22:SetProperty(EFFECT_FLAG_DELAY)
	e22:SetCode(EVENT_TO_GRAVE)
	e22:SetLabelObject(e20)
	e22:SetCondition(cm.impcon1)
	e22:SetTarget(cm.imptg1)
	e22:SetOperation(cm.impop1)
	c:RegisterEffect(e22)
	local e23=Effect.CreateEffect(c)
	e23:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e23:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e23:SetProperty(EFFECT_FLAG_DELAY)
	e23:SetCode(EVENT_RELEASE)
	e23:SetLabelObject(e20)
	e23:SetTarget(cm.imptg1)
	e23:SetOperation(cm.impop1)
	c:RegisterEffect(e23)
end
--Activate
function cm.ddfilter(c,tp)
	return  c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.down(c)
	return  c:IsFacedown() and c:IsLocation(LOCATION_REMOVED)
end
function cm.thfilter1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ddfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) 
		local g3=Duel.GetOperatedGroup()
		local ct=g3:FilterCount(cm.down,nil) 
		if ct>0 then
			local mg=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil) 
			if #mg>=2 then
				if  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					local sg=mg:RandomSelect(tp,1)
					if sg:GetCount()>0 then
						Duel.SendtoHand(sg,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sg)
					end
					if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
						local sg1=mg:RandomSelect(1-tp,1)
						if sg1:GetCount()>0 then
							Duel.SendtoHand(sg1,1-tp,REASON_EFFECT)
							Duel.ConfirmCards(tp,sg1)
						end
					end
				else
					if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
						local sg1=mg:RandomSelect(1-tp,1)
						if sg1:GetCount()>0 then
							Duel.SendtoHand(sg1,1-tp,REASON_EFFECT)
							Duel.ConfirmCards(tp,sg1)
						end
					end 
				end  
			end
		end
	end
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
	return e:GetLabelObject():GetLabel()==1
end
function cm.imptg(e,tp,eg,ep,ev,re,r,rp,chk)
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
	if sg:GetCount()>=2 then
		c:RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.impop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if  c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)   
	end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		Duel.RegisterFlagEffect(tp,30015000,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		local n=Duel.GetFlagEffect(tp,30015000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		e1:SetValue(n+1)
		Duel.RegisterEffect(e1,tp)
	end
	if c:GetFlagEffect(m+1)>0 and c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.ruinsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Card.ResetFlagEffect(c,m+1)
	end
end
function cm.drmfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.drmfilter1(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function cm.ruinsop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.drmfilter1,tp,LOCATION_REMOVED,0,nil)
	if mg:GetCount()~=0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=mg:RandomSelect(tp,1)
		local tc=sg:GetFirst() 
		if tc then
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end   
		if rk.check(tc,"Overuins") 
			and tc:IsLocation(LOCATION_GRAVE)  then
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
				if tc:IsSSetable()  then
					Duel.SSet(tp,tc)
				else
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end

function cm.impcon1(e,tp,eg,ep,ev,re,r,rp) --rp==1-tp and
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_DECK) and e:GetLabelObject():GetLabel()~=1
end
function cm.imptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.impop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if  c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)   
	end 
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		Duel.RegisterFlagEffect(tp,30015000,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		local n=Duel.GetFlagEffect(tp,30015000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		e1:SetValue(n+1)
		Duel.RegisterEffect(e1,tp)
	end
end