--G-神智机 炎
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16107106,"GODONOVAARMS")
local nova=0x1cc ----nova counter
function cm.initial_effect(c)
	c:EnableCounterPermit(nova)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--local e0=rk.effectg(c,m)
	--Removed Card Cannot Effect
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetTargetRange(0,1)
	e1_1:SetValue(cm.aclimit)
	--c:RegisterEffect(e1_1)
	--DESTROY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.cost)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.remtg)
	e3:SetOperation(cm.remop)
	--c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon2)
	--c:RegisterEffect(e2)
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return (rc:IsStatus(STATUS_BATTLE_DESTROYED) or rc:IsComplexReason(REASON_DESTROY,true,REASON_EFFECT,REASON_BATTLE)) and not rc:IsControler(e:GetHandlerPlayer())
end
--e3
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,16107112)~=0 and e:GetHandler():IsOriginalSetCard(0xccc)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Debug.Message(tp)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,2,nil) end
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct=g0:GetCount()
	if ct<2 then return  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local zg=c:GetOverlayGroup():Filter(Card.IsAttribute,nil,ATTRIBUTE_FIRE)
	local tg=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,tp)
	if #zg>0 and #tg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	if Duel.SelectYesNo(tp,aux.Stringid(16107106,0))  then
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(2000)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.eqfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsType(TYPE_MONSTER)
end