local m=53764009
local cm=_G["c"..m]
cm.name="天之感召"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.has_text_type=TYPE_SPIRIT
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0
end
function cm.filter(c)
	return c:IsType(TYPE_SPIRIT) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function cm.thfilter1(c,tp)
	return c:IsLevelAbove(5) and c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(function(c,cd)return c:IsFaceup() and c:IsCode(cd)end,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.thfilter2(c,res)
	local mi,ma=c:GetTributeRequirement()
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and (res or (cm.filter(c) and mi>0 and Duel.CheckTribute(c,mi)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil,tp)
	local res=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
	local b2=res or Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil,res)
	if chk==0 then return b1 or b2 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil,tp)
	local res=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil)
	local b2=res or Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil,res)
	local opt=0
	if b1 and b2 then opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1 elseif b1 then opt=1 elseif b2 then opt=2 end
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif opt==2 then
		if not res or (Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil,true) and Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetLabelObject(tc)
			e1:SetOperation(cm.checkop)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EVENT_SUMMON_NEGATED)
				e2:SetLabelObject(e1)
				e2:SetOperation(cm.rstop)
				Duel.RegisterEffect(e2,tp)
				Duel.Summon(tp,tc,true,nil,1)
			else
				e1:SetCode(EVENT_MSET)
				Duel.RegisterEffect(e1,tp)
				Duel.MSet(tp,tc,true,nil,1)
			end
		end
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
