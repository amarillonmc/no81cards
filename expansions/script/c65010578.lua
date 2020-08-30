--绝对宣言-独奏会-
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65010578)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"rm",nil,nil,nil,cm.tg,cm.act)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local ct=0
	local rmct=0
	::Step::
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc then 
		ct=ct+1
		Duel.ConfirmDecktop(tp,1)
		if not tc:IsCode(ac) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 then 
			rmct = rmct + 1
			goto Step
		end
	end
	if ct==0 then return end
	local dg=Duel.GetDecktopGroup(1-tp,ct)
	if #dg>0 then
		Duel.BreakEffect()
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		rmct = rmct + #og
		cm.returnop(og,e,tp)
	end
	if rmct<20 then return end
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if hg:IsExists(Card.IsAbleToRemove,1,nil) and rsop.SelectYesNo(tp,{m,0}) then
		Duel.BreakEffect()
		Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		cm.returnop(og,e,tp)		
	end
end
function cm.returnop(og,e,tp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local rct= Duel.GetTurnPlayer()==tp and 3 or 2
	for tc in aux.Next(og) do 
		tc:RegisterFlagEffect(m,rsreset.est_pend+RESET_SELF_TURN,0,rct+1,fid)
	end
	local e1=rsef.FC({c,tp},EVENT_PHASE+PHASE_END,{m,1},1,nil,nil,cm.rtcon,cm.rtop,{rsreset.pend+RESET_SELF_TURN,rct})
	og:KeepAlive()
	e1:SetLabelObject(og)
	e1:SetLabel(fid)
	e1:SetValue(Duel.GetTurnCount())
end
function cm.rtfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.rtcon(e,tp)
	local og=e:GetLabelObject() 
	if og:IsExists(cm.rtfilter,1,nil,e:GetLabel()) then
		return Duel.GetTurnCount()~=e:GetValue() and Duel.GetTurnPlayer()==tp 
	else
		e:Reset()
		return false
	end
end
function cm.tfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function cm.rtop(e,tp)
	e:Reset()
	local og=e:GetLabelObject()
	local rg=og:Filter(cm.rtfilter,nil,e:GetLabel())
	local rg1=rg:Filter(cm.tfilter,nil,0)
	local rg2=rg:Filter(cm.tfilter,nil,1)
	rshint.Card(m)
	if rg:GetFirst():IsPreviousLocation(LOCATION_DECK) then 
		Duel.SendtoDeck(rg1,0,2,REASON_EFFECT)
		Duel.SendtoDeck(rg2,1,2,REASON_EFFECT)
	else
		Duel.SendtoHand(rg1,0,REASON_EFFECT)
		Duel.SendtoHand(rg2,1,REASON_EFFECT)
	end
end