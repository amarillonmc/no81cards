--非对称均衡II
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--adjust(disablecheck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e2,0)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if cm.condition(e,e:GetHandler():GetControler(),eg,ep,ev,re,r,rp) then
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.abs(Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)-Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD))
	return ct<=3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	--[[Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,1-tp,LOCATION_ONFIELD)
	if cm.condition(e,tp,eg,ep,ev,re,r,rp) then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+0x200)
	else e:SetProperty(0) end--]]
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,#g,nil)
	Duel.HintSelection(sg)
	if aux.SelectFromOptions(1-tp,{sg:IsExists(Card.IsAbleToHand,1,nil),aux.Stringid(m,0)},{true,aux.Stringid(m,1)})==1 then
		Duel.SendtoHand(sg,nil,REASON_RULE)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local eid=e1:GetFieldID()
		e1:SetValue(function(e,re,tp) return re:GetHandler():GetFlagEffect(m)==0 or re:GetHandler():GetFlagEffectLabel(m)==eid end)
		for tc in aux.Next(sg) do
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,2))
		end
	end
end