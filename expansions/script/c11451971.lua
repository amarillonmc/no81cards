--秘计螺旋 扩容
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(cm.adop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.tgfilter(c,tp,sc)
	return c:IsSetCard(0x836) and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and #Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()<4) or #Duel.GetMatchingGroup(cm.setfilter0,tp,LOCATION_HAND,0,nil)>0)
end
function cm.setfilter0(c)
	return c:IsSSetable(true) and c:IsType(TYPE_FIELD)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,0,nil,tp,c)
	return #g>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,0,nil,tp,c)
	local g2=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or (sg:GetFirst():IsLocation(LOCATION_SZONE) and sg:GetFirst():GetSequence()<4)) then g2=g2:Filter(cm.setfilter0,nil) end
	local sg2=g2:Select(tp,1,1,nil)
	if #sg>0 and #sg2>0 then
		sg:Merge(sg2)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local sg=g:Filter(Card.IsOnField,nil)
	Duel.SendtoGrave(sg,REASON_SPSUMMON+REASON_COST)
	local loc=LOCATION_SZONE
	local tc=(g-sg):GetFirst()
	if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE end
	Duel.MoveToField(tc,tp,tp,loc,POS_FACEDOWN,false)
	tc:SetStatus(STATUS_SET_TURN,true)
	Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_SPSUMMON+REASON_COST,tp,tp,0)
	--Duel.SSet(tp,g-sg,tp,false)
	g:DeleteGroup()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==m then
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			local tid=Duel.GetTurnCount()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetCondition(function() return Duel.GetTurnCount()~=tid end)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	if DEFECT_ORAL_COUNT==3 and Duel.IsPlayerAffectedByEffect(0,m) then
		DEFECT_ORAL_COUNT=5
	elseif DEFECT_ORAL_COUNT==5 and not Duel.IsPlayerAffectedByEffect(0,m) then
		DEFECT_ORAL_COUNT=3
		for tp=0,1 do
			local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
			while #eset>DEFECT_ORAL_COUNT do
				local de=eset[#eset]
				local ce=de:GetLabelObject()
				if ce and aux.GetValueType(ce)=="Effect" then
					local tc=ce:GetHandler()
					local eset2={tc:IsHasEffect(EFFECT_FLAG_EFFECT+11451961)}
					local res=false
					for _,te in pairs(eset2) do
						if te:GetLabel()==de:GetLabel() then res=true break end
					end
					if res then
						Duel.RaiseEvent(tc,EVENT_CUSTOM+11451961,e,0,0,0,0)
						Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(tc:GetOriginalCode(),3))
						Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(tc:GetOriginalCode(),3))
					end
					ce:Reset()
				end
				de:Reset()
				eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
			end
		end
	end  
end