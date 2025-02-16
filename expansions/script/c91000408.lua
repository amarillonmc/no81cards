--机械装甲捌
local m=91000408
local cm=c91000408
function c91000408.initial_effect(c)
	 c:EnableReviveLimit()  
	aux.AddFusionProcFun2(c,(function(c) return c:IsLevel(10) end),(function(c) return c:IsType(TYPE_EQUIP) end),false)  
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_IGNITION)
	--e5:SetRange(LOCATION_SZONE)
	--e5:SetCountLimit(1,m*2)
	--e5:SetCondition(cm.negcon)
	--e5:SetTarget(cm.negtg)
	--e5:SetOperation(cm.negop)
	--c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m+100)
	e6:SetTarget(cm.negtg)
	e6:SetOperation(cm.negop)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(91000408,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return  c:IsLevel(10)
end
function cm.counterfilter1(e,c)
	return  not c:IsLevel(10)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.GetCustomActivityCount(91000408,tp,ACTIVITY_SPSUMMON)==0 end
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.counterfilter1)
	Duel.RegisterEffect(e1,tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
if g:GetCount()>0 then 
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0   then
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local sc=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		Duel.Equip(tp,sc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		end 
	 end
   end
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.counterfilter1)
	Duel.RegisterEffect(e1,tp)
end
function cm.counterfilter1(e,c)
	return  not (c:IsLevel(10) or c:IsRank(10)) and c:IsLocation(LOCATION_EXTRA)
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end

function cm.fit2(c)
	return  c:IsSetCard(0x9d2) and c:IsFaceup()
end
function cm.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(cm.fit2,tp,LOCATION_ONFIELD,0,nil)*500
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetEquipTarget()
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x9d2)and not c:IsForbidden() and c:IsType(TYPE_MONSTER)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if  Duel.Draw(p,d,REASON_EFFECT)>0 then
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  then   
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local sc=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		Duel.Equip(tp,sc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		end
	   
		end
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.counterfilter1)
	Duel.RegisterEffect(e1,tp)
end
function cm.counterfilter1(e,c)
	return  not (c:IsLevel(10) or c:IsRank(10)) and c:IsLocation(LOCATION_EXTRA)
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end

function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e11:SetCountLimit(1)
		e11:SetCondition(cm.spcon)
		e11:SetOperation(cm.spop)
		if Duel.GetCurrentPhase()<=PHASE_BATTLE_START then
		e11:SetReset(RESET_PHASE+PHASE_BATTLE)
	else
		e11:SetReset(RESET_PHASE+PHASE_BATTLE)
	end
		 Duel.RegisterEffect(e11,tp)
end
function cm.fit(c)
	return  c:IsSetCard(0x9d2)and not c:IsForbidden()  and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE,0,1,nil,e) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		Duel.Equip(tp,sc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.counterfilter1)
	Duel.RegisterEffect(e1,tp)
end
function cm.counterfilter1(e,c)
	return  not (c:IsLevel(10) or c:IsRank(10)) and c:IsLocation(LOCATION_EXTRA)
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end