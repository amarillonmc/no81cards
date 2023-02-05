--超级量子机神 炎浆狮虎
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,59975920)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(s.atcon)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--
	if not s.globle_check then
		s.globle_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(s.XyzConditionAlter)
		e1:SetTarget(s.XyzTargetAlter)
		e1:SetOperation(s.XyzOperationAlter)
		e1:SetValue(SUMMON_TYPE_XYZ)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,57031794))
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,0)
	end
end
--Xyz summon(alterf)
function s.XyzConditionAlter(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	return mg:IsExists(s.ovfilter2,1,nil)
end
function s.XyzTargetAlter(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	local g=nil
	if mg:IsExists(s.ovfilter2,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,s.ovfilter2,1,1,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	else return false end
end
function s.XyzOperationAlter(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.Overlay(c,mg2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function s.ovfilter2(c)
	return c:IsFaceup() and c:GetOriginalCodeRule()==id
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(57031794)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.atcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function s.filter(c,mc)
	return c:IsSetCard(0xdc) and (c:IsAbleToHand() or (mc:IsType(TYPE_XYZ) and c:IsCanOverlay()))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		if c:IsType(TYPE_XYZ) and tc:IsCanOverlay() and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(id,3))==1) then
			Duel.Overlay(c,Group.FromCards(tc))
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
