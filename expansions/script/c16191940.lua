--往生的贤者 八云紫
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤	
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x67b0),aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),true)
	c:EnableReviveLimit()
	--伤害并回复
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(s.flagop)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.efregop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--融合召唤    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.fsptg)
	e3:SetOperation(s.fspop)
	c:RegisterEffect(e3)
	--伤害减免
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,id+o)
	e4:SetOperation(s.efop)
	c:RegisterEffect(e4)    
end
function s.flagop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
end
function s.efregop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and e:GetHandler():GetFlagEffect(id)>0 then
		e:GetHandler():RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(id+o)>0 and Duel.GetLP(1-tp)>0 and c:GetFlagEffect(id)>0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)    
	Duel.Damage(1-tp,400,REASON_EFFECT)
    Duel.Recover(tp,400,REASON_EFFECT)
end
function s.fspfilter(c,mg)
	return c:IsType(TYPE_FUSION) and c:IsFusionSummonableCard() and c:CheckFusionMaterial(mg)
end
function s.dkmtfilter(c,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsReleasableByEffect() and c:IsCanBeFusionMaterial() and c:IsSetCard(0x67b0) and c:IsType(TYPE_MONSTER)
    	and Duel.IsExistingMatchingCard(s.fspfilter,tp,LOCATION_EXTRA,0,1,nil,mg) 
end
function s.mtfilter(c,tp)
	return c:IsReleasableByEffect() and c:IsCanBeFusionMaterial()
    	and Duel.IsExistingMatchingCard(s.dkmtfilter,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function s.fsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.mtfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.mtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectTarget(tp,s.mtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	local rg=Duel.GetMatchingGroup(s.dkmtfilter,tp,LOCATION_DECK,0,nil,tp,g:GetFirst())
    rg:Merge(g)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end	
function s.fselect(g,sc,mc)
	return sc:CheckFusionMaterial(g) and g:IsContains(mc)
end    
function s.fspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or not tc:IsReleasableByEffect() 
    	or not tc:IsCanBeFusionMaterial() then return end
    local mg=Duel.GetMatchingGroup(s.dkmtfilter,tp,LOCATION_DECK,0,nil,tp,tc)
    if mg:GetCount()<=0 then return end
    mg:AddCard(tc)
    local sg=Duel.GetMatchingGroup(s.fspfilter,tp,LOCATION_EXTRA,0,nil,mg)
    if sg:GetCount()<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
    Duel.ConfirmCards(1-tp,sc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
    local fg=mg:SelectSubGroup(tp,s.fselect,false,2,2,sc,tc)
    if fg and fg:GetCount()>0 then
    	sc:SetMaterial(fg)
    	Duel.Release(fg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
    end   
    if sc then        	    
        sc:RegisterFlagEffect(id+o*2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
        e1:SetLabelObject(sc)
		e1:SetCondition(s.exspcon)
		e1:SetOperation(s.exspop)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e1,tp)        	
    end
end
function s.exspcon(e,tp,eg,ep,ev,re,r,rp)
	local fc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and fc and Duel.GetLocationCountFromEx(tp,tp,nil,fc)>0
    	and fc:GetFlagEffect(id+o*2)>0 and fc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
end
function s.exspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
    local fc=e:GetLabelObject()
    fc:ResetFlagEffect(id+o*2)
    if fc then
		Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
    	fc:CompleteProcedure()
    end 
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--特殊召唤    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,7))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.selfspcon)
	e1:SetOperation(s.selfspop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
	--伤害减免
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,6))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.damval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)   
end
function s.selfspfilter(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.selfspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.selfspfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function s.selfspop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.selfspfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.damval(e,re,val,r,rp,rc)
	if val>1800 then return 1800 end
	return val
end