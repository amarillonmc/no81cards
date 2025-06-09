--嘿白融合怪
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,10))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,11))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetOperation(s.inspect_op)
	c:RegisterEffect(e2)
	--带来毁灭--
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetTarget(s.target)
	e11:SetOperation(s.activate)
	c:RegisterEffect(e11)
	--global check
	if not s.global_check then
		s.global_check=true
		s.global_counter=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(function(e)
			s.update_all_cards()
			s.update_client_hint()
			e:Reset()
		end)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(function(e)
			s.update_all_cards()
			s.update_client_hint()
			if s.global_counter>=98 then
				s.global_counter=98
				e:Reset()
			end
		end)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(function(e)
			s.global_counter=s.global_counter+1
			s.update_client_hint()
			if s.global_counter>=98 then
				s.global_counter=98
				e:Reset()
			end
		end)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_MOVE)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			s.update_group(eg)
			s.update_client_hint()
			if s.global_counter>=98 then
				s.global_counter=98
				e:Reset()
			end
		end)
		Duel.RegisterEffect(ge4,0)
	end
end
function s.update_counter(c)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK) then
		if c:GetFlagEffect(id)~=0 then
			if c:GetFlagEffectLabel(id)~=c:GetRealFieldID() then
				c:SetFlagEffectLabel(id,c:GetRealFieldID())
				s.global_counter=s.global_counter+1
			end
		else
			c:RegisterFlagEffect(id,0,0,1,c:GetRealFieldID(),0)
		end
	else
		if c:GetFlagEffect(id)~=0 then
			c:ResetFlagEffect(id)
			s.global_counter=s.global_counter+1
		end
	end
end
function s.update_all_cards()
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	s.update_group(g)
end
function s.update_group(g)
	for tc in aux.Next(g) do
		s.update_counter(tc)
		local og=tc:GetOverlayGroup()
		for oc in aux.Next(og) do
			s.update_counter(oc)
		end
	end
end
function s.update_client_hint()
	if s.global_counter>=98 then
		s.global_counter=98
	end
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	for tc in aux.Next(g) do
		s.update_client_hint_single(tc)
		local og=tc:GetOverlayGroup()
		for oc in aux.Next(og) do
			s.update_client_hint_single(oc)
		end
	end
end
function s.update_client_hint_single(c)
	if c:GetOriginalCode()==id then
		c:ResetFlagEffect(id+1)
		if c:IsLocation(LOCATION_EXTRA) then
			local v1=s.global_counter%10
			local v2=(s.global_counter-v1)/10
			if v2>0 then
				c:RegisterFlagEffect(id+1,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id+1,v2))
			end
			if v1>0 then
				c:RegisterFlagEffect(id+1,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,v1))
			end
		end
	end
end
function s.spgoal(g,tp,c)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local count=99-s.global_counter
	return mg:CheckSubGroup(s.spgoal,count,count,tp,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local count=99-s.global_counter
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,s.spgoal,true,count,count,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function s.inspect_op(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local v1=s.global_counter%10
	local v2=(s.global_counter-v1)/10
	if v2>0 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id+1,v2))
	end
	if v1>0 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,v1))
	end
	if s.global_counter==0 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id,0))
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.Destroy(sg,REASON_EFFECT)
end