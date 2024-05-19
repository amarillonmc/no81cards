--牛头人萨满
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,5053103)
	aux.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.check)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e1)
	e2:SetCondition(s.ccon)
	e2:SetTarget(s.ctg)
	e2:SetOperation(s.cop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsCode(5053103)
end
function s.check(e,c)
	if c:GetMaterial():IsExists(Card.IsCode,1,nil,5053103) then e:SetLabel(1) else e:SetLabel(0) end
end
function s.ccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabelObject():GetLabel()==1
end
function s.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function s.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.GetControl(tc,tp)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER)
end
function s.spsumfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.spsumfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.gcheck(g,e,tp)
	if #g~=2 then return false end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	return s.spsumfilter1(ac,e,tp) and s.spsumfilter2(bc,e,tp)
		or s.spsumfilter1(bc,e,tp) and s.spsumfilter2(ac,e,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_GRAVE,nil,e,tp)
	if chk==0 then
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft1>0 and ft2>0
			and g:CheckSubGroup(s.gcheck,2,2,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function s.ccfilter(c,tp)
	return c:GetOwner()==tp
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft1<=0 or ft2<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	if not g:CheckSubGroup(s.gcheck,2,2,e,tp) then return end
	local sg=nil
	if e:GetHandler():GetMaterial():IsExists(s.ccfilter,1,nil,1-tp) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		sg=g:FilterSelect(tp,s.spsumfilter2,1,1,nil,e,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		sg=g:FilterSelect(1-tp,s.spsumfilter2,1,1,nil,e,tp)
	end
	Duel.SpecialSummonStep(sg:GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep((g-sg):GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end