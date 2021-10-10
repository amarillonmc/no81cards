--方舟骑士·无题密令 送葬人
function c82568009.initial_effect(c)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568009,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,82568109)
	e1:SetCondition(c82568009.descon)
	e1:SetTarget(c82568009.sstarget)
	e1:SetOperation(c82568009.ssoperation)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568009,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82568009)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82568009.spcon)
	e4:SetTarget(c82568009.target)
	e4:SetOperation(c82568009.activate)
	c:RegisterEffect(e4)
end
function c82568009.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) 
end
function c82568009.tgfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end 
function c82568009.desfilter(c,atk,e)
	return c:IsFaceup() and c:IsAttackBelow(atk) 
end
function c82568009.sstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568009.desfilter,tp,0,LOCATION_MZONE,1,nil,atk,e) end
	local g=Duel.GetMatchingGroup(c82568009.desfilter,tp,0,LOCATION_MZONE,nil,atk,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82568009.ssoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82568009.desfilter,tp,0,LOCATION_MZONE,nil,atk,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c82568009.cfilter2(c,e,tp)
	return not c:IsType(TYPE_TUNER)  and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c82568009.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel()+e:GetHandler():GetLevel(),Group.FromCards(c,e:GetHandler()))
end
function c82568009.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x825) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c82568009.thfilter(c)
	return c:IsAbleToHand()
		   and c:IsCode(82567785)
	end
function c82568009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end

function c82568009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568009.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
	 Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

function c82568009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c82568009.cfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(e:GetHandler():GetLevel()+g2:GetFirst():GetLevel())
	g2:AddCard(e:GetHandler())
	g2:KeepAlive()
	Duel.Release(g2,nil,0,REASON_COST)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568009.spfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		tc:SetMaterial(g2)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		 tc:CompleteProcedure()
end
end