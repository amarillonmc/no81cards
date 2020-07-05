local m=82206046
local cm=_G["c"..m]
cm.name="植占师26-幽灵"
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
	--lv change  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_PZONE) 
	e2:SetCountLimit(2,m)
	e2:SetTarget(cm.tg)  
	e2:SetOperation(cm.op)  
	c:RegisterEffect(e2)   
	--spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_SUMMON_SUCCESS)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e3:SetTarget(cm.target)  
	e3:SetOperation(cm.operation)  
	c:RegisterEffect(e3)
	--indestructable  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e4:SetValue(cm.indval)  
	c:RegisterEffect(e4)	
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end  
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:GetLevel()>0  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)  
	local lv=g:GetFirst():GetLevel()  
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)  
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_LEVEL)  
		e1:SetValue(e:GetLabel())  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end  
function cm.spfilter(c,e,tp)  
	return c:IsLevelBelow(4) and c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  
function cm.indval(e,c)  
	return c:IsRace(RACE_ZOMBIE)
end  