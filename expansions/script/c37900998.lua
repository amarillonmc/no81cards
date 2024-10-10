--「人神一体」·结城友奈
function c37900998.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c37900998.con)
	e1:SetOperation(c37900998.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37900998,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c37900998.con2)
	e2:SetValue(c37900998.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,37900998)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c37900998.tg3)
	e3:SetOperation(c37900998.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)	
	e4:SetCondition(c37900998.con4)
	e4:SetTarget(c37900998.tg4)
	e4:SetOperation(c37900998.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c37900998.val5)
	c:RegisterEffect(e5)
	if not c37900998_atk then
		c37900998_atk=true
		c37900998_dam = {}
		c37900998_dam[0] = 0 
		c37900998_dam[1] = 0
		c37900998_SetLP = Duel["SetLP"]
		Duel["SetLP"] = 
			function (player,lp)
				local x = Duel.GetLP(player)
				if lp < x then
				c37900998_dam[player] = c37900998_dam[player] + ( x - lp )
				end
					if Duel.GetFlagEffect(player,37900998)>0 and ( x - lp ) > 0 then
					Duel.Hint(2,1-player,aux.Stringid(37900998,6))
					Duel.Hint(2,1-player,aux.Stringid(37900998,7))
					end
				return c37900998_SetLP(player,lp)
			end
		c37900998_PayLPCost	 = Duel["PayLPCost"]	
		Duel["PayLPCost"] = 
			function (player,lp)
				c37900998_dam[player] = c37900998_dam[player] + lp 
					if Duel.GetFlagEffect(player,37900998)>0 and lp > 0 then
					Duel.Hint(2,1-player,aux.Stringid(37900998,6))
					Duel.Hint(2,1-player,aux.Stringid(37900998,7))
					end
				return c37900998_PayLPCost(player,lp)
			end
		c37900998_Damage = Duel["Damage"]	
		Duel["Damage"] = 
			function (player,value,reason,...)
				c37900998_dam[player] = c37900998_dam[player] + value 
					if Duel.GetFlagEffect(player,37900998)>0 and value > 0 then
					Duel.Hint(2,1-player,aux.Stringid(37900998,6))
					Duel.Hint(2,1-player,aux.Stringid(37900998,7))
					end
				return c37900998_Damage(player,value,reason,...)
			end		
	end
end
function c37900998.q(c,tp)
	return c:IsAbleToRemoveAsCost(tp,POS_FACEDOWN)
end
function c37900998.con(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c37900998.q,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	local all=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	return lp2>lp1 and (lp2-lp1)>=4000 and #g>0 and #g==#all and Duel.GetLocationCountFromEx(tp,tp,g,c)>0	
end
function c37900998.w(c)
	return c:IsLocation(LOCATION_HAND) and not c:IsPublic()
end
function c37900998.e(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown()
end
function c37900998.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c37900998.q,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	local all=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0)
	local conf1=g:Filter(c37900998.w,nil)
	local conf2=g:Filter(c37900998.e,nil)
	if #conf1>0 then
	Duel.ConfirmCards(1-tp,conf1)
	end
	if #conf2>0 then
	Duel.ConfirmCards(1-tp,conf2)
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	if Duel.GetFlagEffect(player,37900998)==0 then
	Duel.RegisterFlagEffect(tp,37900998,0,0,0)
	end
end
function c37900998.con2(e)
	return e:GetHandler():GetSequence()>4
end
function c37900998.val2(e,te)
	return not (te:GetOwner():IsType(TYPE_SYNCHRO) and te:GetOwner():IsFaceup()) or not te:GetOwner()==e:GetHandler()
end
function c37900998.r(c,sc)
	return (c:GetAttack()>sc:GetAttack() or c:GetAttack()<sc:GetAttack()) and c:IsFaceup()
end
function c37900998.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c37900998.r,tp,0,4,1,nil,c) end
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c37900998.r,tp,0,4,1,1,nil,c)
	Duel.Hint(2,1-tp,aux.Stringid(37900998,1))
	Duel.Hint(2,1-tp,aux.Stringid(37900998,2))
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(c:GetAttack()-g:GetFirst():GetAttack()))
end
function c37900998.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
	local x=math.abs(c:GetAttack()-tc:GetAttack())
	if x==0 then return end
	Duel.Damage(1-tp,x,REASON_EFFECT)
	end
end
function c37900998.con4(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c37900998.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(2,1-tp,aux.Stringid(37900998,3))
	Duel.Hint(2,1-tp,aux.Stringid(37900998,4))
	Duel.Hint(2,1-tp,aux.Stringid(37900998,5))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c37900998.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,4)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900998.val5(e)
	return c37900998_dam[e:GetHandlerPlayer()]
end