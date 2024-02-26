local m=15000211
local cm=_G["c"..m]
cm.name="模仿者"
cm.loaded_metatable_list={}
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	--e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local codelist={}
	local codelist2=0
	while codelist2==0 do
		local l=Duel.GetRandomNumber(1,999999999)
		local mt=cm.load_metatable_load(l)
		if mt then
			local token=Duel.CreateToken(tp,l)
			if token and token:IsType(TYPE_MONSTER) and token:IsType(TYPE_EFFECT) and not token:IsForbidden() and token:CheckUniqueOnField(tp) then
				c:SetHint(CHINT_CARD,l)
				Duel.Hint(HINT_CARD,1-tp,l)
				local tcode=l
				c:SetEntityCode(tcode,true)
				c:ReplaceEffect(tcode,0,0)
				codelist2=codelist2+1
			end
		end
	end
end
function cm.load_metatable_load(code)
	local type=Duel.ReadCard(code,CARDDATA_TYPE)
	return type
end
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