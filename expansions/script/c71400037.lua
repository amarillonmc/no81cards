--幻异梦境-昭和胡同
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400037.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self limitation & field activation
	yume.AddYumeFieldGlobal(c,71400037,1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c71400037.tg1)
	e1:SetValue(c71400037.filter1)
	c:RegisterEffect(e1)
end
function c71400037.tg1(e,c)
	return c:IsSetCard(0x714)
end
function c71400037.filter1(e,te,c)
	local tc=te:GetHandler()
	local tseq=tc:GetSequence()
	if tc:GetControler()~=c:GetControler() then tseq=tseq+16 end
	if tc:IsLocation(LOCATION_SZONE) then tseq=tseq+8 end
	local zone=c:GetColumnZone(LOCATION_ONFIELD)
	return zone and bit.extract(zone,tseq)~=0
end