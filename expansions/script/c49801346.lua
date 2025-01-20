--冥肃号 恩黑帝斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddXyzProcedure(c,nil,11,2,s.mfilter,aux.Stringid(id,0),2,s.altop)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(s.fuslimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,1)
	e5:SetCondition(s.accon)
	e5:SetValue(s.aclimit)
	c:RegisterEffect(e5)
	--remove material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.rmcon)
	e6:SetOperation(s.rmop)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.mfilter(c,e,tp)
	return c:IsAttackAbove(2500) or c:IsDefenseAbove(2500)
end
function s.altop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.GetFlagEffect(tp,id+10000+200)>0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.fuslimit(e,c,sumtype)
	return sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function s.isactivate(tp,code)
	local codetable=table.pack(Duel.GetFlagEffectLabel(tp,id+10000+100))
	for _, v in pairs(codetable) do
		if v==code then
			return true
		end
	end
	return false
end
function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	if s.isactivate(rp,code) then
		Duel.RegisterFlagEffect(1-rp,id+10000+200,RESET_PHASE+PHASE_END,0,2)
	else
		Duel.RegisterFlagEffect(rp,id+10000+100,RESET_PHASE+PHASE_END,0,1,code)
	end
end
function s.accon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.aclimit(e,re,tp)
	return s.isactivate(tp,re:GetHandler():GetCode())
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_HAND,0,1,1,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end