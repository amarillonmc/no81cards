--爆苍联合 麋鹿
local s, id = GetID()
s.named_with_RoaringAzure=1
function s.RoaringAzure(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_RoaringAzure
end

function s.initial_effect(c)

	aux.AddSynchroProcedure(c,s.sfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)	
end
function s.sfilter(c)
	return s.RoaringAzure(c)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end

	local ct=Duel.GetMatchingGroupCount(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil,POS_DEFENSE)
	e:SetLabel(ct)

	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1+ct,1-tp,LOCATION_MZONE)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)

	local ct=e:GetLabel() + 1
	
	for i=1,ct do

		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()==0 then break end
		

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Destroy(sg,REASON_EFFECT)

		end
	end
end

function s.spfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE) 
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)

	if Duel.GetCurrentPhase()==PHASE_DRAW then return false end

	return eg:IsExists(s.spfilter,1,nil,tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		local ct=hg:GetCount()
		if ct>=6 then
			Duel.BreakEffect()
			local discard_num = ct - 3
			Duel.DiscardHand(1-tp,nil,discard_num,discard_num,REASON_EFFECT+REASON_DISCARD)
		end
	end
end