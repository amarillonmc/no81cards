--我家偷菜
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174056)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"rm")
	e1:SetOperation(cm.act)
	if not cm.checkcodelist then 
		cm.checkcodelist={[0]={},[1]={}}
		local ge1=rsef.FC({c,0},EVENT_TO_GRAVE)
		ge1:SetOperation(cm.regop)
		local ge2=rsef.RegisterClone({c,0},ge1,"code",EVENT_REMOVE)
		local ge3=rsef.RegisterClone({c,0},ge1,"code",EVENT_TO_HAND)
		local ge4=rsef.RegisterClone({c,0},ge1,"code",EVENT_TO_DECK)
		local ge5=rsef.FC({c,0},EVENT_ADJUST)
		ge5:SetOperation(cm.disop)
		local ge6=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
		ge6:SetOperation(cm.negop)
		local ge7=rsef.RegisterClone({c,0},ge6,"code",EVENT_CHAIN_DISABLED)
		local ge8=rsef.FC({c,0},EVENT_PHASE_START+PHASE_DRAW)
		ge8:SetOperation(cm.resetop)
	end 
end
function cm.act(e,tp)
	local e1=rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_END,nil,1)
	e1:SetOperation(cm.rmop)
	e1:SetReset(rsreset.pend)
end
function cm.rmfilter(c,codelist)
	return c:IsCode(table.unpack(codelist))
end
function cm.rmop(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	local codelist=cm.checkcodelist[tp]
	if #codelist>0 then
		local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,nil,codelist)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.regop(e,p,eg)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_EFFECT) then 
			local rp=tc:GetReasonPlayer()
			local cp=tc:GetControler()
			local re=tc:GetReasonEffect()
			local rc=re:GetHandler()
			local code=rc:GetCode()
			if rp~=cp and not rsof.Table_List(cm.checkcodelist[cp],code) then
				table.insert(cm.checkcodelist[cp],code)
			end
		end
	end
end
function cm.disop(e,tp)
	local g1=Duel.GetMatchingGroup(Card.IsStatus,0,0xff,0xff,nil,STATUS_DISABLED) 
	for tc in aux.Next(g1) do
		local elist={tc:IsHasEffect(EFFECT_DISABLE)} 
		for _,re in pairs(elist) do
			local rc=re:GetOwner()
			local rp=re:GetOwnerPlayer()
			local cp=tc:GetControler()
			local code=rc:GetCode()
			if rp~=cp and not rsof.Table_List(cm.checkcodelist[cp],code) then
				table.insert(cm.checkcodelist[cp],code)
			end
		end
	end
end
function cm.negop(e,tp)
	local dp,ep,de=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER,CHAININFO_TRIGGERING_PLAYER,CHAININFO_DISABLE_REASON)
	local code=not de and 0 or de:GetHandler():GetCode()
	if de and dp~=ep and not rsof.Table_List(cm.checkcodelist[ep],code) then
		table.insert(cm.checkcodelist[ep],code)
	end
end
function cm.resetop(e,tp)
	cm.checkcodelist={[0]={},[1]={}}
end