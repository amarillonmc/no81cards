--焰之巫女 帕拉玛
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009792,"BlazeMaiden")
function cm.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(cm.ffilter),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)




	local e4 = rsef.FTF(c,EVENT_PHASE+PHASE_END,"tf",nil,"tg",nil,
		LOCATION_MZONE,cm.tgcon,nil,
		rsop.target({Card.IsAbleToGrave,"tg"},
		{cm.tffilter,"tf",LOCATION_GRAVE }),cm.tgop)
end

function cm.ffilter(c)
	return c:CheckSetCard("BlazeMaiden")
end

function cm.thfilter(c)
	return c:CheckSetCard("BlazeTalisman") and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function cm.tgcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.tgop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or Duel.SendtoGrave(c,REASON_EFFECT) <= 0 or not c:IsLocation(LOCATION_GRAVE) then return end
	rsop.SelectOperate("tf",tp,aux.NecroValleyFilter(cm.tffilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.tffilter(c,e,tp)
	return c:CheckSetCard("BlazeTalisman") and c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end