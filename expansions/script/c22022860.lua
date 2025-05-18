--人理之基 芭万·希
function c22022860.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,22021740),1,1)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022860,1))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,22022860) 
	e1:SetTarget(c22022860.cltg)
	e1:SetOperation(c22022860.clop)
	c:RegisterEffect(e1) 
	--to grave
	local e2=Effect.CreateEffect(c)   
	e2:SetDescription(aux.Stringid(22022860,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,12022860) 
	e2:SetCost(c22022860.tgcost)
	e2:SetTarget(c22022860.tgtg)
	e2:SetOperation(c22022860.tgop)
	c:RegisterEffect(e2) 
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022860,0))
	e3:SetCategory(CATEGORY_CONTROL+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,22022860) 
	e3:SetCondition(c22022860.erecon)
	e3:SetCost(c22022860.erecost)
	e3:SetTarget(c22022860.cltg)
	e3:SetOperation(c22022860.clop)
	c:RegisterEffect(e3) 
	--to grave
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(22022860,5))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e4:SetRange(LOCATION_GRAVE) 
	e4:SetCountLimit(1,12022860) 
	e4:SetCondition(c22022860.erecon)
	e4:SetCost(c22022860.tgcost1)
	e4:SetTarget(c22022860.tgtg)
	e4:SetOperation(c22022860.tgop)
	c:RegisterEffect(e4) 
end
function c22022860.cltg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetBaseAttack())
end
function c22022860.clop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp) then  
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT) 
	end
end 
function c22022860.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22022860.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() end,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)  
end
function c22022860.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() end,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() end,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
		local g=Duel.GetMatchingGroup(function(c,code) return c:IsFaceup() and c:IsCode(code) end,tp,0,LOCATION_ONFIELD,nil,tc:GetCode()) 
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and g:GetCount()>0 then 
			Duel.BreakEffect() 
			Duel.SelectOption(tp,aux.Stringid(22022860,3))
			Duel.SelectOption(tp,aux.Stringid(22022860,4))
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE) 
		end 
	end 
end 
function c22022860.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022860.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22022860.tgcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
