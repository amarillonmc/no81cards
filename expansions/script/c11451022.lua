--幽玄龙景＊岁星合月
local cm,m=GetID()
function cm.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spirit return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(cm.SpiritReturnReg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCost(cm.sumcost)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e3
end
function cm.filter(c)
	return c:GetOriginalType()&TYPE_LINK==0 and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	local p=0xd
	if tc:IsStatus(STATUS_BATTLE_DESTROYED) then p=POS_FACEUP end
	local pos=Duel.SelectPosition(tp,tc,p&~tc:GetPosition())
	local prop=e:GetProperty()
	e:SetProperty(prop|EFFECT_FLAG_IGNORE_IMMUNE)
	Duel.ChangePosition(tc,pos)
	e:SetProperty(prop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnConditionForced)
	e1:SetTarget(Auxiliary.SpiritReturnTargetForced)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Auxiliary.SpiritReturnConditionOptional)
	e2:SetTarget(Auxiliary.SpiritReturnTargetOptional)
	c:RegisterEffect(e2)
end
function cm.cpfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(cm.cpfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e,tp,c)
end
function cm.cpfilter2(c,e,tp,tc)
	local fg=Group.FromCards(c,tc)
	return c:IsFacedown() and c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,fg,e,tp,fg)
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc2=Duel.SelectMatchingCard(tp,cm.cpfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp,tc):GetFirst()
	local fg=Group.FromCards(tc,tc2)
	--Debug.Message(Duel.GetMatchingGroupCount(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,fg,e,tp,fg))
	Duel.SendtoHand(fg,nil,REASON_COST)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,exchk)
	if chk==0 then return e:IsCostChecked() or (exchk==100 and Duel.IsExistingMatchingCard(cm.smfilter11,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter11(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.smfilter(c,e,tp,fg)
	local eset1={c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)}
	local eset2={c:IsHasEffect(EFFECT_LIMIT_SET_PROC)}
	local eset3={c:IsHasEffect(EFFECT_SUMMON_PROC)}
	local eset4={c:IsHasEffect(EFFECT_SET_PROC)}
	local e1,e2=Effect.CreateEffect(e:GetHandler()),Effect.CreateEffect(e:GetHandler())
	local _CheckTribute=Duel.CheckTribute
	local _GetLocationCount=Duel.GetLocationCount
	local _GetMZoneCount=Duel.GetMZoneCount
	if aux.GetValueType(fg)=="Group" then
		function Duel.CheckTribute(c,mi,ma,mg,top,...)
			local g=mg or Duel.GetTributeGroup(c)
			return _CheckTribute(c,mi,ma,g-fg,top,...)
		end
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
	Duel.CheckTribute=_CheckTribute
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
	--if mi>0 then Debug.Message(c:GetCode()) Debug.Message(Duel.CheckTribute(c,mi,ma,mg)) end
	if mi>0 then return Duel.CheckTribute(c,mi,ma,mg) end
	return Duel.GetMZoneCount(tp,fg)>0
end
function cm.smfilter2(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
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