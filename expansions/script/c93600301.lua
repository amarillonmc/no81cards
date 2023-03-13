--噬星的进化龙 黑洞形态
local m=93600301
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,nil,nil,99)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--Black Hole
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.atcost)
	e1:SetTarget(cm.xyztarget)
	e1:SetOperation(cm.xyzoperation)
	c:RegisterEffect(e1)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(m,0))
	e1_1:SetType(EFFECT_TYPE_QUICK_O)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetCountLimit(1)
	e1_1:SetCode(EVENT_FREE_CHAIN)
	e1_1:SetCost(cm.atcost)
	e1_1:SetCondition(cm.xyzcondition)
	e1_1:SetTarget(cm.xyztarget)
	e1_1:SetOperation(cm.xyzoperation)
	c:RegisterEffect(e1_1)
-------------Xyz Materials Effect--
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.effcon)
	e2:SetValue(cm.atkval)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	e3:SetCondition(cm.effcon)
	e3:SetLabel(5)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCondition(cm.effcon)
	e4:SetLabel(5)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCondition(cm.effcon)
	e5:SetLabel(7)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
	--
	local e6=rkch.MonzToPen(c,m,EVENT_LEAVE_FIELD,true)
-----------------pzone--
	--Recover
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ea:SetCode(EVENT_CHAINING)
	ea:SetRange(LOCATION_PZONE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ea:SetOperation(cm.regop)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	eb:SetCode(EVENT_CHAIN_SOLVED)
	eb:SetRange(LOCATION_PZONE)
	eb:SetCondition(cm.damcon)
	eb:SetOperation(cm.damop)
	c:RegisterEffect(eb)
	--resurrection  summon
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ed:SetCode(EVENT_PHASE+PHASE_STANDBY)
	ed:SetRange(LOCATION_PZONE)
	ed:SetCountLimit(1)
	ed:SetCondition(cm.spcon)
	ed:SetOperation(cm.spop)
	c:RegisterEffect(ed)
end
cm.pendulum_level=9
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*300
end
--material--
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and tc:IsCanOverlay() and e:GetHandler():GetFlagEffect(m)==0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and tc:IsRelateToBattle() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Hint(HINT_CARD,0,m)
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
--pzone--
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(m)~=0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,300,REASON_EFFECT)
end
--resurrection  summon
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=Duel.GetLP(1-tp)+6000 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.CheckReleaseGroup(tp,Card.IsLocation,1,nil,LOCATION_MZONE) and Duel.GetMatchingGroupCount(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>2
end
function cm.spop(e,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		Duel.Release(g,REASON_EFFECT)
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
			local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
			Duel.Overlay(e:GetHandler(),sg)
		end
	end
end
--Black Hole--
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.xyzcondition(e,tp)
	return e:GetHandler():GetOverlayCount()>8
end
function cm.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local seq=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,seq)
	Duel.Hint(HINT_ZONE,1-tp,seq>>16)
end
function cm.xyzoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetLabel()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetLabel(seq)
	e0:SetOwnerPlayer(tp)
	e0:SetCondition(cm.xcon)
	e0:SetOperation(cm.xop)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e0,true)
end
function cm.xcon(e)
	local tp=e:GetOwnerPlayer()
	local c=e:GetHandler()
	local seq=e:GetLabel()
	local zone=math.floor(math.log(seq,2))
	local phase=Duel.GetCurrentPhase()
	local rp=0
	local loc=0
	if c:IsFaceup() then
		if zone<14 then
			rp=tp
			if zone>4 and zone~=13 then
				loc=LOCATION_SZONE
				zone=zone-8
			end
			if zone==13 then
				loc=LOCATION_FZONE
				zone=zone-8
			end
			if zone<5 then
				loc=LOCATION_MZONE
			end
		end
		if zone>14 and zone<23 and zone~=21 and zone~=22 then
			rp=1-tp
			loc=LOCATION_MZONE
			zone=zone-16
		end
		if zone>23 then
			rp=1-tp
			loc=LOCATION_SZONE
			if zone==29 then
				loc=LOCATION_FZONE
			end
			zone=zone-24
		end  
		local tc=Duel.GetFieldCard(rp,loc,zone)
		local sg=Group.CreateGroup()
		if tc then sg:AddCard(tc) end
		if zone~=21 and zone~=22 then
			sg=Duel.GetMatchingGroup(cm.seqfilter,rp,LOCATION_ONFIELD,0,nil,zone)
		end
		if loc==LOCATION_FZONE then 
			tc=Duel.GetFieldCard(rp,loc,0)
			if tc then sg=Group.FromCards(tc) end
		end
		if zone==22 then
			local xcg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			if xcg:GetCount()>0 then
				sg=Group.CreateGroup()
				sg:Merge(xcg)
			end
		end
		if zone==21 then
			local xcg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			if xcg:GetCount()>0 then
				sg=Group.CreateGroup()
				sg:Merge(xcg)
			end
		end
		sg:RemoveCard(c)
		sg=sg:Filter(cm.imfilter,nil,e)
		return sg:GetCount()>0
	else
		e:Reset()
		return false
	end
end
function cm.imfilter(c,e)
	return not c:IsImmuneToEffect(e) and not c:IsType(TYPE_TOKEN)
end
function cm.filter(c,tp)
	return aux.GetColumn(c,tp)==1 
end
function cm.filter2(c,tp)
	return aux.GetColumn(c,tp)==3 
end
function cm.seqfilter(c,seq)
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or math.abs(cseq-seq)==1
end
function  cm.xop(e)
	local tp=e:GetOwnerPlayer()
	local c=e:GetHandler()
	local seq=e:GetLabel()
	local zone=math.floor(math.log(seq,2))
	local rp=0
	local loc=0
	if c:IsFaceup() then
		if zone<14 then
			rp=tp
			if zone>4 and zone~=13 then
				loc=LOCATION_SZONE
				zone=zone-8
			end
			if zone==13 then
				loc=LOCATION_FZONE
				zone=zone-8
			end
			if zone<5 then
				loc=LOCATION_MZONE
			end
		end
		if zone>14 and zone<23 and zone~=21 and zone~=22 then
			rp=1-tp
			loc=LOCATION_MZONE
			zone=zone-16
		end
		if zone>23 then
			rp=1-tp
			loc=LOCATION_SZONE
			if zone==29 then
				loc=LOCATION_FZONE
			end
			zone=zone-24
		end 
		local tc=Duel.GetFieldCard(rp,loc,zone)
		local sg=Group.CreateGroup()
		if tc then sg:AddCard(tc) end
		if zone~=21 and zone~=22 then
			sg=Duel.GetMatchingGroup(cm.seqfilter,rp,LOCATION_ONFIELD,0,nil,zone)
		end
		if loc==LOCATION_FZONE then 
			tc=Duel.GetFieldCard(rp,loc,0)
			if tc then sg:AddCard(tc) end
		end
		if zone==22 then
			local xcg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			if xcg:GetCount()>0 then
				sg=Group.CreateGroup()
				sg:Merge(xcg)
			end
		end
		if zone==21 then
			local xcg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			if xcg:GetCount()>0 then
				sg=Group.CreateGroup()
				sg:Merge(xcg)
			end
		end
		sg:RemoveCard(c)
		for tc in aux.Next(sg) do
			if tc:IsCanOverlay() and not tc:IsImmuneToEffect(e) and not c:IsType(TYPE_TOKEN) then
				local sg=tc:GetOverlayGroup()
				if sg then
					Duel.SendtoGrave(sg,REASON_RULE)
				end
				Duel.Overlay(c,tc)
			end
		end
	end
end