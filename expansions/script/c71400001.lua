--梦见
	yume=yume or {}
	yume.temp_card_field=yume.temp_card_field or {}
if c71400001 then
function c71400001.initial_effect(c)
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400001,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(yume.nonYumeCon)
	e1:SetTarget(yume.YumeFieldCheckTarget(0,1))
	e1:SetCost(c71400001.cost)
	e1:SetOperation(c71400001.activate1)
	e1:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400001,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(yume.YumeCon)
	e2:SetTarget(c71400001.target2)
	e2:SetCost(c71400001.cost)
	e2:SetOperation(c71400001.activate2)
	e2:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
end
function c71400001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400001.activate1(e,tp,eg,ep,ev,re,r,rp)
	yume.ActivateYumeField(tp,nil,1)
end
function c71400001.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400001.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71400001.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and c:IsSetCard(0xb714)
end
function c71400001.filter2(c,tp)
	return c:IsSetCard(0x714) and c:IsAbleToHand() and not c:IsCode(71400001)
end
function c71400001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400001.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
end
--global part
table=require("table")
yume.RustFlag=false
function yume.AddYumeSummonLimit(c,ssm)
--1=special summon monster, 0=non special summon monster
	ssm=ssm or 0
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_SPSUMMON_CONDITION)
	el1:SetValue(yume.YumeCheck)
	c:RegisterEffect(el1)
	if ssm==0 then
		local el2=Effect.CreateEffect(c)
		el2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		el2:SetType(EFFECT_TYPE_SINGLE)
		el2:SetCode(EFFECT_CANNOT_MSET)
		el2:SetCondition(yume.YumeCheck2)
		c:RegisterEffect(el2)
		local el3=el2:Clone()
		el3:SetCode(EFFECT_CANNOT_SUMMON)
		c:RegisterEffect(el3)
	end
end
function yume.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
		local mt=getmetatable(v)
		if mt==Group then return "G"
		elseif mt==Effect then return "E"
		else return "C" end
	else return t end
