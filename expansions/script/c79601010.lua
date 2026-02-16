--幽冥战士 卡莫斯
local s,id,o=GetID()
function s.initial_effect(c)
	--No Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	--Search or SpSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Grant Effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(s.efcon)
	e4:SetOperation(s.efop)
	c:RegisterEffect(e4)
	--Counter for restriction
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.thfilter(c,e,tp,can_sp)
	if not (c:IsSetCard(0xd70) and not c:IsCode(id) and c:IsType(TYPE_MONSTER)) then return false end
	if c:IsAbleToHand() then return true end
	if can_sp and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return true end
	return false
end
function s.thcfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local can_sp=not Duel.IsExistingMatchingCard(s.thcfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,can_sp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local can_sp=not Duel.IsExistingMatchingCard(s.thcfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,can_sp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=can_sp and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if not b1 and not b2 then return end
		local op=aux.SelectFromOptions(tp,
			{b1,1190},
			{b2,1152})
		if op==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsSetCard(0xd70) and bc and not bc:IsAttribute(ATTRIBUTE_DARK)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
end