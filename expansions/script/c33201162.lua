--寂海的祝巫 露米娅
local s,id,o=GetID()
Duel.LoadScript("c33201150.lua")
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetLabelObject(e1)
	e2:SetLabel(id)
	e2:SetCondition(Mermaid_VHisc.effcon)
	e2:SetOperation(Mermaid_VHisc.effop)
	c:RegisterEffect(e2)
end
s.VHisc_Mermaid=true

--e1
function s.smfilter(c,e,tp)
	return c.VHisc_Mermaid and c:IsType(TYPE_CONTINUOUS+TYPE_SPELL) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.smfilter(chkc,e,tp) end
	if chk==0 then return Mermaid_VHisc.fgck(e:GetHandler(),id) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and  Duel.IsExistingTarget(s.smfilter,tp,LOCATION_SZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.smfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler(),e,tp)
	Mermaid_VHisc.flagc(e:GetHandler(),id)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_SZONE)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsRelateToEffect(e) then 
		Mermaid_VHisc.sp(e:GetHandler(),tp)
		if e:GetHandler():IsLocation(LOCATION_SZONE) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,tc) and tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,tc):GetFirst()
			local g=Group.FromCards(rc,tc)
			if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local c=e:GetHandler()
				local fid=c:GetFieldID()
				local rct=1
				if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
				local og=Duel.GetOperatedGroup()
				local oc=og:GetFirst()
				while oc do
					oc:RegisterFlagEffect(id+20000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,rct,fid)
					oc=og:GetNext()
				end
				og:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(s.retcon)
				e1:SetOperation(s.retop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id+20000)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end

