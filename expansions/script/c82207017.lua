local m=82207017
local cm=_G["c"..m]
cm.name="蓝悠悠"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,cm.matfilter,2,2,cm.lcheck)  
	c:EnableReviveLimit()
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetCode(aux.indoval)
	c:RegisterEffect(e4)  
	local e5=e3:Clone()   
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)  
	c:RegisterEffect(e5)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m) 
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
end
function cm.matfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkCode,1,nil,27288416)  
end  
function cm.cfilter(c)  
	return c:IsFacedown() or not (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT))  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end
function cm.spfilter(c,e,tp)  
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetValue(cm.actlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
end  
function cm.actlimit(e,re,rp)  
	local rc=re:GetHandler()  
	return re:IsActiveType(TYPE_MONSTER) and not (rc:IsAttribute(ATTRIBUTE_LIGHT) and rc:IsRace(RACE_FAIRY)) 
end  