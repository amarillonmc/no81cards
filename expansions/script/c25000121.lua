--圆盘生物 星人布纽
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000121)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,tg,rm",nil,nil,nil,cm.tg,cm.op) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,tp,POS_FACEDOWN)
	local tlist={ TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP }
	local enable=0
	for _,ctype in pairs(tlist) do
		if g:IsExists(Card.IsType,3,nil,ctype) then 
			enable = enable | ctype
		end
	end 
	if chk==0 then return enable>0 end
	getmetatable(c).announce_filter={ enable,OPCODE_ISTYPE }
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,ac)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	end
end
function cm.tgfilter(c,code)
	return c:IsAbleToGrave() and c:IsCode(code) and c:IsFaceup()
end
function cm.op(e,tp)
	local c=rscf.GetSelf(e)
	if not rsufo.ToDeck(e) then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	local tk=Duel.CreateToken(tp,ac)
	local tlist= {TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP }
	local enable=0
	for _,ctype in pairs(tlist) do
		if tk:IsType(ctype) then 
			enable = ctype 
			break
		end
	end 
	local ct,og=rsop.SelectRemove(1-tp,cm.rmfilter,tp,LOCATION_DECK,0,3,3,nil,{ POS_FACEDOWN,REASON_EFFECT },enable)
	Duel.ShuffleDeck(tp)
	if ct==3 and og:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,ac)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTargetRange(0,0x7f)
		e1:SetCondition(rsufo.scon(true))
		e1:SetTarget(cm.bantg)
		e1:SetLabel(ac)
		local rct=Duel.GetTurnPlayer()==tp and 2 or 1
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.rmfilter(c,enable)
	return c:IsAbleToRemove(c:GetControler(),POS_FACEDOWN) and c:IsType(enable)
end