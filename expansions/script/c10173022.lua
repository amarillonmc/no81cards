--神奇小兔
function c10173022.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173022,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10173022)
	e1:SetCondition(c10173022.condition)
	e1:SetCost(c10173022.cost)
	e1:SetTarget(c10173022.target)
	e1:SetOperation(c10173022.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(10173022,ACTIVITY_SPSUMMON,c10173022.counterfilter)
end
function c10173022.counterfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c10173022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10173022,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10173022.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10173022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10173022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10173022.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c10173022.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local t={}
	local p=g:GetFirst():GetLevel()-1
	p=math.min(p,3)
	for i=1,p do
		t[i]=i
	end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c10173022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_UPDATE_LEVEL)
	   e1:SetValue(e:GetLabel()*-1)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_SYNCHRO_MATERIAL)
	   e2:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e2)	   
	end
end
function c10173022.filter(c)
	return c:GetLevel()>=2 and c:IsFaceup() and c:IsCanBeSynchroMaterial()
end
function c10173022.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c10173022.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO 
end