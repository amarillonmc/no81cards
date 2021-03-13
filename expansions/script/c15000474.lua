local m=15000474
local cm=_G["c"..m]
cm.name="星拟小龙"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x41),1,1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--avoid atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(cm.atcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(cm.atcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,code)
	return c:IsFaceup() and (c:IsSetCard(0xf34) or c:IsSetCard(0x41)) and not c:IsCode(code)
end
function cm.atcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil,e:GetHandler():GetCode())
end
function cm.spfilter(c,att,rac,lv,e,tp)
	return c:IsSetCard(0x41) and c:GetLevel()>lv and c:GetLevel()<=lv+3 and c:IsAttribute(att) and c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetMaterial():GetFirst()
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():GetFlagEffect(m)==0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and tc and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,tc:GetAttribute(),tc:GetRace(),tc:GetLevel(),e,tp) and Duel.GetMZoneCount(tp)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetMaterial():GetFirst()
	local tp=e:GetHandler():GetControler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,m)
		e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
		if Duel.GetMZoneCount(tp)==0 or not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,tc:GetAttribute(),tc:GetRace(),tc:GetLevel(),e,tp) then return end
		local ac=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute(),tc:GetRace(),tc:GetLevel(),e,tp):GetFirst()
		if ac then
			Duel.SpecialSummon(ac,0,tp,tp,true,true,POS_FACEUP)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xf34) and c:IsLocation(LOCATION_EXTRA)
end