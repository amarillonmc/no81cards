local m=15005213
local cm=_G["c"..m]
cm.name="繁绘隅穹-工艺家的奇想"
function cm.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,15005213+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,15005214)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	if not TddSkandhaGlobalCheck then
		TddSkandhaGlobalCheck=true
		_SkandhaCRemoveCounter=Card.RemoveCounter
		function Card.RemoveCounter(tc,p,countertype,ct,r,re)
			if countertype==0 then
				local count=tc:GetCounter(0x1f37)
				if count>0 and not re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,nil,r,p,tc:GetControler(),count)
				elseif count>0 and re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,re,r,p,tc:GetControler(),count)
				end
			end
			if countertype==0x1f37 then
				local count=tc:GetCounter(0x1f37)
				if count>0 and not re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,nil,r,p,tc:GetControler(),ct)
				elseif count>0 and re then
					Duel.RaiseEvent(tc,EVENT_REMOVE_COUNTER+0x1f37,re,r,p,tc:GetControler(),ct)
				end
			end
			return _SkandhaCRemoveCounter(tc,p,countertype,ct,r)
		end
		_SkandhaDRemoveCounter=Duel.RemoveCounter
		function Duel.RemoveCounter(p,s,o,countertype,ct,r)
			if countertype~=0x1f37 then
				return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
			end
			if s~=0 and o~=0 then
				return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
			end
			local f=function(c)
						return c:GetCounter(0x1f37)>0
					end
			local rmg=Duel.GetMatchingGroup(f,p,s,o,nil)
			local rmg0=rmg:Filter(Card.IsControler,nil,0)
			local rmg1=rmg:Filter(Card.IsControler,nil,1)
			if #rmg0~=0 then 
				Duel.RaiseEvent(rmg0,EVENT_REMOVE_COUNTER+0x1f37,nil,r,7,0,ct)
			end
			if #rmg1~=0 then 
				Duel.RaiseEvent(rmg1,EVENT_REMOVE_COUNTER+0x1f37,nil,r,7,1,ct)
			end
			return _SkandhaDRemoveCounter(p,s,o,countertype,ct,r)
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0=eg:Filter(Card.IsControler,nil,0):GetSum(Card.GetCounter,0x1f37)
							local ct1=eg:Filter(Card.IsControler,nil,1):GetSum(Card.GetCounter,0x1f37)
							e:SetLabel(ct0,ct1)
						end)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_FIELD)
		ge2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0,ct1=e:GetLabelObject():GetLabel()
							return ct0~=0 or ct1~=0
						end)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local ct0,ct1=e:GetLabelObject():GetLabel()
							if ct0~=0 then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+15005200,re,r,rp,0,ct0)
							end
							if ct1~=0 then
								Duel.RaiseEvent(eg,EVENT_CUSTOM+15005200,re,r,rp,1,ct1)
							end
						end)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CUSTOM+15005200)
		ge3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							return ev>0
						end)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local x=100
							if Duel.IsPlayerAffectedByEffect(ep,15005204) then
								x=Duel.IsPlayerAffectedByEffect(ep,15005204):GetValue()
							end
							if Duel.IsPlayerAffectedByEffect(ep,15005202) then
								Duel.Recover(ep,ev*x,REASON_EFFECT)
							else
								Duel.Damage(ep,ev*x,REASON_EFFECT)
							end
						end)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_REMOVE_COUNTER+0x1f37)
		ge4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							return ev>0 and (rp==0 or rp==1)
						end)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local x=100
							if Duel.IsPlayerAffectedByEffect(ep,15005204) then
								x=Duel.IsPlayerAffectedByEffect(ep,15005204):GetValue()
							end
							if Duel.IsPlayerAffectedByEffect(ep,15005202) then
								Duel.Recover(ep,ev*x,REASON_EFFECT)
							else
								Duel.Damage(ep,ev*x,REASON_EFFECT)
							end
						end)
		Duel.RegisterEffect(ge4,0)
	end
end
cm.counter_add_list={0x1f37}
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.ctfilter(c)
	return c:IsCanAddCounter(0x1f37,1)
end
function cm.rctfilter(c)
	return c:GetCounter(0x1f37)~=0
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCounter(tp,LOCATION_MZONE,LOCATION_MZONE,0x1f37)==0 then return end
	local ct0=Duel.GetCounter(tp,LOCATION_MZONE,0,0x1f37)
	local ct1=Duel.GetCounter(1-tp,LOCATION_MZONE,0,0x1f37)
	local sg=Duel.GetMatchingGroup(cm.rctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=sg:GetFirst()
	while tc do
		tc:RemoveCounter(tp,0x1f37,tc:GetCounter(0x1f37),REASON_EFFECT)
		tc=sg:GetNext()
	end
	local cg=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #cg~=0 then
		local cc=cg:GetFirst()
		while cc do
			cc:AddCounter(0x1f37,1)
			Duel.RaiseEvent(cc,EVENT_CUSTOM+15005201,e,0,tp,tp,1)
			cc=cg:GetNext()
		end
	end
end
function cm.spfilter(c,e,tp)
	return aux.IsCounterAdded(c,0x1f37) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end