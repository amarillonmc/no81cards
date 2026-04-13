--魔恋的天晶
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11771900,11771925,11771920)
	--手卡发动    
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,3))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--选择效果发动    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--代破    
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)    
end
function s.hcfilter(c)
	return c:IsFaceup() and c:IsCode(11771925)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.xyzfilter(c,e,tp,mc)
	return c:IsCode(11771925) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.mfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(11771920) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) 
    	and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end    
function s.spfilter(c,e,tp)
	return aux.IsCodeOrListed(c,11771900) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
    local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
    	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return (b1 or b2) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
    local loc=0
    if op==1 then
    	loc=LOCATION_EXTRA
    elseif op==2 then
    	loc=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED
    end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xc=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
		if not xc or xc:IsFacedown() or xc:IsControler(1-tp) or xc:IsImmuneToEffect(e) or not aux.MustMaterialCheck(xc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
        Duel.HintSelection(Group.FromCards(xc))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,xc):GetFirst()		
		if tc then
			local mg=xc:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(xc))
			Duel.Overlay(tc,Group.FromCards(xc))
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
                tc:CompleteProcedure()                
            end    
        end
    elseif op==2 then
    	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
        	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end    
    end
end    
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsCode(11771900,11771925) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end