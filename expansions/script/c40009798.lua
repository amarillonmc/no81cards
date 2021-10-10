--伐楼利拿·阿勒克斯
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009798)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.accon)
	e4:SetOperation(cm.chainop)
	c:RegisterEffect(e4)



end
function cm.rsfwh_ex_ritual(c)
	return c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and c:IsSetCard(0x7f1b)
end

function cm.accon(e,tp)
	return e:GetHandler():GetFlagEffect(m) > 0
end

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0x6f1b) or re:GetHandler():IsSetCard(0x7f1b) or re:GetHandler():IsSetCard(0x8f1b)) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end