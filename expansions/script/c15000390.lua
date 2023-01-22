local m=15000390
local cm=_G["c"..m]
cm.name="便携式镜世界"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15000390+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.mrfilter2(c,sc)
	return c:GetSequence()<5 and c:GetColumnGroup():IsContains(sc)
end
function cm.filter(c,tp)
	local atk=c:GetAttack()
	local def=c:GetDefense()
	local pos=c:GetPosition()
	local seq=c:GetSequence()
	if seq==0 then seq=4
	elseif seq==1 then seq=3
	elseif seq==2 then seq=2
	elseif seq==3 then seq=1
	elseif seq==4 then seq=0
	elseif seq==5 then seq=3
	elseif seq==6 then seq=1 end
	local p=c:GetControler()
	local zone=0x1<<seq
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and Duel.IsPlayerCanSpecialSummonMonster(tp,15000391,nil,TYPES_TOKEN_MONSTER,atk,def,1,RACE_FIEND,ATTRIBUTE_DARK,pos,1-c:GetControler(),0) and Duel.GetLocationCount(1-p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and not Duel.IsExistingMatchingCard(cm.mrfilter2,p,0,LOCATION_MZONE,1,nil,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
--&0x1f001f
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local pos=tc:GetPosition()
		local p=tc:GetControler()
		local seq=tc:GetSequence()
		if seq==0 then seq=4
		elseif seq==1 then seq=3
		elseif seq==2 then seq=2
		elseif seq==3 then seq=1
		elseif seq==4 then seq=0
		elseif seq==5 then seq=3
		elseif seq==6 then seq=1 end
		local zone=0x1<<seq
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000391,nil,TYPES_TOKEN_MONSTER,atk,def,1,RACE_FIEND,ATTRIBUTE_DARK,pos,1-p,0) and not Duel.IsExistingMatchingCard(cm.mrfilter2,p,0,LOCATION_MZONE,1,nil,tc) then
			local token=Duel.CreateToken(tp,15000391)
			--tc:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
			Duel.SpecialSummonStep(token,0,tp,1-tc:GetControler(),false,false,pos,zone)
			token:SetCardTarget(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(cm.tokenatk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(cm.tokendef)
			token:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_CODE)
			e3:SetValue(cm.tokencode)
			token:RegisterEffect(e3,true)

			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_ADJUST)
			e6:SetRange(LOCATION_MZONE)
			--e6:SetCondition(cm.tokendescon)
			e6:SetOperation(cm.tokendesop)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e6,true)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.tokenatk(e,c)
	local tc=e:GetHandler():GetCardTarget():GetFirst()
	if not tc then return 0 end
	return tc:GetAttack()
end
function cm.tokencode(e,c)
	local tc=e:GetHandler():GetCardTarget():GetFirst()
	if not tc then return 0 end
	return tc:GetCode()
end
function cm.tokendef(e,c)
	local tc=e:GetHandler():GetCardTarget():GetFirst()
	if not tc then return 0 end
	return tc:GetDefense()
end
function cm.tokendescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCardTargetCount()==0
end
function cm.tokendesop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCardTargetCount()==0 then
		Duel.Destroy(e:GetHandler(),REASON_RULE)
		return
	end
	if e:GetHandler():GetCardTarget() and e:GetHandler():GetCardTarget():GetFirst():GetPosition()~=e:GetHandler():GetPosition() then
		Duel.ChangePosition(e:GetHandler(),e:GetHandler():GetCardTarget():GetFirst():GetPosition())
	end
end