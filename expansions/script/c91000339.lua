--古战士暗蚀
function c91000339.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c91000339.filter,nil,nil,c91000339.matfilter,true) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,91000339)
	c:RegisterEffect(e1)  
	--draw
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)  end) 
	e2:SetTarget(c91000339.thtg) 
	e2:SetOperation(c91000339.thop) 
	c:RegisterEffect(e2)  
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e7:SetTarget(c91000339.sumlimit)
	c:RegisterEffect(e7)
	--Equip 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_RELEASE) 
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCountLimit(1,29100339) 
	e4:SetOperation(c91000339.riop) 
	c:RegisterEffect(e4)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000339.spccost)
	e0:SetOperation(c91000339.spcop)
	c:RegisterEffect(e0)   
	if not c91000339.global_check then
		c91000339.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000339.checkop)
		Duel.RegisterEffect(ge1,0)
	end   
end
c91000339.SetCard_Dr_AcWarrior=true 
function c91000339.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp, 91000339,RESET_PHASE+PHASE_END,0,0)  
	end  
end
function c91000339.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000339)==0 
end
function c91000339.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)  
	e2:SetValue(c91000339.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000339.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000339.filter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL)  
end
function c91000339.matfilter(c,e,tp,chk)
	return not chk or true 
end 

function c91000339.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c91000339.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c91000339.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function c91000339.filters(c)
	return c:IsFaceup()
end
function c91000339.riop(e,tp,eg,ep,ev,re,r,rp)
local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)   
local c=e:GetHandler()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local te=dg:Select(tp,1,1,nil)
	Duel.HintSelection(te)
	local tc=te:GetFirst()
	 Duel.Equip(tp,c,tc)
	if tc:IsFaceup() then
		--immune
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_EQUIP)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetValue(c91000339.efilter)
		c:RegisterEffect(e5)
		local e51=Effect.CreateEffect(c)
		e51:SetType(EFFECT_TYPE_EQUIP)
		e51:SetCode(EFFECT_CANNOT_TRIGGER)
		c:RegisterEffect(e51)
		if tc:IsControler(1-tp) then
			--control
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetCode(EFFECT_SET_CONTROL)
			e3:SetValue(c91000339.cval)
			c:RegisterEffect(e3)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(c91000339.eqlimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	else
		c:CancelToGrave(false)
	end
end
function c91000339.cval(e,c)
	return e:GetHandlerPlayer()
end
function c91000339.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c91000339.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c
end