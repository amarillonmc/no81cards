local m=15005373
local cm=_G["c"..m]
cm.name="迷忆渊裔C1017-雪后的视线"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--to deck & SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.xpcon)
	e2:SetTarget(cm.xptg)
	e2:SetOperation(cm.xpop)
	c:RegisterEffect(e2)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.filter(c)
	return c:IsSetCard(0xcf3c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.xpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.desfilter(c,e,tp)
	return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cm.spfilter(c,e,tp,sc)
	return c:IsSetCard(0xcf3c) and c:IsType(TYPE_XYZ) and c:IsRank(3) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,sc,c) and not Duel.IsExistingMatchingCard(cm.dnfilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function cm.dnfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.xptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.desfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local x=0
	if e:GetHandler():GetOverlayCount()==0 then x=1 end
	e:SetLabel(x)
end
function cm.matfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.xpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b=e:GetLabel()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and (#og==0 or Duel.SendtoDeck(og,nil,2,REASON_EFFECT)~=0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
			if g:GetCount()>0 and Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				if b==1 and Duel.IsExistingMatchingCard(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,g) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local xg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.matfilter2),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,g)
					if xg:GetCount()>0 then
						Duel.HintSelection(xg)
						for oc in aux.Next(xg) do
							local lg=oc:GetOverlayGroup()
							if lg:GetCount()>0 then
								Duel.SendtoGrave(lg,REASON_RULE)
							end
						end
						Duel.Overlay(g:GetFirst(),xg)
					end
				end
			end
		end
	end
end