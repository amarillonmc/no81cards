--尤利西斯
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000063)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e1)
	local e2=rsef.FC(c,EVENT_PHASE_START+PHASE_DRAW,nil,nil,nil,LOCATION_HAND+LOCATION_DECK,cm.con,cm.op)
end
function cm.con(e,tp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rshint.Card(m)
	Duel.ConfirmCards(1-tp,c)
	Duel.RegisterFlagEffect(tp,m,0,0,1)
	local e1=rsef.FC({c,0},EVENT_ADJUST)
	e1:SetOperation(cm.hapeop)
end
function cm.hapeop(e,tp)
	for p=0,1 do
		local elist1={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_SPECIAL_SUMMON)}
		local elist2={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_SUMMON)}
		local elist3={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_FLIP_SUMMON)}
		local elist4={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
		local elistx=rsof.Table_Mix(elist1,elist2,elist3,elist4)
		for _,ae in pairs(elistx) do 
			ae:SetCondition(aux.FALSE)
		end
	end
	EFFECT_DISABLE_FIELD = 0
end