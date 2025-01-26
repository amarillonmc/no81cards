--秘计螺旋 死咒
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.XyzCondition)
	e1:SetTarget(s.XyzTarget)
	e1:SetOperation(s.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(s.fuslimit)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCost(s.damcost)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==1 and g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<=1
end
function s.XyzCondition(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if og then
		return og:GetCount()==2 and s.xyzcheck(og)
	else
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
		return g:CheckSubGroup(s.xyzcheck,2,2,nil)
	end
end
function s.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og then
		return true
	end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
	local sg=g:SelectSubGroup(tp,s.xyzcheck,true,2,2,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetPreviousOverlayCountOnField()
	e:SetLabel(ct)
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(100*ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100*ct)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end