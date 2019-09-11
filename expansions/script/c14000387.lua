--荒碑咫尺
local m=14000387
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,14000380,cm.ffilter,1,true,false)
	--change name
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(14000380)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(14000380)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.cntg)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.tg)
	e3:SetValue(800)
	c:RegisterEffect(e3)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Gravalond
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
function cm.check_fusion_set_Grava(c)
	if c:IsHasEffect(6205579) then return false end
	local codet={c:GetFusionCode()}
	for j,code in pairs(codet) do
		local mt=cm.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_Gravalond") and v then return true end
			end
		end
	end
	return false
end
function cm.ffilter(c)
	return cm.check_fusion_set_Grava(c) or c:IsFusionCode(14000380)
end
function cm.tg(e,c)
	return cm.Grava(c) or c:IsCode(14000380)
end
function cm.cntg(e,c)
	return cm.Grava(c)
end