local m=33700650
local cm=_G["c"..m]

sr_ptsh=sr_ptsh or {}
sr_ptsh.loaded_metatable_list={}

function sr_ptsh.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=sr_ptsh.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			sr_ptsh.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end

function sr_ptsh.check_set(c,setcode,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=sr_ptsh.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
function sr_ptsh.check_set_ptsh(c)  --破天神狐
	return sr_ptsh.check_set(c,"ptsh")
end
--
function sr_ptsh.Cmeffect(c,code)
	--special summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetRange(0x3ff)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(sr_ptsh.limitfilter,code))
	c:RegisterEffect(e1)
	
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_MONSTER_SSET)
	e11:SetValue(TYPE_SPELL)
	c:RegisterEffect(e11)
	return e1 and e11
end
function sr_ptsh.limitfilter(c,code)  --破天神狐
	return c:IsCode(code)
end
function sr_ptsh.efeffect(c,cod,cate,code,pro)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(cod,0))
	e2:SetCategory(cate)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetCode(code)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	if pro then
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+pro)
	end
	e2:SetCost(sr_ptsh.cost)
	if c.condition then
		e2:SetCondition(c.condition)
	end
	e2:SetTarget(c.target)
	e2:SetOperation(c.operation)
	c:RegisterEffect(e2)
	return e2
end
function sr_ptsh.opeffect(c,code,cate)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCost(sr_ptsh.cost)
	e1:SetCondition(sr_ptsh.opcon)
	e1:SetTarget(sr_ptsh.optg)
	e1:SetOperation(sr_ptsh.opop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(code,2))
	e2:SetCategory(cate)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(sr_ptsh.cost)
	e2:SetCondition(sr_ptsh.opcon1)
	e2:SetTarget(sr_ptsh.optg1)
	e2:SetOperation(sr_ptsh.opop1)
	c:RegisterEffect(e2)
	return e1 and e2
end
function sr_ptsh.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and aux.exccon(e) end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	c:CreateEffectRelation(e)
	c:CancelToGrave(false)
	c:RegisterFlagEffect(m,RESET_EVENT+EVENT_CHAIN_END,0,1)
end
function sr_ptsh.opcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function sr_ptsh.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local c=e:GetHandler()
	c:CancelToGrave(true)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function sr_ptsh.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function sr_ptsh.opcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function sr_ptsh.opop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave(true)
end
function sr_ptsh.optg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
--  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	c:RegisterEffect(e2)
	--remain field
	if c.geteffect then 
	   c.geteffect(e,tp,eg,ep,ev,re,r,rp)
	end
end
if not cm then return end
cm.named_with_ptsh=true
--破天神狐 捌〇〇·六五七三七五七九
function cm.initial_effect(c)
	local e1=sr_ptsh.Cmeffect(c,m)
	
	local e2=sr_ptsh.efeffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES,EVENT_TO_HAND)

	local e3=sr_ptsh.opeffect(c,m)

end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not ep or not eg then return false end
	return  eg:IsExists(cm.cfilter,1,nil,1-tp) and r==REASON_EFFECT and Duel.GetTurnPlayer()==1-tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local cc=eg:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,cc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.ffilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local sg=eg:Filter(cm.ffilter,nil,e,1-tp)
	if sg:GetCount()==0 then
	else
	   local c=e:GetHandler()
	   if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)~=0 and c:IsRelateToEffect(e) then
		   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
function cm.geteffect(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return sr_ptsh.check_set_ptsh(c) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end