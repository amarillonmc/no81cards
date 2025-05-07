--魔导礼 鸾刀
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	--ns limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	e0:SetCondition(s.excon)
	--c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_SUMMON_COST)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetOperation(s.nsoath)
	c:RegisterEffect(e00)   
	
	--summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spscon)
	e1:SetTarget(s.spstg)
	e1:SetOperation(s.spsop)
	c:RegisterEffect(e1)
	
	--Typhoon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10000)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.coscon)
	e2:SetTarget(s.costg)
	e2:SetOperation(s.cosop)
	c:RegisterEffect(e2)
end

function s.coscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function s.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.graveflt(c)
	return c:IsSetCard(0xcd70) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end

function s.handflt(c)
	return c:IsCode(5318639) and c:IsAbleToHand()
end

function s.costg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.tgfilter(chkc) end
	if chk==0 then
	local b1 = Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2 = Duel.IsExistingMatchingCard(s.graveflt,tp,LOCATION_DECK,0,1,nil)
	local b3 = Duel.IsExistingMatchingCard(s.handflt,tp,LOCATION_DECK,0,1,nil)
	--Debug.Message("luandao:"..tostring(b1)..tostring(b2)..tostring(b3))
	return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (Duel.IsExistingMatchingCard(s.graveflt,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(s.handflt,tp,LOCATION_DECK,0,1,nil) )
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.cosop(e,tp,eg,ep,ev,re,r,rp)

	local gg = Duel.GetMatchingGroup(s.graveflt,tp,LOCATION_DECK,0,nil)
	local gflg = (#gg>0)
	local hg = Duel.GetMatchingGroup(s.handflt,tp,LOCATION_DECK,0,nil)
	local hflg = (#hg>0)
	local op=aux.SelectFromOptions(tp,{gflg,aux.Stringid(id,2)},{hflg,aux.Stringid(id,3)})
	if op==1 then
		local g = Duel.SelectMatchingCard(tp,s.graveflt,tp,LOCATION_DECK,0,1,1,nil) 
		if Duel.SendtoGrave(g,REASON_EFFECT) <= 0 then
			return
		end
	elseif op==2 then
		local g = Duel.SelectMatchingCard(tp,s.handflt,tp,LOCATION_DECK,0,1,1,nil)  
		if Duel.SendtoHand(g,nil,REASON_EFFECT) <= 0 then
			return
		else
			Duel.ConfirmCards(1-tp,g)
		end 
	else
		return
	end
	
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.spscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function s.filter(c,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function s.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,c,tp)
	--Debug.Message(c:IsSummonable(true,nil))
	--Debug.Message(#g)
	if chk==0 then return #g>0 and c:IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end

function s.spsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	else
		return
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Summon(tp,c,true,nil)
end


function s.nscost(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,79323590)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
end


function s.counterfilter(c)
	return c:IsType(TYPE_FUSION)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_FUSION)
end

function s.excon(e)
	local c = e:GetHandler()
	--Debug.Message(Duel.GetCustomActivityCount(id,c:GetControler(),ACTIVITY_SPSUMMON))
	return Duel.GetCustomActivityCount(id,c:GetControler(),ACTIVITY_SPSUMMON)~=0
end

function s.nsoath(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end