--沙包化
local m=33701377
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)*4)
	local t2=Duel.IsPlayerCanDraw(tp)
	local op=0
	local m={}
	local n={}
	local ct=1
	m[ct]=aux.Stringid(m,0) n[ct]=1 ct=ct+1
	if t2 then m[ct]=aux.Stringid(m,1) n[ct]=2 ct=ct+1 end
	local sp=Duel.SelectOption(1-tp,table.unpack(m))
	op=n[sp+1]
	Duel.BreakEffect()
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(cm.damval)
		Duel.RegisterEffect(e1,tp)
	elseif op==2 then
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
function cm.damval(e,re,val,r,rp)
	return val*2
end
