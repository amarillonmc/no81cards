--遗弃之地
function c67201507.initial_effect(c)
	aux.AddCodeList(c,67201503)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c67201507.target)
	e1:SetOperation(c67201507.activate)
	c:RegisterEffect(e1) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201507,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,67201507)
	e2:SetCondition(c67201507.atkcon2)
	e2:SetTarget(c67201507.atktg)
	e2:SetOperation(c67201507.atkop)
	c:RegisterEffect(e2)   
end

function c67201507.matfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0
end
function c67201507.mfilter(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsReleasableByEffect(e)
end
function c67201507.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM)
end
function c67201507.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c67201507.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
--
function c67201507.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c67201507.matfilter,nil)
		local mg2=Duel.GetMatchingGroup(c67201507.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
		aux.RCheckAdditional=c67201507.rcheck
		aux.RGCheckAdditional=c67201507.rgcheck
		local res=Duel.IsExistingMatchingCard(c67201507.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c67201507.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c67201507.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c67201507.matfilter,nil)
	local mg2=Duel.GetMatchingGroup(c67201507.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c67201507.rcheck
	aux.RGCheckAdditional=c67201507.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c67201507.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,#mg,tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		e:SetLabelObject(tc)
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
--
function c67201507.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and aux.IsCodeListed(c,67201503) and rp==tp
end
function c67201507.srfilter(c)
	return aux.IsCodeListed(c,67201503) and not c:IsCode(67201507) and c:IsAbleToHand()
end
function c67201507.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67201507.srfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
end
function c67201507.atkop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c67201507.srfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201507,1),aux.Stringid(67201507,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201507,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201507,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67201507.srfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
