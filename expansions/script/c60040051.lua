--战栗的侵略
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsPlayerCanSpecialSummonMonster(tp,60040044,0,TYPES_TOKEN_MONSTER,1000,2000,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then b1=true end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,60040045,0,TYPES_TOKEN_MONSTER,2000,1000,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then b2=true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local op=0
	if b1 and b2 and Duel.IsPlayerAffectedByEffect(tp,59822133) and (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60040033) or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60040046)) then
		op=3
	else
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,1)},
			{b2,aux.Stringid(m,2)})
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or (not Duel.IsPlayerCanSpecialSummonMonster(tp,60040044,0,TYPES_TOKEN_MONSTER,1000,2000,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) and op==1) or (Duel.IsPlayerCanSpecialSummonMonster(tp,60040045,0,TYPES_TOKEN_MONSTER,2000,1000,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) and op==2) then return end
	local code=0
	if op~=3 then
		if op==1 then code=60040044 end
		if op==2 then code=60040045 end
		local token=Duel.CreateToken(tp,code)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	elseif op==3 and (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60040033) or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60040046)) and Duel.IsPlayerAffectedByEffect(tp,59822133) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,60040043+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
end