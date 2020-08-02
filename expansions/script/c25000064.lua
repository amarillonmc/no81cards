--芬尼根的守灵夜
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000064)
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
	e1:SetOperation(cm.codeop)
	local e2=rsef.FV_LIMIT_PLAYER({c,0},"act",cm.aclimit,nil,{1,1})
	local e3=rsef.FC({c,0},EVENT_MOVE)
	e3:SetOperation(cm.mvop)
end
function cm.codeop(e,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,0,0xff,0xff,nil)
	for tc in aux.Next(g) do
		local telist={tc:IsHasEffect(EFFECT_CHANGE_CODE)}
		local telist2={tc:IsHasEffect(EFFECT_ADD_CODE)}
		for _,te in pairs(telist) do
			te:SetCondition(aux.FALSE)
		end
		for _,te in pairs(telist2) do
			te:SetCondition(aux.FALSE)
		end
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_DECK)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for tc in aux.Next(eg) do
		local p=tc:GetPreviousControler()
		if tc:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) and p~=rp then
			dg:AddCard(tc)
		end
	end 
	if #dg>0 then
		rshint.Card(m)
		Duel.SendtoDeck(dg,1-rp,2,REASON_RULE)
	end
end