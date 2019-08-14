--深层空想 失落雨林
local m=10122014
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	rsef.ACT(c)
	rsul.GraveDestroyActivateEffect(c,m)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.tkcon)
	e2:SetTarget(rsul.TokenTg)
	e2:SetOperation(rsul.TokenOp(cm.op))
	c:RegisterEffect(e2)   
 
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.op(c)
	rsef.SV_INDESTRUCTABLE(c,"ct",cm.valcon,nil,rsreset.est,nil,{m,1},1)
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,3})
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end

