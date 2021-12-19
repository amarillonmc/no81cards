--死者的舞台
local m=71100100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--accumulate
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(0x10000000+m)
	e00:SetRange(LOCATION_FZONE)
	e00:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e00:SetTargetRange(1,1)
	c:RegisterEffect(e00)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.ctop)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--cannot set/activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.setlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)
	--counter  
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_COUNTER) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e4:SetOperation(cm.ctop2)  
	c:RegisterEffect(e4)
	local e5=Effect.Clone(e4)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.Clone(e4)
	e6:SetCode(EVENT_FLIP)
	c:RegisterEffect(e6)
	--attack limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetValue(cm.atlimit)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e8:SetTarget(cm.eftg)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
	--attack cost
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ATTACK_COST)
	e9:SetCost(cm.atcost)
	e9:SetOperation(cm.atop)
	local e91=Effect.CreateEffect(c)
	e91:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e91:SetRange(LOCATION_FZONE)
	e91:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e91:SetTarget(cm.eftg)
	e91:SetLabelObject(e9)
	c:RegisterEffect(e91)
	--activate cost
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_ACTIVATE_COST)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,1)
	e10:SetTarget(cm.actarget)
	e10:SetCost(cm.costchk)
	e10:SetOperation(cm.costop)
	c:RegisterEffect(e10)
	--move
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,0))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_FZONE)
	e11:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e11:SetTarget(cm.mvtg)
	e11:SetOperation(cm.mvop)
	c:RegisterEffect(e11)
	--counter
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,2))
	e12:SetCategory(CATEGORY_COUNTER)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_FZONE)
	e12:SetCondition(cm.condition)
	e12:SetTarget(cm.target)
	e12:SetOperation(cm.ctop)
	c:RegisterEffect(e12)
end
function cm.ctfilter(c)  
	return c:IsFaceup()
end 
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	local tc=g:GetFirst()  
	while tc do 
			if tc:GetLevel()~=0 then
				local x=tc:GetLevel()
				if x<=4 then x=4 end
				tc:AddCounter(0x17d7,x)
			end
			if tc:IsType(TYPE_XYZ) then
				local y=tc:GetRank()
				if y<=4 then y=4 end
				tc:AddCounter(0x17d7,y)
			end
			if tc:IsType(TYPE_LINK) then
				local z=tc:GetLink()*2
				if z<=4 then z=4 end
				tc:AddCounter(0x17d7,z)
			end
		tc=g:GetNext()  
	end
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp) 
	local tc=eg:GetFirst()  
	while tc do 
			if tc:GetLevel()~=0 then
				local x=tc:GetLevel()
				if x<=4 then x=4 end
				tc:AddCounter(0x17d7,x)
			end
			if tc:IsType(TYPE_XYZ) then
				local y=tc:GetRank()
				if y<=4 then y=4 end
				tc:AddCounter(0x17d7,y)
			end
			if tc:IsType(TYPE_LINK) then
				local z=tc:GetLink()*2
				if z<=4 then z=4 end
				tc:AddCounter(0x17d7,z)
			end
		tc=eg:GetNext()  
	end  
end
function cm.atlimit(e,c)
	return not c:GetColumnGroup():IsContains(e:GetHandler())
end
function cm.eftg(e,c)
	return true
end
function cm.atcost(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	local c=e:GetHandler()
	return c:IsCanRemoveCounter(tp,0x17d7,2*ct,REASON_COST)
end
function cm.attarget(e,te,tp)
	Debug.Message(1)
	e:SetLabelObject(c)
	return c:IsFaceup()
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x17d7,2,REASON_COST)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te:GetHandler())
	return not te:GetHandler():IsSetCard(0x7d8) and te:GetHandler():IsType(TYPE_MONSTER) and te:GetHandler():IsLocation(LOCATION_MZONE)
end
function cm.costchk(e,te,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	local tc=te:GetHandler()
	return tc:IsCanRemoveCounter(tp,0x17d7,2*ct,REASON_COST)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	tc:RemoveCounter(tp,0x17d7,2,REASON_COST)
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.mvfilter(c)
	return c:IsFaceup() and c:IsCanRemoveCounter(tp,0x17d7,4,REASON_COST)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local tc=Duel.SelectTarget(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	tc:RemoveCounter(tp,0x17d7,4,REASON_COST)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCondition(cm.limitcon)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
end
function cm.limitcon(e,tp)
	return Duel.GetCurrentChain()<1
end
function cm.addfilter(c)
	return c:GetCounter(0x17d7)>0 and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.addfilter1(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x17d7,c:GetRace()+c:GetLevel()+c:GetLink()*2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local gn=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local agn=Duel.GetMatchingGroupCount(cm.addfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return gn==agn and gn>0 end
end