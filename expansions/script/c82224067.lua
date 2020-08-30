local m=82224067
local cm=_G["c"..m]
cm.name="极光歼星士"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),3,true)
	--direct attack  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_DIRECT_ATTACK)  
	e1:SetCondition(cm.dacon)  
	c:RegisterEffect(e1)
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)  
	e3:SetCost(cm.atkcost) 
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end  
function cm.costfilter(c)  
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsAbleToGraveAsCost()  
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local tg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()  
	e:SetLabel(tg:GetLink())
	Duel.SendtoGrave(tg,REASON_COST)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local atk=e:GetLabel()*1000
	if c:IsFaceup() and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(atk) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end  