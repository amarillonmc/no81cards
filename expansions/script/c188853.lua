local m=188853
local cm=_G["c"..m]
cm.name="自奏圣乐·交响曲韵龙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.atktg)
	e3:SetValue(800)
	c:RegisterEffect(e3)
end
function cm.atktg(e,c)
	return c:IsSetCard(0x11b) or c:IsType(TYPE_LINK)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function cm.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup()) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetRace())
end
function cm.thfilter(c,lv,rac)
	return c:IsSetCard(0x11b) and not c:IsCode(m) and c:IsAbleToHand() and (rac&RACE_MACHINE==0 or Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,c,lv))
end
function cm.tgfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x11b) and not c:IsLevel(lv) and c:IsAbleToGrave()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,true):Filter(cm.costfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if #g==g:FilterCount(Card.IsRace,nil,RACE_MACHINE) then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetReleaseGroup(tp,true):Filter(cm.costfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	local lv,rac=tc:GetLevel(),tc:GetRace()
	if Duel.Release(tc,REASON_COST)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv,rac)
		if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,hg)
			local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil,lv)
			if rac&RACE_MACHINE>0 and #sg>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local gg=sg:Select(tp,1,1,nil)
				if #gg>0 then Duel.SendtoGrave(gg,REASON_EFFECT) end
			end
		end
	end
end
function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
