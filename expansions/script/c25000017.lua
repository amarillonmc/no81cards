local m=25000017
local cm=_G["c"..m]
cm.name="到灯塔去"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x9af8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.cttg)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(cm.drcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x9af8,1) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	ac=Duel.AnnounceNumber(tp,1,2)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:AddCounter(0x9af8,ac)~=0 then
		local ct=c:GetCounter(0x9af8)
		Duel.BreakEffect()
		if ct%2==0 then
			if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x9af8)
	e:SetLabel(ct)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return ct>0
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=e:GetLabel()-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=e:GetLabel()-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct1>0 and Duel.IsPlayerCanDraw(tp,ct1) and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=e:GetLabel()-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=e:GetLabel()-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct1>0 then Duel.Draw(tp,ct1,REASON_EFFECT) end
	if ct2>0 then Duel.Draw(1-tp,ct2,REASON_EFFECT) end
end
