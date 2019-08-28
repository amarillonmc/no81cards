--void-机械人偶
function c1008026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c1008026.target)
	e1:SetOperation(c1008026.activate)
	c:RegisterEffect(e1)
	local ore=Effect.CreateEffect(c)
	ore:SetCode(EFFECT_CHANGE_TYPE)
	ore:SetType(EFFECT_TYPE_SINGLE)
	ore:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	ore:SetRange(0xfb)
	ore:SetValue(0x20002)
	c:RegisterEffect(ore)
end
function c1008026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and Card.IsFaceup(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1008026,0,0x4023,1000,1000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1008026.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,1008026,0,0x4023,1000,1000,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsType(TYPE_TOKEN) then
		local gl=c:GetOwnerTarget()--:Filter(c1008026.linkfilter,nil,e)
		local link=gl:GetFirst()
		c:AddTrapMonsterAttribute(0x4023,ATTRIBUTE_DARK,RACE_FIEND,1,1000,1000)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		c:TrapMonsterBlock()
		if link and link:IsLocation(LOCATION_MZONE) then
			link:SetCardTarget(c)
		end
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then		
			c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		end
		--indes
		-- local e1=Effect.CreateEffect(c)
		-- e1:SetType(EFFECT_TYPE_SINGLE)
		-- e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		-- e1:SetValue(c1008026.indes)
		-- c:RegisterEffect(e1)
	end
end
-- function c1008026.indes(e,c)
	-- return c:GetAttack()==e:GetHandler():GetAttack()
-- end