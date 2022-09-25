--银刺龙女皇 维纳斯·露姬雅
local m=40010497
local cm=_G["c"..m]
cm.named_with_SilverThorn=1
function cm.SilverThorn(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SilverThorn
end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)  
	--Revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.mttg)
	e2:SetOperation(cm.mtop)
	c:RegisterEffect(e2)
end
function cm.ovfilter(c)
	return c:IsFaceup() and cm.SilverThorn(c) and c:IsType(TYPE_XYZ) and c:IsRank(6)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and cm.SilverThorn(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if ct<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function cm.mtfilter(c,e)
	return c:IsFaceup() and cm.SilverThorn(c) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetFlagEffect(m)>0
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_MZONE,0,1,6,e:GetHandler(),e)
	local tc=g:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		tc=g:GetNext()
	end
	if  g:GetCount()>3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(cm.turncon)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.turncon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end