--“暗月誓装” 上柚木八千代
local m=14002130
local cm=_G["c"..m]
cm.named_with_Yachiyo=1
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--cannot be attacktarget
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(aux.imval1)
	c:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.copytg)
	e1:SetOperation(cm.copyop)
	c:RegisterEffect(e1)
	--Destroy and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	cm.Death_Embrace_effect1=e2
end
function cm.Yachiyo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Yachiyo
end
function cm.Almotaher(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Almotaher
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
function cm.check_link_set_Yachiyo(c)
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_Yachiyo") and v then return true end
			end
		end
	end
	return false
end
function cm.matfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_DARK)
end
function cm.lfilter(c)
	return cm.check_link_set_Yachiyo(c)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.copytgfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (cm.Yachiyo(c) and c:IsFaceup()) then return false end
	for i=1,3 do
		local te=c["Death_Embrace_effect"..i]
		if te then
			local tg=te:GetTarget()
			if tg and tg(e,tp,eg,ep,ev,re,r,rp,0) then
				return true
			end
		end
	end
	return false
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and cm.copytgfilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(cm.copytgfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.copytgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te_list={}
	for i=1,3 do
		local te=tc["Death_Embrace_effect"..i]
		if te then
			local tg=te:GetTarget()
			local ok=false
			if not tg then
				ok=true
			else
				ok=tg(e,tp,eg,ep,ev,re,r,rp,0)
			end
			if ok then
				table.insert(te_list,te)
			end
		end
	end
	local sel_te=nil
	if #te_list==1 then
		sel_te=te_list[1]
	else
		local desc_list={}
		for i,te in ipairs(te_list) do
			local desc=te:GetDescription()
			table.insert(desc_list,desc and desc~=0 and desc or "Effect "..i)
		end
		local sel=Duel.SelectOption(tp,table.unpack(desc_list))
		sel_te=te_list[sel+1]
	end
	e:SetLabel(sel_te:GetFieldID())
	local target_func=sel_te:GetTarget()
	if target_func then
		target_func(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.Hint(HINT_OPSELECTED,1-tp,sel_te:GetDescription())
	end
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local target_fieldid=e:GetLabel()
	local sel_te=nil
	for i=1,3 do
		local te=tc["Death_Embrace_effect"..i]
		if te and te:GetFieldID()==target_fieldid then
			sel_te=te
			break
		end
	end
	if not sel_te then return end
	local op=sel_te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
	--tc:ReleaseEffectRelation(e)
end
function cm.desfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:GetOriginalType()&TYPE_MONSTER~=0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(c,EVENT_CUSTOM+14002100,e,0,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1,true)
		end
	end
end
