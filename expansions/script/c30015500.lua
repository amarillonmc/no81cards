--终墟库
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015500)
if Overuins then return end
Overuins=cm
function Overuins.imprint(c)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetCondition(Overuins.impcon)
	e21:SetTarget(Overuins.imptg)
	e21:SetOperation(Overuins.impop)
	c:RegisterEffect(e21)
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_REMOVE)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e22:SetProperty(EFFECT_FLAG_DELAY)
	e22:SetCode(EVENT_TO_GRAVE)
	e22:SetCondition(Overuins.impcon1)
	e22:SetTarget(Overuins.imptg1)
	e22:SetOperation(Overuins.impop1)
	c:RegisterEffect(e22)
	return e21,e22
end
function Overuins.impcon(e,tp,eg,ep,ev,re,r,rp) --rp==1-tp and
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) 
end
function Overuins.imptg(e,tp,eg,ep,ev,re,r,rp,chk)
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
end
function Overuins.impop(e,tp,eg,ep,ev,re,r,rp)
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
	if c:GetFlagEffect(m+1)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(Overuins.ruinsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Card.ResetFlagEffect(c,m+1)
	end
end
function Overuins.drmfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function Overuins.drmfilter1(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function Overuins.ruinsop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Overuins.drmfilter1,tp,LOCATION_REMOVED,0,nil)
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
				if tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
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

function Overuins.impcon1(e,tp,eg,ep,ev,re,r,rp) --rp==1-tp and
	local c=e:GetHandler()
	return rp~=1-tp and c:IsPreviousControler(tp) 
end
function Overuins.imptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function Overuins.impop(e,tp,eg,ep,ev,re,r,rp)
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