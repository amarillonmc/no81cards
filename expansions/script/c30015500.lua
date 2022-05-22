--终墟库
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(30015500)
if Overuins then return end
Overuins=cm
function Overuins.imprint(c)
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
	e31:SetLabelObject(e20)
	e31:SetCondition(cm.impcon)
	e31:SetTarget(cm.imptg)
	e31:SetOperation(cm.impop)
	c:RegisterEffect(e31)
	return e30,e31
end
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
	if e:GetLabelObject():GetLabel()==1 then
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
	else
		e:GetLabelObject():SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function cm.impop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if c:IsLocation(LOCATION_REMOVED) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	if  c:IsRelateToEffect(e) then
		if Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)~=0 
			and c:IsLocation(LOCATION_REMOVED) 
			and c:IsFacedown() then
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
		end   
	end
	if sc and sc:IsRelateToEffect(e) 
		and sc:GetOwner()==1-tp 
		and not sc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) 
		and sc:IsAbleToRemove(tp,POS_FACEDOWN) then
			Duel.Remove(sc,POS_FACEDOWN,REASON_EFFECT)
	end	
end