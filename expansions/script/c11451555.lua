--诡雷战队 突击队
--21.04.22
local cm,m=GetID()
function cm.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.tgcost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
end
function cm.eqfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.equipfd(c,tp,tc)
	if tc:IsPosition(POS_FACEUP) then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false) return true end
	if not Duel.Equip(tp,tc,c,false) then return false end
	--Add Equip limit
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	tc:RegisterEffect(e1)
	return true
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsPlayerCanSSet(tp) then return end
	if not c:GetEquipGroup():IsExists(cm.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local tc=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil):GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.DisableShuffleCheck()
		if tc:IsForbidden() then
			Duel.DiscardDeck(tp,1,REASON_RULE)
			Duel.Readjust()
		elseif cm.equipfd(c,tp,tc) then
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			Duel.Readjust()
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.filter(c)
	return c:GetEquipTarget() and c:IsFacedown()
end
function cm.ncfilter(c)
	return not c:IsAbleToGraveAsCost()
end
function cm.desfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 and not g:IsExists(cm.ncfilter,1,nil) end
	local dg=Group.CreateGroup()
	local lab=0
	for tc in aux.Next(g) do
		dg:Merge(tc:GetColumnGroup())
		lab=lab|1<<tc:GetSequence()
	end
	dg:Sub(g)
	dg:KeepAlive()
	e:SetLabelObject(dg)
	local num=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(lab,num)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tab={e:GetLabel()}
	local dg=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,tab[2]*400)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tab={e:GetLabel()}
	if Duel.Damage(tp,tab[2]*400,REASON_EFFECT)<=0 then return end
	local dg=Group.CreateGroup()
	for i=0,4 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		if tab[1]&(1<<i)~=0 then
			local g=Duel.GetMatchingGroup(cm.desfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)
			if #g>0 then dg:Merge(g:Select(tp,0,1,nil)) end
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end