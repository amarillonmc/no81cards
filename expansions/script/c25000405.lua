local m=25000405
local cm=_G["c"..m]
cm.name="零二龙 程式升蝗"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,function(c)return c:GetLevel()>0 and c:IsRace(RACE_PSYCHO)end,function(g)return g:GetClassCount(Card.GetLevel)==1 end,3,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(function(e,c)return e:GetHandler():GetOverlayCount()-1 end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_ONFIELD~=0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg,t=Group.CreateGroup(),{}
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp~=tp and Duel.IsChainNegatable(i) then table.insert(t,i) end
	end
	local ct,xct=#t,c:GetOverlayCount()
	while #t>0 do
		if xct==0 then break end
		if ct~=#t and not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local ac=Duel.AnnounceNumber(tp,table.unpack(t))
		local me=Duel.GetChainInfo(ac,CHAININFO_TRIGGERING_EFFECT)
		local mc=me:GetHandler()
		if Duel.NegateActivation(ac) and (mc:IsLocation(LOCATION_ONFIELD) or me:IsHasType(EFFECT_TYPE_ACTIVATE)) and mc:IsCanOverlay() and not mc:IsImmuneToEffect(e) then
			if me:IsHasType(EFFECT_TYPE_ACTIVATE) then mc:CancelToGrave() end
			dg:AddCard(mc)
		end
		for k,v in pairs(t) do if v==ac then table.remove(t,k) end end
		xct=xct-1
	end
	if #dg==0 then return end
	local og=Group.CreateGroup()
	for oc in aux.Next(dg) do og:Merge(oc:GetOverlayGroup()) end
	if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
	Duel.Overlay(c,dg)
end
