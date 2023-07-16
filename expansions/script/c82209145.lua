--元素太阳 赫利俄斯
local m=82209145
local cm=c82209145
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,cm.mfilter,1)  
	c:EnableReviveLimit() 
	--atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)  
	e1:SetRange(LOCATION_MZONE)	 
	e1:SetValue(1)
	c:RegisterEffect(e1)  
	--cannot to deck  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_REMOVE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,1)  
	e2:SetTarget(cm.tdtg)  
	c:RegisterEffect(e2)  
	--return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.mfilter(c)  
	return c:IsLevelAbove(4) and c:IsLinkRace(RACE_PYRO) and c:IsLinkAttribute(ATTRIBUTE_LIGHT)  
end  
function cm.tdtg(e,c)  
	return c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(6) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()  
end  
function cm.confilter(c)
	return c:IsCode(30241314) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToHand() and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.sumfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSummonable(true,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local sg=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end
end


