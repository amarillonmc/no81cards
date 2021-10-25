--滑翔机小姐
--Scripted by: XGlitchy30
function GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end
local s,id=GetID()
function s.initial_effect(c)
	--cannot link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.spcon)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
--selfdes
function s.cfilter(c,cc)
	return c~=cc
end
function s.sdcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,e:GetHandler())
end
--return
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_DESTROY>0 and (r&REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE and e:GetHandler():GetPreviousPosition()&POS_FACEUP>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=(Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY) and 2 or 1
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,ct)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,ct)
	e1:SetCountLimit(1)
	e1:SetCondition(s.retcon)
	e1:SetOperation(s.retop)
	e1:SetLabel(ct-1)
	e1:SetLabelObject(c)
	Duel.RegisterEffect(e1,tp)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabel()
	if e:GetLabelObject():GetFlagEffect(id)>0 then
		if t==1 then
			e:SetLabel(0)
		else
			Duel.MoveToField(e:GetLabelObject(),tp,tp,LOCATION_MZONE,e:GetLabelObject():GetPreviousPosition(),true)
		end
	else
		e:Reset()
	end
end