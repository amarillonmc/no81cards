--方舟騎士·码语寻理者 白面鸮
function c82567838.initial_effect(c)
	c:EnableReviveLimit()
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,82567838)
	e2:SetCondition(c82567838.discon)
	e2:SetCost(c82567838.discost)
	e2:SetTarget(c82567838.distg)
	e2:SetOperation(c82567838.disop)
	c:RegisterEffect(e2)
	--Summon 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567838,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,82567938)
	e3:SetOperation(c82567838.ctop)
	c:RegisterEffect(e3)
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567838,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82567940)
	e1:SetTarget(c82567838.target)
	e1:SetOperation(c82567838.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567838,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82567940)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82567838.spcon)
	e4:SetTarget(c82567838.target)
	e4:SetOperation(c82567838.activate)
	c:RegisterEffect(e4)
end
function c82567838.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c82567838.rcop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Recover(tp,1000,REASON_EFFECT)
end
function c82567838.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)  and Duel.IsChainDisablable(ev)
end
function c82567838.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) and e:GetHandler():IsDiscardable(REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c82567838.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c82567838.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c82567838.filter(c)
	return c:IsFaceup() 
end
function c82567838.ntfilter(c)
	return c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_TUNER)
end
function c82567838.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82567786.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	  while tc do   
	  tc:AddCounter(0x5825,1)
	 tc=g:GetNext()
   end
end

function c82567838.cfilter2(c,e,tp)
	return not c:IsType(TYPE_TUNER)  and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c82567838.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel()+e:GetHandler():GetLevel(),Group.FromCards(c,e:GetHandler()))
end
function c82567838.spfilter(c,e,tp,lv,mg)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x825) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c82567838.thfilter(c)
	return c:IsAbleToHand()
		   and c:IsCode(82567785)
	end
function c82567838.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end

function c82567838.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567838.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
end

function c82567838.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c82567838.cfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(e:GetHandler():GetLevel()+g2:GetFirst():GetLevel())
	g2:AddCard(e:GetHandler())
	g2:KeepAlive()
	Duel.Release(g2,nil,0,REASON_COST)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567838.spfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	tc:SetMaterial(g2)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		 tc:CompleteProcedure() 
	if Duel.IsExistingMatchingCard(c82567838.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82567838,2)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567838.thfilter,tp,LOCATION_GRAVE,0,0,1,nil)
	if g:GetCount()>0 then
		 Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	 end 
	end
end