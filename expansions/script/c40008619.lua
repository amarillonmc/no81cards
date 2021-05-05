--传说究极异兽-奈克洛兹玛-拂晓之翼
function c40008619.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,40008614,40008617,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	--increase level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008619,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c40008619.indcon)
	e3:SetOperation(c40008619.indop1)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c40008619.valcheck1)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2) 
	--increase level
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008619,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c40008619.indcon)
	e6:SetOperation(c40008619.indop2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MATERIAL_CHECK)
	e7:SetValue(c40008619.valcheck2)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
	--increase level
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(40008619,2))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c40008619.indcon)
	e8:SetOperation(c40008619.indop3)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(c40008619.valcheck3)
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
end
function c40008619.valcheck3(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c40008619.filterv3,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008619.valcheck1(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c40008619.filterv,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008619.valcheck2(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c40008619.filterv2,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008619.filterv3(c)
	return c:IsCode(40008617) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>7
end
function c40008619.filterv2(c)
	return c:IsCode(40008617) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>4
end
function c40008619.filterv(c)
	return c:IsCode(40008617) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>1
end
function c40008619.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and e:GetLabel()==1
end
function c40008619.indop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008619,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetOwnerPlayer(tp)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40008619,4))
end
function c40008619.indop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008619,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c40008619.aclimit)
	e1:SetOwnerPlayer(tp)
	e1:SetReset(RESET_PHASE+0x1fe0000)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40008619,6))
end
function c40008619.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c40008619.indop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008619,7))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40008619.target)
	e1:SetOperation(c40008619.activate)
	c:RegisterEffect(e1,tp)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40008619,8))
end
function c40008619.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gc=g:GetCount()
	if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(1-tp,gc) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,gc)
end
function c40008619.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gc=g:GetCount()
	if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if oc>0 then
			Duel.Draw(1-tp,oc,REASON_EFFECT)
		end
	end
end


