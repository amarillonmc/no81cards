local m=82224064
local cm=_G["c"..m]
cm.name="秘旋谍-致命玫瑰"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,cm.matfilter,1,1)  
	c:EnableReviveLimit()
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.tgcon) 
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)  
	e1:SetOperation(cm.tgop)  
	c:RegisterEffect(e1)  
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetValue(cm.indval)  
	c:RegisterEffect(e3) 
end
function cm.matfilter(c)  
	return c:IsSetCard(0xee) and not c:IsCode(m)
end  
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.tgfilter(c)  
	return c:IsSetCard(0xee) and c:IsAbleToGrave()  
end  
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)  
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)  
end  
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)  
	e:SetLabel(Duel.AnnounceType(tp))
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end  
	Duel.ConfirmDecktop(1-tp,1)  
	local g=Duel.GetDecktopGroup(1-tp,1)  
	local tc=g:GetFirst()  
	local opt=e:GetLabel()  
	if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)  
		if g:GetCount()>0 then  
			Duel.SendtoGrave(g,REASON_EFFECT)  
		end
	end
end
function cm.indval(e,c)  
	return not c:IsType(TYPE_LINK)  
end  