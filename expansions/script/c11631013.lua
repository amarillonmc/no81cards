--专业药剂师 隆
local m=11631013
local cm=_G["c"..m]
--strings
function cm.initial_effect(c)
	--draw  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)	 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)  
	--change effect  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)  
	e3:SetCondition(cm.chcon)
	e3:SetTarget(cm.chtg)  
	e3:SetOperation(cm.chop)  
	c:RegisterEffect(e3)  
	--activate from hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.actfilter)  
	e4:SetTargetRange(LOCATION_HAND,0)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e5) 
end

--draw
function cm.filter(c)  
	return c:IsSetCard(0x5221) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsForbidden() 
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
		if g:GetCount()>0  then 
			Duel.SSet(tp,g,1-tp)
			Duel.ShuffleDeck(tp)
		end
	end  
end  
--change effect
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x5221) and rp==1-tp  
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end 
end  
function cm.chop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,g)  
	Duel.ChangeChainOperation(ev,cm.repop)  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Draw(1-tp,1,REASON_EFFECT)
end  
--act in hand
function cm.actfilter(e,c)
	return c:IsSetCard(0x5221) and c:IsPublic()
end