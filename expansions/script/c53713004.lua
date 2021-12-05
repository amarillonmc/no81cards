local m=53713004
local cm=_G["c"..m]
cm.name="ALC之脑 TIS"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCIppa(c,m,2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.setfilter2(c)
	return c:IsCode(53713010) and c:IsSSetable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g1>0 then
		Duel.SSet(tp,g1)
	end
end
