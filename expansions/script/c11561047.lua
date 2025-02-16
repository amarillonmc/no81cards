--暴 风 之 翼  公 主 ·怜
local m=11561047
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c11561047.xyzcondition)
	e1:SetTarget(c11561047.xyztarget)
	e1:SetOperation(c11561047.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--dest
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11561047+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c11561047.cdtcon)
	e2:SetTarget(c11561047.cdttg)
	e2:SetOperation(c11561047.cdtop)
	c:RegisterEffect(e2)
	--summon success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c11561047.regcon)
	e5:SetOperation(c11561047.regop)
	--c:RegisterEffect(e5)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c11561047.valcheck)
	e3:SetLabelObject(e5)
	--c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c11561047.effcon)
	e4:SetValue(1)
	--c:RegisterEffect(e4)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c11561047.effcon)
	e6:SetValue(aux.imval1)
	--c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(1)
	--c:RegisterEffect(e7)
	--atklimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c11561047.atkval)
	c:RegisterEffect(e8)
	--double attack
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EXTRA_ATTACK)
	e9:SetValue(c11561047.atkcval)
	c:RegisterEffect(e9)
	
end
function c11561047.atkval(e,c)
	return e:GetHandler():GetCounter(0x1)*100*Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil):GetCount()
end
function c11561047.atkcval(e,c)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)-1
	if ct<1 then ct=1 end
	return ct
end
function c11561047.mfilter(g)
	return g:GetClassCount(Card.GetRace)>2
end
function c11561047.valcheck(e,c)
	local g=c:GetMaterial()
	if g:CheckSubGroup(c11561047.mfilter,3,3) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11561047.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c11561047.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(11561047,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11561047,1))
end
function c11561047.effcon(e)
	return e:GetHandler():GetFlagEffect(11561047)>0
end
function c11561047.cdtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11561047.cdttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return ct>0 end -- Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1)
	--Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	--Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c11561047.cdtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()==0 then return end
		local ct=Duel.SendtoGrave(og,REASON_EFFECT) 
		if ct>0 then
		c:AddCounter(0x1,ct)
		--if Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil) then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		--local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		--if g:GetCount()>0 then
		--	Duel.HintSelection(g)
		--	if Duel.Destroy(g,REASON_EFFECT) then
		--		local ccg=Duel.GetOperatedGroup()
		--		local cct=ccg:Filter(Card.IsPreviousControler,nil,tp):GetCount()
		--		if cct>0 and Duel.IsPlayerCanDraw(tp,cct) then 
		--			Duel.Draw(tp,cct,REASON_EFFECT)
		--		end
		--	end
		--end
		--end
		end
	end
end
function c11561047.xyzcheck(g,tp,xyzc)
	return g:GetClassCount(Card.GetOriginalLevel)==1 and g:IsExists(Card.IsLevelAbove,1,nil,1) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c11561047.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(c11561047.xyzcheck,3,99,tp,c)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c11561047.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	end
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	g=mg:SelectSubGroup(tp,c11561047.xyzcheck,cancel,3,99,tp,c)
	Auxiliary.GCheckAdditional=nil
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c11561047.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		mg=og
	else
		mg=e:GetLabelObject()
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
		end
	Duel.SendtoGrave(sg,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end

