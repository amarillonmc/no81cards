-- 极彩色的时间囚徒
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetEntityCode then KOISHI_CHECK=true end
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCost(s.hdcost)
	c:RegisterEffect(e0)
	--exile
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler():IsCode(id) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x5a73) and c:IsFaceup() and c:IsAbleToRemoveAsCost() 
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function s.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return #g>0 end
end
function s.check(c)
	local eset1={c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)}
	local eset2={c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)}
	for _,te in pairs(eset1) do
		if te:GetValue()~=0 then return true end
	end
	for _,te in pairs(eset2) do
		if te:GetValue()~=0 then return true end
	end
	return false
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local ct=Duel.GetFlagEffect(tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local sg=g:Select(tp,1,1+ct,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		for tc in aux.Next(sg) do
			if tc:IsType(TYPE_XYZ) and tc:GetOverlayCount()>0 then
				Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE)
			end
			tc:ReplaceEffect(id,0,1)
		end
		local cg=sg:Filter(s.check,nil)
		for cc in aux.Next(cg) do
			local eset1={cc:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)}
			local eset2={cc:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)}
			for _,te in pairs(eset1) do
				if te:GetValue()~=0 then
					te:SetValue(0)
				end
			end
			for _,te in pairs(eset2) do
				if te:GetValue()~=0 then
					te:SetValue(0)
				end
			end
		end
		if KOISHI_CHECK then
			Duel.Exile(sg,REASON_RULE)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
			e1:SetValue(LOCATION_REMOVED+LOCATION_GRAVE)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			Duel.SendtoGrave(sg,REASON_RULE)
			e1:Reset()
		end
	end
end