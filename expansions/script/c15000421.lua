local m=15000421
local cm=_G["c"..m]
cm.name="神见雪辉缄默城·米拉玻莉亚兹"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000400)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,15000400,aux.FilterBoolFunction(Card.IsLevelBelow,7),1,false,false)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--destroy & damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ATKCHANGE) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP) 
	e3:SetCondition(cm.atkcon2)
	e3:SetOperation(cm.atkop2)  
	c:RegisterEffect(e3)
end
function cm.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function cm.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(200)
	c:RegisterEffect(e1,true)
end
function cm.cfilter(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function cm.atkcon(e)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if chk==0 then return true end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local atkval=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(atkval)
	c:RegisterEffect(e1,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if chk==0 then 
		if c:GetAttack()>=1500 and c:GetFlagEffect(15010421)==0 then 
			local x=c:GetAttack()
			while x>1500 do
				c:RegisterFlagEffect(15010421,RESET_CHAIN,0,1)
				x=x-1500
			end
		end
		return Duel.GetFlagEffect(tp,15000421)<Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil) and c:GetFlagEffect(15010421)>c:GetFlagEffect(15020421)
	end
	Duel.RegisterFlagEffect(tp,15000421,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(15020421,RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if c:GetAttack()<1500 then return end
	local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if tc then
		local atkval=c:GetAttack()-1500
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atkval)
		c:RegisterEffect(e1,true)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end