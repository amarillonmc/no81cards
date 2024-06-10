--瞌睡
local m=33703037
local cm=_G["c"..m]
function cm.initial_effect(c,tp)
	c:EnableCounterPermit(0x1010)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--damage add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--reduce damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.val2) 
	Duel.RegisterEffect(e2,tp)
	--adjust 
	 local e4=Effect.CreateEffect(c)
  	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
 	e4:SetOperation(cm.adjustop)
	c:RegisterEffect(e4)
	--recover 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetLabel(0)
	e3:SetTarget(cm.rectg)
	e3:SetOperation(cm.recop)
	c:RegisterEffect(e3)	
	e4:SetLabelObject(e3)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:SetLabel(e:GetHandler():GetCounter(0x1010))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if ev>100 and rp ~= tp then
		local temp=math.floor(ev/100)
		e:GetHandler():AddCounter(0x1010,temp)
	end
end
function cm.val2(e,re,val,r,rp,rc)
	local temp=val-(e:GetHandler():GetCounter(0x1010)*100)
	if temp <0 then
	return 0
	end
 	return math.floor(temp)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,LOCATION_SZONE)

end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,(e:GetLabel()*100),REASON_EFFECT)
end