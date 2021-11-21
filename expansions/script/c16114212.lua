--圣夜妖精 梅莉莉丝
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16114212,"FAIRY")
function cm.initial_effect(c)
   c:SetSPSummonOnce(m)
	--res
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spc(c,e,tp)
	return rk.check(c,"FAIRY") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thc(c)
	return rk.check(c,"FAIRY") and c:IsAbleToHand()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	local tg=g:RandomSelect(tp,3)
	Duel.ConfirmCards(1-tp,tg)
	Duel.ConfirmCards(tp,tg)
	local tc=tg:GetFirst()
	if tg:FilterCount(function (c)
						return rk.check(c,"FAIRY") and c:IsType(TYPE_MONSTER) end,nil)>=2 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		local a=Duel.IsExistingMatchingCard(cm.spc,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local b=Duel.IsExistingMatchingCard(cm.thc,tp,LOCATION_DECK,0,1,nil)
		local op=2
		if a and b then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		elseif a and not b then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3))
			if op==1 then
				op=op+1
			end
		elseif not a and b then
			op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,3))+2
		end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,cm.spc,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=Duel.SelectMatchingCard(tp,cm.thc,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.Recover(tp,2000,REASON_EFFECT)
		end
		return
	end
	Duel.ShuffleDeck(tp)
end