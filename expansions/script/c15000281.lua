local m=15000281
local cm=_G["c"..m]
cm.name="星拟构梦·扑风之星 LV7"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000282)
	c:EnableReviveLimit()
	--cannot special Summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,15000281)
	e1:SetCost(cm.srcost)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)
	c15000281.self_effect1=e1
	--I cannot activate other effect
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCondition(cm.actcon)
	e2:SetOperation(cm.actop)  
	c:RegisterEffect(e2)
	--lv up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15000280,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,15010281)
	e3:SetCondition(cm.sp2con)
	e3:SetCost(cm.sp2cost)
	e3:SetTarget(cm.sp2tg)
	e3:SetOperation(cm.sp2op)
	c:RegisterEffect(e3)
	--lv up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(15000280,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,15010281)
	e4:SetCondition(cm.sp3con)
	e4:SetCost(cm.sp2cost)
	e4:SetTarget(cm.sp2tg)
	e4:SetOperation(cm.sp2op)
	c:RegisterEffect(e4)
end
cm.lvup={15000282}
cm.lvdn={15000280}
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler() and not (re==c15000281.self_effect1 or re:GetDescription()==aux.Stringid(m,0))
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(15000281,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(15000280,4))
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ag=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
		local bg=Group.CreateGroup()
		local tc=ag:GetFirst()
		while tc do
			if Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil,tc) then
				bg:AddCard(tc)
			end
			tc=ag:GetNext()
		end
		return ag:GetCount()~=0 and bg:GetCount()~=0
	end
	local ag=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	local bg=Group.CreateGroup()
	local tc=ag:GetFirst()
	while tc do
		if Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil,tc) then
			bg:AddCard(tc)
		end
		tc=ag:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=bg:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.srfilter(c,tc)
	return c:GetTextAttack()>=0 and c:GetAttack()==c:GetDefense() and not c:IsCode(15000281) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(tc:GetCode())
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCode(15000282) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000281)==0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
end
function cm.sp3con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000281)==0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,15000282)~=0
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end