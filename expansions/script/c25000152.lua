local m=25000152
local cm=_G["c"..m]
cm.name="究极合体怪兽 基伽奇美拉"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,cm.sprop(c))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	local e_org=Effect.CreateEffect(c)
	e_org:SetType(EFFECT_TYPE_FIELD)
	e_org:SetRange(LOCATION_MZONE)
	e_org:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_org:SetTargetRange(0,1)
	e_org:SetCondition(cm.con)
	local e3=e_org:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTarget(cm.risplimit)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	local e4=e_org:Clone()
	e4:SetCode(EFFECT_DISABLE)
	e4:SetProperty(nil)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetLabel(2)
	c:RegisterEffect(e4)
	local e5=e_org:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTarget(cm.sysplimit)
	e5:SetLabel(4)
	c:RegisterEffect(e5)
	local e6=e_org:Clone()
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetValue(cm.xyzplimit)
	e6:SetLabel(8)
	c:RegisterEffect(e6)
	local e7=e_org:Clone()
	e7:SetCode(EFFECT_SET_ATTACK)
	e7:SetProperty(nil)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetValue(0)
	e7:SetLabel(16)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e8)
	local e9=e_org:Clone()
	e9:SetCode(63060238)
	e9:SetLabel(4)
	c:RegisterEffect(e9)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetHandler():GetFlagEffectLabel(m)
	if not lab then return false end
	return bit.band(lab,e:GetLabel())~=0
end
function cm.risplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.sysplimit(e,c)
	return not c:IsLocation(LOCATION_EXTRA)
end
function cm.xyzplimit(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function cm.sprop(c)
	return  function(g)
				Duel.Remove(g,POS_FACEUP,REASON_COST)
				local lab=0
				local res=RESET_EVENT+0xff0000
				if g:IsExists(Card.IsType,1,nil,TYPE_RITUAL) then
					lab=lab+1
					c:RegisterFlagEffect(0,res,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				end
				if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) then
					lab=lab+2
					c:RegisterFlagEffect(0,res,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				end
				if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then
					lab=lab+4
					c:RegisterFlagEffect(0,res,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
				end
				if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
					lab=lab+8
					c:RegisterFlagEffect(0,res,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
				end
				if g:IsExists(Card.IsType,1,nil,TYPE_LINK) then
					lab=lab+16
					c:RegisterFlagEffect(0,res,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
				end
				c:RegisterFlagEffect(m,res,0,1,lab)
			end
end