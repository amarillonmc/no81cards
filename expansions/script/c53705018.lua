local m=53705018
local cm=_G["c"..m]
cm.name="超幻海袭 古机"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzCondition)
	e1:SetTarget(cm.XyzTarget)
	e1:SetOperation(cm.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(cm.effcon)
	e1:SetValue(cm.value)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.effcon)
	e2:SetLabel(2)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(3)
	e3:SetCondition(cm.effcon)
	e3:SetCost(cm.pubcost)
	e3:SetTarget(cm.pubtg)
	e3:SetOperation(cm.pubop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(cm.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do if (tc:IsReason(REASON_BATTLE) or rp~=e:GetHandler():GetControler()) and tc:IsLocation(LOCATION_GRAVE) then tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1) end end
end
function cm.mfilter(c,xyzc)
	-- 必须能作为超量素材
	if not c:IsCanBeXyzMaterial(xyzc) then return false end
	
	-- 情况1：场上的9星怪兽
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsLevel(9) then
		return true
	end
	
	-- 情况2：墓地被对方破坏的「幻海袭」同调怪兽
	-- 检查 FlagEffect 确认是否被对方破坏
	if c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x3534) and c:IsType(TYPE_SYNCHRO) and c:GetFlagEffect(m)>0 then
		return true
	end
	
	return false
end
-- 目标检查：位置判定
function cm.xyzgoal(g,tp,xyzc)
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
-- 召唤条件
function cm.XyzCondition(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	-- 默认要求：2只以上
	local minc=2
	local maxc=99
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if maxc<minc then return false end
	
	local mg=nil
	if og then
		mg=og
	else
		-- 获取场上和墓地的符合条件的卡
		mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	end
	
	-- 必须作为素材的检查 (MustMaterial)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
	
	Duel.SetSelectedCard(sg)
	-- 调弦之魔术师等卡的额外检查 (TuneMagician Check)
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(cm.xyzgoal,minc,maxc,tp,c)
	Auxiliary.GCheckAdditional=nil
	return res
end
-- 召唤目标选择
function cm.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local minc=2
	local maxc=99
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	
	local cancel=Duel.IsSummonCancelable()
	Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local g=mg:SelectSubGroup(tp,cm.xyzgoal,cancel,minc,maxc,tp,c)
	Auxiliary.GCheckAdditional=nil
	
	if g and g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
-- 召唤操作
function cm.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
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
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	local ng=og:Filter(Card.IsSetCard,nil,0x3534)
	return ng:GetCount()>=e:GetLabel()
end
function cm.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPublic,0,LOCATION_HAND,LOCATION_HAND,nil)*300
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if chk==0 then return #g>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if #g>0 and #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sdg=dg:Select(tp,1,g:GetCount(),nil)
		Duel.HintSelection(sdg)
		Duel.SendtoGrave(sdg,REASON_EFFECT)
	end
end
function cm.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.pubfilter(c)
	return not c:IsPublic()
end
function cm.pubtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function cm.pubop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.pubfilter,tp,LOCATION_HAND,LOCATION_HAND,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do SNNM.SetPublic(tc,4,RESET_EVENT+RESETS_STANDARD,1) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
	if ct>0 then Duel.Damage(1-tp,ct*400,REASON_EFFECT) end
end
function cm.indcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
