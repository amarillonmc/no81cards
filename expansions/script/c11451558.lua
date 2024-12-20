--诡雷战队R -颠覆者-
--21.04.24
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.LinkCondition(cm.matfilter,4))
	e0:SetTarget(cm.LinkTarget(cm.matfilter,4))
	e0:SetOperation(cm.LinkOperation(cm.matfilter,4))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function() return not pnfl_adjusting end)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
	--exchange
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.excost)
	e2:SetOperation(cm.exop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
end
if not Duel.GetMustMaterial then
	function Duel.GetMustMaterial(tp,code)
		local g=Group.CreateGroup()
		local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if tc then g:AddCard(tc) end
		end
		return g
	end
end
function cm.matfilter(c)
	return c:IsType(TYPE_EFFECT) or cm.fdfilter(c)
end
function cm.fdfilter(c)
	return c:IsType(TYPE_EQUIP)
end
function cm.LConditionFilter(c,f,lc)
	return (((c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc)) or (Duel.GetFlagEffect(lc:GetControler(),m)==0 and cm.fdfilter(c))) and (not f or f(c))
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter,tp,LOCATION_ONFIELD,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg)) and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp) and (not lmat or sg:IsContains(lmat)) and not sg:IsExists(cm.fdfilter,Duel.GetTurnCount()+1,nil)
end
function cm.gcheck(sg)
	return not sg:IsExists(cm.fdfilter,4,nil)
end
function cm.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				aux.GCheckAdditional=cm.gcheck
				local res=mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
				aux.GCheckAdditional=nil
				return res
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				aux.GCheckAdditional=cm.gcheck
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				aux.GCheckAdditional=nil
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					if sg:IsExists(cm.fdfilter,1,nil) then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1) end
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				aux.LExtraMaterialCount(g,c,tp)
				--g1=g:Filter(cm.fdfilter,nil)
				--g:Sub(g1)
				--for tc in aux.Next(g1) do if tc:IsCode(m-2) then Debug.Message(tc:IsType(TYPE_LINK)) end end
				--Duel.SendtoDeck(g1,nil,2,REASON_MATERIAL+REASON_LINK)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
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
			c:ResetFlagEffect(11451552)
			c:RegisterFlagEffect(11451552,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451552,flag))
		else
			c:RegisterFlagEffect(11451552,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,5,aux.Stringid(11451552,5))
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
	return c:GetEquipTarget() and c:IsFacedown() and c:IsAbleToHandAsCost()
end
function cm.thfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(1-tp)
end
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local cg=g:Select(tp,1,#g,nil)
	Duel.SendtoHand(cg,1-tp,REASON_COST)
	Duel.ShuffleHand(1-tp)
	local ft=Duel.GetOperatedGroup():FilterCount(cm.thfilter,nil,tp)
	e:SetLabel(ft)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,1))
	local ag=g:RandomSelect(1-tp,e:GetLabel())
	if Duel.SendtoHand(ag,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,ag)
		Duel.ShuffleHand(1-tp)
	end
end