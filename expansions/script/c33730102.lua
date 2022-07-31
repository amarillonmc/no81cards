--键★记忆 小小的手心 || K.E.Y. Memoria - Piccolo Palmo
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,6)
	--special summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(1)
	e1:SetCondition(s.sprcon)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.xyzcon)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.imcon)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--detach and equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.attcon)
	e4:SetCost(s.attcost)
	e4:SetTarget(s.atttg)
	e4:SetOperation(s.attop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.discon)
	e5:SetCost(s.discost)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
end
function s.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460)
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsCanRemoveCounter(tp,1,1,0x1,7,REASON_COST)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x1,7,REASON_COST)
end

function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x460) and not c:IsForbidden() and c:IsCanOverlay()
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain(0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 then
		local ct=g:GetClassCount(Card.GetCode)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
		if #sg>0 then
			Duel.Attach(sg,c)
		end
	end
end

function s.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.attcon(e)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and not c:GetOverlayGroup():IsExists(aux.NOT(Card.IsSetCard),1,nil,0x460)
end
function s.attcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function Card.CheckEquipTargetWhileOverlay(c,ec)
	local egroup=global_card_effect_table[c]
	for _,ce in ipairs(egroup) do
		if ce and aux.GetValueType(ce)=="Effect" and ce:GetCode()==EFFECT_EQUIP_LIMIT then
			local val=ce:GetValue()
			if not val or type(val)=="number" then
				return true
			elseif type(val)=="function" then
				return val(ce,ec)
			end
		end
	end
	return false
end
function s.detachfilter(c,ec,tp,step)
	if c:IsForbidden() or not c:CheckUniqueOnField(tp) then return false end
	if not c:IsType(TYPE_EQUIP) then return true end
	if tp then
		return Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,0,1,nil,c)
	else
		return not step and c:CheckEquipTargetWhileOverlay(ec) or (step and c:CheckEquipTarget(ec))
	end
end
function s.attfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0x460) and ((aux.GetValueType(g)=="Card" and s.detachfilter(g,c)) or (aux.GetValueType(g)=="Group" and g:IsExists(s.detachfilter,1,nil,c)))
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_MZONE,0,1,nil,g) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local detached=g:FilterSelect(tp,s.detachfilter,1,1,c,nil,tp):GetFirst()
	if detached and Duel.SendtoGrave(detached,REASON_COST)>0 then
		Duel.SetTargetCard(detached)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,detached,1,detached:GetControler(),detached:GetLocation())
		if detached:IsLocation(LOCATION_GRAVE) then
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,detached,1,tp,0)
		end
	end
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain(0) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsForbidden() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.attfilter,tp,LOCATION_MZONE,0,1,1,nil,tc,nil,true)
	if #g>0 then
		Duel.HintSelection(g)
		if not Duel.Equip(tp,tc,g:GetFirst()) or tc:IsOriginalType(TYPE_EQUIP) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(g:GetFirst())
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and s.attcon(e)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end