--白月骑士的决心
if not pcall(function() require("expansions/script/c65010579") end) then require("script/c65010579") end
local m,cm=rscf.DefineCard(65010580,"WMKnight")
function cm.initial_effect(c)
	local e1=rswk.EquipEffect(c,m,true)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(rswk.gecon)
	e2:SetCost(rscost.lpcost(2000))
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	rswk.GainEffect(c,e2)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FC({c,tp},EVENT_CHAIN_SOLVING,nil,nil,nil,nil,cm.con,cm.op,rsreset.pend)
	--local e2=rsef.FC({c,tp},EVENT_TO_GRAVE,nil,nil,nil,nil,nil,cm.regop,rsreset.pend)
	--local e3=rsef.RegisterClone({c,tp},e2,"code",EVENT_REMOVE)
end
function cm.regop(e,tp,eg)
	for tc in aux.Next(eg) do 
		if tc:IsControler(1-tp) then
			local reset = c:IsLocation(LOCATION_GRAVE) and RESET_TOGRAVE or RESET_REMOVE 
			tc:RegisterFlagEffect(m,reset+rsreset.pend,0,1)
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp) 
	local loc,cp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return loc & LOCATION_GRAVE + LOCATION_REMOVED ~=0 and cp~=tp and Duel.IsChainDisablable(ev) --and re:GetHandler():GetFlagEffect(m)>0 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	Duel.NegateEffect(ev)
end