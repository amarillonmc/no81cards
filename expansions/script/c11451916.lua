--幽之汐雏 灾诞之影
local cm,m=GetID()
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(aux.TRUE)
	c:RegisterEffect(e3)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.pspcon2)
	c:RegisterEffect(e5)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetTarget(cm.psptg2(11451911))
	c:RegisterEffect(e4)
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetTarget(cm.psptg2(11451913))
	c:RegisterEffect(e6)
	local e8=e5:Clone()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetTarget(cm.psptg2(11451915))
	c:RegisterEffect(e8)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(11451912)
	e0:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	c:RegisterEffect(e0)
	if not STRIDGON_REPSPSUMMON_CHECK then
		STRIDGON_REPSPSUMMON_CHECK=true
		local _PConditionFilter=aux.PConditionFilter
		function aux.PConditionFilter(c,e,...)
			cm[0]=e
			return _PConditionFilter(c,e,...)
		end
		local _PendOperationCheck=aux.PendOperationCheck
		function aux.PendOperationCheck(ft1,ft2,ft)
			cm[2]=true
			return _PendOperationCheck(ft1,ft2,ft)
		end
		local _SelectSubGroup=Group.SelectSubGroup
		function Group.SelectSubGroup(...)
			local res=_SelectSubGroup(...)
			if res and cm[0] and cm[2] then cm[1]=cm[0] end
			cm[0]=nil
			cm[2]=nil
			return res
		end
		local _Merge=Group.Merge
		function Group.Merge(sg,obj)
			if cm[1]==nil or (aux.GetValueType(obj)=="Group" and #obj~=1) then cm[1]=nil return _Merge(sg,obj) end
			local tc=obj
			if aux.GetValueType(obj)=="Group" then tc=obj:GetFirst() end
			local tp=tc:GetControler()
			if 1==1 then --and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451912,0))
				local tg=Duel.GetMatchingGroup(cm.tspfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,tc,nil,tp,tc):CancelableSelect(tp,1,1,nil)
				if tg and #tg>0 then
					local e1=Effect.CreateEffect(tg:GetFirst())
					e1:SetDescription(aux.Stringid(tg:GetFirst():GetOriginalCode(),7))
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_FLAG_EFFECT+tg:GetFirst():GetOriginalCode())
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					e1:SetTargetRange(1,0)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					cm[1]=nil
					Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451912,6))
					return _Merge(sg,tg)
				end
			end
			cm[1]=nil
			return _Merge(sg,obj)
		end
		local _SpecialSummonRule=Duel.SpecialSummonRule
		function Duel.SpecialSummonRule(tp,tc,sumtype)
			if sumtype~=SUMMON_TYPE_PENDULUM then _SpecialSummonRule(tp,tc,sumtype) end
			local tp=tc:GetControler()
			if 1==1 then --and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451912,0))
				local tg=Duel.GetMatchingGroup(cm.tspfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,tc,nil,tp,tc):CancelableSelect(tp,1,1,nil)
				if tg and #tg>0 then 
					local e1=Effect.CreateEffect(tg:GetFirst())
					e1:SetDescription(aux.Stringid(tg:GetFirst():GetOriginalCode(),7))
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_FLAG_EFFECT+tg:GetFirst():GetOriginalCode())
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					e1:SetTargetRange(1,0)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					local tc2=tg:GetFirst()
					tc2.pendulum_rule[tc2]:SetLabel(1)
					if tc.pendulum_rule and tc.pendulum_rule[tc] then tc.pendulum_rule[tc]:SetLabel(0) end
					Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451912,6))
					return _SpecialSummonRule(tp,tc2,SUMMON_TYPE_PENDULUM)
				end
			end
			_SpecialSummonRule(tp,tc,sumtype)
		end
	end
end
function cm.tspfilter(c,e,tp)
	if not c:IsHasEffect(11451912) or Duel.GetFlagEffect(tp,c:GetOriginalCode())>0 or (e and not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)) then return false end
	if not e then
		local tc=c
		if not tc.pendulum_rule or not tc.pendulum_rule[tc] then
			local tcm=getmetatable(tc)
			tcm.pendulum_rule=tcm.pendulum_rule or {}
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
			e1:SetLabel(1)
			e1:SetCondition(function(e) return e:GetLabel()==1 end)
			e1:SetTarget(function(e) e:SetLabel(0) return true end)
			e1:SetValue(SUMMON_TYPE_PENDULUM)
			tc:RegisterEffect(e1,true)
			tcm.pendulum_rule[tc]=e1
		else
			tc.pendulum_rule[tc]:SetLabel(1)
		end
		if not tc:IsCanBeSpecialSummoned(tc.pendulum_rule[tc],SUMMON_TYPE_PENDULUM,tp,false,false) then tc.pendulum_rule[tc]:SetLabel(0) return false end
		tc.pendulum_rule[tc]:SetLabel(0)
	end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	local g=Group.FromCards(c)
	local ext=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	return ext<=ft2 and #g-ext<=ft1 and #g<=ft
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.spfilter0(c,loc)
	return c:IsPreviousLocation(loc) and not (c:IsLocation(loc) and c:IsControler(c:GetPreviousControler()))
end
function cm.pspcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter0,1,nil,LOCATION_DECK) and (not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.thfilter(c,...)
	local tab={...}
	for _,code in ipairs(tab) do
		if c:GetOriginalCode()==code and c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) then return true end
	end
	return false
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tab0={11451911,11451913,11451915}
	local tab={}
	for _,code in ipairs(tab0) do
		if c:GetFlagEffect(code)>0 then tab[#tab+1]=code end
	end
	if chk==0 then
		return #tab>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,table.unpack(tab))
	end
	e:SetLabel(table.unpack(tab))
end
function cm.psptg2(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then
					c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
					return false
				end
			end
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local tab={e:GetLabel()}
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil,table.unpack(tab))
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil) --SelectSubGroup(tp,aux.dncheck,false,1,g:GetClassCount(Card.GetOriginalCode))
	if #sg>0 then
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	end
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.desfilter(c)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>0 end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g=g:Select(tp,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end