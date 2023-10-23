local m=53796144
local cm=_G["c"..m]
cm.name="电子光虫-继电蜻蜓"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(cm.xyzlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(m)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.efcon)
	e2:SetOperation(cm.efop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(cm.adjustop)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_CHANGE_POS)
		ge5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return not Pos_Changed_by_Effect end)
		ge5:SetOperation(cm.tgop)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge5:Clone()
		Duel.RegisterEffect(ge6,1)
		Relaytonbo_IsStatus=Card.IsStatus
		Card.IsStatus=function(tc,int)
			if int&(STATUS_SUMMON_TURN|STATUS_SPSUMMON_TURN|STATUS_FORM_CHANGED)~=0 and tc:GetFlagEffect(m)>0 then return true else return Relaytonbo_IsStatus(tc,int) end
		end
		Relaytonbo_ChangePosition=Duel.ChangePosition
		Duel.ChangePosition=function(...)
			Pos_Changed_by_Effect=true
			local op=Relaytonbo_ChangePosition(...)
			Pos_Changed_by_Effect=false
			return op
		end
	end
end
function cm.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
function cm.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_INSECT)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c)return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)end,nil)
	for tc in aux.Next(g) do tc:RegisterFlagEffect(m,RESET_EVENT+0xec0000+RESET_PHASE+PHASE_END,0,1,e:GetCode()) end
end
function cm.cfilter(c)
	return c:IsHasEffect(m) and c:IsAbleToGraveAsCost()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0x3,0,nil)
	local fg=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(m)>0 end,tp,0x4,0,nil)
	if #g>0 then
		for tc in aux.Next(fg:Filter(function(c)return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)end,nil)) do
			if tc:GetFlagEffectLabel(m)==1100 then tc:SetStatus(STATUS_SUMMON_TURN,false) else tc:SetStatus(STATUS_SPSUMMON_TURN,false) end
			if tc:IsStatus(STATUS_FORM_CHANGED) then tc:SetStatus(STATUS_FORM_CHANGED,false) end
		end
	else
		for tc in aux.Next(fg) do
			if tc:GetFlagEffectLabel(m)==1100 then tc:SetStatus(STATUS_SUMMON_TURN,true) else tc:SetStatus(STATUS_SPSUMMON_TURN,true) end
			if tc:IsStatus(STATUS_FORM_CHANGED) then tc:SetStatus(STATUS_FORM_CHANGED,true) end
		end
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if #eg~=1 or not tc:IsControler(tp) or tc:GetFlagEffect(m)==0 or not Duel.IsExistingMatchingCard(cm.cfilter,tp,0x3,0,1,nil) then return end
	--tc:SetStatus(STATUS_FORM_CHANGED,false)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0x3,0,1,1,nil):GetFirst()
	if Duel.SendtoGrave(sc,REASON_COST)==0 or not sc:IsLocation(LOCATION_GRAVE) then return end
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
	local lv=tc:GetLevel()
	if lv==0 then lv=tc:GetRank() end
	local e2=Effect.CreateEffect(sc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(lv)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	--sc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(sc)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e3,true)
	Duel.AdjustAll()
end
function cm.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function cm.matfilter(c,e,tp)
	return (Duel.GetTurnCount()~=c:GetTurnID() or c:IsReason(REASON_RETURN)) and c:IsType(TYPE_MONSTER)
end
function cm.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,1,ct) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.fgoal(sg,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,sg,#sg,#sg)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>0 and mg:CheckSubGroup(cm.fgoal,1,ct,exg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ct<1 then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.matfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=mg:SelectSubGroup(tp,cm.fgoal,false,1,ct,exg)
	if not sg or #sg==0 then return end
	local sct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll()
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sct then return end
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg,sct)
	if sct>0 and xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg)
	end
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:RegisterFlagEffect(m+500,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
	e1:SetLabelObject(rc)
	e1:SetTarget(function(e,c)return e:GetLabelObject():GetOverlayGroup():IsContains(c)end)
	e1:SetValue(LOCATION_DECKSHF)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.regop)
	Duel.RegisterEffect(e2,tp)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetOwner():IsLocation(LOCATION_MZONE) or e:GetOwner():GetFlagEffect(m+500)==0 then return end
	e:GetLabelObject():Reset()
	e:Reset()
end
