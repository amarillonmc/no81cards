--殂世魇魔 吞山魔龙
local m=33201307
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201300") end,function() require("script/c33201300") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,cm.ovfilter,aux.Stringid(m,0),5,cm.xyzop)
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.atkcost)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--flip op
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--flip flag
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FLIP)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(cm.flipop)
	c:RegisterEffect(e4)
end
cm.VHisc_BeastHell=true

--xyz
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)>0 and VHisc_Bh.ck(c)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

--e1
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(1500)
		c:RegisterEffect(e1)
	end
end

--e2
function cm.filter(c)
	return c:IsCanOverlay() and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then tc:CancelToGrave() end
	end
end

--e4
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(m)==0 and VHisc_Bh.ck(tc) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		tc=eg:GetNext()
	end
end