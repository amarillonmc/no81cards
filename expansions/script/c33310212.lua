--空想寒晶 冰凰
function c33310212.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x551),aux.FilterBoolFunction(Card.IsAttackAbove,2000),true)
	--chaojifuzade effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33310212.cost)
	e1:SetTarget(c33310212.tg)
	e1:SetOperation(c33310212.op)
	c:RegisterEffect(e1)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33310212,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,33310212)
	e5:SetCondition(c33310212.spcon)
	e5:SetTarget(c33310212.sptg)
	e5:SetOperation(c33310212.spop)
	c:RegisterEffect(e5)
	if not c33310212.global_check then
		c33310212.table={}
		c33310212.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c33310212.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33310212.checkop(e,tp,eg,ep,ev,re,r,rp)
	c33310212.table={}
end
function c33310212.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) 
end
function c33310212.spfilter(c,e,tp)
	return c:IsSetCard(0x551) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c33310212.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310212.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33310212.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33310212.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c33310212.costfil(c)
	return  c:IsAbleToDeckAsCost()--c:IsPublic() and
end
function c33310212.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310212.costfil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c33310212.costfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c33310212.thfil(c)
	for i,v in ipairs(c33310212.table) do
		if v==c:GetCode() then return false end
	end
	return c:IsSetCard(0x551) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33310212.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310212.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(33310212)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(33310212,RESET_CHAIN,0,1)
end
function c33310212.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c33310212.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(33310212,1)) then
			Duel.ConfirmCards(1-tp,g)
			local tc=g:GetFirst()
			table.insert(c33310212.table,tc:GetCode())
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end