--虚构死械-枯骨王者
local m=14001014
local cm=_G["c"..m]
cm.named_with_IDC=1
function cm.initial_effect(c)
	--linksummon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lkfilter,2,4)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.tg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e3)
	--GY
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(cm.aclimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_GRAVE)
	e5:SetTarget(cm.disable)
	c:RegisterEffect(e5)
	--selecteffect
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(cm.eftg)
	e6:SetOperation(cm.efop)
	c:RegisterEffect(e6)
end
function cm.IDC(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_IDC
end
function cm.lkfilter(c)
	return c:IsRace(RACE_ZOMBIE+RACE_MACHINE) or cm.check_link_set_IDC(c)
end
cm.loaded_metatable_list=cm.loaded_metatable_list or {}
function cm.LoadMetatable(code)
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
function cm.check_link_set_IDC(c)
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.LoadMetatable(code)
		if mt then
			for str,v in pairs(mt) do   
				if type(str)=="string" and str:find("_IDC") and v then return true end
			end
		end
	end
	return false
end
function cm.tg(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function cm.disable(e,c)
	return (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE+RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thfilter(c)
	return c:IsRace(RACE_ZOMBIE+RACE_MACHINE) and c:IsAbleToHand()
end
function cm.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	elseif sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g>0 then
			Duel.ConfirmCards(tp,g)
			if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
				local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,nil)
				if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
					Duel.BreakEffect()
					local rg=g:Select(tp,1,1,nil)
					if #rg>0 then
						Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
					end
				end
			end
			Duel.ShuffleHand(1-tp)
		end
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end