--荒神仪-书幻魔
local m=14000241
local cm=_G["c"..m]
cm.named_with_war=1
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	--effct flag
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EVENT_TO_GRAVE)
	e10:SetRange(1)
	e10:SetOperation(cm.reop)
	c:RegisterEffect(e10)
end
function cm.war(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_war
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	if re and cm.war(re:GetHandler()) then
		local tc=eg:GetFirst()
		while tc do
			if tc and tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) then
				tc:RegisterFlagEffect(14000241,RESET_EVENT+0x1fe0000,0,0,0)
			end
			tc=eg:GetNext()
		end
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_EXTRA)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<=0 and Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)<=0 then return end
	local type=TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_EXTRA,0,1,1,nil,e,1-tp)
	g1:Merge(g2)
	if g1:GetCount()<=0 then return end
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
		local tc=g1:GetFirst()
		while tc do
			local ct=0
			if tc and tc:IsLocation(LOCATION_GRAVE) then
				if bit.band(type,tc:GetType())~=0 then
					ct=bit.band(type,tc:GetType())
				end
				if ct~=0 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetRange(LOCATION_GRAVE)
					e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(1,0)
					e1:SetLabel(ct)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					e1:SetTarget(cm.splimit)
					tc:RegisterEffect(e1)
				end
			end
			tc=g1:GetNext()
		end
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel()) and c:IsLocation(LOCATION_EXTRA)
end
function cm.tdfilter(c,e,tp)
	return c:GetFlagEffect(14000241)~=0 and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.thfilter(c,e,tp)
	return c:IsCode(14000255) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,c,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end