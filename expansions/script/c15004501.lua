local m=15004501
local cm=_G["c"..m]
cm.name="古亚四灾·玉"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	c:RegisterEffect(e0)
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--no not Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.decon)
	e2:SetOperation(cm.deop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(15004501)
	e3:SetRange(LOCATION_MZONE) 
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,15004503)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end
function cm.spfilter1(c,p)
	return not c:IsAbleToRemove(p)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	return Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cm.demfilter(c)
	if not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) then return false end
	if c:IsHasEffect(15004502) then return false end
	return true
end
function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.demfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.demfilter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) then
			for _,i in ipairs{tc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)} do
				local ae=i
				if ae:GetHandler():GetControler()==1-tp then
					local ac=ae:GetHandler()
					local e1=Effect.CreateEffect(c)  
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(15004502)
					e1:SetLabelObject(ae)
					if ae:GetCondition()~=nil then e1:SetCondition(ae:GetCondition()) end
					ac:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)  
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
					e2:SetCode(EVENT_ADJUST)
					e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e2:SetRange(0xff)
					e2:SetCondition(cm.givecon)
					e2:SetOperation(cm.giveop)
					ac:RegisterEffect(e2,true)
					ae:SetCondition(cm.chicon)
				end
			end
		end
		tc=g:GetNext()
	end
end
function cm.ifilter(c)
	return c:IsFaceup() and c:IsHasEffect(15004501) and not c:IsDisabled() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.chicon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.ifilter,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.givecon(e,tp,eg,ep,ev,re,r,rp)
	return ((not Duel.IsExistingMatchingCard(cm.ifilter,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil) and e:GetHandler():IsHasEffect(15004502)) or ((not e:GetHandler():IsOnField()) or (not e:GetHandler():IsFaceup())))
end
function cm.giveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for _,i in ipairs{c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)} do
		local ae=i
		for _,v in ipairs{c:IsHasEffect(15004502)} do
			if v:GetLabelObject()==ae then
				if v:GetCondition() then
					ae:SetCondition(v:GetCondition())
				end
				v:Reset()
			end
		end
	end
	e:Reset()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
		e1:SetTarget(cm.nrmtg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.nrmtg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and c:IsFaceup()
end