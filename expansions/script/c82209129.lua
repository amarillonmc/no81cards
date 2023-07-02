--传马
local m=82209129
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.lcheck)  
	c:EnableReviveLimit()  
	--todeck  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.rmcon)  
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop) 
	c:RegisterEffect(e2)  
end
function cm.lcheck(g)  
	return g:IsExists(cm.matfilter,1,nil)  
end  
function cm.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.spfilter(c,e,p,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,p,false,false) and
	((c:IsLocation(LOCATION_HAND+LOCATION_DECK) and Duel.GetLocationCount(p,LOCATION_MZONE)>0)
	or
	(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(p,p,nil,c)>0))
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetCode()
		local p=tc:GetControler()
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.spfilter,p,0x43,0,1,nil,e,p,code) and Duel.SelectYesNo(p,aux.Stringid(m,1)) then
			local g=Duel.SelectMatchingCard(p,cm.spfilter,p,0x43,0,1,1,nil,e,p,code)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEUP)
			end
		end
	end
end