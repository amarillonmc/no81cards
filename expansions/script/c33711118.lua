--哆帝伽姪世滅遮罰耶倒罰豆冥蘇怯度皤佛俱真娑究梵無罰若不即蘇孕世隸佛故諳羯瑟夜室哆大怯波參
local m=33711118
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp) return Duel.GetLP(tp)<=1000 end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<=1000 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.sumlimit)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetCost(cm.cost1)
		e2:SetTarget(cm.tg1)
		e2:SetOperation(cm.op1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetCountLimit(1)
		e3:SetCost(cm.cost2)
		e3:SetTarget(cm.tg2)
		e3:SetOperation(cm.op2)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,2))
		e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetCountLimit(1)
		e4:SetCost(cm.cost3)
		e4:SetTarget(cm.tg3)
		e4:SetOperation(cm.op3)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsType(TYPE_TOKEN) or c:IsCode(33710928) or c:IsCode(33711115,33711116,33711117,33700412,33701414,33711113,33711114))
end
function cm.check1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.check2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cm.check3(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.check2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.check3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_TOKEN) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then 
		if e:GetLabel()==1 then
			return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) and Duel.IsExistingMatchingCard(cm.check1,tp,LOCATION_GRAVE,0,1,nil) 
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g=Duel.SelectMatchingCard(tp,cm.check1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_TOKEN)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33710919,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_NORMAL,0,0,4,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rac=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(rac)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lc=e:GetLabelObject()
	local atk=lc:GetAttack()
	local def=lc:GetDefense()
	local race=lc:GetRace()
	local att=lc:GetAttribute()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def)
	tc:RegisterEffect(e2)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e11:SetValue(att)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e11)
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_CHANGE_RACE)
	e21:SetValue(race)
	e21:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e21)
	if lc:IsType(TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabel()
	local p,rac=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33710919,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_NORMAL,0,0,4,rc,rac) then
		for i=1,4 do
			local token=Duel.CreateToken(tp,33710919)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e11=Effect.CreateEffect(e:GetHandler())
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e11:SetValue(rc)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e11)
			local e21=Effect.CreateEffect(e:GetHandler())
			e21:SetType(EFFECT_TYPE_SINGLE)
			e21:SetCode(EFFECT_CHANGE_RACE)
			e21:SetValue(rac)
			e21:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e21)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetProperty(EFFECT_CANNOT_DISABLE)
		e3:SetOperation(cm.rcop)
		tc:RegisterEffect(e3)
	end
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end