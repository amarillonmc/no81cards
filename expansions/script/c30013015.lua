--深土之物 塔里克丝贝牛
local m=30013015
local cm=_G["c"..m]  
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.fpcon)
	e4:SetCost(cm.fpcost)
	e4:SetTarget(cm.fptg)
	e4:SetOperation(cm.fpop)
	c:RegisterEffect(e4)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+101)
	e1:SetTarget(cm.sptg)
	c:RegisterEffect(e1)
	--Effect 3
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1,m+100)
	e12:SetCondition(cm.thcon1)
	e12:SetCost(cm.thcost)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetRange(LOCATION_GRAVE)
	e32:SetCountLimit(1,m+100)
	e32:SetCondition(cm.thcon2)
	e32:SetCost(cm.thcost)
	e32:SetTarget(cm.thtg)
	e32:SetOperation(cm.thop)
	c:RegisterEffect(e32)
end
--Effect 1
function cm.fpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.fp(c)
	return (c:IsFacedown() and c:IsLocation(LOCATION_MZONE)) 
		or (c:IsFaceup() and (c:IsSetCard(0x92c) or c:IsType(TYPE_FLIP)))
end
function cm.fpcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.fptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.fp,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:GetCount()>0 end
end
function cm.fpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.fp,tp,LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	while tc do  
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e4:SetOwnerPlayer(tp)
		tc:RegisterEffect(e4)  
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		tc=g:GetNext()
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--Effect 2
function cm.spe(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30013020)
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spe,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) end
	if Duel.IsPlayerAffectedByEffect(tp,30013020) then
		e:SetOperation(cm.spop3)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		e:SetOperation(cm.spop)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.spcon5)
	e1:SetOperation(cm.spop5)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.spcon5(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spe,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.spop5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spe),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
	if e:GetHandler():IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then	
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end 
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spe),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 and c:IsCanTurnSet() 
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		end
		Duel.ConfirmCards(1-tp,tc)
	end
end
--Effect 3 
function cm.thcon1(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcon2(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.pos(c,tp)
	return c:IsFacedown() and c:IsCanChangePosition()
		and Duel.IsExistingMatchingCard(cm.tog,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function cm.tog(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x92c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pos,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.pos,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		local pos1=0
		if not tc:IsPosition(POS_FACEUP_ATTACK) then pos1=pos1+POS_FACEUP_ATTACK end
		if not tc:IsPosition(POS_FACEUP_DEFENSE) then pos1=pos1+POS_FACEUP_DEFENSE end
		local pos2=Duel.SelectPosition(tp,tc,pos1)
		if Duel.ChangePosition(tc,pos2)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tog),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			end
		end
	end
end
 
 