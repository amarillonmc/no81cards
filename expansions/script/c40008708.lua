--天启之渎圣骑士
function c40008708.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c40008708.matfilter,1,1)
	c:EnableReviveLimit()   
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008708,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40008708)
	e1:SetTarget(c40008708.tktg)
	e1:SetOperation(c40008708.tkop)
	c:RegisterEffect(e1) 
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008708,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,40008709)
	e2:SetCondition(c40008708.condition)
	e2:SetTarget(c40008708.sptg)
	e2:SetOperation(c40008708.spop)
	c:RegisterEffect(e2)
end
function c40008708.matfilter(c)
	return c:IsLinkType(TYPE_LINK) and not c:IsLinkCode(40008708)
end
function c40008708.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40008710,0,0x4011,3000,3000,9,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c40008708.filter(c)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x10c)) and c:IsAbleToHand()
end
function c40008708.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40008710,0,0x4011,3000,3000,9,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,40008710)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(40008708,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		   local g=Duel.GetMatchingGroup(c40008708.filter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40008708,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	end
end
end
function c40008708.cfilter(c,tp,col)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and col==aux.GetColumn(c)
end
function c40008708.condition(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c40008708.cfilter,1,nil,tp,col) and e:GetHandler():GetFlagEffect(40008708)~=0
end
function c40008708.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40008708.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

