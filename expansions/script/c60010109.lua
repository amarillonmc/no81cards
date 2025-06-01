--虚无之终点
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=42
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetTargetRange(0,LOCATION_ONFIELD)
		e1:SetTarget(cm.eftg)
		e1:SetLabelObject(ce1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetLabelObject(ce2)
		Duel.RegisterEffect(e2,tp)
		
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e3:SetTarget(cm.disable)
		e3:SetCode(EFFECT_DISABLE)
		Duel.RegisterEffect(e3,0)
	
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_LEAVE_FIELD_P)
		ce1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ce1:SetOperation(cm.regop)
		local ce2=Effect.CreateEffect(c)
		ce2:SetCategory(CATEGORY_DRAW)
		ce2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ce2:SetProperty(EFFECT_FLAG_DELAY)
		ce2:SetCode(EVENT_TO_GRAVE)
		ce2:SetCountLimit(1)
		ce2:SetCondition(cm.drcon)
		ce2:SetTarget(cm.drtg)
		ce2:SetOperation(cm.drop)
		ce2:SetLabelObject(ce1)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,3,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
end
function cm.disable(e,c)
	return c:GetFlagEffect(m)~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(m)
	e:SetLabel(ct)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	return ct>0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,ct) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	for i=1,ct do
		if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		end
	end
end
function cm.eftg(e,c)
	return c:IsFaceup()
end