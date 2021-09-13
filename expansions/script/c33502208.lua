--冰汽时代 义肢
local m=33502208
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	local e1=syu.turnup(c,m,nil,nil,cm.turnupop,CATEGORY_EQUIP)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsFaceup()
end
function cm.turnupop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then return end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
	   local c=e:GetHandler()
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.HintSelection(sc)
	   if c:IsRelateToEffect(e) and sc:IsFaceup() then
		Duel.Equip(tp,c,sc)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		end
	end
end
function cm.eqlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp)
end
--e2
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetEquipTarget():IsSetCard(0x1a81) then return false end
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and ep==1-tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
  if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	if Duel.SendtoGrave(tc,REASON_COST+REASON_EFFECT)~=0 then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
  end
end