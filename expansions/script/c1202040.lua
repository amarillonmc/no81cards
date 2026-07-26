--化尘教长老-鸢本仙子
local s,id,o=GetID()
local CodeList=1202045	--万土归尘卡号
local CodeList2=1202035	--万尘化土卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList,CodeList2)
	c:EnableReviveLimit()
	--cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(s.con)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	--e3:SetCondition(s.costcon)
	e3:SetCost(s.costchk)
	e3:SetTarget(s.costtg)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SSET_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_HAND)
	--e4:SetCondition(s.costcon)
	e4:SetCost(s.costchk)
	e4:SetTarget(s.costtg2)
	e4:SetOperation(s.costop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		s.willreturn=Group.CreateGroup()
		s.willreturn:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(id,3))
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		--ge1:SetReset(RESET_PHASE+PHASE_END)
		--ge1:SetLabelObject(s.willreturn)
		ge1:SetCountLimit(1)
		--ge1:SetCondition(s.retcon)
		ge1:SetOperation(s.retop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.limfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9240)
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.limfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE)
end

function s.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	--level
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end

function s.costcon(e)
	s[0]=false
	return true
end
function s.costchk(e,te_or_c,tp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList)
	local g=Duel.GetDecktopGroup(tp,gc)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==gc
end
function s.costtg(e,te,tp)
	if not (te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	if not s.con(e) then return false end
	--if not te:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then return false end
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList)
	return gc>0
end
function s.costtg2(e,te,tp)
	if not s.con(e) then return false end
	--if not te:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then return false end
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList)
	return gc>0
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	--if s[0] then return end
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList)
	local g=Duel.GetDecktopGroup(tp,gc)	
	if Duel.Remove(g,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		s.willreturn:Merge(og)
		if Duel.GetFlagEffect(tp,id+2)==0 then
			local ge1=Effect.CreateEffect(c)
			ge1:SetDescription(aux.Stringid(id,3))
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_PHASE+PHASE_END)
			ge1:SetReset(RESET_PHASE+PHASE_END)
			--ge1:SetLabelObject(s.willreturn)
			ge1:SetCountLimit(1)
			ge1:SetCondition(s.retcon)
			ge1:SetOperation(s.retop)
			Duel.RegisterEffect(ge1,p)
			Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		end
	end
	--s[0]=true
end

function s.retfilter(c)
	return c:GetFlagEffect(id+1)~=0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if s.willreturn:IsExists(s.retfilter,1,nil) then
		return true
	else
		s.willreturn:Clear()
		return false
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if s.willreturn:IsExists(s.retfilter,1,nil) then
		local g=s.willreturn:Filter(s.retfilter,nil)
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	s.willreturn:Clear()
	--for tc in aux.Next(g) do
	--	Duel.ReturnToField(tc)
	--end
end
