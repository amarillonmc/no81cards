--编码-零 僵尸电脑
local m=14000614
local cm=_G["c"..m]
cm.named_with_CodeNull=1
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.eccon)
	e2:SetTarget(cm.ectg)
	e2:SetOperation(cm.ecop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_LINK))
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
end
function cm.Code0(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CodeNull
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
cm.loaded_metatable_list=cm.loaded_metatable_list or {}
function cm.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=cm.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			cm.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function cm.check_link_set_Code0(c)
	if c:IsLinkCode(m) then return end
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_CodeNull") and v then return true end
			end
		end
	end
	return false
end
function cm.matfilter(c)
	return cm.check_link_set_Code0(c)
end
function cm.eccon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and ((re:GetHandler():IsRace(RACE_CYBERSE) and rp==tp) or Duel.IsPlayerAffectedByEffect(tp,14000608))
end
function cm.thfilter(c)
	return cm.Code0(c) and c:IsAbleToHand()
end
function cm.ectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.ecop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.atktg(e,c)
	return cm.Code0(c) and c:IsType(TYPE_LINK)
end
function cm.atkfilter(c)
	return cm.Code0(c) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.val(e,c)
	if cm.Code0(c) then
		return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*200
	end
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*100
end