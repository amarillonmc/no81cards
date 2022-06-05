--时烈龙 异界巅峰
function c25000025.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c25000025.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5614808,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,25000025)
	e1:SetTarget(c25000025.eqtg)
	e1:SetOperation(c25000025.eqop)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000025)
	e2:SetTarget(c25000025.sptg)
	e2:SetOperation(c25000025.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c25000025.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) and c:IsLevelBelow(4)
end
function c25000025.eqfilter(c)
	return c:IsType(TYPE_UNION) and not c:IsForbidden()
end
function c25000025.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c25000025.eqfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c25000025.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c25000025.eqfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c25000025.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c25000025.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c25000025.sckfil(c)
	return not c:IsType(TYPE_TUNER) 
end
function c25000025.spfil(c,e,tp)
	return c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c25000025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local x=mg:Filter(c25000025.sckfil,nil):GetCount()
	if chk==0 then return x>0 and Duel.IsExistingMatchingCard(c25000025.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c25000025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c25000025.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local x=mg:Filter(c25000025.sckfil,nil):GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<x then x=ft end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then x=1 end
	if ft>0 and g:GetCount()>0 then 
	local sg=g:Select(tp,1,x,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end


