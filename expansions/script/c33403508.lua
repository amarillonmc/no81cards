--森罗万象第六十六乐章「实存相变移」
local m=33403508
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
 return Duel.GetFlagEffect(tp,33413501)<(Duel.GetFlagEffect(tp,33403501)/2+1)and Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
e:SetLabel(1)
 if chk==0 then return true end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349)and  not c:IsCode(33403500)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
 Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
	if e:GetLabel()==1 then 
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop2)
	e2:SetReset(RESET_EVENT+RESET_CHAIN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)   
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) 
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)   
	e:SetLabel(2)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x5349) and rp==tp
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local n1=Duel.GetFlagEffect(tp,33413501)
	local n2=Duel.GetFlagEffect(tp,33403501)
	local n3=Duel.GetFlagEffect(tp,m+20000)
	Duel.ResetFlagEffect(tp,33413501)
	Duel.ResetFlagEffect(tp,33403501)
	Duel.ResetFlagEffect(tp,m+20000)
	if n1>=2 then 
		for i=1,n1-1 do
		Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
		end 
	end
	if n2>=2 then
		for i=1,n2-1 do
		 Duel.RegisterFlagEffect(tp,33403501,0,0,0)
		end 
	end
	if n3>=2 then 
		for i=1,n3 do
		  Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)
		end 
	end 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if not Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	local tc1=g1:GetFirst()
	if Duel.GetControl(tc1,tp)==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToChangeControler,1-tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.GetControl(tc,tp)~=0 then
			--cannot be target
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e5:SetRange(LOCATION_MZONE)
			e5:SetTargetRange(LOCATION_MZONE,0)
			e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,33403500))
			e5:SetValue(aux.tgoval)
			tc:RegisterEffect(e5)
			local e2=e5:Clone()
			e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
			tc:RegisterEffect(e2)
		end
	else
			--cannot be target
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e5:SetRange(LOCATION_MZONE)
			e5:SetTargetRange(LOCATION_MZONE,0)
			e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,33403500))
			e5:SetValue(aux.tgoval)
			tc1:RegisterEffect(e5)
			local e2=e5:Clone()
			e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
			tc1:RegisterEffect(e2)
	end
end

function cm.filter(c)
	return c:IsFaceup() and c:IsCode(33403500)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end