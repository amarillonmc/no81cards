--战车道少女·秋山优花里
dofile("expansions/script/c9910100.lua")
function c9910103.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,true,nil,true,nil,true,nil)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c9910103.condition)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c9910103.condition)
	e3:SetValue(800)
	c:RegisterEffect(e3)
end
function c9910103.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
