--VOICEROID 葵
if not pcall(function() require("expansions/script/c33700784") end) then require("script/c33700784") end
local m=33700785
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.lfilter,2,2)
	c:EnableReviveLimit()
	--extra link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTarget(cm.mattg)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)  
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c,tp,setable)
	return c:IsType(TYPE_SPELL) and (c:IsAbleToHand() or (setable and c:IsSSetable())) and (c:IsControler(tp) or setable)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetMutualLinkedGroup()
	local setable=g:IsExists(Card.IsCode,1,nil,m-1) and true or false 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc,tp,setable) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp,setable) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp,setable)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=e:GetHandler():GetMutualLinkedGroup()
	local setable=g:IsExists(Card.IsCode,1,nil,m-1) and true or false 
	local b1=tc:IsAbleToHand()
	local b2=e:GetHandler():IsRelateToEffect(e) and setable and tc:IsAbleToHand()
	if not b1 and not b2 then return end
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SSet(tp,tc)
	end
end
function cm.lfilter(c)
	return c:IsLinkRace(RACE_CYBERSE+RACE_MACHINE) or c:IsType(TYPE_SPELL)
end
function cm.matval(e,c,mg)
	return c:IsCode(m)
end
function cm.mattg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end