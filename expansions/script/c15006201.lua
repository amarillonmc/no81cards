local m=15006201
local cm=_G["c"..m]
cm.name="无止诗篇"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006200)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function cm.tdffilter(c)
	return c:IsSetCard(0x9f44) and c:IsLocation(LOCATION_MZONE)
end
function cm.tdgcheck(g,e,tp)
	local spg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	spg:Sub(g)
	return g:IsExists(cm.tdffilter,1,nil) and Duel.GetMZoneCount(tp,g)>0 and #spg>0
end
function cm.spfilter(c,e,tp)
	return c:IsCode(15006200) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.fufilter(c,e,tp,sg)
	return c:IsSetCard(0x9f44) and c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and c:CheckFusionMaterial(sg)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ag=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return ag:CheckSubGroup(cm.tdgcheck,2,2,e,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=ag:SelectSubGroup(tp,cm.tdgcheck,false,2,2,e,tp)
	local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then
		Duel.ConfirmCards(1-tp,hg)
	end
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if #gg>0 then
		Duel.HintSelection(gg)
	end
	local ct=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if ct==2 and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(0x9f44)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			--Negate
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,2))
			e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_CHAINING)
			e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCondition(cm.negcon)
			e2:SetCost(cm.negcost)
			e2:SetTarget(cm.negtg)
			e2:SetOperation(cm.negop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			--change type
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e7:SetCode(EFFECT_ADD_TYPE)
			e7:SetRange(LOCATION_MZONE)
			e7:SetValue(TYPE_EFFECT)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e7)
			--
			Duel.SpecialSummonComplete()
			tc:CompleteProcedure()
			if Duel.IsExistingMatchingCard(cm.fufilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,og) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local fc=Duel.SelectMatchingCard(tp,cm.fufilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,og):GetFirst()
				if fc then
					Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
					fc:CompleteProcedure()
				end
			end
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.excostfilter(c,tp)
	return c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup())
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local locs=0
	local loco=0
	if Duel.IsPlayerAffectedByEffect(tp,15006207) then locs=LOCATION_HAND+LOCATION_MZONE end
	if Duel.IsPlayerAffectedByEffect(tp,15006206) then loco=LOCATION_MZONE end
	local ag=Group.CreateGroup()
	if c:IsReleasable() then ag:AddCard(c) end
	local arg=Duel.GetMatchingGroup(cm.excostfilter,tp,locs,loco,nil,tp)
	if #arg>0 then ag:Merge(arg) end
	if chk==0 then return #ag>0 end
	local rc=c
	if #ag>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		rc=ag:Select(tp,1,1,nil):GetFirst()
	end
	if rc:IsControler(1-tp) then
		Duel.HintSelection(Group.FromCards(rc))
		local te=Duel.IsPlayerAffectedByEffect(tp,15006206)
		te:UseCountLimit(tp)
	end
	if rc~=c then Duel.Hint(HINT_CARD,1-tp,15006206) end
	Duel.Release(rc,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end