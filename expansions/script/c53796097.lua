local m=53796097
local cm=_G["c"..m]
cm.name="博士外星人"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return (c:IsRace(RACE_REPTILE) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsSetCard(0xc)
end
function cm.spfilter(c)
	return c:IsFaceup() and c:GetCounter(0x100e)>0 and c:IsControlerCanBeChanged()
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local le={tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
	for _,v in pairs(le) do
		local val=v:GetValue()
		v:SetValue(cm.chval(val,e))
	end
	if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_REPTILE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e2,tp)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not ((c:IsRace(RACE_REPTILE) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsSetCard(0xc))
end
function cm.chval(_val,ce)
	return function(e,te)
				if te==ce then return false end
				return _val(e,te)
			end
end
function cm.tgfilter(c,tp)
	return (c:GetOwner()~=tp or c:IsSetCard(0xc)) and c:IsAbleToGraveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thfilter(c)
	return aux.IsCounterAdded(c,0x100e) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
