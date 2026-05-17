--底噪石血泉的自饮
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71
local CARD_BOTTOMNOISE_CAVERN=21401270
local FLAG_BOTTOMNOISE_QP_FROM_GRAVE=0x5d710100
local GLOBAL_BOTTOMNOISE_QP_HAND="GLOBAL_BOTTOMNOISE_QP_HAND"

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	--② 共用全局手发效果
	s.register_qp_hand_global(c)
	--② 墓地标记
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetOperation(s.qpmarkop)
	c:RegisterEffect(e3)
end

--② 全局只注册一次
function s.register_qp_hand_global(c)
	if _G[GLOBAL_BOTTOMNOISE_QP_HAND] then return end
	_G[GLOBAL_BOTTOMNOISE_QP_HAND]=true
	for p=0,1 do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCondition(s.qphandcon)
		e1:SetTarget(s.qphandtg)
		e1:SetCost(s.qphandcost)
		e1:SetValue(FLAG_BOTTOMNOISE_QP_FROM_GRAVE)
		e1:SetLabel(p)
		Duel.RegisterEffect(e1,p)
	end
end

function s.qphandcon(e)
	local tp=e:GetLabel()
	return Duel.GetTurnPlayer()~=tp
		and Duel.IsExistingMatchingCard(s.qpcostfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function s.qphandtg(e,c)
	return c:IsSetCard(SET_BOTTOMNOISE) and c:IsType(TYPE_QUICKPLAY)
end

function s.qpcostfilter(c)
	return c:GetFlagEffect(FLAG_BOTTOMNOISE_QP_FROM_GRAVE)>0
		and c:IsAbleToRemoveAsCost()
end

function s.qphandcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.qpcostfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.qpcostfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.qpmarkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(FLAG_BOTTOMNOISE_QP_FROM_GRAVE)==0 then
		c:RegisterFlagEffect(FLAG_BOTTOMNOISE_QP_FROM_GRAVE,
			RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end

--① cost
function s.costfilter(c,ec)
	return c~=ec
		and c:IsSetCard(SET_BOTTOMNOISE)
		and c:IsDiscardable()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

--self-destroy at your End Phase
function s.regdes(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_SZONE) then
		Duel.Destroy(c,REASON_RULE)
	end
end

--① draw and change names
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	local c=e:GetHandler()
	if c:IsType(TYPE_QUICKPLAY) and c:IsLocation(LOCATION_SZONE) then
		s.regdes(c)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=2 then return end

	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsOnField()) then return end

	local g=s.getcolumngroup(c)
	g:AddCard(c)
	for tc in aux.Next(g) do
		if tc==c or not tc:IsImmuneToEffect(e) then
			s.changecode(tc)
		end
	end
end

function s.colfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function s.getcolumngroup(c)
	local g=Group.CreateGroup()
	if Card.GetColumnGroup then
		g=c:GetColumnGroup()
	else
		local tp=c:GetControler()
		local seq=c:GetSequence()
		if seq<5 then
			if c:IsLocation(LOCATION_SZONE) then
				local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
				if tc then g:AddCard(tc) end
				local oc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
				if oc then g:AddCard(oc) end
			elseif c:IsLocation(LOCATION_MZONE) then
				local oc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
				if oc then g:AddCard(oc) end
			end
		end
	end
	return g:Filter(s.colfilter,nil)
end

function s.changecode(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(CARD_BOTTOMNOISE_CAVERN)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
