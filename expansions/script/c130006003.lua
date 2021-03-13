--受教示的集结者
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006003)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,nil,nil,{1,m,1})
	e1:SetOperation(cm.act)
end
function cm.act(e,tp)
	local c = e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.linkcon)
	e1:SetOperation(cm.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_LINK))
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function cm.cfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) and not og and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,c:GetLink(),nil) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	rsop.SelectToDeck(tp,cm.cfilter,tp,LOCATION_GRAVE,0,c:GetLink(),c:GetLink(),nil,{ nil,2,REASON_COST })
end
