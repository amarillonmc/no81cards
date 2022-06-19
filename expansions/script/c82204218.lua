local m=82204218
local cm=_G["c"..m]
cm.name="堕世魔镜-焚尽"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE) 
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(800)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT) 
	Duel.BreakEffect()
	Duel.Damage(p,d,REASON_EFFECT) 
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_FIELD)  
	e0:SetCode(EFFECT_CANNOT_BP)  
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e0:SetReset(RESET_PHASE+PHASE_END)  
	e0:SetTargetRange(0,1)  
	Duel.RegisterEffect(e0,tp)  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)   
	Duel.RegisterEffect(e1,tp)  
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)  
	Duel.RegisterEffect(e3,tp)
end   