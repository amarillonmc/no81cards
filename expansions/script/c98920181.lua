--防火灾难龙
function c98920181.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),2,true)
		--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920181,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920181)
	e1:SetCondition(c98920181.descon)
	e1:SetTarget(c98920181.destg)
	e1:SetOperation(c98920181.desop)
	c:RegisterEffect(e1)   
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920181,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98930181)
	e1:SetCondition(c98920181.spcon)
	e1:SetTarget(c98920181.sptg)
	e1:SetOperation(c98920181.spop)
	c:RegisterEffect(e1)
end
function c98920181.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c98920181.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0):Filter(Card.IsPosition,nil,POS_ATTACK):GetCount()>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(98920181,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(98920181,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(98920181,0),aux.Stringid(98920181,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920181.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c98920181.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c98920181.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsLink(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920181.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920181.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920181.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920181.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920181.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end