local m=15000625
local cm=_G["c"..m]
cm.name="幻智的远岸·麦哲伦"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--Disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,15000625)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--DISABLE!
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15010625)
	e2:SetCost(cm.seqcost)
	e2:SetTarget(cm.seqtg)
	e2:SetOperation(cm.seqop)
	c:RegisterEffect(e2)
	--I'm back!
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,15020625)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(15000625,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return c:IsSetCard(0xf36)
end
function cm.xyzfilter(c,sg)
	return c:IsRace(RACE_PSYCHO)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf36)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,15000625)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,15000625,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	e:GetHandler():RegisterFlagEffect(15000625,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
--  Debug.Message("极北吗？那是个冰冷又残酷的梦境。")
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local zone=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	e:SetLabel(zone)
--Debug.Message("勘探和支援就交给我吧！")
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.disfilter(c,loc,zone)
	local x=0
	if loc==LOCATION_MZONE then x=0x10000 end
	if loc==LOCATION_SZONE then x=0x1000000 end
	return c:IsFaceup() and c:IsLocation(loc) and (bit.band(zone,(2^c:GetSequence())*x)~=0 or (loc==LOCATION_FZONE and c:IsLocation(LOCATION_FZONE)))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetLabel()
	local loc=0
	if bit.band(zone,0x1f001f)~=0 then loc=LOCATION_MZONE end
	if bit.band(zone,0x1f001f00)~=0 then loc=LOCATION_SZONE end
	if bit.band(zone,0x20002000)~=0 then loc=LOCATION_FZONE end
	local tc=Duel.GetMatchingGroup(cm.disfilter,tp,0,loc,nil,loc,zone):GetFirst()
	if tc then
		Duel.NegateRelatedChain(tc,RESET_CHAIN)
	end
--Debug.Message("还得调试下设备……好了！选择的区域是："..zone)
--Debug.Message("与怪兽区的交集是："..bit.band(zone,0x1f001f))
--Debug.Message("与魔陷区的交集是："..bit.band(zone,0x1f001f00))
--if tc then
--  local x=0
--  if loc==LOCATION_MZONE then x=0x10000 end
--  if loc==LOCATION_SZONE then x=0x1000000 end
--  if loc==LOCATION_FZONE then
--  Debug.Message("成功了，目标卡在场地区域！")
--  else
--  Debug.Message("成功了，在"..(2^tc:GetSequence())*x.."处抓到了卡！")
--  end
--end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(cm.disable)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(zone)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(cm.dis2op)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(zone)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(cm.disable)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabel(zone)
	Duel.RegisterEffect(e3,tp)

--  local e0=Effect.CreateEffect(e:GetHandler())
--  e0:SetDescription(aux.Stringid(m,4))
--  e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--  e0:SetCode(EVENT_FREE_CHAIN)
--  e0:SetOperation(cm.debug)
--  e0:SetLabel(zone)
--  e0:SetReset(RESET_PHASE+PHASE_END)
--  Duel.RegisterEffect(e0,1-tp)
end
function cm.debug(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()>>16
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,tp,zone)
end
function cm.disable(e,c)
	local zone=e:GetLabel()
	local loc=0
	if bit.band(zone,0x1f001f)~=0 then loc=LOCATION_MZONE end
	if bit.band(zone,0x1f001f00)~=0 then loc=LOCATION_SZONE end
	if bit.band(zone,0x20002000)~=0 then loc=LOCATION_FZONE end
	local x=0
	if loc==LOCATION_MZONE then x=0x10000 end
	if loc==LOCATION_SZONE then x=0x1000000 end
	return c:IsFaceup() and c:IsLocation(loc) and (bit.band(zone,(2^c:GetSequence())*x)~=0 or (loc==LOCATION_FZONE and c:IsLocation(LOCATION_FZONE)))
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	local loc=0
	if bit.band(zone,0x1f001f)~=0 then loc=LOCATION_MZONE end
	if bit.band(zone,0x1f001f00)~=0 then loc=LOCATION_SZONE end
	if bit.band(zone,0x20002000)~=0 then loc=LOCATION_FZONE end
	local x=0
	if loc==LOCATION_MZONE then x=0x10000 end
	if loc==LOCATION_SZONE then x=0x1000000 end
	local loca,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if loca&LOCATION_ONFIELD~=0 and p~=tp and re:IsActivated() and loca&loc~=0 and (bit.band(zone,(2^seq)*x)~=0 or loca==LOCATION_FZONE) then
		Duel.NegateEffect(ev)
	end
end
function cm.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.CheckLPCost(tp,500) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,500)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(15000625)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local zone=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	e:SetLabel(zone)
--Debug.Message("目标就位了吗？好，无人机激活！")
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetLabel()
	local seq=math.log(zone>>16,2)
	local loc=0
	if bit.band(zone,0x1f001f)~=0 then loc=LOCATION_MZONE end
	if bit.band(zone,0x1f001f00)~=0 then loc=LOCATION_SZONE end
	if bit.band(zone,0x20002000)~=0 then loc=LOCATION_FZONE end
	local ag=Group.CreateGroup()
	if loc~=LOCATION_FZONE then
		ag=Duel.GetMatchingGroup(cm.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	else
		ag=Duel.GetMatchingGroup(nil,tp,0,LOCATION_FZONE,nil)
	end
	local tc=ag:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_CHAIN)
		tc=ag:GetNext()
	end
