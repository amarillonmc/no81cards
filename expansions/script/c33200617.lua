--圣殿剑骑 贞德
function c33200617.initial_effect(c)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200617,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33200617)
	e1:SetCondition(c33200617.srcon)
	e1:SetTarget(c33200617.srtg)
	e1:SetOperation(c33200617.srop)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c33200617.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--ritual summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200617,1))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetTarget(c33200617.rstg)
	e4:SetOperation(c33200617.rsop)
	c:RegisterEffect(e4)
end

--e2e3
function c33200617.atkfilter(c)
	return c:IsSetCard(0x329)
end
function c33200617.val(e,c)
	return Duel.GetMatchingGroupCount(c33200617.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*300
end

--e1
function c33200617.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c33200617.srfilter(c,tp)
	return c:IsSetCard(0x5329) and c:IsAbleToHand() 
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c33200617.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200617.srfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200617.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200617.srfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e4
function c33200617.rfilter(c,e,tp)
	return c:IsSetCard(0x5329)
end
function c33200617.rcheck(gc)
	return  function(tp,g,c)
				return g:IsContains(gc)
			end
end
function c33200617.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=c33200617.rcheck(c)
		local res=mg:IsContains(c) and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c33200617.rfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33200617.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or not mg:IsContains(c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c33200617.rcheck(c)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c33200617.rfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
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
