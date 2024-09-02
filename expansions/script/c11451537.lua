--无前之斗争军势
--21.05.21
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,nil,nil,99)
	c:EnableReviveLimit()
	--xyz in battle
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.xyzcon)
	e0:SetOperation(cm.xyzop)
	c:RegisterEffect(e0)
	--advance
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCondition(cm.adcon)
	c:RegisterEffect(e4)
	--summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.otcon)
	e2:SetOperation(cm.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(m)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DECREASE_TRIBUTE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e6:SetTarget(aux.TRUE)
	e6:SetValue(cm.decval)
	--c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SUMMON_COST)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e7:SetCost(cm.costchk)
	e7:SetOperation(cm.costop)
	--c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		cm.CheckTribute=Duel.CheckTribute
		local _SelectTribute=Duel.SelectTribute
		local _Release=Duel.Release
		function Duel.CheckTribute(c,mi,ma,mg,top,...)
			local tp=c:GetControler()
			local xg=Duel.GetMatchingGroup(cm.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
			if #xg==0 then return cm.CheckTribute(c,mi,ma,mg,top,...) end
			local og=Group.CreateGroup()
			for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
			og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
			local eset4={c:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
			if #eset4>0 then
				for _,te in pairs(eset4) do
					local val=te:GetValue()
					if aux.GetValueType(val)=="function" then
						for oc in aux.Next(og) do
							if val(te,oc) then og:RemoveCard(oc) end
						end
					end
				end
			end
			if #og>=mi and Duel.GetMZoneCount(top)>0 then return true end
			return cm.CheckTribute(c,mi-#og,ma,mg,top,...)
		end
		function Duel.SelectTribute(tp,c,mi,ma,mg,...)
			local g=mg or Duel.GetTributeGroup(c)
			local xg=Duel.GetMatchingGroup(cm.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			if #xg==0 then return _SelectTribute(tp,c,mi,ma,mg,...) end
			local og=Group.CreateGroup()
			for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
			og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
			local eset4={c:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
			if #eset4>0 then
				for _,te in pairs(eset4) do
					local val=te:GetValue()
					if aux.GetValueType(val)=="function" then
						for oc in aux.Next(og) do
							if val(te,oc) then og:RemoveCard(oc) end
						end
					end
				end
			end
			g:Merge(og)
			local tp=c:GetControler()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TRIBUTE)
			local sg=g:SelectSubGroup(tp,cm.fselect,false,mi,ma)
			--sg:KeepAlive()
			return sg
		end
		function Duel.Release(sg,r)
			if r&(REASON_SUMMON+REASON_MATERIAL)~=REASON_SUMMON+REASON_MATERIAL then return _Release(sg,r) end
			local xg=Duel.GetMatchingGroup(cm.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
			if #xg==0 then return _Release(sg,r) end
			local tab={}
			local og=Group.CreateGroup()
			local tab={}
			for oc in aux.Next(xg) do
				tab[oc]=oc:GetOverlayGroup()
				og:Merge(tab[oc])
			end
			og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
			local eset4={c:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
			if #eset4>0 then
				for _,te in pairs(eset4) do
					local val=te:GetValue()
					if aux.GetValueType(val)=="function" then
						for oc in aux.Next(og) do
							if val(te,oc) then og:RemoveCard(oc) end
						end
					end
				end
			end
			local sg2=Group.__band(og,sg)
			sg:Sub(sg2)
			local tg=Group.CreateGroup()
			if #sg2>0 then
				Duel.SendtoGrave(sg2,r|REASON_COST)
				tg=Duel.GetOperatedGroup()
			end
			_Release(sg,r)
			if #tg>0 then
				for ec in aux.Next(xg) do
					local ct=#Group.__band(tab[ec],tg)
					if ct>0 then
						local e1=Effect.CreateEffect(ec)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UPDATE_ATTACK)
						e1:SetValue(ct*1050)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
						ec:RegisterEffect(e1)
					end
				end
			end
		end
	end
end
function cm.tdfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and not (cm[1] and aux.GetValueType(cm[1])=="Group" and cm[1]:IsContains(c))
end
function cm.costchk(e,te_or_c,tp)
	e:SetLabelObject(te_or_c)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if cm[0] then return end
	local xg=Duel.GetMatchingGroup(cm.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #xg==0 then return end
	local og=Group.CreateGroup()
	for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
	og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
	local tp=tc:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TRIBUTE)
	local sg=og:SelectSubGroup(tp,cm.fselect,false,mi,ma)
	tc:SetMaterial(sg)
	local ct=Duel.SendtoGrave(sg,REASON_SUMMON+REASON_COST+REASON_MATERIAL)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct*1050)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e:GetHandler():RegisterEffect(e1)
	end
	cm[0]=tc
end
function cm.decval(e,c)
	local xg=Duel.GetMatchingGroup(cm.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local og=Group.CreateGroup()
	for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
	og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
	return #og
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and e:GetHandler():IsSpecialSummonable(SUMMON_TYPE_XYZ)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummonRule(tp,e:GetHandler(),SUMMON_TYPE_XYZ)
end
function cm.filter(c,tp,ec)
	return c:IsCanOverlay(tp) and Duel.IsExistingMatchingCard(cm.adfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,c,ec)
end
function cm.adfilter(c,tc,ec)
	local ft=Duel.GetMZoneCount(c:GetControler())
	if c:IsSummonable(true,nil) or c:IsMSetable(true,nil) then
		return true
	elseif (tc:GetOriginalType()&TYPE_MONSTER==0 and ft>0) or c:IsOnField() then
		return false
	end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabelObject(tc)
	e1:SetTarget(function(e,c) return c==e:GetLabelObject() end)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local res=c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
	if not res and ft<=0 then
		local fg=Group.FromCards(tc)
		res=cm.smfilter22(c,nil,nil,fg)
	end
	e1:Reset()
	return res
end
function cm.smfilter22(c,e,tp,fg)
	local eset1={c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)}
	local eset2={c:IsHasEffect(EFFECT_LIMIT_SET_PROC)}
	local eset3={c:IsHasEffect(EFFECT_SUMMON_PROC)}
	local eset4={c:IsHasEffect(EFFECT_SET_PROC)}
	local e1,e2=Effect.CreateEffect(c),Effect.CreateEffect(c)
	local _GetLocationCount=Duel.GetLocationCount
	local _GetMZoneCount=Duel.GetMZoneCount
	if aux.GetValueType(fg)=="Group" then
		function Duel.GetLocationCount(p,loc,...)
			if loc~=LOCATION_MZONE then return _GetLocationCount(p,loc,...) end
			return _GetMZoneCount(p,fg,...)
		end
		function Duel.GetMZoneCount(p,lg,...)
			if lg then return _GetMZoneCount(p,fg+lg,...) end
			return _GetMZoneCount(p,fg,...)
		end
	end
	local mi,ma=c:GetTributeRequirement()
	if #eset1==0 then
		--summon
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e1:SetLabelObject(fg)
		e1:SetCondition(cm.ttcon)
		if mi>0 then e1:SetValue(SUMMON_TYPE_ADVANCE) end
		c:RegisterEffect(e1,true)
	end
	if #eset2==0 then
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LIMIT_SET_PROC)
		e2:SetLabelObject(fg)
		e2:SetCondition(cm.ttcon)
		c:RegisterEffect(e2,true)
	end
	local res=c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
	e1:Reset()
	e2:Reset()
	if not res then
		if #eset1==0 and #eset3>0 then
			for _,te in pairs(eset3) do
				local te1=te:Clone()
				te1:SetType(EFFECT_TYPE_SINGLE)
				te1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
				te1:SetRange(nil)
				c:RegisterEffect(te1,true)
				res=res or c:IsSummonable(true,nil)
				te1:Reset()
				if res then break end
			end
		end
		if #eset2==0 and #eset4>0 then
			for _,te in pairs(eset4) do
				local te1=te:Clone()
				te1:SetType(EFFECT_TYPE_SINGLE)
				te1:SetCode(EFFECT_LIMIT_SET_PROC)
				te1:SetRange(nil)
				c:RegisterEffect(te1,true)
				res=res or c:IsMSetable(true,nil)
				te1:Reset()
				if res then break end
			end
		end
	end
	Duel.GetLocationCount=_GetLocationCount
	Duel.GetMZoneCount=_GetMZoneCount
	--Debug.Message(res)
	return res
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	local mg=Duel.GetTributeGroup(c)
	local fg=e:GetLabelObject()
	if mi>0 then return Duel.CheckTribute(c,mi,ma,mg) end
	return Duel.GetMZoneCount(tp,fg)>0
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=e:GetHandlerPlayer()
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp,c)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	local og=tc:GetOverlayGroup()
	if og:GetCount()>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	tc:CancelToGrave()
	Duel.Overlay(c,sg)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function cm.tcfilter(c)
	return c:IsHasEffect(m)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local eset1={c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)}
	if #eset1>0 then return false end
	local eset2={c:IsHasEffect(EFFECT_SUMMON_PROC)}
	local eset3={c:IsHasEffect(EFFECT_SET_PROC)}
	--if #eset2>1 or #eset3>1 then return false end
	local xg=Duel.GetMatchingGroup(cm.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #xg==0 then return false end
	local og=Group.CreateGroup()
	for oc in aux.Next(xg) do og:Merge(oc:GetOverlayGroup()) end
	og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
	local eset4={c:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
	if #eset4>0 then
		for _,te in pairs(eset4) do
			local val=te:GetValue()
			if aux.GetValueType(val)=="function" then
				for oc in aux.Next(og) do
					if val(te,oc) then og:RemoveCard(oc) end
				end
			end
		end
	end
	if #og==0 then return false end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	return ma>0 and minc<=ma and ((math.max(mi,minc)<=#og and Duel.GetMZoneCount(tp)>0) or cm.CheckTribute(c,math.max(1,math.max(mi,minc)-#og)))
end
function cm.fselect(g)
	return Duel.GetMZoneCount(tp,g)>0
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	local g=Duel.GetTributeGroup(c)
	local xg=Duel.GetMatchingGroup(cm.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #xg==0 then return end
	local og=Group.CreateGroup()
	local tab={}
	for oc in aux.Next(xg) do
		tab[oc]=oc:GetOverlayGroup()
		og:Merge(tab[oc])
	end
	og=og:Filter(Card.IsType,nil,TYPE_MONSTER)
	local eset4={c:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
	if #eset4>0 then
		for _,te in pairs(eset4) do
			local val=te:GetValue()
			if aux.GetValueType(val)=="function" then
				for oc in aux.Next(og) do
					if val(te,oc) then og:RemoveCard(oc) end
				end
			end
		end
	end
	g:Merge(og)
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TRIBUTE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,mi,ma)
	c:SetMaterial(sg)
	local sg2=Group.__band(og,sg)
	sg:Sub(sg2)
	local tg=Group.CreateGroup()
	if #sg2>0 then
		Duel.SendtoGrave(sg2,REASON_SUMMON+REASON_COST+REASON_MATERIAL)
		tg=Duel.GetOperatedGroup()
	end
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	if #tg>0 then
		for ec in aux.Next(xg) do
			local ct=#Group.__band(tab[ec],tg)
			if ct>0 then
				local e1=Effect.CreateEffect(ec)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(ct*1050)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				ec:RegisterEffect(e1)
			end
		end
	end
end