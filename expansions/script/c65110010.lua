--被封印的贤者 维涅特
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.ovcost)
	e2:SetTarget(s.ovtg)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
function s.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.tffilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(65110000) and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsForbidden()
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_GRAVE,0,1,nil,tp) and e:GetHandler():IsCanOverlay() end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.ResetFlagEffect(tp,15248873)
	if tc then  
		if not KOISHI_CHECK or Duel.GetMasterRule()>=4 then
			local fg=Group.CreateGroup()
			fg:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) 
			fg:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,6)) 
			if fg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(fg,REASON_RULE)
			end
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
	if tc then
		local etype=oe1:GetType()
		local con=oe1:GetCondition()
		if not con then con=aux.TRUE end
		oe1:SetCondition(s.chcon(con,seq))
		oe1:SetType(etype|EFFECT_TYPE_XMATERIAL)
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			oe1:SetRange(LOCATION_SZONE)
		end
		c:RegisterEffect(oe1)
		local re=Effect.CreateEffect(c)
		re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		re:SetRange(0xff)
		re:SetCode(EVENT_ADJUST)
		re:SetLabelObject(oe1)
		re:SetOperation(s.resetop)
		c:RegisterEffect(re)
		if c:IsRelateToChain() or (c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_HAND) and c:GetReasonEffect()==e) then
			Duel.Overlay(tc,c)
		end
	end
end
function s.chcon(con,seq)
	return function(e,tp,...)
				if Duel.GetFieldGroup(tp,LOCATION_MZONE,0)==0 then return false end
				return con(e,tp,...)
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end