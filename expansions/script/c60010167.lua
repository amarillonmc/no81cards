--星-存护-
local cm,m,o=GetID()
function cm.initial_effect(c)
	for i=0,0xffff do
		c:EnableCounterPermit(i,LOCATION_ONFIELD)
	end
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--target/atk protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(cm.atcon)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.atcon)
	e3:SetTarget(cm.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(cm.checkcon)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.cgop)
	c:RegisterEffect(e1)
end
if not cm.preservationcheck then
	cm.lastcounter=0
	cm.counterchange=0
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local ph=Duel.GetCurrentPhase()
	local counternum=0 
	for i=0,0xffff do
		counternum=counternum+Duel.GetCounter(p,LOCATION_ONFIELD,0,i)
	end
	e:SetLabel(counternum)
	return cm.lastcounter~=counternum and not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local counternum=e:GetLabel()
	cm.counterchange=math.abs(cm.lastcounter-counternum)
	cm.lastcounter=counternum
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,p,p,0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>=5 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(cm.levelchangecon)
		e1:SetOperation(cm.levelchangeop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)

		for i=0,0xffff do
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetRange(LOCATION_MZONE)
			e0:SetCode(EVENT_ADJUST)
			e0:SetLabel(i)
			e0:SetCondition(cm.countercon)
			e0:SetOperation(cm.counterop)
			e0:SetReset(RESET_EVENT+0xff0000)
			c:RegisterEffect(e0)
		end
	end
end
function cm.levelchangecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return c:GetLevel()~=math.min(Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil),13) and not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
end
function cm.levelchangeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=math.min(Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil),13)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function cm.countercon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local i=e:GetLabel()
	local ph=Duel.GetCurrentPhase()
	local tf=false
	if Duel.GetCounter(tp,LOCATION_ONFIELD,0,i)~=c:GetCounter(i) and c:GetCounter(i)~=c:GetLevel() and Duel.GetCounter(tp,LOCATION_ONFIELD,0,i)~=0 then
		tf=true
	end
	return tf and not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
end
function cm.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local i=e:GetLabel()

	local lv=c:GetLevel()
	local ct=c:GetCounter(i)
	if ct>lv then
		c:RemoveCounter(tp,i,ct-lv,REASON_RULE)
	elseif ct<lv then
		c:AddCounter(i,lv-ct)
		Debug.Message(i)
	end
	
end
function cm.atcon(e)
	return e:GetHandler():GetDefense()~=0
end
function cm.atlimit(e,c)
	return c~=e:GetHandler()
end
function cm.tglimit(e,c)
	return c~=e:GetHandler()
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.counterchange*400)
	c:RegisterEffect(e1)
	Duel.Recover(tp,cm.counterchange*400,REASON_EFFECT)
end










