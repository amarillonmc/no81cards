--深海歌者-斯卡蒂
function c29024390.initial_effect(c)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29024390,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,29024390)
	e3:SetTarget(c29024390.actg)
	e3:SetOperation(c29024390.acop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--special summon other monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55273560,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29024391)
	e2:SetCost(c29024390.spcost)
	e2:SetTarget(c29024390.sptg)
	e2:SetOperation(c29024390.spop)
	c:RegisterEffect(e2)
end
--e2
function c29024390.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c29024390.spfilter(c,e,tp)
	if not (c:IsSetCard(0x87af) and c:IsLevelAbove(5) and c:IsRace(RACE_FISH) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c29024390.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29024390.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c29024390.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29024390.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--e1
function c29024390.filter(c,tp)
	return (aux.IsCodeListed(c,22702055) or c:GetOriginalCode()==295517 or c:GetOriginalCode()==2819435 or c:GetOriginalCode()==26534688 or c:GetOriginalCode()==34103656) and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c29024390.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29024390.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c29024390.acop(e,tp,eg,ep,ev,re,r,rp)
	local to=tp
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c29024390.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		sel=Duel.SelectOption(tp,aux.Stringid(29024390,2),aux.Stringid(29024390,3))
		if sel==1 then to=1-tp end
		local fc=Duel.GetFieldCard(to,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,to,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end