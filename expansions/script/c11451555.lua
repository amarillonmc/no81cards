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
	e1:SetCondition(function() return not pnfl_adjusting end)
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
	if tc:IsPosition(POS_FACEUP) then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false) end
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
	if pnfl_adjusting then return end
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(11451552)
	if not ((phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsPlayerCanSSet(tp) and c:IsLocation(LOCATION_MZONE) and not c:GetEquipGroup():IsExists(cm.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>0 and (not flag or flag>2) then
		if flag then
			flag=flag-1
			local flage=c:IsHasEffect(EFFECT_FLAG_EFFECT+11451552)
			--flage:SetLabel(flag)
			--flage:SetDescription(aux.Stringid(11451552,flag))
			c:ResetFlagEffect(11451552)
			c:RegisterFlagEffect(11451552,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451552,flag))
		else
			c:RegisterFlagEffect(11451552,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,4,aux.Stringid(11451552,4))
		end
		Duel.Hint(HINT_CARD,0,m)
		--Duel.HintSelection(Group.FromCards(c))
		local tc=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil):GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.DisableShuffleCheck()
		pnfl_adjusting=true
		if tc:IsForbidden() then
			Duel.DiscardDeck(tp,1,REASON_RULE)
			pnfl_adjusting=false
			cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
		elseif cm.equipfd(c,tp,tc) then
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			pnfl_adjusting=false
			Duel.Readjust()
		end
		pnfl_adjusting=false
	end
	pnfl_adjusting=false
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
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 and not g:IsExists(cm.ncfilter,1,nil) end
	local dg=Group.CreateGroup()
	local lab,lab2=0,0
	for tc in aux.Next(g) do
		local tseq=tc:GetSequence()
		if tc:IsControler(1-tp) then tseq=4-tseq end
		dg:Merge(tc:GetColumnGroup())
		if lab&(1<<tseq)>0 then lab2=lab2|1<<tseq end
		lab=lab|1<<tseq
	end
	dg:Sub(g)
	dg:KeepAlive()
	e:SetLabelObject(dg)
	local num=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(lab,num,lab2)
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
			local mt=1
			if tab[3]&(1<<i)~=0 then mt=2 end
			local g=Duel.GetMatchingGroup(cm.desfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)
			if #g>0 then dg:Merge(g:Select(tp,0,mt,nil)) end
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end