--亡语 法老ー
function c99988033.initial_effect(c)
    --Change race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99988033,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c99988033.spcon)
	e2:SetTarget(c99988033.sptg)
	e2:SetOperation(c99988033.spop)
	c:RegisterEffect(e2)	
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c99988033.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c99988033.valcheckfil(c,e)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c99988033.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c99988033.valcheckfil,1,nil,e) then	    
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
   end
 end 
function c99988033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabel()==1
end
function c99988033.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x20df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99988033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99988033.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99988033.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99988033.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(g:GetClassCount(Card.GetLevel),ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=aux.dlvcheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,ct,ct)
	aux.GCheckAdditional=nil
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end