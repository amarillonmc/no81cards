--幻兽 贝希摩斯
function c98920731.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920731+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920731.spcon)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c98920731.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920731,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c98920731.tgtg)
	e1:SetOperation(c98920731.tgop)
	c:RegisterEffect(e1)
end
function c98920731.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST+RACE_ILLUSION+RACE_WINDBEAST+RACE_BEASTWARRIOR) and not c:IsCode(98920731)
end
function c98920731.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920731.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c98920731.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function c98920731.tgfilter(c)
	return c:IsRace(RACE_BEAST+RACE_ILLUSION+RACE_WINDBEAST+RACE_BEASTWARRIOR) and not c:IsCode(98920731) and c:IsAbleToGrave()
end
function c98920731.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920731.tgfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAttackAbove(700) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920731.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-700)
	c:RegisterEffect(e1)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98920731.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end