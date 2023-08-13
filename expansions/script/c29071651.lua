--方舟骑士-暴行
c29071651.named_with_Arknight=1
function c29071651.initial_effect(c)
	aux.AddCodeList(c,29065500,29065502)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29071651,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,29071651+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29071651.spcon)
	e1:SetOperation(c29071651.spop)
	c:RegisterEffect(e1)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(29071651,ACTIVITY_SUMMON,c29071651.counterfilter)
	Duel.AddCustomActivityCounter(29071651,ACTIVITY_SPSUMMON,c29071651.counterfilter)
end
function c29071651.counterfilter(c)
	return not (c:IsCode(29065502) or c:IsCode(29065500))
end
function c29071651.spcon(e,c)
	if c==nil then return true end
	return (Duel.GetCustomActivityCount(29071651,tp,ACTIVITY_SUMMON)~=0
		or Duel.GetCustomActivityCount(29071651,tp,ACTIVITY_SPSUMMON)~=0)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x10ae,2,REASON_COST)
		or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x10ae,1,REASON_COST)))
end
function c29071651.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFlagEffect(tp,29096814)==1 then
		Duel.ResetFlagEffect(tp,29096814)
		Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_RULE)
	else
		Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	end
end