--底噪石无端的织茧
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71
local CARD_BOTTOMNOISE_CAVERN=21401270
local FLAG_BOTTOMNOISE_QP_FROM_GRAVE=0x5d710100
local GLOBAL_BOTTOMNOISE_QP_HAND="GLOBAL_BOTTOMNOISE_QP_HAND"

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
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

--①
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local c=e:GetHandler()
	if c:IsType(TYPE_QUICKPLAY) and c:IsLocation(LOCATION_SZONE) then
		s.regdes(c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local spok=false

	--自己墓地的1只怪兽特殊召唤
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				spok=true
				--这个效果特殊召唤的怪兽卡名当做「底噪石窟」使用
				s.changecode(tc)
				--这个回合不能把效果发动
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end

	--那之后：这张卡以及相同纵列的所有表侧怪兽的卡名当做「底噪石窟」使用
	if spok and c:IsFaceup() and c:IsOnField() then
		local cg=s.getcolumngroup(c)
		cg:AddCard(c)
		for sc in aux.Next(cg) do
			if sc==c or not sc:IsImmuneToEffect(e) then
				s.changecode(sc)
			end
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
