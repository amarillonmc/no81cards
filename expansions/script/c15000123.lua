local m=15000123
local cm=_G["c"..m]
cm.name="星遗物携来的希望"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.thfilter(c)
	return c:IsSetCard(0xfd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--extra material
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	e2:SetValue(SUMMON_TYPE_LINK)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(cm.mattg)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.mattg(e,c)
	return c:IsSetCard(0xfd) and c:IsType(TYPE_LINK)
end
function cm.rmfilter1(c,tp,lk)
	return c:IsAbleToRemoveAsCost() and c:IsCode(15000123) and (lk==1 or Duel.IsExistingMatchingCard(cm.rmfilter2,tp,LOCATION_GRAVE,0,lk-1,c))
end
function cm.rmfilter2(c)
	return c:IsAbleToRemoveAsCost() and (c:IsSetCard(0xfe) or c:IsSetCard(0xfd))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lk=c:GetLink()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(cm.rmfilter1,tp,LOCATION_GRAVE,0,1,nil,tp,lk) and Duel.GetFlagEffect(tp,15000123)==0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lk=c:GetLink()
	local g1=Duel.SelectMatchingCard(tp,cm.rmfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp,lk)
	if lk>=2 then
		local g2=Duel.SelectMatchingCard(tp,cm.rmfilter2,tp,LOCATION_GRAVE,0,lk-1,lk-1,g1)
		g1:Merge(g2)
	end
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
	Duel.RegisterFlagEffect(tp,15000123,RESET_PHASE+PHASE_END,0,1)
end