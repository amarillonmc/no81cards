--持续扩散的诡异
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--无效
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--融合召唤    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.txcon)
	e3:SetTarget(s.txtg)
	e3:SetOperation(s.txop)
	c:RegisterEffect(e3)
end
s.has_text_type=TYPE_DUAL
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x6c77) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    	and ((c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
        or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end        
end
function s.confilter(c)
	return (c:IsType(TYPE_DUAL) or c:IsSetCard(0x6c77)) and c:IsFaceup()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(id)==0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,4)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,6))		
	end
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x6c77) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_FUSION)
end
function s.txcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetTurnPlayer()==1-tp 
end
function s.txfilter(c)
	return c:IsSetCard(0x6c77) and c:IsType(TYPE_FUSION) and c:IsAbleToExtra() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.txtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.txfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.fspfilter(c,e,tp,lv,atr)
	return c:IsSetCard(0x6c77) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
    	and c:CheckFusionMaterial() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLevel(lv) and not c:IsAttribute(atr)
end
function s.txop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.txfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc then return end
    Duel.HintSelection(Group.FromCards(tc))
    if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA)
    	and Duel.IsExistingMatchingCard(s.fspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel(),tc:GetAttribute())
        and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.fspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel(),tc:GetAttribute()):GetFirst()
		if not sc then return end
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
			sc:CompleteProcedure()
		end
	end
end