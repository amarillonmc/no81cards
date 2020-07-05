--罗德岛·辅助干员-巫恋
function c79029199.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),2,2,true) 
	--atk down + token 
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(c79029199.attg)
	e1:SetOperation(c79029199.atop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c79029199.rmtg)
	c:RegisterEffect(e2)
	--half
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c79029199.hcost)
	e3:SetOperation(c79029199.hop)
	c:RegisterEffect(e3)
end
function c79029199.tgfilter(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c79029199.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(79029199)==0
		and Duel.IsExistingMatchingCard(c79029199.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(79029199,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c79029199.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	local g=Duel.SelectMatchingCard(tp,c79029199.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToBattle() and c:IsFaceup() then
		local lv=tc:GetLevel()
		local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		local tc=tg:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-lv*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	 end
	 if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0
	 or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029200,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	 local x=Duel.CreateToken(tp,79029200)
	 Duel.MoveToField(x,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end
end
function c79029199.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c79029199.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,10,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,10,10,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c79029199.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end





