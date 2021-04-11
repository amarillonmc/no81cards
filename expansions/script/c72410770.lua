--命运之神意-7『战车』·奥辂昂
function c72410770.initial_effect(c)
		--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_HANDES+CATEGORY_DAMAGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c72410770.con)
	e1:SetTarget(c72410770.target)
	e1:SetOperation(c72410770.operation)
	c:RegisterEffect(e1)
end
c72410770.toss_dice=true
function c72410770.con(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c72410770.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c72410770.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
function c72410770.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	local c=e:GetHandler()
	if d==1 or d==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c72410770.atklimit)
		e1:SetLabel(c:GetRealFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	elseif d==3 or d==4 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,72410771,nil,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local fid=e:GetHandler():GetFieldID()
		local g=Group.CreateGroup()
		for i=1,ft do
			local token=Duel.CreateToken(tp,72410771)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			g:AddCard(token)
		end
		Duel.SpecialSummonComplete()
	elseif d==5 or d==6 then	
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g2:GetCount()>0 then
		local sg=g2:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local tc=sg:GetFirst()
			if tc:IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
		end
	end
end