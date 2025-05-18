--拿来吧你
function c60158212.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158212,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,60158212)
	e1:SetTarget(c60158212.e1tg)
	e1:SetOperation(c60158212.e1op)
	c:RegisterEffect(e1)
	
	--2xg
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(60158212,1))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	--e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1)
	--e2:SetCode(EVENT_CHAINING)
	--e2:SetCondition(c60158212.e2con)
	--e2:SetTarget(c60158212.e2tg)
	--e2:SetOperation(c60158212.e2op)
	--c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158212,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c60158212.discon)
	e3:SetOperation(c60158212.disop)
	c:RegisterEffect(e3)
end

	--1xg
function c60158212.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c60158212.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,2)~=0 then
		local reset=RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END+RESET_OPPO_TURN
		--[[
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(reset)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e2:SetReset(reset)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		]]
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(60158212,2))
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(reset)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(60158101)
		e4:SetReset(reset)
		tc:RegisterEffect(e4)
		--cannot link material
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e5:SetValue(c60158212.lmlimit)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
	end
end
function c60158212.lmlimit(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end

	--2xg
function c60158212.e2con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler()~=e:GetHandler()
end
function c60158212.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=eg:GetFirst()
	local sccode=sc:GetOriginalCode()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER) 
			and not (sc:IsLocation(LOCATION_MZONE) or sc:IsLocation(LOCATION_DECK) or sc:IsLocation(LOCATION_HAND))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
end
function c60158212.e2op(e,tp,eg,ep,ev,re,r,rp)
	local sc=eg:GetFirst()
	local sccode=sc:GetOriginalCode()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER) then return end
	if (sc:IsLocation(LOCATION_MZONE) or sc:IsLocation(LOCATION_DECK) or sc:IsLocation(LOCATION_HAND)) then return end
	if sc:IsType(TYPE_SPELL) then 
		sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500) 
	elseif sc:IsType(TYPE_TRAP) then
		sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500)
	else
		return false 
	end
	sc:CancelToGrave()
	Duel.SpecialSummon(sc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(60158212,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(60158101)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(c60158212.lmlimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e2)
end


function c60158212.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local sc=re:GetHandler()
	local sccode=sc:GetOriginalCode()
	return sc~=e:GetHandler() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetFlagEffect(60158212)<=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER) 
			and not (sc:IsLocation(LOCATION_MZONE) or sc:IsLocation(LOCATION_DECK) or sc:IsLocation(LOCATION_HAND))
			
end
function c60158212.disop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local sc=re:GetHandler()
	local sccode=sc:GetOriginalCode()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER) and not (sc:IsLocation(LOCATION_MZONE) or sc:IsLocation(LOCATION_DECK) or sc:IsLocation(LOCATION_HAND)) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(60158212,4)) then
		if sc:IsType(TYPE_SPELL) then 
			sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500) 
		elseif sc:IsType(TYPE_TRAP) then
			sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500)
		else
			return false 
		end
		Duel.Hint(HINT_CARD,0,60158212)
		if Duel.SpecialSummon(sc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP) then
			--
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(60158212,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(60158101)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			--cannot link material
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2:SetValue(c60158212.lmlimit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			e:GetHandler():RegisterFlagEffect(60158212,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60158212,5))
		end
	end
end