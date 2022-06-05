local m=25000034
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.xcon)
	e4:SetCost(cm.xcost)
	e4:SetTarget(cm.xtg)
	e4:SetOperation(cm.xop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(cm.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_NORMAL)
end
function cm.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) 
end
function cm.xcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1500) end 
	Duel.PayLPCost(tp,1500)
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE+LOCATION_HAND)
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
	while Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>0 do
		local x,s=0,0
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		g1:Merge(g2:Filter(Card.IsPublic,nil))
		g2=g2:Filter(aux.NOT(Card.IsPublic),nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		if #g2>0 then s=Duel.AnnounceType(tp) else
			local t={}
			g1:ForEach(cm.cal,t)
			s=Duel.SelectOption(tp,table.unpack(t))
		end
		if s==0 then x=0x1 elseif s==1 then x=0x2 else x=0x4 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,x)
		if #g>0 then
			if g:GetFirst():IsLocation(LOCATION_ONFIELD) then Duel.HintSelection(g) end
			if Duel.SendtoGrave(g,REASON_RULE)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.CheckLPCost(tp,1500) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.PayLPCost(tp,1500)
			else break end
		else break end
	end
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkType,1,nil,TYPE_SPIRIT) then e:GetLabelObject():SetLabel(1) else e:GetLabelObject():SetLabel(0) end
end
function cm.cal(c,t)
	if c:IsFaceup() then
		if c:IsType(TYPE_MONSTER) and not SNNM.IsInTable(70,t) then table.insert(t,70) end
		if c:IsType(TYPE_SPELL) and not SNNM.IsInTable(71,t) then table.insert(t,71) end
		if c:IsType(TYPE_TRAP) and not SNNM.IsInTable(72,t) then table.insert(t,72) end
	else
		if c:IsLocation(LOCATION_MZONE) and not SNNM.IsInTable(70,t) then table.insert(t,70) end
		if c:IsLocation(LOCATION_SZONE) then
			if not SNNM.IsInTable(71,t) then table.insert(t,71) end
			if not SNNM.IsInTable(72,t) then table.insert(t,72) end
		end
	end
end
