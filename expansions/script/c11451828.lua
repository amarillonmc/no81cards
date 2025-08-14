--珂拉琪的心影奇境
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x970)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--special counter permit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_COUNTER_PERMIT+0x970)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.ctpermit)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetCondition(cm.tdcon)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(aux.FALSE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local _PConditionFilter=aux.PConditionFilter
		function aux.PConditionFilter(c,e,tp,lscale,rscale,eset)
			if Duel.GetCounter(0,1,1,0x970)==0 then return _PConditionFilter(c,e,tp,lscale,rscale,eset) end
			local lv=0
			if c.pendulum_level then
				lv=c.pendulum_level
			else
				lv=c:GetLevel()
			end
			local bool=Auxiliary.PendulumSummonableBool(c)
			return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
				and ((lv>lscale and lv<rscale) or Duel.IsCanRemoveCounter(tp,1,1,0x970,math.max(lscale-lv,lv-rscale)+1,REASON_EFFECT)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
				and not c:IsForbidden()
				and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
		end
		local _PendOperationCheck=aux.PendOperationCheck
		function aux.PendOperationCheck(ft1,ft2,ft)
			if Duel.GetCounter(0,1,1,0x970)==0 then return _PendOperationCheck(ft1,ft2,ft) end
			return  function(g)
						local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						local mg=g-exg
						local tp=0
						if #g>0 then tp=g:GetFirst():GetControler() end
						local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
						local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
						if not lpz or not rpz then return _PendOperationCheck(ft1,ft2,ft) end
						local lscale=lpz:GetLeftScale()
						local rscale=rpz:GetRightScale()
						if lscale>rscale then lscale,rscale=rscale,lscale end
						local _,maxlv=g:GetMaxGroup(Card.GetLevel)
						local _,minlv=g:GetMinGroup(Card.GetLevel)
						local clv=math.max(lscale-minlv+1,0)+math.max(maxlv-rscale+1,0)
						if clv>0 then cm[0]=true end
						return #g<=ft and #exg<=ft2 and #mg<=ft1 and (clv==0 or Duel.IsCanRemoveCounter(tp,1,1,0x970,clv,REASON_EFFECT))
					end
		end
		local _SelectSubGroup=Group.SelectSubGroup
		function Group.SelectSubGroup(...)
			if Duel.GetCounter(0,1,1,0x970)==0 then return _SelectSubGroup(...) end
			local sg=_SelectSubGroup(...)
			if cm[0] then
				cm[0]=nil
				local tp=0
				if #sg>0 then tp=sg:GetFirst():GetControler() end
				local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if not lpz or not rpz then return sg end
				local lscale=lpz:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then
					lscale,rscale=rscale,lscale
					lpz,rpz=rpz,lpz
				end
				local _,maxlv=sg:GetMaxGroup(Card.GetLevel)
				local _,minlv=sg:GetMinGroup(Card.GetLevel)
				local clv=math.max(lscale-minlv+1,0)+math.max(maxlv-rscale+1,0)
				if clv>0 and Duel.IsCanRemoveCounter(tp,1,1,0x970,clv,REASON_EFFECT) then
					Duel.RemoveCounter(tp,1,1,0x970,clv,REASON_EFFECT)
				end
			end
			--[[local e1=Effect.CreateEffect(lpz)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(-lscale+minlv-1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lpz:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			e2:SetLabelObject(e1)
			lpz:RegisterEffect(e2)
			local e3=Effect.CreateEffect(rpz)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_LSCALE)
			e3:SetValue(maxlv-rscale+1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			rpz:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_RSCALE)
			e4:SetLabelObject(e3)
			rpz:RegisterEffect(e4)--]]
			return sg
		end
	end   
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x970,7,c) end
	Duel.IsCanAddCounter(tp,0x970,7,c)
	c:AddCounter(0x970,7)
end
function cm.ctpermit(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_CHAINING)
end
function cm.cfilter(c)
	return c:IsSetCard(0x163) and c:IsFaceup() and c:IsPreviousLocation(LOCATION_HAND+LOCATION_EXTRA)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x60,1,REASON_COST) end
	c:RemoveCounter(tp,0x60,1,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.tdfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x97c) and c:IsAbleToHand()
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local set=(c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or c:IsSSetable()
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetReasonEffect()==de and set and cm.tdfilter(re:GetHandler(),tp) and dp==1-tp
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local set=(c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or c:IsSSetable()
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.SendtoHand(rc,nil,REASON_EFFECT) and set then
		if c:IsLocation(LOCATION_SZONE) then
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		else
			Duel.SSet(tp,c,tp,true)
		end
	end
end
function cm.repfilter(c,tp)
	return cm.tdfilter(c,tp) and c:IsOnField() and c:IsFaceup() and c:GetFlagEffect(m)==0 
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) and rp~=tp end
	local g=eg:Filter(cm.repfilter,nil,tp)
	Duel.HintSelection(g)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			if tc:GetOriginalType()&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)==0 then
				tc:RegisterFlagEffect(m,RESET_EVENT+0x15e0000+RESET_PHASE+PHASE_END,0,1)
			else
				tc:RegisterFlagEffect(m,RESET_EVENT+0x13e0000+RESET_PHASE+PHASE_END,0,1)
			end
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function cm.thfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local c=e:GetHandler()
	local set=(c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or c:IsSSetable()
	if set then
		if c:IsLocation(LOCATION_SZONE) then
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		else
			Duel.SSet(tp,c,tp,true)
		end
	end
end