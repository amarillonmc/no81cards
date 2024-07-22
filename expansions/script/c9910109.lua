--战车道少女·逸见艾丽卡
dofile("expansions/script/c9910100.lua")
function c9910109.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,true,nil,true,nil,true,nil)
	--active limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c9910109.condition)
	e2:SetTarget(c9910109.actlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
end
function c9910109.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c9910109.actlimit(e,c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