Debug.Message("设备运行良好！选择的区域是："..zone)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(cm.dis2able)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(zone)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(cm.dis3op)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(zone)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(cm.dis2able)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabel(zone)
	Duel.RegisterEffect(e3,tp)
end
function cm.dis2able(e,c)
	local zone=e:GetLabel()
	local seq=math.log(zone>>16,2)
	local aloc=0
	if bit.band(zone,0x1f001f)~=0 then aloc=LOCATION_MZONE end
	if bit.band(zone,0x1f001f00)~=0 then aloc=LOCATION_SZONE end
	if bit.band(zone,0x20002000)~=0 then aloc=LOCATION_FZONE end
	if aloc==LOCATION_FZONE then
		return c:IsLocation(LOCATION_FZONE) and c:GetControler()~=e:GetHandlerPlayer()
	else
		local loc=LOCATION_MZONE
		if seq>8 then
			loc=LOCATION_SZONE
			seq=seq-8
		end
		if seq>=5 and seq<=7 then return false end
		local cseq=c:GetSequence()
		local cloc=c:GetLocation()
		if cloc==LOCATION_SZONE and cseq>=5 then return false end
		if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
		return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
	end
end
function cm.dis3op(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	local seq=math.log(zone>>16,2)
	local aloc=0
	if bit.band(zone,0x1f001f)~=0 then aloc=LOCATION_MZONE end
	if bit.band(zone,0x1f001f00)~=0 then aloc=LOCATION_SZONE end
	if bit.band(zone,0x20002000)~=0 then aloc=LOCATION_FZONE end
	if aloc==LOCATION_FZONE then
		local cloc,cseq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
		if cloc&LOCATION_FZONE~=0 and p~=tp and re:IsActivated() then
			Duel.NegateEffect(ev)
		end
	else
		local loc=LOCATION_MZONE
		if seq>8 then
			loc=LOCATION_SZONE
			seq=seq-8
		end
		if seq>=5 and seq<=7 then return end
		local cloc,cseq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
		if cloc==LOCATION_SZONE and cseq>=5 then return end
		if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE and (seq==1 and cseq==5 or seq==3 and cseq==6) then
			if cseq==seq or cloc==loc and math.abs(cseq-seq)==1 and p~=tp and re:IsActivated() and cloc&LOCATION_ONFIELD~=0 then
				Duel.NegateEffect(ev)
			end
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLP(tp)<=2000
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetCustomActivityCount(15000625,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xf36)
end
function cm.ov2filter(c,sc)
	return c:IsFaceup() and c:IsCanOverlay(sc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingTarget(cm.ov2filter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.ov2filter,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc))
	end
end