--深层空想 燃魂沙丘
local m=10122016
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.GraveDestroyActivateEffect(c,m)
	local e3=rsef.QO(c,nil,{m,0},1,"tk,sp",nil,LOCATION_FZONE,nil,nil,cm.tg,nil,rsul.hint)
	if cm.counter==nil then
	   cm.counter=true
	   cm[0]=0
	   cm[1]=0
	   local ge1=Effect.CreateEffect(c)
	   ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   ge1:SetCode(EVENT_CHAINING)
	   ge1:SetOperation(cm.ctop)
	   Duel.RegisterEffect(ge1,0)
	   local ge2=ge1:Clone()
	   ge2:SetCode(EVENT_CHAIN_NEGATED)
	   ge2:SetOperation(cm.ctop2)
	   Duel.RegisterEffect(ge2,0)
	   local ge3=ge1:Clone()
	   ge3:SetCode(4179255)
	   ge3:SetOperation(cm.ctop)
	   Duel.RegisterEffect(ge3,0)
	   local ge4=ge1:Clone()
	   ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	   ge4:SetOperation(cm.ctop3)
	   Duel.RegisterEffect(ge4,0)
	end
end
function cm.ctop3(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:GetHandler():IsType(TYPE_FIELD) then return end
	cm[rp]=cm[rp]+1
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:GetHandler():IsType(TYPE_FIELD) then return end
	cm[rp]=cm[rp]-1
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm[tp]>0 and rsul.SpecialOrPlaceBool(tp) end
	e:SetOperation(rsul.TokenOp(cm.op,nil,1,cm[tp]))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op(c)
	rsef.SV_LIMIT(c,"ress",1,nil,rsreset.est,nil,{m,3})
end
