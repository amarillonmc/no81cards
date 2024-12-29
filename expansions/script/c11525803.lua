--启声之异响鸣
function c11525803.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c11525803.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c11525803.condition)
	e1:SetOperation(c11525803.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,11525803)
	e2:SetCost(c11525803.tdcost)
	e2:SetTarget(c11525803.tdtg)
	e2:SetOperation(c11525803.tdop)
	c:RegisterEffect(e2)
end
function c11525803.hcfilter(c)
	return c:IsSetCard(0x1a3) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c11525803.handcon(e)
	return Duel.IsExistingMatchingCard(c11525803.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11525803.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a3) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c11525803.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11525803.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c11525803.activate(e,tp,eg,ep,ev,re,r,rp,op)
	if op==nil and not c11525803.condition(e,tp) then return end
	local c=e:GetHandler()
	if op==nil then
		op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(11525803,0)},
			{true,aux.Stringid(11525803,1)})
	end
	if op&1>0 and Duel.Recover(tp,500,REASON_EFFECT)>0 then
		if Duel.GetFlagEffect(tp,11525803)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(11525803,2))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCountLimit(1,29432356)
			e1:SetValue(aux.TRUE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,11525803,RESET_PHASE+PHASE_END,0,1)
		end
	end
	if op&2>0 and Duel.Damage(tp,500,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c11525803.discon)
		e1:SetOperation(c11525803.disop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11525803.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c11525803.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(11525803,3)) then
		Duel.Hint(HINT_CARD,0,11525803)
		Duel.NegateEffect(ev)
		e:Reset()
	end
end
function c11525803.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c11525803.tdfilter(c)
	return c:IsSetCard(0x1a3) and c:IsFaceupEx() and c:IsAbleToDeck() and c:IsAbleToHand()
end
function c11525803.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not c11525803.tdfilter(e:GetHandler()) then return false end
	local ct=Duel.GetMatchingGroupCount(c11525803.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,e:GetHandler())
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsCanRemoveCounter(tp,1,0,0x6a,3,REASON_COST) and ct>=2
	end
	local op=1
	if Duel.IsCanRemoveCounter(tp,1,0,0x6a,6,REASON_COST) and ct>=5 then
		op=Duel.SelectOption(tp,aux.Stringid(11525803,4),aux.Stringid(11525803,5))+1
	end
	Duel.RemoveCounter(tp,1,0,0x6a,op*3,REASON_COST)
	Duel.SetTargetParam(op*3-1)
end
function c11525803.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c11525803.tdfilter(c)) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11525803.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,ct,ct,c)
	if g:GetCount()==0 then return end
	g:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		g:Sub(tg)
	end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c11525803.pop(e,tp,eg,ep,ev,re,r,rp)
		local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if lpz==nil or rpz==nil then return false end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local eset={e1}
		local lscale=lpz:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local g=Duel.GetFieldGroup(tp,loc,0)
		local res=g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
		e1:Reset()
		if res and Duel.SelectYesNo(tp,aux.Stringid(11525803,2)) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(aux.TRUE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			eset={e1}
			local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
			local ft=Duel.GetUsableMZoneCount(tp)
			local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
			if ect and ect<ft2 then ft2=ect end
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then
				if ft1>0 then ft1=1 end
				if ft2>0 then ft2=1 end
				ft=1
			end
			if ft1>0 then loc=loc|LOCATION_HAND end
			if ft2>0 then loc=loc|LOCATION_EXTRA end
			local tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
			tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,e1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
			local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,math.min(#tg,ft))
			aux.GCheckAdditional=nil
			if not g then
				e1:Reset()
				return
			end
			local sg=Group.CreateGroup()
			sg:Merge(g)
			Duel.HintSelection(Group.FromCards(lpz))
			Duel.HintSelection(Group.FromCards(rpz))
			Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
			Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
			e1:Reset()
		end
end
