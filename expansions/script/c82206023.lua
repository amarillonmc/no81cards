local m=82206023
local cm=_G["c"..m]
cm.name="植占师3-棱镜"
function cm.initial_effect(c) 
	--pendulum summon  
	aux.EnablePendulumAttribute(c)  
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1)  
	--atkdown  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetTargetRange(0,LOCATION_MZONE)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))  
	e2:SetValue(-800)  
	c:RegisterEffect(e2)  
	--defdown 
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)
	--send to grave  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tgtg)  
	e4:SetOperation(cm.tgop)  
	c:RegisterEffect(e4)	
	local e5=e4:Clone()  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e5)  
	--atkup
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE)  
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCode(EFFECT_UPDATE_ATTACK)  
	e6:SetValue(cm.value)  
	c:RegisterEffect(e6)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end  
function cm.tgfilter(c)  
	return c:IsLevelBelow(3) and c:IsRace(RACE_PLANT) and c:IsAbleToGrave() and not c:IsCode(m)  
end  
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300) 
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then 
		if Duel.SendtoGrave(g,REASON_EFFECT) then
			Duel.Damage(1-tp,300,REASON_EFFECT)
		end
	end  
end  
function cm.atkfilter(c)  
	return c:GetSequence()<5 and c:IsSetCard(0x29d)  
end
function cm.value(e,c)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_SZONE,0,nil)*500  
end  