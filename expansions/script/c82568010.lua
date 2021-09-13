--方舟骑士·潮汐暗流 幽灵鲨
function c82568010.initial_effect(c)
	c:EnableReviveLimit()
	--link success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,82568110)
	e1:SetCondition(c82568010.spcon1)
	e1:SetTarget(c82568010.sptg)
	e1:SetOperation(c82568010.spop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82568010)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82568010.spcon)
	e4:SetTarget(c82568010.target)
	e4:SetOperation(c82568010.activate)
	c:RegisterEffect(e4)
end
function c82568010.spfilter1(c,e,tp)
	return c:IsSetCard(0x825) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82568010.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and Duel.IsExistingMatchingCard(c82568010.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c82568010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and chkc:IsSetCard(0x825) and  chkc:IsLevelBelow(4) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c82568010.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c82568010.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	   if tc then local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	  end
	 end
end
function c82568010.cfilter2(c,e,tp)
	return not c:IsType(TYPE_TUNER)  and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c82568010.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel()+e:GetHandler():GetLevel(),Group.FromCards(c,e:GetHandler()))
end
function c82568010.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x825) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c82568010.thfilter(c)
	return c:IsAbleToHand()
		   and c:IsCode(82567785)
	end
function c82568010.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end

function c82568010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568010.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

function c82568010.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c82568010.cfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(e:GetHandler():GetLevel()+g2:GetFirst():GetLevel())
	g2:AddCard(e:GetHandler())
	g2:KeepAlive()
	Duel.Release(g2,nil,0,REASON_COST)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568010.spfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	   tc:SetMaterial(g2)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		 tc:CompleteProcedure() 
	if Duel.IsExistingMatchingCard(c82568010.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82568010,2)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568010.thfilter),tp,LOCATION_GRAVE,0,0,1,nil)
	if g:GetCount()>0 then
		 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	 end 
end
end