end
function yume.YumeCheckFilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3714) and c:IsType(TYPE_FIELD)
end
function yume.IsYumeFieldOnField(tp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	return fc and yume.YumeCheckFilter(fc)
end
--[[
Yume SpSummon Check
v in effect = spsummon condition value(return true = can summon)
v in card = material filter gen(return true = can summon)
--]]
function yume.YumeCheck(v,se,sp)
	local t=yume.GetValueType(v)
	if t=="E" then
		return yume.IsYumeFieldOnField(sp)
	elseif t=="C" then
		return function(c) return yume.IsYumeFieldOnField(v:GetControler()) end
	end
end
--[[
Yume Summon/Set Check
return true = cannot summon
--]]
function yume.YumeCheck2(e)
	return not yume.IsYumeFieldOnField(e:GetHandler():GetControler())
end
--Yume Condition
function yume.YumeCon(e,tp,eg,ep,ev,re,r,rp)
	if not tp then tp=e:GetHandlerPlayer() end
	return yume.IsYumeFieldOnField(tp)
end
--Yume Condition for lethal weapons
function yume.YumeLethalCon(e,tp,eg,ep,ev,re,r,rp)
	if not yume.IsYumeFieldOnField(tp) then return false end
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function yume.nonYumeCon(e,tp,eg,ep,ev,re,r,rp)
	if not tp then tp=e:GetHandlerPlayer() end
	return not yume.IsYumeFieldOnField(tp)
end
--ft=field type, 0-All Yume 1-Visionary Yume 2-Erosive Yume
--loc=location
function yume.AddYumeFieldGlobal(c,id,ft)
	ft=ft or 0
	if not id then return end
	yume.temp_card_field[c]=yume.temp_card_field[c] or {}
	yume.temp_card_field[c].id=id
	yume.temp_card_field[c].ft=ft
	--Activate
	local eac=Effect.CreateEffect(c)
	eac:SetType(EFFECT_TYPE_ACTIVATE)
	eac:SetCode(EVENT_FREE_CHAIN)
	eac:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(eac)
	--[[--old self to deck
	local esl=Effect.CreateEffect(c)
	esl:SetDescription(aux.Stringid(71400001,1))
	esl:SetType(EFFECT_TYPE_QUICK_F)
	esl:SetCode(EVENT_CHAINING)
	esl:SetRange(LOCATION_FZONE)
	esl:SetCondition(yume.YumeFieldLimitCon)
	esl:SetOperation(yume.YumeFieldLimitOp)
	c:RegisterEffect(esl)
	--]]
	--self to deck
	local esd1=Effect.CreateEffect(c)
	esd1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	esd1:SetCode(EVENT_CHAINING)
	esd1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	esd1:SetRange(LOCATION_FZONE)
	esd1:SetOperation(aux.chainreg)
	c:RegisterEffect(esd1)
	local esd2=Effect.CreateEffect(c)
	esd2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	esd2:SetCode(EVENT_CHAIN_SOLVED)
	esd2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	esd2:SetRange(LOCATION_FZONE)
	esd2:SetOperation(yume.SelfToDeckOp)
	c:RegisterEffect(esd2)
	--activate field
	local efa=Effect.CreateEffect(c)
	efa:SetDescription(aux.Stringid(71400001,2))
	efa:SetCategory(EFFECT_TYPE_ACTIVATE)
	efa:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	efa:SetCode(EVENT_LEAVE_FIELD)
	efa:SetRange(LOCATION_FZONE)
	efa:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	efa:SetCondition(yume.ActivateFieldCon)
	efa:SetOperation(yume.ActivateFieldOp)
	c:RegisterEffect(efa)
end
--[[--old Against Yume
function yume.YumeFieldLimitCon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rp==tp and (not ec:IsSetCard(0x714) and (ec:IsLocation(loc) or loc&LOCATION_ONFIELD==0) or not (ec:IsPreviousSetCard(0x714) or ec:IsLocation(loc)) and loc&LOCATION_ONFIELD~=0)
end
function yume.YumeFieldLimitOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(yume.YumeActivateYumeFieldLimit)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function yume.YumeActivateYumeFieldLimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsSetCard(0x714)
end
--]]
--Self To Deck
function yume.SelfToDeckOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsSetCard(0x714) and rp==tp and c:GetFlagEffect(1)>0 then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
--activate field
function yume.YumeFieldCheck(tp,id,ft,loc)
	ft=ft or 0
	id=id or 0
	loc=loc or LOCATION_DECK
	return Duel.IsExistingMatchingCard(yume.ActivateFieldFilter,tp,loc,0,1,nil,tp,id,ft)
end
function yume.YumeFieldCheckTarget(id,ft,loc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return yume.YumeFieldCheck(tp,id,ft,loc) end
	end
end
function yume.ActivateYumeField(tp,id,ft,loc)
	ft=ft or 0
	id=id or 0
	loc=loc or LOCATION_DECK
	local tc
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400001,3))
	if loc&LOCATION_GRAVE~=0 and loc~=LOCATION_GRAVE then
		tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(yume.ActivateFieldFilter),tp,loc,0,1,1,nil,tp,id,ft):GetFirst()
	else
		tc=Duel.SelectMatchingCard(tp,yume.ActivateFieldFilter,tp,loc,0,1,1,nil,tp,id,ft):GetFirst()
	end
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		return tc
	end
	return nil
end
function yume.ActivateFieldFilter(c,tp,id,ft)
	local flag=c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsCode(id)
	if ft==0 then return flag and c:IsSetCard(0x3714)
	elseif ft==1 then return flag and c:IsSetCard(0xb714)
	elseif ft==2 then return flag and c:IsSetCard(0x7714)
	end
end
function yume.ActivateFieldCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function yume.ActivateFieldOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local id=yume.temp_card_field[c].id
	local ft=yume.temp_card_field[c].ft
	yume.ActivateYumeField(tp,id,ft,LOCATION_DECK+LOCATION_HAND)
end
--uniquify the same name
function yume.UniquifyCardName(g)
	local tc=g:GetFirst()
	while tc do
		g:Remove(Card.IsCode,tc,tc:GetCode())
		tc=g:GetNext()
	end
end