local m=31400123
local cm=_G["c"..m]
cm.name="核成兽的血核"
function cm.initial_effect(c)
	aux.AddCodeList(c,36623431)
	aux.EnableChangeCode(c,36623431,LOCATION_HAND+LOCATION_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.actcon)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.returntg)
	e3:SetOperation(cm.returnop)
	c:RegisterEffect(e3)
	if not cm.effect_level then
		cm.effect_level=0
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.effect_level>2
end
function cm.filter(c,e,tp)
	local con1=c:IsSetCard(0x1d) and c:IsType(TYPE_MONSTER)
	local con2=cm.effect_level>1 and c:IsLocation(LOCATION_HAND) and not c:IsPublic()
	local con3=c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP)
	local con4=Duel.IsExistingMatchingCard(cm.deckfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetRace())
	return con1 and (con2 or con3) and con4
end
function cm.deckfilter(c,e,tp,race)
	return c:IsRace(race) and c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and cm.effect_level>0)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local c=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if not c then return end
	if c:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.deckfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,c:GetRace()):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (cm.effect_level==0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.returntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if c:IsLocation(LOCATION_DECK) and cm.effect_level<3 then
		cm.effect_level=cm.effect_level+1
	end
end