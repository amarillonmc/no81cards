--卡通圣之数码兽 战斗暴龙兽
function c50224150.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c50224150.condition)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c50224150.tktg)
	e2:SetOperation(c50224150.tkop)
	c:RegisterEffect(e2)
end
function c50224150.condition(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c50224150.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50218141,0xcb1,0x4011,1000,0,2,RACE_DINOSAUR,ATTRIBUTE_LIGHT) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50218142,0xcb1,0x4011,900,100,2,RACE_BEAST,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c50224150.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,50218141,0xcb1,0x4011,1000,0,2,RACE_DINOSAUR,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,50218142,0xcb1,0x4011,900,100,2,RACE_BEAST,ATTRIBUTE_DARK) then
		local token1=Duel.CreateToken(tp,50218141)
		Duel.SpecialSummon(token1,0,tp,tp,false,false,POS_FACEUP)
		local token2=Duel.CreateToken(tp,50218142)
		Duel.SpecialSummon(token2,0,tp,tp,false,false,POS_FACEUP)
	end
end