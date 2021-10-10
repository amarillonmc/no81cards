--AK-炎狱的炎熔
function c82568061.initial_effect(c)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,82568161)
	e1:SetTarget(c82568061.target1)
	e1:SetOperation(c82568061.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82568061)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82568061.spcon)
	e4:SetTarget(c82568061.target)
	e4:SetOperation(c82568061.activate)
	c:RegisterEffect(e4)
end
function c82568061.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,ct*300)
end
function c82568061.atkfilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()  
end
function c82568061.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	  Duel.Damage(p,ct*300,REASON_EFFECT)
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.IsExistingMatchingCard(c82568061.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(82568061,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c82568061.atkfilter,tp,LOCATION_MZONE,0,0,1,e:GetHandler())
	if g:GetCount()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
	end
end
function c82568061.cfilter2(c,e,tp)
	return not c:IsType(TYPE_TUNER)  and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c82568061.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel()+e:GetHandler():GetLevel(),Group.FromCards(c,e:GetHandler()))
end
function c82568061.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x825) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c82568061.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c82568061.thfilter(c)
	return c:IsAbleToHand()
		   and c:IsCode(82567785)
end
function c82568061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568061.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82568061.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c82568061.cfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(e:GetHandler():GetLevel()+g2:GetFirst():GetLevel())
	g2:AddCard(e:GetHandler())
	g2:KeepAlive()
	Duel.Release(g2,nil,0,REASON_COST)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568061.spfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	   tc:SetMaterial(g2)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	 tc:CompleteProcedure() 
	if Duel.IsExistingMatchingCard(c82568061.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82568010,2)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82568061.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	 end 
end
end