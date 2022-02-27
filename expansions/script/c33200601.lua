--圣殿剑骑 拜亚尔将军
function c33200601.initial_effect(c)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200601,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33200601)
	e1:SetCondition(c33200601.srcon)
	e1:SetTarget(c33200601.srtg)
	e1:SetOperation(c33200601.srop)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200601,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c33200601.rstg)
	e2:SetOperation(c33200601.rsop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33200601.rmcon)
	e3:SetTarget(c33200601.rmtarget)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end

--e3
function c33200601.rmcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c33200601.rmtarget(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end

--e1
function c33200601.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c33200601.srfilter(c,tp)
	return c:IsSetCard(0x5329) and c:IsAbleToHand() 
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c33200601.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200601.srfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200601.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200601.srfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e2
function c33200601.rfilter(c,e,tp)
	return c:IsSetCard(0x5329)
end
function c33200601.rcheck(gc)
	return  function(tp,g,c)
				return g:IsContains(gc)
			end
end
function c33200601.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=c33200601.rcheck(c)
		local res=mg:IsContains(c) and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c33200601.rfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33200601.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or not mg:IsContains(c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c33200601.rcheck(c)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c33200601.rfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
		mg:RemoveCard(tc)
		end
		if not mg:IsContains(c) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		Duel.SetSelectedCard(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
end
