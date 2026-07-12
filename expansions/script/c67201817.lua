--银白之都的骑士 库拉蒂
local s,id,o=GetID()
function c67201817.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1,67201818)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)	
end
--
function s.filter1(c)
	return c:IsSetCard(0x667f) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.filter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOwner()==1-tp and not c:IsForbidden()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND,0,c)
	local gg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tcc=gg:SelectUnselect(nil,tp,false,true,1,1)
	if tc and tcc then
		local ggg=Group.CreateGroup()
		Group.AddCard(ggg,tc)
		Group.AddCard(ggg,tcc)
		ggg:KeepAlive()
		e:SetLabelObject(ggg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ggg=e:GetLabelObject()
	local tc1=ggg:GetFirst()
	local tc2=ggg:GetNext()
	if Duel.MoveToField(tc1,tp,tc1:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		if Duel.MoveToField(tc2,tp,tc2:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc2:RegisterEffect(e1)
			--tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc1:RegisterEffect(e2)
		--tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
--
function s.mvcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x667f)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Duel.SetTargetPlayer(tp)
	--Duel.SetTargetParam(ev)
	--Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	--local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	--Duel.Recover(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667f))
	e1:SetValue(ev)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
