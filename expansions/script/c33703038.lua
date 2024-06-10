--虚拟战！
local m=33703038
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,33703039,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_WATER) and Duel.IsPlayerCanSpecialSummonMonster(tp,33703040,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,1-tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.sfilter,tp,0,LOCATION_MZONE,nil)
	local sel=0
	local sel2=0
	if Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil) then sel=2 end 
	if sel~=2 and #g>0 then
		sel2=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
	end
	if (sel2==1 or sel==2) and Duel.IsPlayerCanSpecialSummonCount(tp,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33703039,nil,TYPES_TOKEN_MONSTER,tc:GetAttack()/2,tc:GetDefense()/2,1,tc:GetRace(),tc:GetAttribute()) then return end
			local token=Duel.CreateToken(1-tp,33703039)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(tc:GetAttribute())
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(tc:GetRace())
			token:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(tc:GetAttack()/2)
			token:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			e4:SetValue(tc:GetDefense()/2)
			token:RegisterEffect(e4,true)
			Duel.SpecialSummonComplete()
			local tc1=token
			local fdzone=0
			for i=0,4 do
				if (tc1:GetSequence()~=0 or tc1:GetSequence()~=4) and tc1:GetSequence()==i then
					fdzone=fdzone|1<<i+1
					fdzone=fdzone|1<<i-1
				elseif tc1:GetSequence()==0 and tc1:GetSequence()==i then
					fdzone=fdzone|1<<i+1
				elseif tc1:GetSequence()==4 and tc1:GetSequence()==i then
					fdzone=fdzone|1<<i-1
				end
			end
			local dis=Duel.SelectField(tp,1,0,LOCATION_MZONE,~fdzone<<16)
			local seq2=math.log(dis>>16,2)
			Duel.Hint(HINT_ZONE,tp,dis)
			local g2=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil,dis)
			local tc2=g2:GetFirst()
			if #g2>0 then
				if Duel.SendtoGrave(g2,REASON_EFFECT)~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33703040,nil,TYPES_TOKEN_MONSTER,tc2:GetAttack()/2,tc2:GetDefense()/2,1,tc2:GetRace(),tc2:GetAttribute()) then
					local token2=Duel.CreateToken(1-tp,33703040)				
					Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP,2^seq2)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
					e1:SetValue(tc2:GetAttribute())
					token2:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_CHANGE_RACE)
					e2:SetValue(tc2:GetRace())
					token2:RegisterEffect(e2,true)
					local e3=e1:Clone()
					e3:SetCode(EFFECT_SET_ATTACK)
					e3:SetValue(tc2:GetAttack()/2)
					token2:RegisterEffect(e3,true)
					local e4=e1:Clone()
					e4:SetCode(EFFECT_SET_DEFENSE)
					e4:SetValue(tc2:GetDefense()/2)
					token2:RegisterEffect(e4,true)
					Duel.SpecialSummonComplete()
				end
			elseif Duel.IsPlayerCanSpecialSummonMonster(tp,33703039,nil,TYPES_TOKEN_MONSTER,tc:GetAttack()/2,tc:GetDefense()/2,1,tc:GetRace(),tc:GetAttribute()) then
				local token3=Duel.CreateToken(tp,33703039)
				Duel.SpecialSummonStep(token3,0,tp,1-tp,false,false,POS_FACEUP,2^seq2)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(tc:GetAttribute())
				token3:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(tc:GetRace())
				token3:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_SET_ATTACK)
				e3:SetValue(tc:GetAttack()/2)
				token3:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_DEFENSE)
				e4:SetValue(tc:GetDefense()/2)
				token3:RegisterEffect(e4,true)
				Duel.SpecialSummonComplete()
			end	 
		end
	end
	if (sel2==2 or sel==2) then
		local g3=Duel.GetMatchingGroup(cm.sfilter,tp,0,LOCATION_MZONE,nil)
		local tc3=g3:GetFirst()
		while tc3 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue((math.floor(tc3:GetAttack()))/2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc3:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue((math.floor(tc3:GetDefense()))/2)
			tc3:RegisterEffect(e2)
			local e3=e1:Clone()
			if tc3:IsType(TYPE_XYZ) then
				e3:SetCode(EFFECT_CHANGE_RANK)
			else
				e3:SetCode(EFFECT_CHANGE_LEVEL)
			end
			e3:SetValue(cm.val)
			tc3:RegisterEffect(e3)
			tc3=g3:GetNext()
		end
	end
end
function cm.disfilter(c,dis)
	return (c:IsFaceup() or c:IsFacedown()) and c:IsAbleToGrave() and (2^c:GetSequence())*0x10000&dis~=0
end
function cm.spfilter3(c,dis)
	return (2^c:GetSequence())*0x10000&dis~=0
end
function cm.spfilter(c,s,tp)
	local seq=c:GetSequence()
	local g =Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_MZONE,0,nil,s,tp)
	return seq<5 and (math.abs(seq-(s-1))==1) and c:IsControler(tp) 
end
function cm.spfilter2(c,s,tp)
	return c:GetSequence()<4 and ((c:GetSequence()==s+1 or c:GetSequence()==s-1) and c:IsType(TYPE_MONSTER))
end
function cm.actfilter(c)
	return (c:IsSetCard(0x445) or c:IsSetCard(0x344c)) and c:IsType(TYPE_MONSTER)
end
function cm.val(e,re,val,r,rp,rc)
	return math.floor((val/2))+1
end