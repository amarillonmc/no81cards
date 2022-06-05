--救世的狮子 宏伟艾泽勒
local m=40010274
local cm=_G["c"..m]
cm.named_with_Ezel=1
function cm.Ezel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ezel
end
function cm.Ezelferind(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ezelferind
end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.adcost)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.necon)
	e3:SetCost(cm.necost)
	e3:SetTarget(cm.netg)
	e3:SetOperation(cm.neop)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and cm.Ezel(c)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.posfilter(c)
	return c:IsPosition(POS_FACEDOWN_ATTACK) 
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end
function cm.adfilter(c)
	return cm.Ezelferind(c) or cm.Ezel(c)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.adfilter,tp,LOCATION_HAND,0,c,tp,c)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=g:Select(tp,1,1,nil)
	Duel.Overlay(c,sg)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(cm.efop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1) 
	end
end
function cm.effilter(c)
	return c:IsType(TYPE_MONSTER) and cm.Ezel(c) and not c:IsCode(m)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ct=c:GetOverlayGroup(tp,1,0)
	local wg=ct:Filter(cm.effilter,nil,tp)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext()
	end  
end
function cm.nefilter(c)
	return c:IsType(TYPE_MONSTER) and cm.Ezel(c) 
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():Filter(cm.nefilter,nil):GetClassCount(Card.GetCode)>2
end
function cm.necost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=e:GetHandler():GetOverlayGroup()
	local ct=g:GetCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end  
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end