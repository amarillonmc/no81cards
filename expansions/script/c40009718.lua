--狂风剑刃·探索者&探索者 圣星温加尔
local m=40009718
local cm=_G["c"..m]
cm.named_with_Seeker=1
function cm.initial_effect(c)
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetValue(cm.attval)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetValue(cm.raval)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetValue(cm.leval)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_CODE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetValue(cm.codeval)
	c:RegisterEffect(e5)
	--Attribute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_COPY_INHERIT)
	e7:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e7)
	--code
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetCode(EFFECT_CHANGE_CODE)
	--e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetValue(cm.codeval)
	--c:RegisterEffect(e5)
	--spsum success
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(cm.gete)
	c:RegisterEffect(e6)
	--defense attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e8)
	--switch stats
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
	e9:SetCode(EVENT_BATTLE_CONFIRM)
	e9:SetCondition(cm.adcon)
	e9:SetOperation(cm.adop)
	c:RegisterEffect(e9)
	--destroy replace
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_SEND_REPLACE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTarget(cm.reptg)
	c:RegisterEffect(e10)
	--effect gian
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_ADJUST)
	e11:SetRange(LOCATION_MZONE)
	e11:SetOperation(cm.efop)
	c:RegisterEffect(e11) 
-----------------------------------------[yi shang shi shuangdou guize]
	--spsummon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,0))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetTarget(cm.sptg)
	e12:SetOperation(cm.spop)
	c:RegisterEffect(e12)
	--extra attack
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_EXTRA_ATTACK)
	e14:SetValue(1)
	c:RegisterEffect(e14)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT+REASON_RELEASE) and not c:IsReason(REASON_REPLACE) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_EFFECT)
	return true
end
function cm.adcon(e)
	local c=e:GetHandler()
	return Duel.GetAttackTarget()==c
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		c:RegisterEffect(e2)
	end
end
function cm.effilter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(cm.effilter,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return att
end
function cm.raval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(cm.effilter,nil)
	local wbc=wg:GetFirst()
	local ra=0
	while wbc do
		ra=ra|wbc:GetRace()
		wbc=wg:GetNext()
	end
	return ra
end
function cm.codeeffilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(40009713)
end
function cm.codeval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(cm.codeeffilter,nil)
	local wbc=wg:GetFirst()
	local code=0
	while wbc do
		code=code|wbc:GetCode()
		wbc=wg:GetNext()
	end
	return code
end
function cm.atkfilter(c)
	return c:GetAttack()>=0
end
function cm.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function cm.lefilter(c)
	return c:GetLevel()>0
end
function cm.leval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.lefilter,nil)
	local tg,val=g:GetMaxGroup(Card.GetLevel)
	return val
end
function cm.gete(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.descon)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e6)
end
function cm.descon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ct=c:GetOverlayGroup(tp,1,0)
	local wg=ct:Filter(cm.effilter,nil,tp)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
		wbc=wg:GetNext()
	end  
end
------------------------------------------------------------
function cm.Seeker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Seeker
end
function cm.spfilter(c,e,tp)
	return cm.Seeker(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end