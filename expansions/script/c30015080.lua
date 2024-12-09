--归墟塌陷
local m=30015080
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
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
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(ors.orsmc)
	e21:SetTarget(ors.orsmtup)
	e21:SetOperation(cm.yleop)
	c:RegisterEffect(e21)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_REMOVE)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e32:SetCode(EVENT_CHAIN_NEGATED)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(ors.yycon)
	e32:SetTarget(ors.yytg)
	e32:SetOperation(cm.yyop)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EVENT_CUSTOM+30015500)
	e33:SetCondition(ors.yycon2)
	c:RegisterEffect(e33)
	--all
	local ge1=ors.alldrawflag(c)
end
c30015080.isoveruins=true
--maintain
function cm.ff(c) 
	return c:IsFaceup() and (ors.stf(c) or c:IsSummonType(SUMMON_TYPE_ADVANCE))
end 
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ff,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
--Effect 1
function cm.cff(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.mrf(c,tp) 
	local b1=c:IsAbleToRemove(tp,POS_FACEDOWN) 
	local b2=c:IsLocation(LOCATION_GRAVE)
	return b1 and b2 
end   
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cff,1,nil) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cff,nil)
	local rg=g:Filter(cm.mrf,nil,tp)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local og=Group.CreateGroup()
	local g=eg:Filter(cm.cff,nil)
	local rg=g:Filter(cm.mrf,nil,tp)
	if #rg==0 or Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
	local og=Duel.GetOperatedGroup()
	for tac in aux.Next(og) do  
		if tac:IsLocation(LOCATION_REMOVED) then 
			tac:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		end
	end   
	Duel.Recover(tp,#og*300,REASON_EFFECT)
	
end
--Effect 2
function cm.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=daval[0]+daval[1]
	return ct>0 
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local ct=daval[0]+daval[1]
	Duel.Hint(HINT_CARD,0,m)
	local dct=ct*50 
	local rct=ct*100 
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dct)
	Duel.Recover(tp,rct,REASON_EFFECT) 
end
--Effect 3 
function cm.fft(c)
	return c:GetFlagEffect(m+100)>0 and c:IsAbleToDeck()
end
function cm.yleop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	local g=Duel.GetMatchingGroup(cm.fft,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct>0 then
		local sc=Duel.GetFirstTarget() 
		ors.removeall(e,tp,sc)
	end
end
function cm.yyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(cm.fft,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if dc and dc~=nil then
		local sc=Duel.GetFirstTarget() 
		ors.removeall(e,tp,sc)
	end
end