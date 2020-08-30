local m=82204253
local cm=_G["c"..m]
cm.name="小红帽「女骑士」"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)  
	e1:SetCountLimit(1,m+10000)  
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetOperation(cm.regop)  
	c:RegisterEffect(e2)  
end
function cm.costfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x5299) and c:IsAbleToGraveAsCost()  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then   
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsPreviousLocation(LOCATION_ONFIELD) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
		e1:SetCode(EVENT_PHASE+PHASE_END)  
		e1:SetRange(LOCATION_GRAVE)  
		e1:SetCountLimit(1,m)  
		e1:SetTarget(cm.thtg)  
		e1:SetOperation(cm.thop)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.thfilter(c,tp)  
	return c:IsSetCard(0x5299) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)  
	local tc=g:GetFirst()  
	if tc then  
		local b1=tc:IsAbleToHand()  
		local b2=tc:GetActivateEffect():IsActivatable(tp)  
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then  
			Duel.SendtoHand(tc,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,tc)  
		else  
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
			local te=tc:GetActivateEffect()  
			local tep=tc:GetControler()  
			local cost=te:GetCost()  
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end  
		end  
	end  
end  