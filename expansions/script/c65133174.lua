--幻叙支配者-水仙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(s.synfilter),1)
	c:EnableReviveLimit()
	--synchro level
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE)
	ge0:SetCode(EFFECT_SYNCHRO_LEVEL)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(0xff)
	ge0:SetValue(s.synclv)
	--effect gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0xff,0)
	e0:SetTarget(s.syntarget)
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(s.hspval)
	c:RegisterEffect(e1)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.effop)
	c:RegisterEffect(e5)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(id)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
end
--synchro summon
function s.synfilter(c)
	return c:IsSetCard(0x838)
end
function s.synclv(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsCode(id) then
		if c:IsLevelAbove(1) then
			return (3<<16)+lv
		else
			return 3
		end
	else
		return lv
	end
end
function s.syntarget(e,c)
	return c:IsSetCard(0x838)
end
function s.hspval(e,c)
	return 0,0x4
end
function s.spcfilter(c)
	return c:IsSetCard(0x838) and not c:IsPublic()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,0x4)>0
		and Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_HAND,0,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
s.check={}
function s.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(id)
end
function s.gfilter(c,g)
	if not g then return true end
	return s.copyfilter(c) and not g:IsContains(c)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)==0 then
		s.check[c]={}
		c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1)
	end
	s.check[c]=s.check[c] or {}
	local exg=Group.CreateGroup()
	for tc,cid in pairs(s.check[c]) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local dg=exg:Filter(s.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(s.check[c][tc],RESET_COPY)
		exg:RemoveCard(tc)
		s.check[c][tc]=nil
	end
	local cg=g:Filter(s.gfilter,nil,exg)
	for tc in aux.Next(cg) do
		local flag=true
		if #s.check[c]==0 then
			s.check[c][tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
		for ac,cid in pairs(s.check[c]) do
			if tc==ac then
				flag=false
			end
		end
		if flag==true then
			s.check[c][tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
	end
end