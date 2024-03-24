local m=15005363
local cm=_G["c"..m]
cm.name="迷忆渊境59-归途"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.acop)
	c:RegisterEffect(e0)
	--when Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(4179255)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.opcon)
	e3:SetTarget(cm.optg)
	e3:SetOperation(cm.opop)
	c:RegisterEffect(e3)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return true end
	Duel.RaiseEvent(e:GetHandler(),4179255,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==e:GetHandler()
end
function cm.thfilter(c)
	return c:IsSetCard(0xcf3c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cm.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.c2filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) and c:IsLocation(LOCATION_MZONE)
end
function cm.ovfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,15005363)==0
	local b2=eg:IsExists(cm.c2filter,1,nil,tp)
		and Duel.GetFlagEffect(tp,15005364)==0
	if chk==0 then return b1 or b2 end
end
function cm.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,15005363)==0
	local b2=eg:IsExists(cm.c2filter,1,nil,tp)
		and Duel.GetFlagEffect(tp,15005364)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,15005363,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local ag=eg:FilterSelect(tp,cm.c2filter,1,1,nil,tp)
		if ag:GetCount()~=0 then
			Duel.HintSelection(ag)
			local tc=ag:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ovfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,tc)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local tg=g:Select(tp,1,1,nil)
				Duel.HintSelection(tg)
				local ac=tg:GetFirst()
				if not ac:IsImmuneToEffect(e) then
					local og=ac:GetOverlayGroup()
					if og:GetCount()>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(tc,tg)
				end
			end
		end
		Duel.RegisterFlagEffect(tp,15005364,RESET_PHASE+PHASE_END,0,1)
	end
end