--真红眼源初龙
function c50203210.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c50203210.lcheck,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,50203210)
	e1:SetCondition(c50203210.spcon)
	e1:SetTarget(c50203210.sptg)
	e1:SetOperation(c50203210.spop)
	c:RegisterEffect(e1)
	--can not be attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c50203210.atcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--synchro summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,50203211)
	e3:SetCondition(c50203210.sccon)
	e3:SetTarget(c50203210.sctg)
	e3:SetOperation(c50203210.scop)
	c:RegisterEffect(e3)
end
function c50203210.lcheck(c)
	return c:IsLinkRace(RACE_DRAGON) and c:IsLinkAttribute(ATTRIBUTE_DARK) and not c:IsCode(50203210)
end
function c50203210.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50203210.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsFaceup() and c:IsLevel(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50203210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(c50203210.spfilter,nil,e,tp)
	if chk==0 then return mg:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg:GetFirst(),1,tp,LOCATION_GRAVE)
end
function c50203210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(c50203210.spfilter,nil,e,tp)
	if mg:GetCount()>0 then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50203210.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b)
end
function c50203210.atcon(e)
	return Duel.IsExistingMatchingCard(c50203210.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c50203210.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c50203210.mfilter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER)
end
function c50203210.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c50203210.scfilter(c,mg)
	return mg:IsExists(c50203210.cfilter,1,nil,c)
end
function c50203210.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c50203210.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c50203210.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50203210.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c50203210.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c50203210.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c50203210.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end