--最初的愿望
local m=29030127
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)	
end
function cm.cfilter(c,e,tp,chk)
	return c:IsReleasableByEffect() and c:IsType(TYPE_MONSTER)
		and (not chk or Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c,chk))
end
function cm.thfilter(c,e,tp,ec)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FAIRY)
		and (c:IsAbleToHand() or (Duel.GetMZoneCount(tp,ec)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and (Duel.IsExistingMatchingCard(cm.facecheck,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(cm.thcheck,tp,LOCATION_DECK,0,1,c))
end
function cm.thcheck(c)
	return c:IsSetCard(0x37af) and c:IsAbleToHand()
end
function cm.facecheck(c)
	return c:IsFaceup() and c:IsSetCard(0x37af)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp,true) end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler(),e,tp,true)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local dg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp,true) then
		dg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,true)
	else
		dg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,false)
	end
	if dg and dg:GetCount()>0 then
		local fg=dg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if fg:GetCount()>0 then
			Duel.HintSelection(fg)
		end
		if Duel.Release(dg,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,nil)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local tc=g:GetFirst()
			if tc then
				if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				if not Duel.IsExistingMatchingCard(cm.facecheck,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.thcheck,tp,LOCATION_DECK,0,1,nil) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tg=Duel.SelectMatchingCard(tp,cm.thcheck,tp,LOCATION_DECK,0,1,1,nil)
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tg)
				end
			end
		end
	end
end