--奈非天
local m=10121017
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,99,cm.ovfilter,aux.Stringid(m,0))
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(cm.atcon)
	e3:SetCost(cm.atcost)
	e3:SetOperation(cm.atop)
	c:RegisterEffect(e3)
	--dam
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(cm.damcon)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
	--[[--gain effect 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.adjustop)
	c:RegisterEffect(e3)--]]
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,200)
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0,true)
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
end
function cm.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsAttackAbove,nil,1)
	return g:GetSum(Card.GetAttack)
end
function cm.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsDefenseAbove,nil,1)
	return g:GetSum(Card.GetDefense)
end
--[[function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(cm.efilter,nil,c)
	for tc in aux.Next(og) do
		local code=tc:GetOriginalCodeRule()
		local eid=c:CopyEffect(code,RESET_EVENT+0x5fe0000)
		c:CreateRelation(tc,RESET_EVENT+0x5fe0000)
		tc:CreateRelation(c,RESET_EVENT+0x5fe0000)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(eid)
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.resetop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc,eid=e:GetOwner(),e:GetLabelObject(),e:GetLabel()
	if not c:IsRelateToCard(tc) or not tc:IsRelateToCard(c) then
	   c:ReleaseRelation(tc)
	   tc:ReleaseRelation(c)
	   c:ResetEffect(eid,RESET_COPY)
	   e:Reset()
	end
end--]]
function cm.efilter(c,rc)
	return not c:IsRelateToCard(rc) or not rc:IsRelateToCard(c)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:GetRank()==10
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1 and g:GetFirst():GetRank()==10
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==10 and c:GetOverlayCount()>=5 and not c:IsCode(m)
end