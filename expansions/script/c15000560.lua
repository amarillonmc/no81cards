local m=15000560
local cm=_G["c"..m]
cm.name="镜舞台"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.acop)
	c:RegisterEffect(e0)
	--cannot mset
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	c:RegisterEffect(e3)
	--force zone
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_USE_MZONE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetValue(0x600060)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e5:SetRange(LOCATION_FZONE)  
	e5:SetCode(EVENT_ADJUST)
	e5:SetCondition(cm.tkcon) 
	e5:SetOperation(cm.tkop)  
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(cm.damcon)
	e6:SetOperation(cm.damop)
	c:RegisterEffect(e6)
	--Damage
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(cm.dam2con)
	e7:SetTarget(cm.dam2tg)
	e7:SetOperation(cm.dam2op)
	c:RegisterEffect(e7)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_RULE)
	end
end
function cm.splimit(e,c)
	if c:IsCode(15000561) then return false end
	if c:IsLocation(LOCATION_EXTRA) then return false end
	return true
end
function cm.ntkfilter(c)
	return c:GetSequence()<5 and not c:IsCode(15000561)
end
function cm.mrfilter(c,tp)
	return c:GetSequence()<5 and not Duel.IsExistingMatchingCard(cm.mrfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function cm.mrfilter2(c,sc,tp)
	return c:GetSequence()<5 and c:GetColumnGroup():IsContains(sc) and c:GetControler()==tp
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.mrfilter,tp,0,LOCATION_MZONE,1,nil,tp) or Duel.IsExistingMatchingCard(cm.ntkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ag=Duel.GetMatchingGroup(cm.mrfilter,tp,0,LOCATION_MZONE,nil,tp)
	local tc=ag:GetFirst()
	while tc do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,15000561,nil,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then
			Duel.HintSelection(Group.FromCards(tc))
			local code=15000561
			local zone=tc:GetColumnZone(LOCATION_MZONE,tp)
			local pos=tc:GetPosition()
			if pos==POS_FACEDOWN_DEFENSE then pos=POS_FACEUP_DEFENSE end
			local token=Duel.CreateToken(tp,code)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,pos,zone) then
				--atkdef
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)  
				e1:SetRange(LOCATION_MZONE)  
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(cm.atkval)  
				e1:SetLabelObject(tc)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)  
				e2:SetRange(LOCATION_MZONE)  
				e2:SetCode(EFFECT_SET_DEFENSE)
				e2:SetValue(cm.defval)  
				e2:SetLabelObject(tc)
				token:RegisterEffect(e2)
				--ChangePosition
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
				e3:SetRange(LOCATION_MZONE)  
				e3:SetCode(EVENT_ADJUST)
				e3:SetCondition(cm.cpcon)
				e3:SetOperation(cm.cpop) 
				token:RegisterEffect(e3)
				--Destroy
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
				e4:SetRange(LOCATION_MZONE)  
				e4:SetCode(EVENT_ADJUST)
				e4:SetCondition(cm.descon)
				e4:SetOperation(cm.desop) 
				token:RegisterEffect(e4)
				Duel.SpecialSummonComplete()
			end
		end
		tc=ag:GetNext()
	end
end
function cm.atkval(e,c)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() then return 0 end
	return tc:GetAttack()
end
function cm.defval(e,c)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() then return 0 end
	return tc:GetDefense()
end
function cm.cpfilter(c,sc)
	return c:GetSequence()<5 and c:GetColumnGroup():IsContains(sc) and c:GetPosition()~=sc:GetPosition()
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cpfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=Duel.GetMatchingGroup(cm.cpfilter,tp,0,LOCATION_MZONE,nil,c):GetFirst()
	if tc then
		local pos=tc:GetPosition()
		if tc:IsPosition(POS_FACEDOWN_DEFENSE) then pos=POS_FACEUP_DEFENSE end
		if pos==c:GetPosition() then return end
		Duel.ChangePosition(c,pos)
	end
end
function cm.desfilter(c,sc)
	return c:GetSequence()<5 and c:GetColumnGroup():IsContains(sc)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil,c)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Destroy(c,REASON_RULE)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,15000561)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function cm.dam2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.dam2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,15000561) end
	local p=PLAYER_ALL
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,15000561)
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(g:GetCount()*1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,g:GetCount()*1000)
end
function cm.dam2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,15000561)
	if g:GetCount()~=0 then
		local x=Duel.Destroy(g,REASON_EFFECT)

if Duel.GetLP(1-tp)<x*1000 and Duel.GetLP(tp)>x*1000 then
	Duel.RegisterFlagEffect(tp,15000560,RESET_PHASE+PHASE_END,0,1)
	Debug.Message("会被刺痛的手臂，还有什么资格谈论守护......")
end

		Duel.Damage(tp,x*1000,REASON_EFFECT,true)
		Duel.Damage(1-tp,x*1000,REASON_EFFECT,true)
		Duel.RDComplete()

if Duel.GetLP(1-tp)>0 and Duel.GetLP(tp)>0 and Duel.GetFlagEffect(tp,15000560)~=0 then
	Duel.ResetFlagEffect(tp,15000560)
	Debug.Message("我会重铸镜门，来看清一万个破碎的未来......")
end

	end
end