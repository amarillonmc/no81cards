--邪心英雄 重装炎魔
function c77000427.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6008),aux.FilterBoolFunction(Card.IsLevelAbove,5),true) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return se:GetHandler():IsCode(94820406)
		or Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2) 
	--copy effect
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,77000427) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end) 
	e2:SetTarget(c77000427.copytg)
	e2:SetOperation(c77000427.copyop)
	c:RegisterEffect(e2)
end
c77000427.material_setcode=0x8
c77000427.dark_calling=true
function c77000427.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6008) and c:IsType(TYPE_FUSION) and c:IsLevelBelow(6)
end
function c77000427.copytg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77000427.copyfilter,tp,LOCATION_EXTRA,0,1,nil) end 
end
function c77000427.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c77000427.copyfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()  
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then  
		local code=tc:GetOriginalCodeRule() 
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		end 
	end 
end

