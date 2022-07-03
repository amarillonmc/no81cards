--缇雅·雅莉珂希德 晚安
local m=60002056
local cm=_G["c"..m]
cm.name="缇雅·雅莉珂希德 晚安"
function cm.initial_effect(c)
	--draw count
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(cm.drval)
	c:RegisterEffect(e4)
end
function cm.drfilter(c)
	return c:IsAttack(3950)
end
function cm.drval(e)
	local g=Duel.GetMatchingGroup(cm.drfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	if g:GetCount()<=0 then return 1 end
	return g:GetCount()
end