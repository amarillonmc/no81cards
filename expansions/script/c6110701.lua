--剑装机岚执行者 #FEFDFC
local m=6110701
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--sum limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.chcon)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2) 
	--SearchCard
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_GRAVE)   
	e3:SetCountLimit(1,m+1000)  
	e3:SetCost(aux.bfgcost)   
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3) 
	--redirect  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e4:SetCondition(cm.recon)  
	e4:SetValue(LOCATION_REMOVED)  
	c:RegisterEffect(e4) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x632,TYPES_EFFECT_TRAP_MONSTER,1800,0,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x632,TYPES_EFFECT_TRAP_MONSTER,1800,0,4,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP)  then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.splimit(e,c)  
	return not c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end  
function cm.thfilter(c,e,tp)  
	return c:IsSetCard(0x631) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,te,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end