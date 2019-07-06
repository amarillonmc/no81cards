--这样的你
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700946
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"rec",nil,nil,nil,cm.tg,cm.op)
	local e2=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e3=rsef.STF(c,EVENT_LEAVE_FIELD,nil,"de",nil,nil,cm.con,nil,nil,cm.op2)
	local e4=rsef.FTF(c,EVENT_PHASE+PHASE_DRAW,{m,0},1,"rec",nil,LOCATION_FZONE,cm.econ,nil,cm.rtg,cm.rop)
	e4:SetLabel(1)
	--local e5=rsef.FTF(c,m,{m,0},1,"rec",nil,LOCATION_FZONE,cm.econ2,nil,cm.rtg,cm.rop)
	local e5=rsef.I(c,{m,0},1,"rec",nil,LOCATION_FZONE,cm.econ2,nil,cm.rtg,cm.rop)
	e5:SetLabel(7)
	local e6=rsef.FTF(c,EVENT_PHASE+PHASE_BATTLE_START,{m,0},1,"rec",nil,LOCATION_FZONE,cm.econ,nil,cm.rtg,cm.rop)
	e6:SetLabel(15)  
	local e7=rsef.FTF(c,EVENT_PHASE+PHASE_END,{m,0},1,"rec",nil,LOCATION_FZONE,cm.econ,nil,cm.rtg,cm.rop)
	e7:SetLabel(21) 
	--adjust
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCondition(cm.adjustcon)
	e8:SetOperation(cm.adjustop)
	c:RegisterEffect(e8)
	--cannot activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,1)
	e9:SetValue(cm.filter)
	c:RegisterEffect(e9)	
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_SSET)
	e10:SetRange(LOCATION_SZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,1)
	e10:SetValue(cm.filter2)
	c:RegisterEffect(e10)   
end 
function cm.econ2(e,tp)
	return cm.econ(e,tp) and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp and not Duel.CheckPhaseActivity()
end
function cm.filter2(e,c)
	return c:IsType(TYPE_FIELD)
end
function cm.adjustcon(e,tp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp and not Duel.CheckPhaseActivity()
end
function cm.adjustop(e)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.econ(e,tp)
	local f=function(rc)
		return rc:IsSetCard(0x442) and rc:IsType(TYPE_MONSTER)
	end
	local g=Duel.GetMatchingGroup(f,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() and Duel.GetTurnPlayer()==tp
end
function cm.filter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	--tg
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,5)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,5)
	cm[e:GetHandler()]=e1
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(m)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if cm.con(e,tp) then
		Duel.SetLP(tp,8000)
	end
end
function cm.con(e,tp)
	local f=function(rc)
		return rc:IsSetCard(0x442) and rc:IsType(TYPE_MONSTER)
	end
	local g=Duel.GetMatchingGroup(f,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==#g and #g>0
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,8000)
end