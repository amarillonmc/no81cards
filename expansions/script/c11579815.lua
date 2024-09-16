--闪刀起动-觉醒
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local _IsLinkSetCard=Card.IsLinkSetCard
		function Card.IsLinkSetCard(c,setname)
			local tp=c:GetControler()
			if Duel.GetFlagEffect(tp,id)>0 and (setname==0x1115 or setname==0x115) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) then return true end
			return _IsLinkSetCard(c,setname)
		end
		--local _IsLinkAttribute=Card.IsLinkAttribute
		--function Card.IsLinkAttribute(c,att,...)
			--if Duel.GetFlagEffect(tp,id)>0 and c:GetAttribute()==0 then return true end
			--return _IsLinkAttribute(c,att,...)
		--end
		function Auxiliary.LExtraFilter(c,f,lc,tp)
			if c:IsOnField() and c:IsFacedown() and not (c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetFlagEffect(tp,id)>0) then return false end
			if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
			local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
			for _,te in pairs(le) do
				local tf=te:GetValue()
				local related,valid=tf(te,lc,nil,c,tp)
				if related then return true end
			end
			return false
		end
	end
end
function s.cfilter(c)
	return c:GetSequence()<5
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter(c)
	return c:IsLinkSummonable(nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.mattg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id)
end
function s.matfilter(c,e)
	local efftable=table.pack(c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL))
	if #efftable==0 then return false end
	for i,v in ipairs(efftable) do
		if v:GetLabel()~=id then return false end
	end
	return true
end
function s.matval(e,lc,mg,c,tp)
	if e:GetHandlerPlayer()~=tp then return false,nil end
	return true,not mg or mg:FilterCount(s.matfilter,c,e)<Duel.GetFlagEffect(tp,id)
end
function s.attcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,id)>0
end
function s.matfilter2(c,e)
	local efftable=table.pack(c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL))
	if #efftable==0 then return false end
	for i,v in ipairs(efftable) do
		if v:GetLabel()~=id+1 then return false end
	end
	return true
end
function s.matval2(e,lc,mg,c,tp)
	if e:GetHandlerPlayer()~=tp then return false,nil end
	return true,not mg or mg:FilterCount(s.matfilter2,c,e)<1
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_LINK_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(s.attcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(ATTRIBUTE_LIGHT)
	Duel.RegisterEffect(e1,tp)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCountLimit(1)
	e2:SetLabel(id)
	e2:SetTarget(s.mattg)
	e2:SetValue(s.matval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local re=Effect.CreateEffect(c)
	re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	re:SetCode(EVENT_ADJUST)
	re:SetLabelObject(e2)
	re:SetOperation(s.resetop)
	Duel.RegisterEffect(re,tp)
	
	--extra material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetLabel(id+1)
	e3:SetValue(s.matval2)

	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then Duel.RegisterEffect(e3,tp) end
	if Duel.GetCurrentChain()==1 then
		local sg=Duel.GetMatchingGroup(Card.IsStatus,0,LOCATION_SZONE,LOCATION_SZONE,nil,STATUS_LEAVE_CONFIRMED)
		sg:KeepAlive()
		for tc in aux.Next(sg) do
			tc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
		end
		local tde=Effect.CreateEffect(c)
		tde:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		tde:SetCode(EVENT_CHAIN_END)
		tde:SetLabelObject(sg)
		tde:SetOperation(s.tdop)
		Duel.RegisterEffect(tde,tp)
	end
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)	
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local re2=Effect.CreateEffect(c)
			re2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			re2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			re2:SetCode(EVENT_MOVE)
			re2:SetLabelObject(e3)
			re2:SetOperation(s.resetop2)
			tc:RegisterEffect(re2)
			Duel.LinkSummon(tp,tc,nil)
		else
			e3:Reset()
		end
	else
		e3:Reset()
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te:CheckCountLimit(tp) then
		Duel.ResetFlagEffect(tp,id)
		e:Reset()
	end
	--
end
function s.resetop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	for tc in aux.Next(sg) do
		tc:SetStatus(STATUS_LEAVE_CONFIRMED,true)
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	e:Reset()
end