--光 子 神 枪 破 碎 者
local m=22348003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348003,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c22348003.tgtg)
	e1:SetOperation(c22348003.tgop)
	c:RegisterEffect(e1)
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c22348003.poscon)
	e2:SetOperation(c22348003.posop)
	c:RegisterEffect(e2)
end


function c22348003.tgfilter(c)
	return c:IsSetCard(0x55,0x7b) and c:IsAbleToGrave()
end
function c22348003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c22348003.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348003.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and c:IsFaceup() and c:IsRelateToEffect(e) and ft1>0 and ft2>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17418745,0x55,TYPES_TOKEN_MONSTER,2000,0,4,RACE_THUNDER,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17418745,0x55,TYPES_TOKEN_MONSTER,2000,0,4,RACE_THUNDER,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if Duel.SelectYesNo(tp,aux.Stringid(22348003,1)) then
			Duel.BreakEffect()
			 local token=Duel.CreateToken(tp,17418745)
			 Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			 local token=Duel.CreateToken(tp,17418745)
			 Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
			 Duel.SpecialSummonComplete()
			end
		end
	end
end

function c22348003.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c22348003.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
