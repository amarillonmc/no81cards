--佛跳墙料理
local s,id,o=GetID()
function s.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9221))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0xa221) then
		Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,tc:GetCode())
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x9221) then
			Duel.RegisterFlagEffect(0,81,RESET_CHAIN,0,1)
		end
	end
end

function s.label_check(...)
	local labels={...}
	local flag={}
	local num=0
	if labels then
		for i = 0, #labels do 
			local tmp=true
			for i2=0, #flag do
				if labels[i]==flag[i2] then
					tmp=false
				end
			end
			if tmp then
				num=num+1
				table.insert(flag,labels[i])
			end
		end
	end
	return num>=3
end
function s.splimit(e,se,sp,st)
	return s.label_check(Duel.GetFlagEffectLabel(0,id)) and se:GetHandler():IsSetCard(0xa221) and Duel.GetFlagEffect(0,81)==0
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and re:GetHandler():IsSetCard(0xa221)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,PLAYER_ALL,LOCATION_MZONE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tc=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
end

function s.atkcfilter(c)
	return c:IsSetCard(0x9221) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceupEx()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.atkcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(s.atkcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Select(tp,1,#g,nil)
	Duel.HintSelection(tg)
	local num=Duel.SendtoDeck(tg,nil,2,REASON_COST)
	e:SetLabel(num)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local num=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(num*500)
	c:RegisterEffect(e1)
end
