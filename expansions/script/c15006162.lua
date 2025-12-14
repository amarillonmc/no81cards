local m=15006162
local cm=_G["c"..m]
cm.name="无海重组协议"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	e5:SetOperation(cm.repop)
	c:RegisterEffect(e5)
end
function cm.texfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsAbleToExtra()
end
function cm.ovfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6f44) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOwner()==tp and c:IsLocation(LOCATION_GRAVE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.texfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
end
function cm.xyzfilter(c,sc)
	return c:IsSetCard(0x6f44) and c:IsXyzSummonable(nil) and not c:IsCode(sc:GetCode())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tec=Duel.SelectMatchingCard(tp,cm.texfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local ovg=Group.CreateGroup()
	if tec and tec:GetOverlayCount()>0 then ovg=tec:GetOverlayGroup() end
	if tec and Duel.SendtoDeck(tec,nil,SEQ_DECKTOP,REASON_EFFECT)>0 and tec:IsLocation(LOCATION_EXTRA) and ovg:IsExists(cm.ovfilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tg=ovg:Filter(aux.NecroValleyFilter(cm.ovfilter),nil,e,tp)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=nil
		if tg:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=tg:Select(tp,ft,ft,nil)
		else
			g=tg
		end
		if g:GetCount()>0 then
			Duel.BreakEffect()
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
				local g2=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,tec)
				if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=g2:Select(tp,1,1,nil):GetFirst()
					if sc then
						Duel.BreakEffect()
						Duel.XyzSummon(tp,sc,nil)
					end
				end
			end
		end
	end
end

function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end