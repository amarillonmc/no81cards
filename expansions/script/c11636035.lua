--渊洋海兽 画皮寄生潜水员
local m = 11636035
local cm = _G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--to hand or summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)		
	--synchro material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)   
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(cm.reptg)
	--e3:SetValue(cm.repval)
	c:RegisterEffect(e3)
	--debuff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DRAW)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.decon)
	e4:SetOperation(cm.deop)
	c:RegisterEffect(e4)	
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.tgcon)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
end
--
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end

function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9223) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) ) and (c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)

end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.syncsumfilter(c)
	return c:IsType(TYPE_SYNCHRO) and  c:IsSetCard(0x223)  and c:IsSynchroSummonable(nil) --
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,1,c,e,tp)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()   
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll()
	if Duel.IsExistingMatchingCard(cm.syncsumfilter,tp,LOCATION_EXTRA,0,1,nil,c,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.syncsumfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil) 
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
--
function cm.repfilter(c)
	return  c:GetLeaveFieldDest()==0 and bit.band(c:GetReason(),REASON_MATERIAL+REASON_SYNCHRO)==REASON_MATERIAL+REASON_SYNCHRO  and  c:GetReasonCard():IsSetCard(0x223)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm.repfilter(c)
	end
	if cm.repfilter(c) then
		Duel.SendtoExtraP(c,1-c:GetControler(),REASON_EFFECT+REASON_REDIRECT)
		return true
	end
	return false
end
--
function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()~=tp and ep==tp
end

function cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.Draw(1-tp,1,REASON_EFFECT) then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+11636070,e,0,0,0,0)
	end
end

function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,11636065)  then --and e:CheckCountLimit(tp)
		cm.oprep(e,tp,eg,ep,ev,re,r,rp)
		--e:UseCountLimit(tp)
	end
end
--
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and p~=e:GetHandler():GetControler()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end