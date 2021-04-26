--幻异梦境-昭和胡同
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400037.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self limitation & field activation
	yume.AddYumeFieldGlobal(c,71400037,1)
	--cannot be target
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1a:SetRange(LOCATION_FZONE)
	e1a:SetTargetRange(LOCATION_MZONE,0)
	e1a:SetValue(aux.imval1)
	c:RegisterEffect(e1a)
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1b:SetRange(LOCATION_FZONE)
	e1b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1b:SetTargetRange(LOCATION_MZONE,0)
	e1b:SetTarget(c71400037.tg1)
	e1b:SetValue(1)
	c:RegisterEffect(e1b)
end
function c71400037.tg1(e,c)
	return c:IsSetCard(0x714)
end