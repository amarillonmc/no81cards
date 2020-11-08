--神话幻兽 尤尼金
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000079)
function cm.initial_effect(c)
	local e0=rscf.SetSummonCondition(c,false,aux.FALSE)
	local e1=rsef.FC(c,EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_REMOVED)
	rsef.RegisterSolve(e1,cm.spcon,nil,nil,cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m,2},"an",nil,cm.con,nil,cm.tg,cm.op)
end
function cm.spcon(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.spop(e,tp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
		rshint.Card(m)
		if Duel.SpecialSummon(c,100,tp,tp,true,true,POS_FACEUP)>0 then
			c:CompleteProcedure()
		end
		Duel.RegisterFlagEffect(tp,m,0,0,1)
	end
end
function cm.con(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+100)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,m,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local e1=rsef.FC({c,tp},EVENT_PHASE+PHASE_END,{m,2},1,nil,nil,cm.rmcon,cm.rmop,{rsreset.pend+RESET_SELF_TURN,2})
	e1:SetLabel(Duel.GetTurnCount())
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(ac)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:CopyEffect(ac,RESET_EVENT+RESETS_STANDARD,1)

end
function cm.rmcon(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp and #g>0
end
function cm.rmop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end